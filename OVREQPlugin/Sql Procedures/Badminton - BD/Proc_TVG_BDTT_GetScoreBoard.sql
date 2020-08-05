IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetScoreBoard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetScoreBoard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetScoreBoard]
----功		  能：获取TVG需要的计分板
----作		  者：王强
----日		  期: 2011-04-26

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetScoreBoard]
		@MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @CurrentSetID INT
	DECLARE @CurrentGameID INT
	
	CREATE TABLE #TMP_TABLE
	(
		NOCA NVARCHAR(20),
		NOCB NVARCHAR(20),
		PlayerNameA NVARCHAR(100),
		PlayerNameB NVARCHAR(100),
		MatchScoreA INT,
		MatchScoreB INT,
		GameScoreA  INT,
		GameScoreB  INT,
		ServerA INT,
		ServerB INT
	)
	
	INSERT INTO #TMP_TABLE (NOCA, NOCB, PlayerNameA, PlayerNameB, MatchScoreA, MatchScoreB)
	(
		SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B1.F_RegisterID), '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B2.F_RegisterID), 
			   C1.F_TvShortName, C2.F_TvShortName, B1.F_Points, B2.F_Points
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID
	)
	
	SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
		
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	
	--单打 
	IF @MatchType = 1
	BEGIN
		UPDATE #TMP_TABLE SET GameScoreA = ISNULL(B1.F_Points, 0), GameScoreB = ISNULL(B2.F_Points,0), 
				ServerA = ISNULL(B1.F_Service, 0 ), ServerB = ISNULL(B2.F_Service, 0 )
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
					AND B2.F_CompetitionPosition = 2
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
		
		UPDATE #TMP_TABLE SET MatchScoreA = ISNULL(F_Points,'0') FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
		UPDATE #TMP_TABLE SET MatchScoreB = ISNULL(F_Points,'0') FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
	END
	
	--团体赛
	IF @MatchType = 3
	BEGIN
			
		--先更新盘比分
		UPDATE #TMP_TABLE SET MatchScoreA = ISNULL(B1.F_Points, 0), MatchScoreB = ISNULL(B2.F_Points,0),
				PlayerNameA = C1.F_TvShortName, PlayerNameB = C2.F_TvShortName
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
					AND B1.F_CompetitionPosition = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
					AND B2.F_CompetitionPosition = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
		
		SET @CurrentGameID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 2)
			
		--更新局比分
		IF @CurrentGameID != 0
			BEGIN
				UPDATE #TMP_TABLE SET GameScoreA = ISNULL(B1.F_Points, 0), GameScoreB = ISNULL(B2.F_Points,0), 
						ServerA = ISNULL( B1.F_Service, 0 ), ServerB = ISNULL(B2.F_Service, 0 )
				FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentGameID
				
			END
		ELSE--如果不存在，说明没有任何一局比赛开始，设置为0 : 0
			BEGIN
				UPDATE #TMP_TABLE SET GameScoreA = 0, GameScoreB = 0, ServerA = 0, ServerB = 0
			END				
	
	END
	
	DECLARE @PtA INT
	DECLARE @PtB INT
	DECLARE @IsReset INT = 0
	SELECT @PtA = GameScoreA, @PtB = GameScoreB FROM #TMP_TABLE
	IF @PtA = 21 OR @PtB = 21
	BEGIN
		IF ABS( (@PtA-@PtB) ) >= 2
		 SET @IsReset = 1
	END
	ELSE IF @PtA = 30 OR @PtB = 30
		SET @IsReset = 1
	ELSE IF @PtA >= 20 AND @PtB >= 20
	BEGIN
		IF ABS( (@PtA-@PtB) ) >= 2
		 SET @IsReset = 1
	END
	
	IF @IsReset = 1
		UPDATE #TMP_TABLE SET GameScoreA = 0, GameScoreB = 0, ServerA = 0, ServerB = 0
	
	SELECT * FROM #TMP_TABLE

	
SET NOCOUNT OFF
END


GO


