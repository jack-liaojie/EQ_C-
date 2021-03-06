IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetTeamAllRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetTeamAllRank]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_BD_GetTeamAllRank]
----功		  能：获取团体赛全排名需要的数据
----作		  者：王强
----日		  期: 2012-05-30


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetTeamAllRank] 
                   (	
					@EventID INT,
					@LanguageCode NVARCHAR(10),
					@ScheduleOnly INT
                   )	
AS
BEGIN
SET NOCOUNT ON

		CREATE TABLE #TMP_TABLE1
		(
			MatchID1 INT,
			MatchID2 INT,
			MatchID3 INT,
			MatchID4 INT,
			MatchStatusID1 INT,
			MatchStatusID2 INT,
			MatchStatusID3 INT,
			MatchStatusID4 INT,
			Order1 INT,
			Order2 INT,
			Order3 INT,
			Order4 INT,
			PosDes1 NVARCHAR(10),
			PosDes2 NVARCHAR(10),
			PosDes3 NVARCHAR(10),
			PosDes4 NVARCHAR(10),
			MatchCode1 NVARCHAR(10),
			MatchCode2 NVARCHAR(10),
			MatchCode3 NVARCHAR(10),
			MatchCode4 NVARCHAR(10),
			TeamName1A NVARCHAR(30),
			TeamName2A NVARCHAR(30),
			TeamName3A NVARCHAR(30),
			TeamName4A NVARCHAR(30),
			TeamName1B NVARCHAR(30),
			TeamName2B NVARCHAR(30),
			TeamName3B NVARCHAR(30),
			TeamName4B NVARCHAR(30),
			TeamNameWin1A NVARCHAR(30),
			TeamNameWin2A NVARCHAR(30),
			TeamNameWin3A NVARCHAR(30),
			TeamNameWin4A NVARCHAR(30),
			TeamNameWin1B NVARCHAR(30),
			TeamNameWin2B NVARCHAR(30),
			TeamNameWin3B NVARCHAR(30),
			TeamNameWin4B NVARCHAR(30),
			ScoreDes1 NVARCHAR(20),
			ScoreDes2 NVARCHAR(20),
			ScoreDes3 NVARCHAR(20),
			ScoreDes4 NVARCHAR(20),
			HomeWin1 INT,
			HomeWin2 INT,
			HomeWin3 INT,
			HomeWin4 INT,
			RankDes1 NVARCHAR(10),
			RankDes2 NVARCHAR(10),
			RankDes3 NVARCHAR(10),
			RankDes4 NVARCHAR(10),
			PhaseName NVARCHAR(20)
		)

		INSERT INTO #TMP_TABLE1
        ( 
			MatchID1,
			MatchID2,
			MatchID3,
			MatchID4,
			MatchStatusID1,
			MatchStatusID2,
			MatchStatusID3,
			MatchStatusID4,
          Order1,
          Order2,
          Order3,
          Order4,
          PosDes1,
          PosDes2,
          PosDes3,
          PosDes4,
		  MatchCode1 ,
          MatchCode2 ,
          MatchCode3 ,
          MatchCode4 ,
          TeamName1A ,
          TeamName2A ,
          TeamName3A ,
          TeamName4A ,
          TeamName1B ,
          TeamName2B ,
          TeamName3B ,
          TeamName4B ,
          ScoreDes1 ,
          ScoreDes2 ,
          ScoreDes3 ,
          ScoreDes4,
          HomeWin1,
          HomeWin2,
          HomeWin3,
          HomeWin4,
			RankDes1,
			RankDes2,
			RankDes3,
			RankDes4,
          PhaseName
        )
		(
			SELECT
			B1.F_MatchID, 
			B2.F_MatchID, 
			B3.F_MatchID, 
			B4.F_MatchID, 
			B1.F_MatchStatusID,
			B2.F_MatchStatusID,
			B3.F_MatchStatusID,
			B4.F_MatchStatusID,
			B1.F_Order,
			B2.F_Order,
			B3.F_Order,
			B4.F_Order,
			D1.F_PhaseCode + CAST( C11.F_SourcePhaseRank AS NVARCHAR(10) ),
			D2.F_PhaseCode + CAST( C12.F_SourcePhaseRank AS NVARCHAR(10) ),
			D3.F_PhaseCode + CAST( C21.F_SourcePhaseRank AS NVARCHAR(10) ),
			D4.F_PhaseCode + CAST( C22.F_SourcePhaseRank AS NVARCHAR(10) ),
			TE.F_EventComment + B1.F_RaceNum,
			TE.F_EventComment + B2.F_RaceNum,
			TE.F_EventComment + B3.F_RaceNum,
			TE.F_EventComment + B4.F_RaceNum,
			dbo.Fun_BDTT_GetRegisterName(C11.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C21.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C31.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C41.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C12.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C22.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C32.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_GetRegisterName(C42.F_RegisterID, 22, @LanguageCode, 0 ),
			dbo.Fun_BDTT_New_GetMatchResultDes(B1.F_MatchID, 1, 0, @ScheduleOnly),
			dbo.Fun_BDTT_New_GetMatchResultDes(B2.F_MatchID, 1, 0, @ScheduleOnly),
			dbo.Fun_BDTT_New_GetMatchResultDes(B3.F_MatchID, 1, 0, @ScheduleOnly),
			dbo.Fun_BDTT_New_GetMatchResultDes(B4.F_MatchID, 1, 0, @ScheduleOnly),
			--dbo.Fun_Report_BD_GetMatchResultDes(B4.F_MatchID, 4, 1),
			CASE WHEN C11.F_Rank = 1 THEN 1 WHEN C11.F_Rank IS NULL THEN NULL ELSE 0 END,
			CASE WHEN C21.F_Rank = 1 THEN 1 WHEN C21.F_Rank IS NULL THEN NULL ELSE 0 END,
			CASE WHEN C31.F_Rank = 1 THEN 1 WHEN C31.F_Rank IS NULL THEN NULL ELSE 0 END,
			CASE WHEN C41.F_Rank = 1 THEN 1 WHEN C41.F_Rank IS NULL THEN NULL ELSE 0 END,
			'第' + CAST(E1.F_EventRank AS NVARCHAR(10)) + '名',
			'第' + CAST(E2.F_EventRank AS NVARCHAR(10)) + '名',
			'第' + CAST(E3.F_EventRank AS NVARCHAR(10)) + '名',
			'第' + CAST(E4.F_EventRank AS NVARCHAR(10)) + '名',
			F.F_PhaseShortName
			FROM TS_Phase AS A
			LEFT JOIN TS_Event_Des AS TE ON TE.F_EventID = A.F_EventID AND TE.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Match AS B1 ON B1.F_PhaseID = A.F_PhaseID AND B1.F_Order = 1
			LEFT JOIN TS_Match AS B2 ON B2.F_PhaseID = A.F_PhaseID AND B2.F_Order = 2
			LEFT JOIN TS_Match AS B3 ON B3.F_PhaseID = A.F_PhaseID AND B3.F_Order = 3
			LEFT JOIN TS_Match AS B4 ON B4.F_PhaseID = A.F_PhaseID AND B4.F_Order = 4
			LEFT JOIN TS_Match_Result AS C11 ON C11.F_MatchID = B1.F_MatchID AND C11.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS C12 ON C12.F_MatchID = B1.F_MatchID AND C12.F_CompetitionPositionDes1 = 2
			LEFT JOIN TS_Match_Result AS C21 ON C21.F_MatchID = B2.F_MatchID AND C21.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS C22 ON C22.F_MatchID = B2.F_MatchID AND C22.F_CompetitionPositionDes1 = 2
			LEFT JOIN TS_Match_Result AS C31 ON C31.F_MatchID = B3.F_MatchID AND C31.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS C32 ON C32.F_MatchID = B3.F_MatchID AND C32.F_CompetitionPositionDes1 = 2
			LEFT JOIN TS_Match_Result AS C41 ON C41.F_MatchID = B4.F_MatchID AND C41.F_CompetitionPositionDes1 = 1
			LEFT JOIN TS_Match_Result AS C42 ON C42.F_MatchID = B4.F_MatchID AND C42.F_CompetitionPositionDes1 = 2
			LEFT JOIN TS_Phase AS D1 ON D1.F_PhaseID = C11.F_SourcePhaseID
			LEFT JOIN TS_Phase AS D2 ON D2.F_PhaseID = C12.F_SourcePhaseID
			LEFT JOIN TS_Phase AS D3 ON D3.F_PhaseID = C21.F_SourcePhaseID
			LEFT JOIN TS_Phase AS D4 ON D4.F_PhaseID = C22.F_SourcePhaseID
			LEFT JOIN TS_Event_Result AS E1 ON E1.F_SourceMatchID = B4.F_MatchID AND E1.F_SourceMatchRank = 1 AND E1.F_EventID = A.F_EventID
			LEFT JOIN TS_Event_Result AS E2 ON E2.F_SourceMatchID = B4.F_MatchID AND E2.F_SourceMatchRank = 2 AND E2.F_EventID = A.F_EventID
			LEFT JOIN TS_Event_Result AS E3 ON E3.F_SourceMatchID = B3.F_MatchID AND E3.F_SourceMatchRank = 1 AND E3.F_EventID = A.F_EventID
			LEFT JOIN TS_Event_Result AS E4 ON E4.F_SourceMatchID = B3.F_MatchID AND E4.F_SourceMatchRank = 2 AND E4.F_EventID = A.F_EventID
			LEFT JOIN TS_Phase_Des AS F ON F.F_PhaseID = A.F_PhaseID AND F.F_LanguageCode = @LanguageCode
			WHERE A.F_PhaseID IN
			(
				SELECT X.F_PhaseID FROM TS_Phase_Des AS X
				INNER JOIN TS_Phase AS Y ON Y.F_PhaseID = X.F_PhaseID AND Y.F_EventID = @EventID
				WHERE X.F_PhaseComment IN ('1','2','3','4')
			)
			
		) ORDER BY A.F_Order
		
		UPDATE #TMP_TABLE1 SET TeamNameWin1A = TeamName1A, TeamNameWin1B = TeamName1B WHERE HomeWin1 = 1
		UPDATE #TMP_TABLE1 SET TeamNameWin2A = TeamName2A, TeamNameWin2B = TeamName2B WHERE HomeWin2 = 1
		UPDATE #TMP_TABLE1 SET TeamNameWin3A = TeamName3A, TeamNameWin3B = TeamName3B WHERE HomeWin3 = 1
		UPDATE #TMP_TABLE1 SET TeamNameWin4A = TeamName4A, TeamNameWin4B = TeamName4B WHERE HomeWin4 = 1
		UPDATE #TMP_TABLE1 SET TeamNameWin1A = TeamName1B, TeamNameWin1B = TeamName1A WHERE HomeWin1 = 0
		UPDATE #TMP_TABLE1 SET TeamNameWin2A = TeamName2B, TeamNameWin2B = TeamName2A WHERE HomeWin2 = 0
		UPDATE #TMP_TABLE1 SET TeamNameWin3A = TeamName3B, TeamNameWin3B = TeamName3A WHERE HomeWin3 = 0
		UPDATE #TMP_TABLE1 SET TeamNameWin4A = TeamName4B, TeamNameWin4B = TeamName4A WHERE HomeWin4 = 0
		
		UPDATE #TMP_TABLE1 SET TeamNameWin1A = dbo.[Fun_Report_BD_GetMatchDateTimeDes](MatchID1), 
							   ScoreDes1 = [dbo].[Fun_Report_BD_GetMatchCourtDes]( MatchID1, @LanguageCode),
							   TeamNameWin1B = '' WHERE @ScheduleOnly = 1 OR MatchStatusID1 NOT IN (100,110)
		
		UPDATE #TMP_TABLE1 SET TeamNameWin2A = dbo.[Fun_Report_BD_GetMatchDateTimeDes](MatchID2), 
							   ScoreDes2 = [dbo].[Fun_Report_BD_GetMatchCourtDes]( MatchID2, @LanguageCode),
							   TeamNameWin2B = '' WHERE @ScheduleOnly = 1 OR MatchStatusID2 NOT IN (100,110)
		
		UPDATE #TMP_TABLE1 SET TeamNameWin3A = dbo.[Fun_Report_BD_GetMatchDateTimeDes](MatchID3), 
		                       ScoreDes3 = [dbo].[Fun_Report_BD_GetMatchCourtDes]( MatchID3, @LanguageCode),
							   TeamNameWin3B = '' WHERE @ScheduleOnly = 1 OR MatchStatusID3 NOT IN (100,110)
							   
		UPDATE #TMP_TABLE1 SET TeamNameWin4A = dbo.[Fun_Report_BD_GetMatchDateTimeDes](MatchID4), 
							   ScoreDes4 = [dbo].[Fun_Report_BD_GetMatchCourtDes]( MatchID4, @LanguageCode),
							   TeamNameWin4B = '' WHERE @ScheduleOnly = 1 OR MatchStatusID4 NOT IN (100,110)
		
		SELECT * FROM #TMP_TABLE1
SET NOCOUNT OFF
END


GO