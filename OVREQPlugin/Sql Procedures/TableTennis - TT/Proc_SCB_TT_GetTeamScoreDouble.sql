IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_TT_GetTeamScoreDouble]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_TT_GetTeamScoreDouble]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_TT_GetTeamScoreDouble]
----功		  能：获取TT SCB需要的团体赛比分(双屏)
----作		  者：王强
----日		  期: 2011-05-23

CREATE PROCEDURE [dbo].[Proc_SCB_TT_GetTeamScoreDouble]
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP_SINGE_SCORE
	(
		MatchID INT,
		MatchSplitTypeID INT,
		CurSetSplitID INT,
		CurGameSplitID INT,
		TableName NVARCHAR(20),
		EventName NVARCHAR(50),
		PhaseName NVARCHAR(50),
		CourtName NVARCHAR(50),
		ServerA INT,
		ServerB INT,
		NOCA NVARCHAR(10),
		NOCB NVARCHAR(10),
		PlayerA1 NVARCHAR(50),
		PlayerA2 NVARCHAR(50),
		PlayerB1 NVARCHAR(50),
		PlayerB2 NVARCHAR(50),
		MatchScoreDes NVARCHAR(20),
		CurSetNameDes NVARCHAR(20),
		CurSetScoreDes NVARCHAR(20),
		GameScoreDes1Left NVARCHAR(20),
		GameScoreDes2Left NVARCHAR(20),
		GameScoreDes3Left NVARCHAR(20),
		GameScoreDes4Left NVARCHAR(20),
		GameScoreDes5Left NVARCHAR(20),
		GameScoreDes1Right NVARCHAR(20),
		GameScoreDes2Right NVARCHAR(20),
		GameScoreDes3Right NVARCHAR(20),
		GameScoreDes4Right NVARCHAR(20),
		GameScoreDes5Right NVARCHAR(20),
		GameNoDes1Left NVARCHAR(10),
		GameNoDes2Left NVARCHAR(10),
		GameNoDes3Left NVARCHAR(10),
		GameNoDes4Left NVARCHAR(10),
		GameNoDes5Left NVARCHAR(10),
		GameNoDes1Right NVARCHAR(10),
		GameNoDes2Right NVARCHAR(10),
		GameNoDes3Right NVARCHAR(10),
		GameNoDes4Right NVARCHAR(10),
		GameNoDes5Right NVARCHAR(10),
		CurGameNameDes NVARCHAR(20),
		CurGameScoreA INT,
		CurGameScoreB INT,
		PlayerA NVARCHAR(100),
		PlayerB NVARCHAR(100),
		EventName_All NVARCHAR(200),
		PhaseName_All NVARCHAR(200),
		CourtName_All NVARCHAR(200),
		TeamNameA_ENG NVARCHAR(200),
		TeamNameA_CHN NVARCHAR(200),
		TeamNameB_ENG NVARCHAR(200),
		TeamNameB_CHN NVARCHAR(200),
		F_Order INT
	)
	
	INSERT INTO #TMP_SINGE_SCORE (MatchID, CurSetSplitID, CurGameSplitID, 
				TableName, EventName, PhaseName, CourtName, ServerA, ServerB,  NOCA, NOCB, MatchScoreDes,EventName_All,PhaseName_All,CourtName_All,
				TeamNameA_ENG, TeamNameA_CHN, TeamNameB_ENG, TeamNameB_CHN)
	(
		SELECT A.F_MatchID, [dbo].[Fun_BD_GetCurrentSetAndGameID]( A.F_MatchID, 1), [dbo].[Fun_BD_GetCurrentSetAndGameID]( A.F_MatchID, 2), 
				Z.F_CourtShortName,  YD.F_EventShortName, XD.F_PhaseShortName, Z.F_CourtShortName,
				B1.F_Service, B2.F_Service, '[Image]'+dbo.Fun_BDTT_GetPlayerNOC(B1.F_RegisterID),
				'[Image]' + dbo.Fun_BDTT_GetPlayerNOC(B2.F_RegisterID), CAST( ISNULL(B1.F_Points,0) AS NVARCHAR(4) ) + ' : ' + CAST( ISNULL(B2.F_Points,0) AS NVARCHAR(4)),
				YD.F_EventShortName + '（' + YD2.F_EventShortName + '）', 
				XD.F_PhaseShortName + '（' + XD2.F_PhaseShortName + '）', 
				Z.F_CourtShortName + '（' + Z2.F_CourtShortName + '）',
				DD11.F_DelegationShortName, DD12.F_DelegationShortName, DD21.F_DelegationShortName, DD22.F_DelegationShortName
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register AS TR1 ON TR1.F_RegisterID = B1.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS DD11 ON DD11.F_DelegationID = TR1.F_DelegationID AND DD11.F_LanguageCode = 'ENG'
		LEFT JOIN TC_Delegation_Des AS DD12 ON DD12.F_DelegationID = TR1.F_DelegationID AND DD12.F_LanguageCode = 'CHN'
		
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register AS TR2 ON TR2.F_RegisterID = B2.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS DD21 ON DD21.F_DelegationID = TR2.F_DelegationID AND DD21.F_LanguageCode = 'ENG'
		LEFT JOIN TC_Delegation_Des AS DD22 ON DD22.F_DelegationID = TR2.F_DelegationID AND DD22.F_LanguageCode = 'CHN'
		
		LEFT JOIN TS_Phase AS X ON X.F_PhaseID = A.F_PhaseID
		LEFT JOIN TS_Event AS Y ON Y.F_EventID = X.F_EventID		
		LEFT JOIN TC_Court_Des AS Z ON Z.F_CourtID = A.F_CourtID AND Z.F_LanguageCode = 'ENG'	
		LEFT JOIN TC_Court_Des AS Z2 ON Z2.F_CourtID = A.F_CourtID AND Z2.F_LanguageCode = 'CHN'					
		LEFT JOIN TS_Phase_Des AS XD ON XD.F_PhaseID = X.F_PhaseID AND XD.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Phase_Des AS XD2 ON XD2.F_PhaseID = X.F_PhaseID AND XD2.F_LanguageCode = 'CHN'
		LEFT JOIN TS_Event_Des AS YD ON YD.F_EventID = Y.F_EventID AND YD.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS YD2 ON YD2.F_EventID = Y.F_EventID AND YD2.F_LanguageCode = 'CHN'
		WHERE A.F_MatchStatusID IN (50, 60, 100,120) AND Y.F_PlayerRegTypeID = 3
	)
	
	UPDATE #TMP_SINGE_SCORE SET MatchSplitTypeID = F_MatchSplitType
	FROM TS_Match_Split_Info
	WHERE F_MatchID = MatchID AND F_MatchSplitID = CurSetSplitID
	
	UPDATE #TMP_SINGE_SCORE SET F_Order = A.F_Order
	FROM TS_Match_Split_Info AS A WHERE F_MatchID = MatchID AND F_MatchSplitID = CurGameSplitID
	--DECLARE @CurGameSplitID INT
	
	--SELECT @CurGameSplitID = CurGameSplitID FROM #TMP_SINGE_SCORE
	
	UPDATE 	#TMP_SINGE_SCORE SET CurSetNameDes = 'Match ' + CAST(A.F_Order AS NVARCHAR(4) ),
			GameNoDes1Left = CASE WHEN C11.F_Points > C12.F_Points THEN '(' + CAST(B1.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes2Left = CASE WHEN C21.F_Points > C22.F_Points THEN '(' + CAST(B2.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes3Left = CASE WHEN C31.F_Points > C32.F_Points THEN '(' + CAST(B3.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes4Left = CASE WHEN C41.F_Points > C42.F_Points THEN '(' + CAST(B4.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes5Left = CASE WHEN C51.F_Points > C52.F_Points THEN '(' + CAST(B5.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes1Right = CASE WHEN C11.F_Points < C12.F_Points THEN '(' + CAST(B1.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes2Right = CASE WHEN C21.F_Points < C22.F_Points THEN '(' + CAST(B2.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes3Right = CASE WHEN C31.F_Points < C32.F_Points THEN '(' + CAST(B3.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes4Right = CASE WHEN C41.F_Points < C42.F_Points THEN '(' + CAST(B4.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameNoDes5Right = CASE WHEN C51.F_Points < C52.F_Points THEN '(' + CAST(B5.F_Order AS NVARCHAR(4)) + ')' ELSE NULL END,
			GameScoreDes1Left = CASE WHEN C11.F_Points > C12.F_Points THEN CAST( C11.F_Points AS NVARCHAR(10)) + ':' + CAST( C12.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes2Left = CASE WHEN C21.F_Points > C22.F_Points THEN CAST( C21.F_Points AS NVARCHAR(10)) + ':' + CAST( C22.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes3Left = CASE WHEN C31.F_Points > C32.F_Points THEN CAST( C31.F_Points AS NVARCHAR(10)) + ':' + CAST( C32.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes4Left = CASE WHEN C41.F_Points > C42.F_Points THEN CAST( C41.F_Points AS NVARCHAR(10)) + ':' + CAST( C42.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes5Left = CASE WHEN C51.F_Points > C52.F_Points THEN CAST( C51.F_Points AS NVARCHAR(10)) + ':' + CAST( C52.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes1Right = CASE WHEN C11.F_Points < C12.F_Points THEN CAST( C11.F_Points AS NVARCHAR(10)) + ':' + CAST( C12.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes2Right = CASE WHEN C21.F_Points < C22.F_Points THEN CAST( C21.F_Points AS NVARCHAR(10)) + ':' + CAST( C22.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes3Right = CASE WHEN C31.F_Points < C32.F_Points THEN CAST( C31.F_Points AS NVARCHAR(10)) + ':' + CAST( C32.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes4Right = CASE WHEN C41.F_Points < C42.F_Points THEN CAST( C41.F_Points AS NVARCHAR(10)) + ':' + CAST( C42.F_Points AS NVARCHAR(10)) ELSE NULL END,
			GameScoreDes5Right = CASE WHEN C51.F_Points < C52.F_Points THEN CAST( C51.F_Points AS NVARCHAR(10)) + ':' + CAST( C52.F_Points AS NVARCHAR(10)) ELSE NULL END,
			CurSetScoreDes = CAST(X1.F_Points AS NVARCHAR(10)) + ' : ' + CAST(X2.F_Points AS NVARCHAR(10))
	FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS X1 ON X1.F_MatchID = A.F_MatchID AND X1.F_MatchSplitID = A.F_MatchSplitID AND X1.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS X2 ON X2.F_MatchID = A.F_MatchID AND X2.F_MatchSplitID = A.F_MatchSplitID AND X2.F_CompetitionPosition = 2
	--Game1
	LEFT JOIN TS_Match_Split_Info AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_FatherMatchSplitID = A.F_MatchSplitID AND B1.F_Order = 1
	LEFT JOIN TS_Match_Split_Result AS C11 ON C11.F_MatchID = B1.F_MatchID AND C11.F_MatchSplitID = B1.F_MatchSplitID 
				AND C11.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS C12 ON C12.F_MatchID = B1.F_MatchID AND C12.F_MatchSplitID = B1.F_MatchSplitID 
				AND C12.F_CompetitionPosition = 2
	--Game2
	LEFT JOIN TS_Match_Split_Info AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_FatherMatchSplitID = A.F_MatchSplitID AND B2.F_Order = 2
	LEFT JOIN TS_Match_Split_Result AS C21 ON C21.F_MatchID = B2.F_MatchID AND C21.F_MatchSplitID = B2.F_MatchSplitID 
				AND C21.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS C22 ON C22.F_MatchID = B2.F_MatchID AND C22.F_MatchSplitID = B2.F_MatchSplitID 
				AND C22.F_CompetitionPosition = 2
	--Game3
	LEFT JOIN TS_Match_Split_Info AS B3 ON B3.F_MatchID = A.F_MatchID AND B3.F_FatherMatchSplitID = A.F_MatchSplitID AND B3.F_Order = 3
	LEFT JOIN TS_Match_Split_Result AS C31 ON C31.F_MatchID = B3.F_MatchID AND C31.F_MatchSplitID = B3.F_MatchSplitID 
				AND C31.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS C32 ON C32.F_MatchID = B3.F_MatchID AND C32.F_MatchSplitID = B3.F_MatchSplitID 
				AND C32.F_CompetitionPosition = 2
	--Game4
	LEFT JOIN TS_Match_Split_Info AS B4 ON B4.F_MatchID = A.F_MatchID AND B4.F_FatherMatchSplitID = A.F_MatchSplitID AND B4.F_Order = 4
	LEFT JOIN TS_Match_Split_Result AS C41 ON C41.F_MatchID = B4.F_MatchID AND C41.F_MatchSplitID = B4.F_MatchSplitID 
				AND C41.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS C42 ON C42.F_MatchID = B4.F_MatchID AND C42.F_MatchSplitID = B4.F_MatchSplitID 
				AND C42.F_CompetitionPosition = 2
	--Game5
	LEFT JOIN TS_Match_Split_Info AS B5 ON B5.F_MatchID = A.F_MatchID AND B5.F_FatherMatchSplitID = A.F_MatchSplitID AND B5.F_Order = 5
	LEFT JOIN TS_Match_Split_Result AS C51 ON C51.F_MatchID = B5.F_MatchID AND C51.F_MatchSplitID = B5.F_MatchSplitID 
				AND C51.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS C52 ON C52.F_MatchID = B5.F_MatchID AND C52.F_MatchSplitID = B5.F_MatchSplitID 
				AND C52.F_CompetitionPosition = 2												
	WHERE A.F_MatchID = MatchID AND A.F_MatchSplitID = CurSetSplitID
	
	UPDATE #TMP_SINGE_SCORE SET CurGameNameDes = 'Game ' + CAST(A.F_Order AS NVARCHAR(10)), CurGameScoreA = B1.F_Points, CurGameScoreB = B2.F_Points
	FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
	WHERE A.F_MatchID = MatchID AND A.F_MatchSplitID = CurGameSplitID

	UPDATE #TMP_SINGE_SCORE SET PlayerA = C1.F_SBShortName, PlayerB = C2.F_SBShortName
	FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
	WHERE MatchID = A.F_MatchID AND A.F_MatchSplitID = CurSetSplitID AND MatchSplitTypeID IN (1,2)

	UPDATE #TMP_SINGE_SCORE SET PlayerA1 = D1.F_SBShortName, PlayerA2 = D2.F_SBShortName, PlayerB1 = D3.F_SBShortName,
			PlayerB2 = D4.F_SBShortName
	FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
	
	LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = 'ENG'
	
	LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = 'ENG'
	
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND  B2.F_CompetitionPosition = 2
	
	LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
	LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = 'ENG'
	
	LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
	LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = 'ENG'
	WHERE MatchID = A.F_MatchID AND A.F_MatchSplitID = CurSetSplitID AND MatchSplitTypeID IN (3,4,5)

	UPDATE #TMP_SINGE_SCORE SET ServerA = ISNULL(A.F_Service, 0 )
	FROM TS_Match_Split_Result AS A
	WHERE A.F_MatchID = MatchID AND A.F_MatchSplitID = CurGameSplitID AND A.F_CompetitionPosition = 1
	
	UPDATE #TMP_SINGE_SCORE SET ServerB = ISNULL(A.F_Service, 0 )
	FROM TS_Match_Split_Result AS A
	WHERE A.F_MatchID = MatchID AND A.F_MatchSplitID = CurGameSplitID AND A.F_CompetitionPosition = 2
	
	UPDATE #TMP_SINGE_SCORE SET GameScoreDes1Left = '', GameScoreDes1Right = '',
								GameNoDes1Left = '', GameNoDes1Right = ''
	WHERE F_Order = 1
	
	UPDATE #TMP_SINGE_SCORE SET GameScoreDes2Left = '', GameScoreDes2Right = '',
								GameNoDes2Left = '', GameNoDes2Right = ''
	WHERE F_Order = 2
	
	UPDATE #TMP_SINGE_SCORE SET GameScoreDes3Left = '', GameScoreDes3Right = '',
								GameNoDes3Left = '', GameNoDes3Right = ''
	WHERE F_Order = 3
	
	UPDATE #TMP_SINGE_SCORE SET GameScoreDes4Left = '', GameScoreDes4Right = '',
								GameNoDes4Left = '', GameNoDes4Right = ''
	WHERE F_Order = 4
	
	UPDATE #TMP_SINGE_SCORE SET GameScoreDes5Left = '', GameScoreDes5Right = '',
								GameNoDes5Left = '', GameNoDes5Right = ''
	WHERE F_Order = 5
	
	SELECT * FROM #TMP_SINGE_SCORE
SET NOCOUNT OFF
END


GO


