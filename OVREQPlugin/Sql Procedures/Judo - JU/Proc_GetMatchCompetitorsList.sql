IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchCompetitorsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchCompetitorsList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_GetMatchCompetitorsList]
--描    述：得到一场比赛，其中的参赛人员列表
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月17日
/*			
	日期					修改人		修改内容
	2011年10月21			宁顺泽		下拉框人名前添加Noc
*/

CREATE PROCEDURE [dbo].[Proc_GetMatchCompetitorsList](
				 @EventID			INT,
				 @PhaseID			INT,
				 @MatchID			INT,
				 @Position			INT,
                 @LanguageCode		CHAR(3),
				 @SelEventID		INT,
				 @SelPhaseID		INT,
				 @SelMatchID		INT,
				 @SelNodeType		INT
)
As
Begin
SET NOCOUNT ON 
	
	IF @PhaseID IS NULL OR @PhaseID = 0
	BEGIN
		SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	END

	IF @EventID IS NULL OR @EventID = 0
	BEGIN
		SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	END

	CREATE TABLE #Table_Competitors(
									F_LongName			NVARCHAR(100),
									F_RegisterID		INT,
									F_Seed				INT
									)


--	INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT F_LongName, F_RegisterID FROM TR_Register_Des
	
	DECLARE @PhaseType			AS INT
	DECLARE @FatherPhaseID		AS INT
	DECLARE @PlayerRegTypeID	AS INT

	SELECT @EventID = F_EventID, @PhaseType = F_PhaseType, @FatherPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	SELECT @PlayerRegTypeID = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID


	DECLARE @CurRegisterID AS INT

	IF @PhaseType = 2  AND @SelNodeType = 0-- 小组赛的签位指定
	BEGIN
		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT isnull(D.F_DelegationCode+N' - ',N'')+B.F_LongName, A.F_RegisterID FROM TR_Inscription AS A 
			LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TC_Delegation aS D on D.F_DelegationID=C.F_DelegationID
				WHERE A.F_EventID = @EventID AND C.F_RegTypeID = @PlayerRegTypeID


		DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_FatherPhaseID = @FatherPhaseID))

		SELECT @CurRegisterID = F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @Position
		
		IF ((@CurRegisterID IS NOT NULL) AND (@CurRegisterID != -1))
		BEGIN
			INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT isnull(D.F_DelegationCode+N' - ',N'')+B.F_LongName, A.F_RegisterID
						FROM TR_Register AS A LEFT JOIN TC_Delegation AS D ON D.F_DelegationID=A.F_DelegationID LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
							WHERE A.F_RegisterID = @CurRegisterID
		END

		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('NONE', 0)
		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('BYE', -1)

		UPDATE #Table_Competitors SET F_Seed = B.F_Seed FROM #Table_Competitors AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_EventID = @EventID
		UPDATE #Table_Competitors SET F_Seed = NULL WHERE F_Seed = 0
		UPDATE #Table_Competitors SET F_LongName = F_LongName + '[' + CAST(F_Seed AS NVARCHAR(100)) + ']' WHERE F_Seed IS NOT NULL

		SELECT * FROM #Table_Competitors
		RETURN

	END
	ELSE IF @PhaseType = 2 AND  @SelNodeType = 1--小组赛下的具体比赛
	BEGIN

		SELECT @CurRegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @Position
		IF @CurRegisterID IS NULL
		BEGIN
			INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('NONE', 0)
		END
		ELSE
		BEGIN
				IF @CurRegisterID = -1
				BEGIN
					INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('BYE', -1)
				END
				ELSE
				BEGIN
					INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT B.F_LongName, A.F_RegisterID 
						FROM TR_Register AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
							WHERE A.F_RegisterID = @CurRegisterID
				END
		END
		
		UPDATE #Table_Competitors SET F_Seed = B.F_Seed FROM #Table_Competitors AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_EventID = @EventID
		UPDATE #Table_Competitors SET F_Seed = NULL WHERE F_Seed = 0
		UPDATE #Table_Competitors SET F_LongName = F_LongName + '[' + CAST(F_Seed AS NVARCHAR(100)) + ']' WHERE F_Seed IS NOT NULL

		SELECT * FROM #Table_Competitors
		RETURN
	
	END
	ELSE IF @PhaseType = 31--淘汰赛
	BEGIN

		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT isnull(D.F_DelegationCode+N' - ',N'')+B.F_LongName, A.F_RegisterID FROM TR_Inscription AS A 
			LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TC_Delegation AS D
				ON D.F_DelegationID=C.F_DelegationID
				WHERE A.F_EventID = @EventID AND C.F_RegTypeID = @PlayerRegTypeID

		DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID))
		SELECT @CurRegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @Position
		
		IF ((@CurRegisterID IS NOT NULL) AND (@CurRegisterID != -1))
		BEGIN
			INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT isnull(d.F_DelegationCode+N' - ',N'')+B.F_LongName, A.F_RegisterID 
						FROM TR_Register AS A LEFT JOIN TC_Delegation AS D on D.F_DelegationID=A.F_DelegationID LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
							WHERE A.F_RegisterID = @CurRegisterID
		END

		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('NONE', 0)
		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('BYE', -1)

	END
	ELSE
	BEGIN--其余的比赛阶段，参赛人员可以全选

		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT isnull(D.F_DelegationCode+N' - ',N'')+B.F_LongName, A.F_RegisterID FROM TR_Inscription AS A 
			LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
			LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID
			LEFT JOIN TC_Delegation AS D
				ON D.F_DelegationID=C.F_DelegationID
				WHERE A.F_EventID = @EventID AND C.F_RegTypeID = @PlayerRegTypeID

		IF @SelNodeType = -1 --Event
		BEGIN
			DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @SelEventID) ))
		END
		ELSE IF @SelNodeType = 0 --Phase
		BEGIN
			DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @SelPhaseID ))
		END
		ELSE IF @SelNodeType = 1 --Match
		BEGIN
			DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @SelMatchID)
		END

		--DELETE FROM #Table_Competitors WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID ))

		SELECT @CurRegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @Position
		
		IF ((@CurRegisterID IS NOT NULL) AND (@CurRegisterID != -1))
		BEGIN
			INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) SELECT isnull(D.F_DelegationCode,N'')+B.F_LongName, A.F_RegisterID 
						FROM TR_Register AS A LEFT JOIN TC_Delegation aS D on D.F_DelegationID=A.F_DelegationID LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode 
							WHERE A.F_RegisterID = @CurRegisterID
		END

		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('NONE', 0)
		INSERT INTO #Table_Competitors (F_LongName, F_RegisterID) VALUES ('BYE', -1)

	END

	DECLARE @StatusID AS INT
    SELECT @StatusID = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
    
    SET @StatusID = ISNULL(@StatusID, 0)
    IF @StatusID >= 40
    BEGIN
		SELECT @CurRegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @Position
		SET @CurRegisterID = ISNULL(@CurRegisterID, 0)
		DELETE FROM #Table_Competitors WHERE F_RegisterID != @CurRegisterID
    END

	UPDATE #Table_Competitors SET F_Seed = B.F_Seed FROM #Table_Competitors AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_EventID = @EventID
	UPDATE #Table_Competitors SET F_Seed = NULL WHERE F_Seed = 0
	UPDATE #Table_Competitors SET F_LongName = F_LongName + '[' + CAST(F_Seed AS NVARCHAR(100)) + ']' WHERE F_Seed IS NOT NULL

	SELECT * FROM #Table_Competitors order by F_LongName
	RETURN
		
		
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

/*

EXEC Proc_GetMatchCompetitorsList 0,0,1075,1,'CHN'
*/