IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetSingleScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetSingleScore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_BDTT_GetSingleScore]
----功		  能：获取TT SCB需要的个人赛比分
----作		  者：王强
----日		  期: 2011-02-17

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetSingleScore]
		@MatchID     INT,
		@DisciplineCode NVARCHAR(2) = 'TT'
AS
BEGIN
	
SET NOCOUNT ON

	
	--定义Game表
	CREATE TABLE #TMP_GAME_TB
	(
		Game_No INT,--当局序号
		[Status] INT,--0 未开始 1 开始 2 结束 
		ScoreA INT,
		ScoreB INT,
		Game_Duation NVARCHAR(10),
		StatusA NVARCHAR(10),--IRM
		StatusB NVARCHAR(10)
	)
									
	INSERT INTO #TMP_GAME_TB (Game_No, [Status], ScoreA, Game_Duation, StatusA )
		(SELECT Game.F_Order AS Game_No, (CASE 
										 WHEN (Game.F_MatchSplitStatusID IS NULL) OR Game.F_MatchSplitStatusID <= 30 THEN '0'
										 WHEN Game.F_MatchSplitStatusID BETWEEN 40 AND 60 THEN '1'
										 ELSE '2'
										 END), 
				ISNULL(B.F_Points,0), dbo.Fun_info_BD_GetTimeForHHMMSS(Game.F_SpendTime), ISNULL(C.F_IRMCODE, '')
			FROM TS_Match_Split_Info AS Game
			LEFT JOIN TS_Match_Split_Result AS B ON B.F_CompetitionPosition = 1 AND B.F_Points IS NOT NULL--AND B.F_MatchID = Game.F_MatchID
						AND B.F_MatchSplitID = Game.F_MatchSplitID
			LEFT JOIN TC_IRM AS C ON C.F_IRMID = B.F_IRMID
			WHERE Game.F_MatchID = @MatchID AND B.F_MatchID = @MatchID
		)
		
	
	UPDATE #TMP_GAME_TB SET ScoreB = ISNULL(B.F_Points,0), StatusB = ISNULL(C.F_IRMCODE,'')
	FROM TS_Match_Split_Info AS Game
	LEFT JOIN TS_Match_Split_Result AS B ON B.F_CompetitionPosition = 2 AND B.F_Points IS NOT NULL
				AND B.F_MatchSplitID = Game.F_MatchSplitID
	LEFT JOIN TC_IRM AS C ON C.F_IRMID = B.F_IRMID
	WHERE Game.F_MatchID = @MatchID AND Game.F_Order = Game_No AND B.F_MatchID = @MatchID
	
	
	IF NOT EXISTS ( SELECT Game_No FROM #TMP_GAME_TB )
		INSERT INTO #TMP_GAME_TB (Game_No, ScoreA, ScoreB) VALUES(1,0,0)
	
	DECLARE @CourtNameCHN NVARCHAR(100)
	DECLARE @EventNameCHN NVARCHAR(100)
	DECLARE @PhaseNameCHN NVARCHAR(100)
	
	
	DECLARE @CourtNameENG NVARCHAR(100)
	DECLARE @EventNameENG NVARCHAR(100)
	DECLARE @PhaseNameENG NVARCHAR(100)
	
	DECLARE @PlayerNameA_CHN NVARCHAR(100)
	DECLARE @PlayerNameA_ENG NVARCHAR(100)
	DECLARE @PlayerNameB_CHN NVARCHAR(100)
	DECLARE @PlayerNameB_ENG NVARCHAR(100)
	
	DECLARE @PlayerNameA1CHN NVARCHAR(100)
	DECLARE @PlayerNameA1ENG NVARCHAR(100)
	DECLARE @PlayerNameA2CHN NVARCHAR(100)
	DECLARE @PlayerNameA2ENG NVARCHAR(100)
	
	DECLARE @PlayerNameB1CHN NVARCHAR(100)
	DECLARE @PlayerNameB1ENG NVARCHAR(100)
	DECLARE @PlayerNameB2CHN NVARCHAR(100)
	DECLARE @PlayerNameB2ENG NVARCHAR(100)
	
	DECLARE @TeamNameA_ENG NVARCHAR(100)
	DECLARE @TeamNameA_CHN NVARCHAR(100)
	DECLARE @TeamNameB_ENG NVARCHAR(100)
	DECLARE @TeamNameB_CHN NVARCHAR(100)
	
	DECLARE @RegA INT
	DECLARE @RegB INT
	DECLARE @RegA1 INT
	DECLARE @RegA2 INT
	DECLARE @RegB1 INT
	DECLARE @RegB2 INT
	
	DECLARE @NOCCodeA NVARCHAR(10)
	DECLARE @NOCCodeB NVARCHAR(10)
	DECLARE @TotalScoreA NVARCHAR(10)
	DECLARE @TotalScoreB NVARCHAR(10)
	DECLARE @PlayerAService NVARCHAR(5) = '0'
	DECLARE @PlayerBService NVARCHAR(5) = '0'
	
	DECLARE @Type INT
	
	SELECT @CourtNameCHN = B.F_CourtShortName, @EventNameCHN = D.F_EventShortName, @PhaseNameCHN = E.F_PhaseShortName
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = @MatchID
	
	SELECT @CourtNameENG = B.F_CourtShortName, @EventNameENG = D.F_EventShortName, @PhaseNameENG = E.F_PhaseShortName, @Type = F.F_PlayerRegTypeID
	FROM TS_Match AS A
	LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Phase_Des AS E ON E.F_PhaseID = C.F_PhaseID AND E.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS D ON D.F_EventID = C.F_EventID AND D.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event AS F ON F.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	SELECT @TotalScoreA = B.F_Points, @TotalScoreB = C.F_Points, 
			@TeamNameA_ENG = E11.F_DelegationShortName, @TeamNameA_CHN = E12.F_DelegationShortName,
			@TeamNameB_ENG = E21.F_DelegationShortName, @TeamNameB_CHN = E22.F_DelegationShortName
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_CompetitionPositionDes1 = 1
	LEFT JOIN TR_Register AS D1 ON D1.F_RegisterID = B.F_RegisterID
	LEFT JOIN TC_Delegation_Des AS E11 ON E11.F_DelegationID = D1.F_DelegationID AND E11.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Delegation_Des AS E12 ON E12.F_DelegationID = D1.F_DelegationID AND E12.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Match_Result AS C ON C.F_MatchID = A.F_MatchID AND C.F_CompetitionPositionDes1 = 2
	LEFT JOIN TR_Register AS D2 ON D2.F_RegisterID = C.F_RegisterID
	LEFT JOIN TC_Delegation_Des AS E21 ON E21.F_DelegationID = D2.F_DelegationID AND E21.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Delegation_Des AS E22 ON E22.F_DelegationID = D2.F_DelegationID AND E22.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = @MatchID
	
	SELECT @RegA = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
	SELECT @RegB = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	
	SELECT @NOCCodeA = B.F_DelegationCode FROM TR_Register AS A
	LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
	WHERE A.F_RegisterID = @RegA
	
	SELECT @NOCCodeB = B.F_DelegationCode FROM TR_Register AS A
	LEFT JOIN TC_Delegation AS B ON B.F_DelegationID = A.F_DelegationID
	WHERE A.F_RegisterID = @RegB
				
	IF @Type = 3
		RETURN
	ELSE IF @Type = 2
		BEGIN
			SELECT @RegA1 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegA AND F_Order = 1
			SELECT @RegA2 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegA AND F_Order = 2
			SELECT @RegB1 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegB AND F_Order = 1
			SELECT @RegB2 = F_MemberRegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegB AND F_Order = 2
			
		END
	
	IF @Type = 1
		BEGIN
			SET @RegA1 = @RegA
			SET @RegB1 = @RegB
		END
	
	SELECT @PlayerNameA1ENG = B.F_SBShortName, @PlayerNameA1CHN = C.F_SBShortName, 
			@PlayerNameA_ENG = B.F_SBShortName, @PlayerNameA_CHN = C.F_SBShortName
	FROM TR_Register AS A
	LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
	WHERE A.F_RegisterID = @RegA1
	
	SELECT @PlayerNameB1ENG = B.F_SBShortName, @PlayerNameB1CHN = C.F_SBShortName,
			@PlayerNameB_ENG = B.F_SBShortName, @PlayerNameB_CHN = C.F_SBShortName
	FROM TR_Register AS A
	LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
	WHERE A.F_RegisterID = @RegB1
	
	IF @Type = 2
		BEGIN
			SELECT @PlayerNameA2ENG = B.F_SBShortName, @PlayerNameA2CHN = C.F_SBShortName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegA2
			
			SELECT @PlayerNameB2ENG = B.F_SBShortName, @PlayerNameB2CHN = C.F_SBShortName
			FROM TR_Register AS A
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
			LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
			WHERE A.F_RegisterID = @RegB2
			
			SET @PlayerNameA_CHN = ''
			SET @PlayerNameB_CHN = ''
			SET @PlayerNameA_ENG = ''
			SET @PlayerNameB_ENG = ''
		END
	ELSE
		BEGIN
			SET @PlayerNameA1CHN = ''
			SET @PlayerNameB1CHN = ''
			SET @PlayerNameA1ENG = ''
			SET @PlayerNameB1ENG = ''
			
			SET @PlayerNameA2CHN = ''
			SET @PlayerNameB2CHN = ''
			SET @PlayerNameA2ENG = ''
			SET @PlayerNameB2ENG = ''
		END		
	
	--SELECT @NOCCodeA = D.F_DelegationCode, @PlayerNameA1CHN = C.F_SBShortName, @TotalScoreA = A.F_Points
	--FROM TS_Match_Result AS A
	--LEFT JOIN TR_Register AS B ON B.F_RegisterID = A.F_RegisterID
	--LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'CHN'
	--LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = B.F_DelegationID
	--WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	
	--SELECT @NOCCodeB = D.F_DelegationCode, @PlayerNameB1CHN = C.F_SBShortName, @TotalScoreB = A.F_Points
	--FROM TS_Match_Result AS A
	--LEFT JOIN TR_Register AS B ON B.F_RegisterID = A.F_RegisterID
	--LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'CHN'
	--LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = B.F_DelegationID
	--WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
	
	--SELECT @PlayerNameAENG = C.F_SBShortName
	--FROM TS_Match_Result AS A
	--LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'ENG'
	--WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
	
	--SELECT @PlayerNameBENG = C.F_SBShortName
	--FROM TS_Match_Result AS A
	--LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'ENG'
	--WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2

	DECLARE @CurrentSetSplitID INT
	
	SET @CurrentSetSplitID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
	IF EXISTS ( SELECT * FROM TS_Match_Split_Result WHERE F_Service = 1 AND F_CompetitionPosition = 1 AND F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetSplitID)
		SET @PlayerAService = '1'
	
	IF EXISTS ( SELECT * FROM TS_Match_Split_Result WHERE F_Service = 1 AND F_CompetitionPosition = 2 AND F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetSplitID)
		SET @PlayerBService = '1'
	

	
	DECLARE @CurrentGameScoreDes NVARCHAR(20)
	DECLARE @CurrentGameScoreA INT
	DECLARE @CurrentGameScoreB INT
	DECLARE @CurrentOrder INT = -1
	IF @CurrentSetSplitID = 0
		SET @CurrentGameScoreDes = '0 : 0'
	ELSE
		BEGIN
			SELECT @CurrentGameScoreDes = CAST( ISNULL( B1.F_Points, 0) AS NVARCHAR(10) ) + ' : ' + CAST( ISNULL( B2.F_Points, 0) AS NVARCHAR(10) ),
					@CurrentGameScoreA = ISNULL( B1.F_Points, 0),@CurrentGameScoreB = ISNULL( B2.F_Points, 0)
			FROM TS_Match_Split_Info AS A
			LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = @CurrentSetSplitID AND B1.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = @CurrentSetSplitID AND B2.F_CompetitionPosition = 2
			WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetSplitID
			
			SELECT @CurrentOrder = F_Order FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentSetSplitID
		END
	
	DECLARE @ResultA INT
	DECLARE @ResultB INT
	
	SELECT @ResultA = CASE WHEN F_ResultID IS NULL THEN NULL WHEN F_ResultID = 1 THEN 1 WHEN F_ResultID = 2 THEN 0 ELSE NULL END
	FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
	
	SELECT @ResultB = CASE WHEN F_ResultID IS NULL THEN NULL WHEN F_ResultID = 1 THEN 1 WHEN F_ResultID = 2 THEN 0 ELSE NULL END
	FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	
	SELECT ISNULL(A.ScoreA, 0) AS GameScoreA, ISNULL(A.ScoreB,0) AS GameScoreB, 
				(CONVERT( NVARCHAR(10),ISNULL(A.ScoreA, 0) ) + ' : ' + CONVERT( NVARCHAR(10), ISNULL(A.ScoreB,0))) AS GameScoreDes,
				CASE @DisciplineCode
				WHEN 'TT' THEN ISNULL(@TotalScoreA, '0') 
				WHEN 'BD' THEN '' + ISNULL(@TotalScoreA, '0') + ''
				ELSE '0'
				END 
				AS MatchScoreA, 
				CASE @DisciplineCode
				WHEN 'TT' THEN ISNULL(@TotalScoreB, '0') 
				WHEN 'BD' THEN '' + ISNULL(@TotalScoreB, '0') + ''
				ELSE '0'
				END 
				AS MatchScoreB, 
				(ISNULL(@TotalScoreA, '0') +  ':' + ISNULL(@TotalScoreB, '0')) AS MatchScoreDes,
			CASE
			WHEN ( CAST(A.ScoreA AS INT) > CAST( A.ScoreB AS INT)) AND A.Game_No != @CurrentOrder THEN CAST(A.ScoreA AS NVARCHAR(10)) + ':' + CAST(A.ScoreB AS NVARCHAR(10))
			ELSE NULL END
			AS ScoreDesA, 
			CASE
			WHEN ( CAST(A.ScoreA AS INT) < CAST( A.ScoreB AS INT)) AND A.Game_No != @CurrentOrder THEN CAST(A.ScoreA AS NVARCHAR(10)) + ':' + CAST(A.ScoreB AS NVARCHAR(10))
			ELSE NULL END
			AS ScoreDesB, 
			@PlayerAService AS ServiceA, @PlayerBService AS ServiceB, 
			UPPER(@CourtNameENG) AS CourtName_ENG, @CourtNameCHN AS CourtName_CHN,UPPER(@EventNameENG) AS EventName_ENG,@EventNameCHN AS EventName_CHN, 
			UPPER(@PhaseNameENG) AS PhaseName_ENG, @PhaseNameCHN AS PhaseName_CHN, '[Image]' + @NOCCodeA AS NOC_A, '[Image]' + @NOCCodeB AS NOC_B, 
			@PlayerNameA1ENG AS PlayerNameA1_ENG, @PlayerNameA1CHN AS PlayerNameA1_CHN, @PlayerNameA2ENG AS PlayerNameA2_ENG, @PlayerNameA2CHN AS PlayerNameA2_CHN, 
			@PlayerNameB1ENG AS PlayerNameB1_ENG, @PlayerNameB1CHN AS PlayerNameB1_CHN, @PlayerNameB2ENG AS PlayerNameB2_ENG, @PlayerNameB2CHN AS PlayerNameB2_CHN,
			@CurrentGameScoreDes AS CurrentGameScore,
			CASE WHEN CAST(A.ScoreA AS INT) > CAST(A.ScoreB AS INT) AND A.Game_No != @CurrentOrder THEN '('+ CAST(A.Game_No AS NVARCHAR(10) )+')' ELSE NULL END AS GameNoA,
			CASE WHEN CAST(A.ScoreA AS INT) < CAST(A.ScoreB AS INT) AND A.Game_No != @CurrentOrder THEN '('+CAST(A.Game_No AS NVARCHAR(10) )+')' ELSE NULL END AS GameNoB,
			'Game ' + CAST(( CASE @CurrentOrder WHEN -1 THEN 1 ELSE @CurrentOrder END) AS NVARCHAR(4) ) AS GameName, @CurrentGameScoreA AS CurrentGameScoreA, @CurrentGameScoreB AS CurrentGameScoreB,
			@ResultA AS ResultA, @ResultB AS ResultB,
			@PhaseNameENG + '（' + @PhaseNameCHN + '）' AS PhaseName_All,
			@CourtNameENG + '（' + @CourtNameCHN + '）' AS CourtName_All,
			@PlayerNameA_CHN AS PlayerNameA_ENG, @PlayerNameA_ENG AS PlayerNameA_CHN,
			@PlayerNameB_CHN AS PlayerNameB_ENG, @PlayerNameB_ENG AS PlayerNameB_CHN,
			@TeamNameA_ENG AS TeamNameA_ENG, @TeamNameA_CHN AS TeamNameA_CHN,
			@TeamNameB_ENG AS TeamNameB_ENG, @TeamNameB_CHN AS TeamNameB_CHN
	FROM #TMP_GAME_TB AS A
	RETURN
	
SET NOCOUNT OFF
END


GO


