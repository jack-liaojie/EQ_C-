IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_SessionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_SessionSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_BD_SessionSchedule]
----功		  能：得到该项目下的一个Session的全部竞赛日程
----作		  者：王强
----日		  期: 2011-07-19



CREATE PROCEDURE [dbo].[Proc_Report_BD_SessionSchedule] 
                   (
                   	@DisciplineID			INT,	
					@SessionID   			INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

       CREATE TABLE #TMP_TABLE
       (
			CourtID INT,
			MatchID INT,
			CourtNo INT,
			MatchTime DATETIME,
			SubMatchOrder INT,
			SubMatchCode NVARCHAR(10),
			NOCA NVARCHAR(10),
			NOCB NVARCHAR(10),
			PlayerNameA NVARCHAR(200),
			PlayerNameB NVARCHAR(200),
			PosA INT,
			PosB INT,
			RaceNum NVARCHAR(20),
			UmpireName1 NVARCHAR(200),
			UmpireName2 NVARCHAR(200),
			UmNOCA NVARCHAR(20),
			UmNOCB NVARCHAR(20)
       )
       INSERT INTO #TMP_TABLE
       SELECT A.F_CourtID, A.F_MatchID, A.F_CourtID, A.F_StartTime, B.F_Order,
				CASE B.F_MatchSplitType WHEN 1 THEN 'MS' WHEN 2 THEN 'WS' WHEN 3 THEN 'MD' WHEN 4 THEN 'WD' WHEN 5 THEN 'XD' ELSE '' END
				,dbo.Fun_BDTT_GetPlayerNOC(C1.F_RegisterID), dbo.Fun_BDTT_GetPlayerNOC(C2.F_RegisterID),
			  E1.F_PrintShortName, E2.F_PrintShortName, Z1.F_PhasePosition, Z2.F_PhasePosition, A.F_RaceNum,Y1.F_SBLongName,Y2.F_SBLongName,
			  dbo.Fun_BDTT_GetPlayerNOC(Y1.F_RegisterID), dbo.Fun_BDTT_GetPlayerNOC(Y2.F_RegisterID)
       FROM TS_Match AS A
       LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = 0
       LEFT JOIN TS_Match_Result AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_CompetitionPositionDes1 = 1
       LEFT JOIN TS_Match_Result AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_CompetitionPositionDes1 = 2
       LEFT JOIN TS_Match_Split_Result AS D1 ON D1.F_MatchID = B.F_MatchID AND D1.F_MatchSplitID = B.F_MatchSplitID
													 AND D1.F_CompetitionPosition = 1
	   LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = D1.F_RegisterID AND E1.F_LanguageCode = @LanguageCode
	   LEFT JOIN TS_Match_Split_Result AS D2 ON D2.F_MatchID = B.F_MatchID AND D2.F_MatchSplitID = B.F_MatchSplitID
													 AND D2.F_CompetitionPosition = 2
	   LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = D2.F_RegisterID AND E2.F_LanguageCode = @LanguageCode
	   LEFT JOIN TS_Phase AS F ON F.F_PhaseID = A.F_PhaseID
	   LEFT JOIN TS_Event AS G ON G.F_EventID = f.F_EventID
	   LEFT JOIN TS_Phase_Position AS Z1 ON Z1.F_RegisterID = C1.F_RegisterID AND Z1.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = G.F_EventID)
	   LEFT JOIN TS_Phase_Position AS Z2 ON Z2.F_RegisterID = C2.F_RegisterID AND Z2.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = G.F_EventID)
	   LEFT JOIN TS_Match_Split_Servant AS X1 ON X1.F_MatchID = B.F_MatchID AND X1.F_MatchSplitID = B.F_MatchSplitID AND X1.F_FunctionID = 1
	   LEFT JOIN TR_Register_Des AS Y1 ON Y1.F_RegisterID = X1.F_RegisterID AND Y1.F_LanguageCode = 'ENG'
	   LEFT JOIN TS_Match_Split_Servant AS X2 ON X2.F_MatchID = B.F_MatchID AND X2.F_MatchSplitID = B.F_MatchSplitID AND X2.F_FunctionID = 5
	   LEFT JOIN TR_Register_Des AS Y2 ON Y2.F_RegisterID = X2.F_RegisterID AND Y2.F_LanguageCode = 'ENG'
       WHERE A.F_SessionID = @SessionID AND A.F_CourtID IS NOT NULL AND G.F_PlayerRegTypeID = 3
       
       INSERT INTO #TMP_TABLE
       SELECT A.F_CourtID,A.F_MatchID, A.F_CourtID, A.F_StartTime, 1,
				H.F_EventComment
				,dbo.Fun_BDTT_GetPlayerNOC(C1.F_RegisterID), dbo.Fun_BDTT_GetPlayerNOC(C2.F_RegisterID),
			  E1.F_PrintShortName, E2.F_PrintShortName, Z1.F_PhasePosition, Z2.F_PhasePosition, A.F_RaceNum, Y1.F_SBLongName, Y2.F_SBLongName,
			  dbo.Fun_BDTT_GetPlayerNOC(Y1.F_RegisterID), dbo.Fun_BDTT_GetPlayerNOC(Y2.F_RegisterID)
       FROM TS_Match AS A
       LEFT JOIN TS_Match_Result AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_CompetitionPositionDes1 = 1
       LEFT JOIN TS_Match_Result AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_CompetitionPositionDes1 = 2
	   LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = C1.F_RegisterID AND E1.F_LanguageCode = @LanguageCode
	   LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = C2.F_RegisterID AND E2.F_LanguageCode = @LanguageCode
	   LEFT JOIN TS_Phase AS F ON F.F_PhaseID = A.F_PhaseID
	   LEFT JOIN TS_Event AS G ON G.F_EventID = F.F_EventID
	   LEFT JOIN TS_Event_Des AS H ON H.F_EventID = G.F_EventID AND H.F_LanguageCode = 'ENG'
	   LEFT JOIN TS_Phase_Position AS Z1 ON Z1.F_RegisterID = C1.F_RegisterID AND Z1.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = G.F_EventID)
	   LEFT JOIN TS_Phase_Position AS Z2 ON Z2.F_RegisterID = C2.F_RegisterID AND Z2.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = G.F_EventID)
	   LEFT JOIN TS_Match_Servant AS X1 ON X1.F_MatchID = A.F_MatchID AND X1.F_FunctionID = 1
	   LEFT JOIN TR_Register_Des AS Y1 ON Y1.F_RegisterID = X1.F_RegisterID AND Y1.F_LanguageCode = 'ENG'
	   LEFT JOIN TS_Match_Servant AS X2 ON X2.F_MatchID = A.F_MatchID AND X2.F_FunctionID = 5
	   LEFT JOIN TR_Register_Des AS Y2 ON Y2.F_RegisterID = X2.F_RegisterID AND Y2.F_LanguageCode = 'ENG'
       WHERE A.F_SessionID = @SessionID AND A.F_CourtID IS NOT NULL AND G.F_PlayerRegTypeID IN (1,2)
       
       SELECT  CourtID,MatchID,
			CourtNo,
			dbo.Fun_Report_BD_GetDateTime(MatchTime,3) AS StartTime,
			SubMatchOrder,
			SubMatchCode,
			NOCA,
			NOCB,
			PlayerNameA,
			PlayerNameB, PosA, PosB, RaceNum, #TMP_TABLE.UmpireName1, #TMP_TABLE.UmpireName2 
			,UmNOCA,UmNOCB FROM #TMP_TABLE ORDER BY CourtID, MatchTime,MatchID, SubMatchOrder
SET NOCOUNT OFF
END


GO

