IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetSingleBracket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetSingleBracket]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_BD_GetSingleBracket]
--描    述：获取个人赛的晋级信息
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2011-05-24


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetSingleBracket](
                       @EventID         INT,
                       @Order           INT -- -1为取所有的Phase
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @PhaseID INT
	DECLARE @EventCode NVARCHAR(10)
	
	CREATE TABLE #PHASEID
	(
		 PhaseOrder INT,
		 PhaseID INT
	)
	
	CREATE TABLE #TMP_TABLE
	(
	   PhaseID INT,
	   MatchID INT,
	   PlayerNameOrDate1 NVARCHAR(100),
	   PlayerNameOrDate2 NVARCHAR(100),
	   MatchDesOrCourt1 NVARCHAR(100),
	   MatchDesOrCourt2 NVARCHAR(100),
	   NOCA NVARCHAR(30),
	   NOCB NVARCHAR(30),
	   ResultDes1 NVARCHAR(100),
	   ResultDes2 NVARCHAR(100),
	   NextMatchPlayerNameOrDate NVARCHAR(100),
	   NextMatchDesOrCourt NVARCHAR(100),
	   NextMatchPlayerNOC NVARCHAR(10),
	   NextMatchResultDes NVARCHAR(100),
	   APos NVARCHAR(10),
	   BPos NVARCHAR(10)
	)
	
	IF @Order IS NULL
	BEGIN
		SELECT * FROM #TMP_TABLE
		RETURN
	END
	

	SELECT @EventCode = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = 'ENG'
	
	IF @Order != -1
		BEGIN
			SELECT @PhaseID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = @Order AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
			INSERT INTO #PHASEID (PhaseOrder,PhaseID) VALUES(1,@PhaseID)
		END
	ELSE
		BEGIN
			INSERT INTO #PHASEID (PhaseOrder,PhaseID)
			(
				SELECT F_Order,F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID <> 0 
			)ORDER BY F_Order
		END

	IF NOT EXISTS (SELECT * FROM #PHASEID)
	BEGIN
		return
	END
		

	
	
	
	
	INSERT INTO #TMP_TABLE (PhaseID, MatchID, PlayerNameOrDate1,PlayerNameOrDate2,MatchDesOrCourt1,MatchDesOrCourt2,
							 NOCA,NOCB,ResultDes1,ResultDes2, NextMatchPlayerNameOrDate,NextMatchDesOrCourt
							 ,NextMatchPlayerNOC, NextMatchResultDes, APos, BPos)
	(SELECT  O.F_PhaseID,A.F_MatchID,
	  ISNULL( C1.F_PrintShortName, 
				(SELECT [dbo].[Fun_Report_BD_GetDateTime](Y.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](Y.F_StartTime, 3) 
				FROM TS_Match_Result AS X 
				LEFT JOIN TS_Match AS Y ON Y.F_MatchID = X.F_SourceMatchID
				WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID =  B1.F_MatchID )
		      )
	  , 
	  ISNULL( C2.F_PrintShortName,
				(SELECT [dbo].[Fun_Report_BD_GetDateTime](Y.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](Y.F_StartTime, 3)
				FROM TS_Match_Result AS X 
				LEFT JOIN TS_Match AS Y ON Y.F_MatchID = X.F_SourceMatchID
				WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID =  B2.F_MatchID )
			  )
	  ,
	  CASE 
	  WHEN D1.F_MatchStatusID NOT IN (100,110) THEN (E1.F_CourtShortName + ','+@EventCode + D1.F_RaceNum)
	  ELSE dbo.Fun_Report_BD_GetMatchResultDes(D1.F_MatchID, 5, 1)
	  END
	  ,	
	  CASE 
	  WHEN D2.F_MatchStatusID NOT IN (100,110) THEN (E2.F_CourtShortName + ','+@EventCode + D2.F_RaceNum)
	  ELSE dbo.Fun_Report_BD_GetMatchResultDes(D2.F_MatchID, 5, 1)
	  END,
	  dbo.Fun_BDTT_GetPlayerNOCName(B1.F_RegisterID),dbo.Fun_BDTT_GetPlayerNOCName(B2.F_RegisterID),
	  dbo.Fun_Report_BD_GetMatchResultDes(D1.F_MatchID, 12, 1),dbo.Fun_Report_BD_GetMatchResultDes(D2.F_MatchID, 12, 1)
	  ,--Next的结果
	  ISNULL( ISNULL(G.F_PrintShortName, S.F_PrintShortName), [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3) )
	  ,
	   CASE 
	  WHEN A.F_MatchStatusID NOT IN (100,110) THEN (H.F_CourtShortName + ','+@EventCode + A.F_RaceNum)
	  ELSE dbo.Fun_Report_BD_GetMatchResultDes(A.F_MatchID, 5, 1)
	  END
	  ,
	  CASE WHEN dbo.Fun_BDTT_GetPlayerNOCName(F.F_RegisterID) = ''
				OR dbo.Fun_BDTT_GetPlayerNOCName(F.F_RegisterID) IS NULL
				THEN dbo.Fun_BDTT_GetPlayerNOCName(R.F_RegisterID)  ELSE '' END
	  ,
	  dbo.Fun_Report_BD_GetMatchResultDes(A.F_MatchID, 12, 1)
	  ,ISNULL( CAST(dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 1) AS NVARCHAR(10)), '')
	  ,ISNULL( CAST(dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 2) AS NVARCHAR(10)), '')
	FROM TS_Match AS A 
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match AS D1 ON D1.F_MatchID = B1.F_SourceMatchID AND B1.F_CompetitionPositionDes1 = 1
	LEFT JOIN TC_Court_Des AS E1 ON E1.F_CourtID = D1.F_CourtID AND E1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match AS D2 ON D2.F_MatchID = B2.F_SourceMatchID AND B2.F_CompetitionPositionDes1 = 2
	LEFT JOIN TC_Court_Des AS E2 ON E2.F_CourtID = D2.F_CourtID AND E2.F_LanguageCode = 'ENG'
	
	LEFT JOIN TS_Match_Result AS F ON F.F_SourceMatchID = A.F_MatchID AND F.F_SourceMatchRank = 1
	LEFT JOIN TR_Register_Des AS G ON G.F_RegisterID = F.F_RegisterID AND G.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Court_Des AS H ON H.F_CourtID = A.F_CourtID AND H.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase AS O ON O.F_PhaseID = A.F_PhaseID
	
	LEFT JOIN TS_Match_Result AS R ON R.F_MatchID = A.F_MatchID AND R.F_ResultID = 1
	LEFT JOIN TR_Register_Des AS S ON S.F_RegisterID = R.F_RegisterID AND S.F_LanguageCode = 'ENG'
	WHERE A.F_PhaseID IN (SELECT PhaseID FROM #PHASEID) )
	ORDER BY O.F_Order,A.F_Order
	
	UPDATE #TMP_TABLE SET PlayerNameOrDate1 = 'BYE' WHERE PlayerNameOrDate1 IS NULL OR PlayerNameOrDate1 = ''
	UPDATE #TMP_TABLE SET PlayerNameOrDate2 = 'BYE' WHERE PlayerNameOrDate2 IS NULL OR PlayerNameOrDate2 = ''
	
	
	SELECT * FROM #TMP_TABLE
	
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

