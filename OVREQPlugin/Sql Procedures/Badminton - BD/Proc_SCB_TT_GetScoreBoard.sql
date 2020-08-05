IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_TT_GetScoreBoard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_TT_GetScoreBoard]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_TT_GetScoreBoard]
----功		  能：获取SCB_TT个人赛计分板数据
----作		  者：王强
----日		  期: 2011-02-21

CREATE PROCEDURE [dbo].[Proc_SCB_TT_GetScoreBoard]
				@Type INT = 0 --0为不过滤，1只显示单打，3只显示团体
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @CurrentSetID INT
	--定义Game表
	CREATE TABLE #TMP_SCORE_BOARD
	(
		MatchID INT,
		CurrentSetID INT,
		CourtNO INT,
		PlayerNameA_ENG NVARCHAR(300), 
		PlayerNameA_CHN NVARCHAR(300), 
		PlayerNameB_ENG NVARCHAR(300), 
		PlayerNameB_CHN NVARCHAR(300), 
		NOC_A NVARCHAR(50),
		NOC_B NVARCHAR(50),
		ScoreA NVARCHAR(10),
		ScoreB NVARCHAR(10),
		EventCode NVARCHAR(10),
		GameScoreA1 INT,
		GameScoreA2 INT,
		GameScoreA3 INT,
		GameScoreB1 INT,
		GameScoreB2 INT,
		GameScoreB3 INT,
		SetScoreA  INT,
		SetScoreB  INT,
		CourtName_ENG NVARCHAR(100),
		CourtName_CHN NVARCHAR(100),
		CurrentGameA INT,
		CurrentGameB INT,
		GameScoreA4 INT,
		GameScoreA5 INT,
		GameScoreA6 INT,
		GameScoreA7 INT,
		GameScoreB4 INT,
		GameScoreB5 INT,
		GameScoreB6 INT,
		GameScoreB7 INT,
		WinLostA INT,
		WinLostB INT
	)
	
	INSERT INTO #TMP_SCORE_BOARD (MatchID, CourtNO, PlayerNameA_ENG, NOC_A, ScoreA, EventCode, CourtName_ENG, CourtName_CHN)
	(
		SELECT A.F_MatchID, A.F_CourtID ,C.F_SBLongName, E.F_DelegationShortName, ISNULL(B.F_Points, 0),
				(G.F_EventComment + A.F_RaceNum), H1.F_CourtShortName, H2.F_CourtShortName
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register AS D ON D.F_RegisterID = C.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS E ON E.F_DelegationID = D.F_DelegationID AND E.F_LanguageCode = 'CHN'
		LEFT JOIN TS_Phase AS F ON F.F_PhaseID = A.F_PhaseID
		LEFT JOIN TS_Event_Des AS G ON G.F_EventID = F.F_EventID AND G.F_LanguageCode = 'ENG'
		LEFT JOIN TC_Court_Des AS H1 ON H1.F_CourtID = A.F_CourtID AND H1.F_LanguageCode = 'ENG'
		LEFT JOIN TC_Court_Des AS H2 ON H2.F_CourtID = A.F_CourtID AND H2.F_LanguageCode = 'CHN'
		WHERE A.F_MatchStatusID IN (50, 60, 100,120)--AND [dbo].[Fun_BD_GetCurrentSetAndGameID](A.F_MatchID, 1) != 0
	
	)				
	
	IF @Type = 1
	BEGIN
		DELETE FROM #TMP_SCORE_BOARD WHERE MatchID IN
		(
			SELECT A.F_MatchID FROM TS_Match AS A
			LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
			WHERE C.F_PlayerRegTypeID = 3
		)
	END
	ELSE IF @Type = 3
	BEGIN
		DELETE FROM #TMP_SCORE_BOARD WHERE MatchID IN
		(
			SELECT A.F_MatchID FROM TS_Match AS A
			LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
			WHERE C.F_PlayerRegTypeID IN (1,2)
		)
	END
	
	--B选手
	UPDATE #TMP_SCORE_BOARD SET PlayerNameB_ENG = C.F_SBLongName, NOC_B = E.F_DelegationShortName, ScoreB = ISNULL(B.F_Points,0)
	FROM TS_Match_Result AS B 
	LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = B.F_RegisterID AND C.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register AS D ON D.F_RegisterID = C.F_RegisterID
	LEFT JOIN TC_Delegation_Des AS E ON E.F_DelegationID = D.F_DelegationID AND E.F_LanguageCode = 'CHN'
	WHERE B.F_MatchID = MatchID AND B.F_CompetitionPositionDes1 = 2
	
	--A中文
	UPDATE #TMP_SCORE_BOARD SET PlayerNameA_CHN = C.F_SBLongName
	FROM TS_Match_Result AS A
	LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = MatchID AND A.F_CompetitionPositionDes1 = 1
	
	--B中文
	UPDATE #TMP_SCORE_BOARD SET PlayerNameB_CHN = C.F_SBLongName
	FROM TS_Match_Result AS A
	LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'CHN'
	WHERE A.F_MatchID = MatchID AND A.F_CompetitionPositionDes1 = 2
	
	IF @Type = 3
	BEGIN
		UPDATE #TMP_SCORE_BOARD SET CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](MatchID,1)
		UPDATE #TMP_SCORE_BOARD SET PlayerNameA_CHN = C1.F_SBShortName, PlayerNameB_CHN = C2.F_SBShortName
		FROM #TMP_SCORE_BOARD AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.MatchID AND B1.F_MatchSplitID = A.CurrentSetID AND B1.F_CompetitionPosition = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'CHN'
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.MatchID AND B2.F_MatchSplitID = A.CurrentSetID AND B2.F_CompetitionPosition = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'CHN'
		WHERE A.CurrentSetID IS NOT NULL
		
		UPDATE #TMP_SCORE_BOARD SET PlayerNameA_ENG = PlayerNameA_CHN, PlayerNameB_ENG = PlayerNameB_CHN
	END

	DECLARE @MatchID INT
	DECLARE @MatchType INT
	DECLARE tmp_cursor CURSOR FOR SELECT MatchID FROM #TMP_SCORE_BOARD
	OPEN tmp_cursor
	FETCH NEXT FROM tmp_cursor INTO @MatchID
	WHILE @@FETCH_STATUS=0
		BEGIN
			SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
			
			IF @MatchType = 1
			BEGIN
				UPDATE #TMP_SCORE_BOARD SET GameScoreA1 = B1.F_Points,GameScoreB1 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 1 AND Z.MatchID = @MatchID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA2 = B1.F_Points,GameScoreB2 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 2 AND Z.MatchID = @MatchID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA3 = B1.F_Points,GameScoreB3 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 3 AND Z.MatchID = @MatchID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA4 = B1.F_Points,GameScoreB4 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 4 AND Z.MatchID = @MatchID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA5 = B1.F_Points,GameScoreB5 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 5 AND Z.MatchID = @MatchID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA6 = B1.F_Points,GameScoreB6 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 6 AND Z.MatchID = @MatchID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA7 = B1.F_Points,GameScoreB7 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 7 AND Z.MatchID = @MatchID
				
			END
			ELSE
			BEGIN
				
				SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
				DECLARE @CurrentGameID INT
				SET @CurrentGameID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 2)
				
				--PRINT @MatchID
				UPDATE #TMP_SCORE_BOARD SET GameScoreA1 = B1.F_Points,GameScoreB1 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 1 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA2 = B1.F_Points,GameScoreB2 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 2 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA3 = B1.F_Points,GameScoreB3 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 3 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA4 = B1.F_Points,GameScoreB4 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 4 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA5 = B1.F_Points,GameScoreB5 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 5 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA6 = B1.F_Points,GameScoreB6 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 6 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				UPDATE #TMP_SCORE_BOARD SET GameScoreA7 = B1.F_Points,GameScoreB7 = B2.F_Points
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND A.F_Order = 7 AND Z.MatchID = @MatchID AND A.F_FatherMatchSplitID = @CurrentSetID
				
				
				UPDATE #TMP_SCORE_BOARD SET SetScoreA = ISNULL(B1.F_Points,0),SetScoreB = ISNULL(B2.F_Points,0)
				FROM #TMP_SCORE_BOARD AS Z
				LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = Z.MatchID
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
							AND B1.F_CompetitionPosition = 1
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
							AND B2.F_CompetitionPosition = 2
				WHERE A.F_MatchID = @MatchID AND Z.MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
				
				IF @CurrentGameID != 0 
				BEGIN
					UPDATE #TMP_SCORE_BOARD SET CurrentGameA = F_Points
					FROM #TMP_SCORE_BOARD AS A 
					LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = A.MatchID
					WHERE A.MatchID = @MatchID AND B.F_MatchSplitID = @CurrentGameID AND F_CompetitionPosition = 1
					
					UPDATE #TMP_SCORE_BOARD SET CurrentGameB = F_Points
					FROM #TMP_SCORE_BOARD AS A 
					LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = A.MatchID
					WHERE A.MatchID = @MatchID AND B.F_MatchSplitID = @CurrentGameID AND F_CompetitionPosition = 2
					
					UPDATE #TMP_SCORE_BOARD SET WinLostA =
					(CASE 
						WHEN B.F_ResultID IS NULL THEN NULL
					    WHEN B.F_ResultID = 1 THEN 1
						WHEN B.F_ResultID = 2 THEN 0
					    ELSE NULL END)
					FROM #TMP_SCORE_BOARD AS A
					LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.MatchID
					WHERE A.MatchID = @MatchID AND B.F_CompetitionPositionDes1 = 1
					
					UPDATE #TMP_SCORE_BOARD SET WinLostB =
					(CASE 
						WHEN B.F_ResultID IS NULL THEN NULL
					    WHEN B.F_ResultID = 1 THEN 1
					    WHEN B.F_ResultID = 2 THEN 0
					    ELSE NULL END)
					FROM #TMP_SCORE_BOARD AS A
					LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.MatchID
					WHERE A.MatchID = @MatchID AND B.F_CompetitionPositionDes1 = 2
				--	UPDATE #TMP_SCORE_BOARD SET CurrentGameB = F_Points
				--	FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @CurrentGameID AND F_CompetitionPosition = 2
				END
				
			END
			
			NEXT_:  FETCH NEXT FROM tmp_cursor INTO @MatchID
		END
	CLOSE tmp_cursor
	DEALLOCATE tmp_cursor
	
	
	
	SELECT CourtNO, PlayerNameA_ENG, PlayerNameA_CHN, PlayerNameB_ENG, PlayerNameB_CHN, NOC_A, NOC_B, ScoreA, ScoreB, EventCode,
			GameScoreA1,GameScoreA2,GameScoreA3,GameScoreB1,GameScoreB2,GameScoreB3, SetScoreA, SetScoreB, CourtName_ENG,CourtName_CHN,
				 CurrentGameA,CurrentGameB, GameScoreA4,GameScoreB4, GameScoreA5,GameScoreB5, GameScoreA6,GameScoreB6, GameScoreA7,GameScoreB7, WinLostA, WinLostB
			FROM #TMP_SCORE_BOARD ORDER BY CourtNO
	
SET NOCOUNT OFF
END


GO


