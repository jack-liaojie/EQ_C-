IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_GetTeamMembersResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_GetTeamMembersResult]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_SH_GetTeamMembersResult]
		@MatchID			AS NVARCHAR(50),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #tmp	(
					
					F_RegisterID	INT,
					F_MemberRegisterID	INT,
					F_Bib			NVARCHAR(50),
					F_PrintLongName	NVARCHAR(50),
					F_Points		NVARCHAR(50),
					F_PointsInt		INT,
					F_Inx			INT,
					F_Rank			NVARCHAR(50),
					
					S_1				NVARCHAR(10),
					S_2				NVARCHAR(10),
					S_3				NVARCHAR(10),
					S_4				NVARCHAR(10),
					S_5				NVARCHAR(10),
					S_6				NVARCHAR(10),
					S_7				NVARCHAR(10),
					S_8				NVARCHAR(10),
					S_9				NVARCHAR(10),
					S_10			NVARCHAR(10),
					S_11			NVARCHAR(10),
					S_12			NVARCHAR(10),
					
					S_1_4			NVARCHAR(10), --S1+S2+S3+S4, for 3 position
					S_5_8			NVARCHAR(10), 
					S_9_12			NVARCHAR(10), 
					
					S_1_3			NVARCHAR(10), --S1+S2+S3, for 25 m rapid fire and 25 m pistol
					S_4_6			NVARCHAR(10), --S1+S2+S3, for 25 m
					
					S_1_2			NVARCHAR(10), --S1+S2, for 25 m standard pistol men
					S_3_4			NVARCHAR(10), 
					S_5_6			NVARCHAR(10), 
					
					IRM_ID			INT,
					IRM_DES			NVARCHAR(10)
					
				)
				
				
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = PHASE_CODE,
			 @MatchCode = Match_Code 
		FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

	
				
	DECLARE @SourceMatchID INT
	DECLARE @PhaseID INT

	SELECT  @SourceMatchID = F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID)
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @SourceMatchID

	INSERT INTO #tmp(F_RegisterID, F_MemberRegisterID, F_Bib, F_PrintLongName, F_Points, F_Rank, F_PointsInt)
	SELECT TR.F_RegisterID, TM.F_MemberRegisterID, R.F_Bib, RD.F_PrintLongName, PR.F_Points/10, PR.F_Rank, PR.F_Points/10
	FROM TR_Register_Member AS TM
	LEFT JOIN TS_Match_Result AS TR ON TM.F_RegisterID = TR.F_RegisterID
	LEFT JOIN TS_Match_Result AS PR  ON PR.F_MatchID IN (SELECT F_MatchId FROM dbo.Func_SH_GetTeamSourceMatchID(@MatchID))
	 AND PR.F_RegisterID = TM.F_MemberRegisterID
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = TM.F_MemberRegisterID
	LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = R.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation E ON E.F_DelegationID = R.F_DelegationID
	WHERE TR.F_MatchID = @MatchID 

	-- Get Series Points from qualification match
	
	CREATE TABLE #Result(	
						RegisterID INT,
						
						S_1 NVARCHAR(10),
						S_2 NVARCHAR(10),
						S_3 NVARCHAR(10),
						S_4 NVARCHAR(10),
						S_5 NVARCHAR(10),
						S_6 NVARCHAR(10),
						S_7 NVARCHAR(10),
						S_8 NVARCHAR(10),
						S_9 NVARCHAR(10),
						S_10 NVARCHAR(10),
						S_11 NVARCHAR(10),
						S_12 NVARCHAR(10),
												
						S_ShotedCount	INT,
						
						S_1_4 NVARCHAR(10), --S1+S2+S3+S4, for 3 position
						S_5_8 NVARCHAR(10), 
						S_9_12 NVARCHAR(10), 
						
						S_1_3 NVARCHAR(10), --S1+S2+S3, for 25 m rapid fire and 25 m pistol
						S_4_6 NVARCHAR(10), --S1+S2+S3, for 25 m
						
						S_1_2 NVARCHAR(10), --S1+S2, for 25 m standard pistol men
						S_3_4 NVARCHAR(10), 
						S_5_6 NVARCHAR(10), 
						IRM_ID INT
						
	)
	

	DECLARE ONE_CURSOR CURSOR FOR SELECT F_MatchID FROM DBO.Func_SH_GetTeamSourceMatchID(@MatchID)
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @SourceMatchID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO #Result(RegisterID, S_1, S_2, S_3, S_4, S_5, S_6, S_7, S_8, S_9, S_10, S_11, S_12, IRM_ID)
		SELECT REG_ID, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12,IRMID FROM dbo.Func_SH_GetMatchQualifiedlResult(@SourceMatchID) 
		FETCH NEXT FROM ONE_CURSOR INTO @SourceMatchID
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR

	
	UPDATE #tmp SET S_1 = B.S_1/10, S_2 = B.S_2/10, S_3 = B.S_3/10, S_4 = B.S_4/10, S_5 = B.S_5/10, S_6 = B.S_6/10, 
					S_7 = B.S_7/10, S_8 = B.S_8/10, S_9 = B.S_9/10, S_10 = B.S_10/10, S_11 = B.S_11/10, S_12 = B.S_12/10, 
					
					S_1_4  = B.S_1/10 + B.S_2/10 + B.S_3/10 + B.S_4/10, 
					S_5_8  = B.S_5/10 + B.S_6/10 + B.S_7/10 + B.S_8/10, 
					S_9_12 = B.S_9/10 + B.S_10/10 + B.S_1/11 + B.S_1/12, 
						
					S_1_3  = B.S_1/10 + B.S_2/10 + B.S_3/10, 
					S_4_6  = B.S_4/10 + B.S_5/10 + B.S_6/10,
						
					S_1_2  = B.S_1/10 + B.S_2/10, 
					S_3_4  = B.S_3/10 + B.S_4/10,
					S_5_6  = B.S_5/10 + B.S_6/10,
					
					IRM_ID = B.IRM_ID
					
	FROM #tmp AS A 
	LEFT JOIN #Result AS B ON A.F_MemberRegisterID = B.RegisterID
	

	UPDATE #tmp SET F_Points = A.F_Points + '-' + 
	--ISNULL(CAST(B.F_RealScore as NVARCHAR(10)),0) + 'x' 
	space(4-2*len(CAST(B.F_RealScore as nvarchar(10)))) + ISNULL(CAST(B.F_RealScore AS NVARCHAR(10) ),'0') + 'x'
	FROM #tmp AS A
	LEFT JOIN TS_Match_Result AS B ON A.F_MemberRegisterID = B.F_RegisterID
	WHERE B.F_MatchID IN (SELECT F_MatchId FROM dbo.Func_SH_GetTeamSourceMatchID(@MatchID))
	
	UPDATE #tmp SET IRM_DES = B.F_IRMCODE
	FROM #tmp AS A
	LEFT JOIN TC_IRM AS B ON A.IRM_ID = B.F_IRMID
	
	
	SELECT * FROM #tmp
	
SET NOCOUNT OFF
END

GO

/*

EXEC Proc_SH_GetTeamResult 62
EXEC Proc_SH_GetTeamMembersResult 62, 'ENG'

*/

 
