IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TVG_BDTT_GetMatchResult]
----功		  能：获取TVG需要的计分板
----作		  者：王强
----日		  期: 2011-04-26

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetMatchResult]
		@MatchID     INT,
		@MatchSplitID INT = -1
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @CurrentSetID INT
	DECLARE @CurrentGameID INT
	--DECLARE @MatchSplitID INT
	--DECLARE @FatherSplitID INT
	--DECLARE @CurrentGameSplitID INT
	
	CREATE TABLE #TMP_TABLE
	(
		MatchName NVARCHAR(100),
		PhaseMatchName NVARCHAR(100),
		NOCA NVARCHAR(50),
		NOCB NVARCHAR(50),
		PlayerNameA NVARCHAR(100),
		PlayerNameB NVARCHAR(100),
		GameScoreA1  INT,
		GameScoreA2  INT,
		GameScoreA3  INT,
		GameScoreB1  INT,
		GameScoreB2  INT,
		GameScoreB3  INT,
		ServerA INT,
		ServerB INT,
		IRMA NVARCHAR(20),
		IRMB NVARCHAR(20)
	)
	
	INSERT INTO #TMP_TABLE (NOCA, NOCB, PlayerNameA, PlayerNameB, MatchName, PhaseMatchName, IRMA, IRMB)
	(
		SELECT REPLACE(C1.F_TvShortName,'/',' / '), REPLACE(C2.F_TvShortName,'/',' / '), 
			   REPLACE(C1.F_TvShortName,'/',' / '), REPLACE(C2.F_TvShortName,'/',' / '), D.F_MatchShortName, E.F_PhaseShortName + ' ' + D.F_MatchShortName,
			   '[Image]IRM_' + F1.F_IRMCODE, '[Image]IRM_' + F2.F_IRMCODE
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Des AS D ON D.F_MatchID = A.F_MatchID AND D.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = A.F_PhaseID AND E.F_LanguageCode = 'ENG'
		LEFT JOIN TC_IRM AS F1 ON F1.F_IRMID = B1.F_IRMID
		LEFT JOIN TC_IRM AS F2 ON F2.F_IRMID = B2.F_IRMID
		WHERE A.F_MatchID = @MatchID
	)
	
	IF @MatchSplitID >= 1
		SET @CurrentSetID = @MatchSplitID
	ELSE
		SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
		
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	
	--单打 
	IF @MatchType = 1
	BEGIN
		UPDATE #TMP_TABLE SET GameScoreA1 = B1.F_Points, GameScoreB1 = B2.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_Order = 1
		
		UPDATE #TMP_TABLE SET GameScoreA2 = B1.F_Points, GameScoreB2 = B2.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_Order = 2
		
		UPDATE #TMP_TABLE SET GameScoreA3 = B1.F_Points, GameScoreB3 = B2.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_Order = 3
		
		UPDATE #TMP_TABLE SET ServerA = ISNULL(B1.F_Service, 0 ), ServerB = ISNULL(B2.F_Service, 0 )
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
	END
	
	--团体赛
	IF @MatchType = 3
	BEGIN
			
		IF EXISTS (SELECT * FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID 
						AND F_IRMID IS NOT NULL)
		BEGIN
			UPDATE #TMP_TABLE SET IRMA = '[Image]IRM_' + C1.F_IRMCODE, IRMB = '[Image]IRM_' + C2.F_IRMCODE
			FROM TS_Match_Split_Info AS A
			LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
			LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
			LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
			LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
			WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
		END
		
		
		UPDATE #TMP_TABLE SET GameScoreA1 = B1.F_Points, GameScoreB1 = B2.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID AND A.F_Order = 1
		
		UPDATE #TMP_TABLE SET GameScoreA2 = B1.F_Points, GameScoreB2 = B2.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID AND A.F_Order = 2
		
		UPDATE #TMP_TABLE SET GameScoreA3 = B1.F_Points, GameScoreB3 = B2.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID AND A.F_Order = 3
		
		--更新对阵
		UPDATE  #TMP_TABLE SET PlayerNameA = REPLACE(C1.F_TvShortName,'/',' / '), PlayerNameB = REPLACE(C2.F_TvShortName,'/',' / ')
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
					AND B2.F_CompetitionPosition = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
		
		SET @CurrentGameID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 2)
		
		IF @CurrentGameID != 0
			BEGIN
				UPDATE #TMP_TABLE SET ServerA = ISNULL( B1.F_Service, 0 ), ServerB = ISNULL(B2.F_Service, 0 )
				FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentGameID
				
			END
		ELSE--如果不存在，说明没有任何一局比赛开始，设置为0 : 0
			BEGIN
				UPDATE #TMP_TABLE SET ServerA = 0, ServerB = 0
			END				
	END
		
	SELECT * FROM #TMP_TABLE

	
SET NOCOUNT OFF
END



GO


