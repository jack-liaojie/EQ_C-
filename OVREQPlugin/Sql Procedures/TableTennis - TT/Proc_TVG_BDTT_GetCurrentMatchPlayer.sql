IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetCurrentMatchPlayer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetCurrentMatchPlayer]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetCurrentMatchPlayer]
----功		  能：获取当前正在比赛的运动员
----作		  者：王强
----日		  期: 2011-04-25

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetCurrentMatchPlayer]
		@MatchID INT,
		@MatchSplitID INT = -1
AS
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @CurrentSetID INT
	
	CREATE TABLE #TMP_TABLE
	(
		NOCA NVARCHAR(20),
		PlayerNameA NVARCHAR(200),
		NOCB NVARCHAR(20),
		PlayerNameB NVARCHAR(200),
		DoublePlayerNameA1 NVARCHAR(200),
		DoublePlayerNameA2 NVARCHAR(200),
		DoublePlayerNameB1 NVARCHAR(200),
		DoublePlayerNameB2 NVARCHAR(200)
	)
	
	--DECLARE @MatchType INT
	--SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	DECLARE @Type INT
	SELECT @Type = C.F_PlayerRegTypeID
			FROM TS_Match AS A
			LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
			WHERE A.F_MatchID = @MatchID
	
	IF @Type IN (1,2)
		BEGIN
			INSERT INTO #TMP_TABLE (NOCA, PlayerNameA, NOCB, PlayerNameB)
			(
				SELECT dbo.Fun_BDTT_GetPlayerNOC(B1.F_RegisterID), REPLACE( C1.F_TvShortName,'/', ' / '),
					   dbo.Fun_BDTT_GetPlayerNOC(B2.F_RegisterID), REPLACE( C2.F_TvShortName,'/', ' / ')
				FROM TS_Match AS A 
				LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
				LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
				WHERE A.F_MatchID = @MatchID
			)
			DECLARE @PhaseName_ENG NVARCHAR(30)
			DECLARE @PhaseName_CHN NVARCHAR(30)
			DECLARE @StartTime NVARCHAR(30)
		    
			
			
			--双打
			IF @Type = 2
			BEGIN
				UPDATE #TMP_TABLE SET DoublePlayerNameA1 = T.A1, DoublePlayerNameA2 = T.A2, 
								DoublePlayerNameB1 = T.A3, DoublePlayerNameB2 = T.A4
				FROM
				(SELECT E1.F_TvShortName AS A1, E2.F_TvShortName AS A2, 
				E3.F_TvShortName AS A3, E4.F_TvShortName AS A4 FROM TS_Match AS A
				LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
				LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = C1.F_MemberRegisterID AND E1.F_LanguageCode = 'ENG'
				LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
				LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = C2.F_MemberRegisterID AND E2.F_LanguageCode = 'ENG'
				
				LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TR_Register_Member AS D1 ON D1.F_RegisterID = B2.F_RegisterID AND D1.F_Order = 1
				LEFT JOIN TR_Register_Des AS E3 ON E3.F_RegisterID = D1.F_MemberRegisterID AND E3.F_LanguageCode = 'ENG'
				LEFT JOIN TR_Register_Member AS D2 ON D2.F_RegisterID = B2.F_RegisterID AND D2.F_Order = 2
				LEFT JOIN TR_Register_Des AS E4 ON E4.F_RegisterID = D2.F_MemberRegisterID AND E4.F_LanguageCode = 'ENG'
				WHERE A.F_MatchID = @MatchID ) AS T
			END
		END
	
	ELSE IF @Type = 3
	BEGIN
			IF @MatchSplitID != -1
				SET @CurrentSetID = @MatchSplitID
			ELSE
				SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
			INSERT INTO #TMP_TABLE (PlayerNameA, PlayerNameB)
			(
				SELECT REPLACE(C1.F_TvShortName,'/',' / '), REPLACE(C2.F_TvShortName,'/',' / ')
				FROM TS_Match_Split_Info AS A 
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
								AND B1.F_CompetitionPosition = 1
				LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
								AND B2.F_CompetitionPosition = 2
				LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
			)
			
			DECLARE @SplitType INT
			SELECT @SplitType = F_MatchSplitType FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID
			--双打，则取具体的人
			IF @SplitType >= 3
			BEGIN
				
				UPDATE #TMP_TABLE SET DoublePlayerNameA1 = T.A1, DoublePlayerNameA2 = T.A2, 
								DoublePlayerNameB1 = T.A3, DoublePlayerNameB2 = T.A4
				FROM
				(SELECT E1.F_TvShortName AS A1, E2.F_TvShortName AS A2, 
				E3.F_TvShortName AS A3, E4.F_TvShortName AS A4 FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
				LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
				LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = C1.F_MemberRegisterID AND E1.F_LanguageCode = 'ENG'
				LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
				LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = C2.F_MemberRegisterID AND E2.F_LanguageCode = 'ENG'
				
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
				LEFT JOIN TR_Register_Member AS D1 ON D1.F_RegisterID = B2.F_RegisterID AND D1.F_Order = 1
				LEFT JOIN TR_Register_Des AS E3 ON E3.F_RegisterID = D1.F_MemberRegisterID AND E3.F_LanguageCode = 'ENG'
				LEFT JOIN TR_Register_Member AS D2 ON D2.F_RegisterID = B2.F_RegisterID AND D2.F_Order = 2
				LEFT JOIN TR_Register_Des AS E4 ON E4.F_RegisterID = D2.F_MemberRegisterID AND E4.F_LanguageCode = 'ENG'
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID) AS T
			END
		
	END
	
	UPDATE #TMP_TABLE SET NOCA = '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID)
	FROM TS_Match_Result AS A
	WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	
	UPDATE #TMP_TABLE SET NOCB = '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID)
	FROM TS_Match_Result AS A
	WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
	
	SELECT * FROM #TMP_TABLE
	
	SET NOCOUNT OFF
END


GO


