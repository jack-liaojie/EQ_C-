IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_TT_GetSingleScoreDouble]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_TT_GetSingleScoreDouble]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_TT_GetSingleScoreDouble]
----功		  能：获取TT SCB需要的个人赛比分(双屏)
----作		  者：王强
----日		  期: 2011-05-23

CREATE PROCEDURE [dbo].[Proc_SCB_TT_GetSingleScoreDouble]
			@MatchID INT = -1 --   -1则选择所有比赛
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP_SINGE_SCORE
	(
		MatchID INT,
		CurMatchSplitID INT,
		MatchTypeID INT,
		TableName NVARCHAR(20),
		EventName NVARCHAR(50),
		PhaseName NVARCHAR(50),
		ServerA INT,
		ServerB INT,
		PlayerA1 NVARCHAR(50),
		PlayerA2 NVARCHAR(50),
		PlayerB1 NVARCHAR(50),
		PlayerB2 NVARCHAR(50),
		MatchScoreA	INT,
		MatchScoreB	INT,
		NOCA NVARCHAR(10),
		NOCB NVARCHAR(10),
		GameA1 INT,
		GameA2 INT,
		GameA3 INT,
		GameA4 INT,
		GameA5 INT,
		GameA6 INT,
		GameA7 INT,
		GameB1 INT,
		GameB2 INT,
		GameB3 INT,
		GameB4 INT,
		GameB5 INT,
		GameB6 INT,
		GameB7 INT,
		PlayerA3 NVARCHAR(50),
		PlayerB3 NVARCHAR(50)
	)
	
	IF @MatchID = -1
	BEGIN
		INSERT INTO #TMP_SINGE_SCORE (MatchID, CurMatchSplitID, MatchTypeID, 
				TableName, EventName, PhaseName, 
				ServerA, ServerB, MatchScoreA, MatchScoreB, NOCA, NOCB, GameA1, GameA2, GameA3
				,GameA4,GameA5,GameA6,GameA7,GameB1,GameB2,GameB3,GameB4,GameB5,GameB6,GameB7)
		(
			SELECT A.F_MatchID, [dbo].[Fun_BD_GetCurrentSetAndGameID]( A.F_MatchID, 1), Y.F_PlayerRegTypeID, 
					Z.F_CourtShortName,  YD.F_EventShortName, XD.F_PhaseShortName,
					B1.F_Service, B2.F_Service, ISNULL(B1.F_Points,0), ISNULL(B2.F_Points,0), '[Image]'+dbo.Fun_BDTT_GetPlayerNOC(B1.F_RegisterID),
					'[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B2.F_RegisterID),
					D11.F_Points,D21.F_Points,D31.F_Points,D41.F_Points,D51.F_Points,D61.F_Points,D71.F_Points,
					D12.F_Points,D22.F_Points,D32.F_Points,D42.F_Points,D52.F_Points,D62.F_Points,D72.F_Points
			FROM TS_Match AS A
			LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
			--Game1
			LEFT JOIN TS_Match_Split_Info AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_Order = 1
			LEFT JOIN TS_Match_Split_Result AS D11 ON D11.F_MatchID = C1.F_MatchID AND D11.F_MatchSplitID = C1.F_MatchSplitID
												AND D11.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D12 ON D12.F_MatchID = C1.F_MatchID AND D12.F_MatchSplitID = C1.F_MatchSplitID
												AND D12.F_CompetitionPosition = 2
			--Game2
			LEFT JOIN TS_Match_Split_Info AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_Order = 2
			LEFT JOIN TS_Match_Split_Result AS D21 ON D21.F_MatchID = C2.F_MatchID AND D21.F_MatchSplitID = C2.F_MatchSplitID
												AND D21.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D22 ON D22.F_MatchID = C2.F_MatchID AND D22.F_MatchSplitID = C2.F_MatchSplitID
												AND D22.F_CompetitionPosition = 2
			--Game3
			LEFT JOIN TS_Match_Split_Info AS C3 ON C3.F_MatchID = A.F_MatchID AND C3.F_Order = 3
			LEFT JOIN TS_Match_Split_Result AS D31 ON D31.F_MatchID = C3.F_MatchID AND D31.F_MatchSplitID = C3.F_MatchSplitID
												AND D31.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D32 ON D32.F_MatchID = C3.F_MatchID AND D32.F_MatchSplitID = C3.F_MatchSplitID
												AND D32.F_CompetitionPosition = 2
			--Game4
			LEFT JOIN TS_Match_Split_Info AS C4 ON C4.F_MatchID = A.F_MatchID AND C4.F_Order = 4
			LEFT JOIN TS_Match_Split_Result AS D41 ON D41.F_MatchID = C4.F_MatchID AND D41.F_MatchSplitID = C4.F_MatchSplitID
												AND D41.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D42 ON D42.F_MatchID = C4.F_MatchID AND D42.F_MatchSplitID = C4.F_MatchSplitID
												AND D42.F_CompetitionPosition = 2	
			--Game5
			LEFT JOIN TS_Match_Split_Info AS C5 ON C5.F_MatchID = A.F_MatchID AND C5.F_Order = 5
			LEFT JOIN TS_Match_Split_Result AS D51 ON D51.F_MatchID = C5.F_MatchID AND D51.F_MatchSplitID = C5.F_MatchSplitID
												AND D51.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D52 ON D52.F_MatchID = C5.F_MatchID AND D52.F_MatchSplitID = C5.F_MatchSplitID
												AND D52.F_CompetitionPosition = 2			
			--Game6
			LEFT JOIN TS_Match_Split_Info AS C6 ON C6.F_MatchID = A.F_MatchID AND C6.F_Order = 6
			LEFT JOIN TS_Match_Split_Result AS D61 ON D61.F_MatchID = C6.F_MatchID AND D61.F_MatchSplitID = C6.F_MatchSplitID
												AND D61.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D62 ON D62.F_MatchID = C6.F_MatchID AND D62.F_MatchSplitID = C6.F_MatchSplitID
												AND D62.F_CompetitionPosition = 2		
			--Game7
			LEFT JOIN TS_Match_Split_Info AS C7 ON C7.F_MatchID = A.F_MatchID AND C7.F_Order = 7
			LEFT JOIN TS_Match_Split_Result AS D71 ON D71.F_MatchID = C7.F_MatchID AND D71.F_MatchSplitID = C7.F_MatchSplitID
												AND D71.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D72 ON D72.F_MatchID = C7.F_MatchID AND D72.F_MatchSplitID = C7.F_MatchSplitID
												AND D72.F_CompetitionPosition = 2
			
			LEFT JOIN TS_Phase AS X ON X.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event AS Y ON Y.F_EventID = X.F_EventID		
			LEFT JOIN TC_Court_Des AS Z ON Z.F_CourtID = A.F_CourtID AND Z.F_LanguageCode = 'ENG'						
			LEFT JOIN TS_Phase_Des AS XD ON XD.F_PhaseID = X.F_PhaseID AND XD.F_LanguageCode = 'ENG'
			LEFT JOIN TS_Event_Des AS YD ON YD.F_EventID = Y.F_EventID AND YD.F_LanguageCode = 'ENG'
			WHERE A.F_MatchStatusID IN (50, 60, 100,120) AND Y.F_PlayerRegTypeID IN (1,2)
		)
	END
	ELSE
	BEGIN

		INSERT INTO #TMP_SINGE_SCORE (MatchID, CurMatchSplitID, MatchTypeID, 
				TableName, EventName, PhaseName, 
				ServerA, ServerB, MatchScoreA, MatchScoreB, NOCA, NOCB, GameA1, GameA2, GameA3
				,GameA4,GameA5,GameA6,GameA7,GameB1,GameB2,GameB3,GameB4,GameB5,GameB6,GameB7)
		(
			SELECT A.F_MatchID, [dbo].[Fun_BD_GetCurrentSetAndGameID]( A.F_MatchID, 1), Y.F_PlayerRegTypeID, 
					Z.F_CourtShortName,  YD.F_EventShortName, XD.F_PhaseShortName,
					B1.F_Service, B2.F_Service, ISNULL(B1.F_Points,0), ISNULL(B2.F_Points,0), '[Image]'+dbo.Fun_BDTT_GetPlayerNOC(B1.F_RegisterID),
					'[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B2.F_RegisterID),
					D11.F_Points,D21.F_Points,D31.F_Points,D41.F_Points,D51.F_Points,D61.F_Points,D71.F_Points,
					D12.F_Points,D22.F_Points,D32.F_Points,D42.F_Points,D52.F_Points,D62.F_Points,D72.F_Points
			FROM TS_Match AS A
			LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
			--Game1
			LEFT JOIN TS_Match_Split_Info AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_Order = 1
			LEFT JOIN TS_Match_Split_Result AS D11 ON D11.F_MatchID = C1.F_MatchID AND D11.F_MatchSplitID = C1.F_MatchSplitID
												AND D11.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D12 ON D12.F_MatchID = C1.F_MatchID AND D12.F_MatchSplitID = C1.F_MatchSplitID
												AND D12.F_CompetitionPosition = 2
			--Game2
			LEFT JOIN TS_Match_Split_Info AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_Order = 2
			LEFT JOIN TS_Match_Split_Result AS D21 ON D21.F_MatchID = C2.F_MatchID AND D21.F_MatchSplitID = C2.F_MatchSplitID
												AND D21.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D22 ON D22.F_MatchID = C2.F_MatchID AND D22.F_MatchSplitID = C2.F_MatchSplitID
												AND D22.F_CompetitionPosition = 2
			--Game3
			LEFT JOIN TS_Match_Split_Info AS C3 ON C3.F_MatchID = A.F_MatchID AND C3.F_Order = 3
			LEFT JOIN TS_Match_Split_Result AS D31 ON D31.F_MatchID = C3.F_MatchID AND D31.F_MatchSplitID = C3.F_MatchSplitID
												AND D31.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D32 ON D32.F_MatchID = C3.F_MatchID AND D32.F_MatchSplitID = C3.F_MatchSplitID
												AND D32.F_CompetitionPosition = 2
			--Game4
			LEFT JOIN TS_Match_Split_Info AS C4 ON C4.F_MatchID = A.F_MatchID AND C4.F_Order = 4
			LEFT JOIN TS_Match_Split_Result AS D41 ON D41.F_MatchID = C4.F_MatchID AND D41.F_MatchSplitID = C4.F_MatchSplitID
												AND D41.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D42 ON D42.F_MatchID = C4.F_MatchID AND D42.F_MatchSplitID = C4.F_MatchSplitID
												AND D42.F_CompetitionPosition = 2	
			--Game5
			LEFT JOIN TS_Match_Split_Info AS C5 ON C5.F_MatchID = A.F_MatchID AND C5.F_Order = 5
			LEFT JOIN TS_Match_Split_Result AS D51 ON D51.F_MatchID = C5.F_MatchID AND D51.F_MatchSplitID = C5.F_MatchSplitID
												AND D51.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D52 ON D52.F_MatchID = C5.F_MatchID AND D52.F_MatchSplitID = C5.F_MatchSplitID
												AND D52.F_CompetitionPosition = 2			
			--Game6
			LEFT JOIN TS_Match_Split_Info AS C6 ON C6.F_MatchID = A.F_MatchID AND C6.F_Order = 6
			LEFT JOIN TS_Match_Split_Result AS D61 ON D61.F_MatchID = C6.F_MatchID AND D61.F_MatchSplitID = C6.F_MatchSplitID
												AND D61.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D62 ON D62.F_MatchID = C6.F_MatchID AND D62.F_MatchSplitID = C6.F_MatchSplitID
												AND D62.F_CompetitionPosition = 2		
			--Game7
			LEFT JOIN TS_Match_Split_Info AS C7 ON C7.F_MatchID = A.F_MatchID AND C7.F_Order = 7
			LEFT JOIN TS_Match_Split_Result AS D71 ON D71.F_MatchID = C7.F_MatchID AND D71.F_MatchSplitID = C7.F_MatchSplitID
												AND D71.F_CompetitionPosition = 1
			LEFT JOIN TS_Match_Split_Result AS D72 ON D72.F_MatchID = C7.F_MatchID AND D72.F_MatchSplitID = C7.F_MatchSplitID
												AND D72.F_CompetitionPosition = 2
			
			LEFT JOIN TS_Phase AS X ON X.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event AS Y ON Y.F_EventID = X.F_EventID		
			LEFT JOIN TC_Court_Des AS Z ON Z.F_CourtID = A.F_CourtID AND Z.F_LanguageCode = 'ENG'						
			LEFT JOIN TS_Phase_Des AS XD ON XD.F_PhaseID = X.F_PhaseID AND XD.F_LanguageCode = 'ENG'
			LEFT JOIN TS_Event_Des AS YD ON YD.F_EventID = Y.F_EventID AND YD.F_LanguageCode = 'ENG'
			WHERE A.F_MatchID = @MatchID AND Y.F_PlayerRegTypeID IN (1,2)
		)
		
	END
	
		
	

	UPDATE #TMP_SINGE_SCORE SET PlayerA3 = C1.F_SBShortName, PlayerB3 = C2.F_SBShortName
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
	WHERE MatchID = A.F_MatchID AND MatchTypeID = 1

	UPDATE #TMP_SINGE_SCORE SET PlayerA1 = D1.F_SBShortName, PlayerA2 = D2.F_SBShortName, PlayerB1 = D3.F_SBShortName,
			PlayerB2 = D4.F_SBShortName
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	
	LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = 'ENG'
	
	LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = 'ENG'
	
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	
	LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
	LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = 'ENG'
	
	LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
	LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = 'ENG'
	WHERE MatchID = A.F_MatchID AND MatchTypeID = 2

	--UPDATE #TMP_SINGE_SCORE SET ServerA = ISNULL(A.F_Service, 0 )
	--FROM TS_Match_Split_Result AS A
	--WHERE A.F_MatchID = MatchID AND A.F_MatchSplitID = CurMatchSplitID AND A.F_CompetitionPosition = 1
	
	--UPDATE #TMP_SINGE_SCORE SET ServerB = ISNULL(A.F_Service, 0 )
	--FROM TS_Match_Split_Result AS A
	--WHERE A.F_MatchID = MatchID AND A.F_MatchSplitID = CurMatchSplitID AND A.F_CompetitionPosition = 2
	
	--UPDATE #TMP_SINGE_SCORE SET PlayerB2 = PlayerB1, PlayerB1 = NULL
	--WHERE (PlayerB1 IS NOT NULL) AND (PlayerB2 IS NULL)

	SELECT * FROM #TMP_SINGE_SCORE
SET NOCOUNT OFF
END


GO


