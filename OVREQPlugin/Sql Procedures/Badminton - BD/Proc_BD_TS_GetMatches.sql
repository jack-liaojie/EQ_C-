IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_TS_GetMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_TS_GetMatches]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_BD_TS_GetMatches]
--描    述: 获取比赛列表
--创 建 人: 王强
--日    期: 2011-06-28



CREATE PROCEDURE [dbo].[Proc_BD_TS_GetMatches]
	--@DayID                    INT,
	--@CourtID                  INT
AS
BEGIN
SET NOCOUNT ON

	
	
	CREATE TABLE #TMP_TABLE
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

			INSERT INTO #TMP_TABLE (
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
		
		SELECT dbo.Fun_Report_BD_GetDateTime(A.F_StartTime,3) AS StartTime,
			G.F_StatusShortName AS [Status],
			E.F_EventShortName AS [Event],
			DS.F_PhaseShortName AS [Phase],
			F.F_MatchShortName AS MatchName,
			dbo.Fun_BDTT_GetPlayerNOCName(H1.F_RegisterID) AS NOCA,
			K1.F_DelegationShortName AS NOCNameA,
			I1.F_SBShortName AS NameA,
			dbo.Fun_BDTT_GetPlayerNOCName(H2.F_RegisterID) AS NOCB,
			K2.F_DelegationShortName AS NOCNameB,
			I2.F_SBShortName AS NameB,
			NULL AS Points,
			A.F_MatchID AS MatchID, 
			C.F_DisciplineDateID AS DateID, 
			A.F_CourtID AS CourtID,
			Z.F_PlayerRegTypeID AS MatchTypeID,
			--A.F_CompetitionRuleID AS MatchRuleID,
			CASE X.F_Type
			WHEN 1 THEN 1
			WHEN 3 THEN 5
			ELSE 1 END AS SetCount,
			CASE X.F_NeedAllSplitsCompleted
			WHEN 1 THEN 1
			ELSE 0 END AS CanBeFullMatch
		FROM TS_Match AS A
		LEFT JOIN TS_Session AS B ON B.F_SessionID = A.F_SessionID
		LEFT JOIN TS_DisciplineDate AS C ON C.F_Date = B.F_SessionDate
		LEFT JOIN TS_Phase AS D ON D.F_PhaseID = A.F_PhaseID
		LEFT JOIN TS_Phase_Des AS DS ON DS.F_PhaseID = D.F_PhaseID AND DS.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS E ON E.F_EventID = D.F_EventID AND E.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event AS Z ON Z.F_EventID = D.F_EventID
		LEFT JOIN TS_Match_Des AS F ON F.F_MatchID = A.F_MatchID AND F.F_LanguageCode = 'ENG'
		LEFT JOIN TC_Status_Des AS G ON G.F_StatusID = A.F_MatchStatusID AND G.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Result AS H1 ON H1.F_MatchID = A.F_MatchID AND H1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS I1 ON I1.F_RegisterID = H1.F_RegisterID AND I1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match_Result AS H2 ON H2.F_MatchID = A.F_MatchID AND H2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Des AS I2 ON I2.F_RegisterID = H2.F_RegisterID AND I2.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register AS J1 ON J1.F_RegisterID = H1.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS K1 ON K1.F_DelegationID = J1.F_DelegationID AND K1.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register AS J2 ON J2.F_RegisterID = H2.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS K2 ON K2.F_DelegationID = J2.F_DelegationID AND K2.F_LanguageCode = 'ENG'
		LEFT JOIN #TMP_TABLE AS X ON X.F_RuleID = A.F_CompetitionRuleID
		WHERE A.F_CourtID IS NOT NULL AND A.F_CompetitionRuleID IS NOT NULL AND A.F_MatchStatusID >= 40
		ORDER BY A.F_StartTime,A.F_RaceNum
	

SET NOCOUNT OFF
END


GO

--exec Proc_BD_TS_GetMatches
