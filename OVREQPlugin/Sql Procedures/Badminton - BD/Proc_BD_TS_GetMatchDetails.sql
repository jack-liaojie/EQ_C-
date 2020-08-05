IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_TS_GetMatchDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_TS_GetMatchDetails]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_BD_TS_GetMatchDetails]
--描    述: 获取比赛信息
--创 建 人: 王强
--日    期: 2011-6-28
--修改记录：
/*			
			日期					修改人		修改内容
			
*/



CREATE PROCEDURE [dbo].[Proc_BD_TS_GetMatchDetails]
AS
BEGIN
SET NOCOUNT ON
		
		DECLARE @Lang NVARCHAR(10) = 'ENG'
		CREATE TABLE #RULE_TABLE
		(
			F_RuleID INT,
			F_Type NVARCHAR(10),
			F_TeamSubMatchTypes NVARCHAR(20),
			F_SplitsCount INT,
			F_GamesCount INT,
			F_GamePoint INT,
			F_AdvantageDiffer INT,
			F_MaxGameScore INT,
			F_ScoredOwnServe INT,
			F_NeedAllSplitsCompleted INT,
			F_NeedAllGamesCompleted INT
		)
	
	DECLARE tmp_cursor CURSOR FOR SELECT F_CompetitionRuleID FROM TD_CompetitionRule
	DECLARE @MatchRuleID INT
	DECLARE @RuleXml NVARCHAR(max)
	OPEN tmp_cursor
	FETCH NEXT FROM tmp_cursor INTO @MatchRuleID
	WHILE @@FETCH_STATUS=0
		BEGIN
			SELECT @RuleXml = CONVERT(NVARCHAR(max), F_CompetitionRuleInfo) FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @MatchRuleID
			
			DECLARE @iDoc AS INT
			EXEC sp_xml_preparedocument @iDoc OUTPUT, @RuleXml

			INSERT INTO #RULE_TABLE (
					F_RuleID,
					F_Type, 
					F_TeamSubMatchTypes,
					F_SplitsCount,
					F_GamesCount,
					F_GamePoint,
					F_AdvantageDiffer,  
					F_MaxGameScore,
					F_ScoredOwnServe,
					F_NeedAllSplitsCompleted,
					F_NeedAllGamesCompleted
				)
				SELECT @MatchRuleID,*
				FROM OPENXML (@iDoc, '/Rule',1)
				WITH 
				(
					F_Type INT, --这里和TT有所不同
					F_TeamSubMatchTypes INT,
					F_SplitsCount INT,
					F_GamesCount NVARCHAR(20),
					F_GamePoint INT,
					F_AdvantageDiffer INT,  
					F_MaxGameScore NVARCHAR(10),
					F_ScoredOwnServe INT, 
					F_NeedAllSplitsCompleted INT, 
					F_NeedAllGamesCompleted INT
				)
				EXEC sp_xml_removedocument @iDoc
			
			
			
			FETCH NEXT FROM tmp_cursor INTO @MatchRuleID
		END
		
		CLOSE tmp_cursor
		DEALLOCATE tmp_cursor

	CREATE TABLE #TMP_TABLE
	(
		F_MatchID INT,
		F_SubMatchNo INT,
		F_SubMatchType INT,
		F_AthleteA1 NVARCHAR(200),
		F_AthleteA2 NVARCHAR(200),
		F_AthleteB1 NVARCHAR(200),
		F_AthleteB2 NVARCHAR(200),
		F_NOCA1 NVARCHAR(10),
		F_NOCA2 NVARCHAR(10),
		F_NOCB1 NVARCHAR(10),
		F_NOCB2 NVARCHAR(10),
		F_RuleID INT,
		GameCount INT,
		CanBeFullGame INT,
		GamePointsWin1 INT,
		GamePointsWin2 INT,
		GamePointsWin3 INT,
		GamePointsWin4 INT,
		GamePointsWin5 INT,
		GamePointsWin6 INT,
		GamePointsWin7 INT,
		GamePointsMax1 INT,
		GamePointsMax2 INT,
		GamePointsMax3 INT,
		GamePointsMax4 INT,
		GamePointsMax5 INT,
		GamePointsMax6 INT,
		GamePointsMax7 INT,
	)

	INSERT INTO #TMP_TABLE (
		F_MatchID,
		F_SubMatchNo,
		F_SubMatchType ,
		F_AthleteA1,
		F_AthleteA2,
		F_AthleteB1,
		F_AthleteB2,
		F_NOCA1,
		F_NOCA2,
		F_NOCB1,
		F_NOCB2,
		F_RuleID
		)
	SELECT A.F_MatchID, 0, 0, ISNULL(C1.F_SBShortName,''), NULL,  
		   ISNULL(C2.F_SBShortName,''), NULL, 
		   dbo.Fun_BDTT_GetPlayerNOCName(B1.F_RegisterID), NULL,
		   dbo.Fun_BDTT_GetPlayerNOCName(B2.F_RegisterID), NULL, A.F_CompetitionRuleID
	FROM TS_Match AS A 
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = @Lang
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = @Lang
	LEFT JOIN TS_Phase AS D ON D.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS E ON E.F_EventID = D.F_EventID
	WHERE E.F_PlayerRegTypeID = 1 AND A.F_CourtID IS NOT NULL AND A.F_CompetitionRuleID IS NOT NULL
				AND A.F_MatchStatusID >= 40
	
	INSERT INTO #TMP_TABLE
	(
				F_MatchID,
		F_SubMatchNo,
		F_SubMatchType ,
		F_AthleteA1,
		F_AthleteA2,
		F_AthleteB1,
		F_AthleteB2,
		F_NOCA1,
		F_NOCA2,
		F_NOCB1,
		F_NOCB2,
		F_RuleID
	)
	SELECT A.F_MatchID,0 AS Match_No, 0 AS MatchType, D1.F_SBShortName,D2.F_SBShortName,
		   D3.F_SBShortName, D4.F_SBShortName, 
		   dbo.Fun_BDTT_GetPlayerNOCName(D1.F_RegisterID),
		   dbo.Fun_BDTT_GetPlayerNOCName(D2.F_RegisterID),
		   dbo.Fun_BDTT_GetPlayerNOCName(D3.F_RegisterID),
		   dbo.Fun_BDTT_GetPlayerNOCName(D4.F_RegisterID),
		   A.F_CompetitionRuleID
	FROM TS_Match AS A 
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1

	LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = @Lang
	LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = @Lang
	
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	
	LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
	LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = @Lang
	LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
	LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = @Lang
	LEFT JOIN TS_Phase AS E ON E.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS F ON F.F_EventID = E.F_EventID
	WHERE F.F_PlayerRegTypeID = 2 AND A.F_CourtID IS NOT NULL AND A.F_CompetitionRuleID IS NOT NULL
			AND A.F_MatchStatusID >= 40
	
		
	INSERT INTO #TMP_TABLE
	(
				F_MatchID,
		F_SubMatchNo,
		F_SubMatchType ,
		F_AthleteA1,
		F_AthleteA2,
		F_AthleteB1,
		F_AthleteB2,
		F_NOCA1,
		F_NOCA2,
		F_NOCB1,
		F_NOCB2,
		F_RuleID
	)
	SELECT A.F_MatchID,A.F_Order, A.F_MatchSplitType, C1.F_SBShortName, NULL, C2.F_SBShortName, NULL,
			dbo.Fun_BDTT_GetPlayerNOCName(C1.F_RegisterID), NULL,dbo.Fun_BDTT_GetPlayerNOCName(C2.F_RegisterID),NULL,
			TM.F_CompetitionRuleID
	FROM TS_Match_Split_Info AS A 
	LEFT JOIN TS_Match AS TM ON TM.F_MatchID = A.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = @Lang
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = @Lang
	LEFT JOIN TS_Match AS Z ON Z.F_MatchID = A.F_MatchID
	LEFT JOIN TS_Phase AS D ON D.F_PhaseID = Z.F_PhaseID
	LEFT JOIN TS_Event AS E ON E.F_EventID = D.F_EventID
	LEFT JOIN TS_Match AS P ON P.F_MatchID = A.F_MatchID
	WHERE E.F_PlayerRegTypeID = 3 AND A.F_FatherMatchSplitID = 0 AND F_MatchSplitType IN (1,2) AND Z.F_CourtID IS NOT NULL
			 AND P.F_CompetitionRuleID IS NOT NULL AND TM.F_MatchStatusID >= 40
	
	INSERT INTO #TMP_TABLE
	(
				F_MatchID,
		F_SubMatchNo,
		F_SubMatchType ,
		F_AthleteA1,
		F_AthleteA2,
		F_AthleteB1,
		F_AthleteB2,
		F_NOCA1,
		F_NOCA2,
		F_NOCB1,
		F_NOCB2,
		F_RuleID
	)
	SELECT A.F_MatchID,A.F_Order, A.F_MatchSplitType, D1.F_SBShortName, D2.F_SBShortName,  
	   D3.F_SBShortName, D4.F_SBShortName,
	   dbo.Fun_BDTT_GetPlayerNOCName(D1.F_RegisterID),
	   dbo.Fun_BDTT_GetPlayerNOCName(D2.F_RegisterID),
	   dbo.Fun_BDTT_GetPlayerNOCName(D3.F_RegisterID),
	   dbo.Fun_BDTT_GetPlayerNOCName(D4.F_RegisterID),
	   TM.F_CompetitionRuleID
	FROM TS_Match_Split_Info AS A 
	LEFT JOIN TS_Match AS TM ON TM.F_MatchID = A.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
				AND B1.F_CompetitionPosition = 1

	LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = @Lang
	LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = @Lang
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
				AND B2.F_CompetitionPosition = 2
	LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
	LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = @Lang
	LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
	LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = @Lang
	LEFT JOIN TS_Match AS Z ON Z.F_MatchID = A.F_MatchID
	LEFT JOIN TS_Phase AS E ON E.F_PhaseID = Z.F_PhaseID
	LEFT JOIN TS_Event AS F ON F.F_EventID = E.F_EventID
	LEFT JOIN TS_Match AS P ON P.F_MatchID = A.F_MatchID
	WHERE F.F_PlayerRegTypeID = 3 AND A.F_FatherMatchSplitID = 0 AND F_MatchSplitType IN (3,4,5)
			AND Z.F_CourtID IS NOT NULL AND P.F_CompetitionRuleID IS NOT NULL AND TM.F_MatchStatusID >= 40
			--	F_RuleID INT,
			--F_Type NVARCHAR(10),
			--F_TeamSubMatchTypes NVARCHAR(20),
			--F_SplitsCount INT,
			--F_GamesCount INT,
			--F_GamePoint INT,
			--F_AdvantageDiffer INT,
			--F_MaxGameScore INT,
			--F_ScoredOwnServe INT,
			--F_NeedAllSplitsCompleted INT,
			--F_NeedAllGamesCompleted INT
	UPDATE #TMP_TABLE SET
		GameCount = B.F_GamesCount,
		CanBeFullGame = CASE B.F_NeedAllGamesCompleted WHEN 1 THEN 1 ELSE 0 END,
		GamePointsWin1 = B.F_GamePoint,
		GamePointsWin2 = B.F_GamePoint,
		GamePointsWin3 = B.F_GamePoint,
		GamePointsWin4 = B.F_GamePoint,
		GamePointsWin5 = B.F_GamePoint,
		GamePointsWin6 = B.F_GamePoint,
		GamePointsWin7 = B.F_GamePoint,
		GamePointsMax1 = F_MaxGameScore,
		GamePointsMax2 = F_MaxGameScore,
		GamePointsMax3 = F_MaxGameScore,
		GamePointsMax4 = F_MaxGameScore,
		GamePointsMax5 = F_MaxGameScore,
		GamePointsMax6 = F_MaxGameScore,
		GamePointsMax7 = F_MaxGameScore
		--CanBeFullGame INT,
		--GamePointsWin1 INT,
		--GamePointsWin2 INT,
		--GamePointsWin3 INT,
		--GamePointsWin4 INT,
		--GamePointsWin5 INT,
		--GamePointsWin6 INT,
		--GamePointsWin7 INT,
		--GamePointsMax1 INT,
		--GamePointsMax2 INT,
		--GamePointsMax3 INT,
		--GamePointsMax4 INT,
		--GamePointsMax5 INT,
		--GamePointsMax6 INT,
		--GamePointsMax7 INT,
	FROM #TMP_TABLE AS A
	LEFT JOIN #RULE_TABLE AS B ON B.F_RuleID = A.F_RuleID
	WHERE A.F_MatchID = F_MatchID
	
	
	SELECT F_MatchID AS MatchID, F_SubMatchNo AS SetNum, F_SubMatchType AS SetTypeID,
			GameCount, CanBeFullGame,GamePointsWin1,GamePointsWin2,GamePointsWin3,GamePointsWin4,GamePointsWin5,GamePointsWin6,GamePointsWin7,
			GamePointsMax1,GamePointsMax2,GamePointsMax3,GamePointsMax4,GamePointsMax5,GamePointsMax6,GamePointsMax7,
			F_NOCA1 AS NOCA, F_AthleteA1 AS NameA1, F_AthleteA2 AS NameA2, F_NOCB1 AS NOCB,
			F_AthleteB1 AS NameB1, F_AthleteB2 AS NameB2
	FROM #TMP_TABLE ORDER BY F_MatchID, F_SubMatchNo

SET NOCOUNT OFF
END

