IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetTeamScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetTeamScore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_BDTT_GetTeamScore]
----功		  能：获取TT SCB需要的团体比分
----作		  者：王强
----日		  期: 2011-02-17

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetTeamScore]
		@MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @CurrentSetID INT
	--DECLARE @MatchSplitID INT
	--DECLARE @FatherSplitID INT

	--盘比分表
	CREATE TABLE #TB_SCORE
	(
		SplitID INT,
		ScoreA NVARCHAR(10),
		ScoreB NVARCHAR(10)
	)

	--获取所有的小场比分
	INSERT INTO #TB_SCORE (ScoreA, SplitID) 
	SELECT F_Points, F_MatchSplitID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1 AND F_MatchSplitID IN
	(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID = 0 AND F_MatchID = @MatchID)

	UPDATE #TB_SCORE SET ScoreB = F_Points
	FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2 AND F_MatchSplitID IN
	(SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_FatherMatchSplitID = 0 AND F_MatchID = @MatchID)
	AND F_MatchSplitID = SplitID

	SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
	
	IF @CurrentSetID = 0
		RETURN


	DECLARE @CurrentGameID INT = -1
	DECLARE @CurrentGameOrder INT = 0
	
	--首先查找是否有运行的比赛
	SELECT @CurrentGameID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 2)
	
	IF @CurrentGameID = 0
		RETURN

	DECLARE @CurrentGameScoreDes NVARCHAR(20)
	DECLARE @CurrentGameScoreA INT
	DECLARE @CurrentGameScoreB INT
	DECLARE @GameDes NVARCHAR(20)
	DECLARE @MatchDes NVARCHAR(20)
	
	SELECT @MatchDes = 'Match ' + CAST( F_Order AS NVARCHAR(4)) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID
	IF @CurrentGameID != 0
		BEGIN
			SELECT @CurrentGameScoreDes = ISNULL(CAST( B1.F_Points AS NVARCHAR(4)),'0') + ' : '
					+ ISNULL(CAST( B2.F_Points AS NVARCHAR(4)),'0'), @CurrentGameOrder = 
					CASE @CurrentGameOrder
					WHEN -1 THEN -1
					ELSE A.F_Order
					END, @GameDes = 'Game ' + CAST(A.F_Order AS NVARCHAR(4)),
					@CurrentGameScoreA = ISNULL( B1.F_Points, 0 ),@CurrentGameScoreB = ISNULL( B2.F_Points, 0 )
			 FROM TS_Match_Split_Info AS A
			LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
													AND B1.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
													AND B2.F_CompetitionPosition = 2
			WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentGameID
			
		END
	ELSE--如果不存在，说明没有任何一局比赛开始，设置为0 : 0
		BEGIN
			SET @CurrentGameScoreDes = '0 : 0'
			SET @GameDes = 'Game 1'
		END
	
	--局比分表
	CREATE TABLE #TMP_GAME_TB
	(
		Game_No INT,--当局序号
		ScoreA NVARCHAR(10),
		ScoreB NVARCHAR(10)
	)
	
	--获取
	INSERT INTO #TMP_GAME_TB (Game_No, ScoreA)
	(   SELECT A.F_Order, B.F_Points
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 1
					AND B.F_MatchSplitID = A.F_MatchSplitID 
	    WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID /*AND B.F_Points IS NOT NULL*/
	)
	
	UPDATE #TMP_GAME_TB SET ScoreB = B.F_Points
					FROM TS_Match_Split_Info AS A
					LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 2
									AND B.F_MatchSplitID = A.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND A.F_Order = Game_No AND B.F_MatchID = @MatchID 
							AND A.F_FatherMatchSplitID = @CurrentSetID /*AND B.F_Points IS NOT NULL*/
	
	INSERT INTO #TB_SCORE (SplitID, ScoreA, ScoreB) (SELECT * FROM #TMP_GAME_TB)
	DROP TABLE #TMP_GAME_TB
	
	DECLARE @CourtNameENG NVARCHAR(30)
	DECLARE @EventNameENG NVARCHAR(30)
	DECLARE @PhaseNameENG NVARCHAR(30)
	DECLARE @PlayerNameAENG NVARCHAR(300)
	DECLARE @PlayerNameBENG NVARCHAR(300)
	DECLARE @PlayerNameACHN NVARCHAR(300)
	DECLARE @PlayerNameBCHN NVARCHAR(300)
	DECLARE @PlayerNameA1ENG NVARCHAR(300)
	DECLARE @PlayerNameA1CHN NVARCHAR(300)
	DECLARE @PlayerNameB1ENG NVARCHAR(300)
	DECLARE @PlayerNameB1CHN NVARCHAR(300)
	DECLARE @PlayerNameA2ENG NVARCHAR(300)
	DECLARE @PlayerNameA2CHN NVARCHAR(300)
	DECLARE @PlayerNameB2ENG NVARCHAR(300)
	DECLARE @PlayerNameB2CHN NVARCHAR(300)
	
	DECLARE @TeamNameA_ENG NVARCHAR(30)
	DECLARE @TeamNameA_CHN NVARCHAR(30)
	DECLARE @TeamNameB_ENG NVARCHAR(30)
	DECLARE @TeamNameB_CHN NVARCHAR(30)
	
	DECLARE @RegA INT
	DECLARE @RegB INT
	DECLARE @RegisterIDA1 INT
	DECLARE @RegisterIDA2 INT
	DECLARE @RegisterIDB1 INT
	DECLARE @RegisterIDB2 INT
	
	DECLARE @CourtNameCHN NVARCHAR(30)
	DECLARE @EventNameCHN NVARCHAR(30)
	DECLARE @PhaseNameCHN NVARCHAR(30)
	
	DECLARE @SplitType INT
	
	
	DECLARE @NOCCodeA NVARCHAR(10)
	DECLARE @NOCCodeB NVARCHAR(10)
	DECLARE @TotalTeamScoreA INT
	DECLARE @TotalTeamScoreB INT
	DECLARE @SplitScoreA INT
	DECLARE @SplitScoreB INT
	DECLARE @PlayerAService NVARCHAR(5) = '0'
	DECLARE @PlayerBService NVARCHAR(5) = '0'
	DECLARE @CurrentSetScoreDes NVARCHAR(20)
	
	SELECT @CurrentSetScoreDes = ISNULL( CAST( B1.F_Points AS NVARCHAR(10) ),'0') + ' : ' + 
			ISNULL( CAST( B2.F_Points AS NVARCHAR(10) ), '0') FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
				AND B1.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
				AND B2.F_CompetitionPosition = 2
	WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
	
	SELECT @CourtNameENG = B.F_CourtShortName, @EventNameENG = D.F_EventShortName, @PhaseNameENG = E.F_PhaseShortName
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'ENG'
	WHERE A.F_MatchID = @MatchID

	
	SELECT @CourtNameCHN = B.F_CourtShortName, @EventNameCHN = D.F_EventShortName, @PhaseNameCHN = E.F_PhaseShortName
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = @MatchID
	
	SELECT @NOCCodeA = '[Image]'+D.F_DelegationCode, @TotalTeamScoreA = A.F_Points, 
			@TeamNameA_ENG = E1.F_SBLongName, @TeamNameA_CHN = E2.F_SBLongName
	FROM TS_Match_Result AS A
	LEFT JOIN TR_Register AS B ON B.F_RegisterID = A.F_RegisterID
	LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = B.F_DelegationID
	LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = A.F_RegisterID AND E1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = A.F_RegisterID AND E2.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	
	SELECT @NOCCodeB = '[Image]'+D.F_DelegationCode, @TotalTeamScoreB = A.F_Points,
			@TeamNameB_ENG = E1.F_SBLongName, @TeamNameB_CHN = E2.F_SBLongName
	FROM TS_Match_Result AS A
	LEFT JOIN TR_Register AS B ON B.F_RegisterID = A.F_RegisterID
	LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = B.F_DelegationID
	LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = A.F_RegisterID AND E1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = A.F_RegisterID AND E2.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
	
	--SELECT @RegA = B1.F_RegisterID, @RegB = B2.F_RegisterID FROM TS_Match_Split_Info AS A
	--LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = @MatchID AND B1.F_MatchSplitID = @CurrentSplitID 
	--			AND B1.F_CompetitionPosition = 1
	--LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = @MatchID AND B2.F_MatchSplitID = @CurrentSplitID 
	--			AND B2.F_CompetitionPosition = 2
	--WHERE A.F_MatchID = @MatchID AND B2.F_MatchSplitID = @CurrentSplitID
	
	SELECT @RegA = B1.F_RegisterID, @RegB = B2.F_RegisterID FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = @CurrentSetID
				AND B1.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = @CurrentSetID
				AND B2.F_CompetitionPosition = 2
	WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
	
	SELECT @SplitType = F_MatchSplitType FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID
	
	--如果是单打
	IF @SplitType <= 2
		BEGIN
			SET @RegisterIDA1 = @RegA
			SET @RegisterIDB1 = @RegB
		END
	ELSE
		BEGIN
			SELECT @RegisterIDA1 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegA AND F_Order = 1
			SELECT @RegisterIDA2 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegA AND F_Order = 2
			SELECT @RegisterIDB1 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegB AND F_Order = 1
			SELECT @RegisterIDB2 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegB AND F_Order = 2
		END
		
	SELECT @PlayerNameA1ENG = B1.F_SBLongName, @PlayerNameAENG = B1.F_SBLongName,@PlayerNameA1CHN = B2.F_SBLongName, @PlayerNameACHN = B2.F_SBLongName
	FROM TR_Register AS A
	LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
	WHERE A.F_RegisterID = @RegisterIDA1
	
	SELECT @PlayerNameB1ENG = B1.F_SBLongName, @PlayerNameBENG = B1.F_SBLongName,@PlayerNameB1CHN = B2.F_SBLongName,@PlayerNameBCHN = B2.F_SBLongName
	FROM TR_Register AS A
	LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
	WHERE A.F_RegisterID = @RegisterIDB1
	
	
	--双打则要获取A2和B2
	IF @SplitType >= 3
		BEGIN
			SELECT @PlayerNameA2ENG = B1.F_SBLongName, @PlayerNameA2CHN = B2.F_SBLongName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegisterIDA2
			
			SELECT @PlayerNameB2ENG = B1.F_SBLongName, @PlayerNameB2CHN = B2.F_SBLongName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegisterIDB2
			
			SET @PlayerNameAENG = ''
			SET @PlayerNameACHN = ''
			SET @PlayerNameBENG = ''
			SET @PlayerNameBCHN = ''
		END
	--ELSE
	--BEGIN
	--		SET @PlayerNameA1ENG = ''
	--		SET @PlayerNameA1CHN = ''
	--		SET @PlayerNameB1ENG = ''
	--		SET @PlayerNameB1CHN = ''
	--		SET @PlayerNameA2ENG = ''
	--		SET @PlayerNameA2CHN = ''
	--		SET @PlayerNameB2ENG = ''
	--		SET @PlayerNameB2CHN = ''
	--END
	
	
	--SELECT @PlayerNameAENG = B.F_SBLongName FROM TS_Match_Split_Result AS A
	--LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND F_LanguageCode = 'ENG'
	--WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSplitID AND F_CompetitionPosition = 1
	
	--SELECT @PlayerNameBENG = B.F_SBLongName FROM TS_Match_Split_Result AS A
	--LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND F_LanguageCode = 'ENG'
	--WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSplitID AND F_CompetitionPosition = 2
	
	--SELECT @PlayerNameACHN = B.F_SBLongName FROM TS_Match_Split_Result AS A
	--LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND F_LanguageCode = 'CHN'
	--WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSplitID AND F_CompetitionPosition = 1
	
	--SELECT @PlayerNameBCHN = B.F_SBLongName FROM TS_Match_Split_Result AS A
	--LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND F_LanguageCode = 'CHN'
	--WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSplitID AND F_CompetitionPosition = 2
	
	SELECT @SplitScoreA = F_Points FROM TS_Match_Split_Result 
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID AND F_CompetitionPosition = 1
	
	SELECT @SplitScoreB = F_Points FROM TS_Match_Split_Result 
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetID AND F_CompetitionPosition = 2


		
	DECLARE @ResultA INT
	DECLARE @ResultB INT
	
	SELECT @ResultA = CASE WHEN F_ResultID IS NULL THEN NULL WHEN F_ResultID = 1 THEN 1 WHEN F_ResultID = 2 THEN 0 ELSE NULL END
	FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
	
	SELECT @ResultB = CASE WHEN F_ResultID IS NULL THEN NULL WHEN F_ResultID = 1 THEN 1 WHEN F_ResultID = 2 THEN 0 ELSE NULL END
	FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2

	SELECT @PlayerAService = CASE F_Service WHEN 1 THEN '1' ELSE '0' END  FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentGameID AND F_CompetitionPosition = 1
	SELECT @PlayerBService = CASE F_Service WHEN 1 THEN '1' ELSE '0' END  FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentGameID AND F_CompetitionPosition = 2
	
	SELECT A.ScoreA, A.ScoreB, 
			CASE
			WHEN ( CAST(A.ScoreA AS INT) > CAST( A.ScoreB AS INT)) AND (A.SplitID != @CurrentGameOrder) THEN A.ScoreA + ':' + A.ScoreB 
			ELSE NULL END
			AS ScoreDesA, 
			CASE
			WHEN ( CAST(A.ScoreA AS INT) < CAST( A.ScoreB AS INT)) AND (A.SplitID != @CurrentGameOrder) THEN A.ScoreA + ':' + A.ScoreB 
			ELSE NULL END
			AS ScoreDesB, 
			CASE WHEN CAST(A.ScoreA AS INT) > CAST(A.ScoreB AS INT) AND A.SplitID != @CurrentGameOrder THEN '('+ CAST(A.SplitID AS NVARCHAR(10) )+')' ELSE NULL END AS GameNoA,
			CASE WHEN CAST(A.ScoreA AS INT) < CAST(A.ScoreB AS INT) AND A.SplitID != @CurrentGameOrder THEN '('+CAST(A.SplitID AS NVARCHAR(10) )+')' ELSE NULL END AS GameNoB,
			UPPER(@CourtNameENG) AS CourtName_ENG, UPPER(@CourtNameCHN) AS CourtName_CHN, 
			UPPER(@EventNameENG) AS EventName_ENG, UPPER(@EventNameCHN) AS EventName_CHN, 
			UPPER(@PhaseNameENG) AS PhaseName_ENG, UPPER(@PhaseNameCHN) AS PhaseName_CHN, 
			@PlayerNameA1ENG AS PlayerNameA1_ENG, @PlayerNameA1CHN AS PlayerNameA1_CHN,  
			@PlayerNameB1ENG AS PlayerNameB1_ENG, @PlayerNameB1CHN AS PlayerNameB1_CHN,  
			@PlayerNameA2ENG AS PlayerNameA2_ENG, @PlayerNameA2CHN AS PlayerNameA2_CHN,  
			@PlayerNameB2ENG AS PlayerNameB2_ENG, @PlayerNameB2CHN AS PlayerNameB2_CHN,  
			@TeamNameA_ENG AS TeamNocA_ENG, @TeamNameA_CHN AS TeamNocA_CHN, @TeamNameB_ENG AS TeamNocB_ENG, @TeamNameB_CHN AS TeamNocB_CHN,
			@NOCCodeA AS NOC_A, @NOCCodeB AS NOC_B, ISNULL(@TotalTeamScoreA,0) AS TolTeamScoreA, 
			ISNULL( @TotalTeamScoreB,0) AS TolTeamScoreB, 
			CAST(ISNULL(@TotalTeamScoreA,0) AS NVARCHAR(4)) + ' : ' + CAST(ISNULL(@TotalTeamScoreB,0) AS NVARCHAR(4)) AS TotalTeamScoreDes,
			@PlayerAService AS Service_A, @PlayerBService As Service_B, ISNULL(@SplitScoreA,0) AS SplitScoreA, ISNULL(@SplitScoreB,0) AS SplitScoreB, 
			@CurrentSetScoreDes AS SetScoreDes, @CurrentGameScoreDes AS CurrentGameScoreDes, @GameDes AS GameDes, @MatchDes AS MatchDes,
			@CurrentGameScoreA AS CurrentGameScoreA,@CurrentGameScoreB AS CurrentGameScoreB, @ResultA AS ResultA, @ResultB AS ResultB,
			@PlayerNameAENG AS PlayerNameA_ENG, @PlayerNameACHN AS PlayerNameA_CHN,@PlayerNameBENG AS PlayerNameB_ENG, @PlayerNameBCHN AS PlayerNameB_CHN,
			@PhaseNameENG + '（' + @PhaseNameCHN + '）' AS PhaseName_All, @CourtNameENG + '（' + @CourtNameCHN + '）' AS CourtName_All
			
	FROM #TB_SCORE AS A
	
	--注意：分数前5行为盘比分，后5或7行为局比分

SET NOCOUNT OFF
END


GO


