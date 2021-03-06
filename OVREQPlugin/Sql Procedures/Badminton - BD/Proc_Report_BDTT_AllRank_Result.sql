IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BDTT_AllRank_Result]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BDTT_AllRank_Result]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BDTT_AllRank_Result]
--描    述：获取全排名报表的日程或成绩
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2012年08月06日


CREATE PROCEDURE [dbo].[Proc_Report_BDTT_AllRank_Result](
												@EventID		   INT,
												@ScheduleOnly     INT,
												@LanguageCode	   NVARCHAR(10)
)
As
Begin
SET NOCOUNT ON 
	
	CREATE TABLE #TMP_TABLE
	(
		MatchID INT,
		MatchStatusID INT,
		MatchPosition INT,
		MatchDate NVARCHAR(20),
		MatchTime NVARCHAR(10),
		CourtName NVARCHAR(50),
		RegisterNameA NVARCHAR(100),
		RegisterNameB NVARCHAR(100),
		Winner NVARCHAR(100),
		Loser NVARCHAR(100)
	)
	
	INSERT INTO #TMP_TABLE
	        ( MatchID ,
	          MatchStatusID ,
	          MatchPosition,
	          MatchDate ,
	          MatchTime ,
	          CourtName,
	          RegisterNameA ,
	          RegisterNameB ,
	          Winner ,
	          Loser
	        )
	(
		SELECT A.F_MatchID, A.F_MatchStatusID, CONVERT(INT,A.F_MatchComment1),
		CASE @LanguageCode WHEN  'CHN' THEN dbo.Fun_Report_BD_GetDateTime(A.F_MatchDate, 13)
						   ELSE dbo.Fun_Report_BD_GetDateTime(A.F_MatchDate, 7) END,
		dbo.Fun_Report_BD_GetDateTime(A.F_StartTime, 3),
		E.F_CourtShortName,
		dbo.Fun_BDTT_GetRegisterName(C1.F_RegisterID, 21, @LanguageCode, 0),
		dbo.Fun_BDTT_GetRegisterName(C2.F_RegisterID, 21, @LanguageCode, 0),
		dbo.Fun_BDTT_GetRegisterName(D1.F_RegisterID, 21, @LanguageCode, 0),
		dbo.Fun_BDTT_GetRegisterName(D2.F_RegisterID, 21, @LanguageCode, 0)
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TS_Match_Result AS C2 ON C2.F_MatchID = A.F_MatchID AND C2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TS_Match_Result AS D1 ON D1.F_MatchID = A.F_MatchID AND D1.F_Rank = 1
		LEFT JOIN TS_Match_Result AS D2 ON D2.F_MatchID = A.F_MatchID AND D2.F_Rank = 2
		LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
		LEFT JOIN TC_Court_Des AS E ON E.F_CourtID = A.F_CourtID AND E.F_LanguageCode = @LanguageCode
		WHERE B.F_EventID = @EventID AND A.F_MatchComment1 IS NOT NULL
	)
	ORDER BY CONVERT(INT,A.F_MatchComment1)

	SELECT MatchPosition, 
		   CASE WHEN MatchStatusID IN (100,110) AND @ScheduleOnly != 1 THEN Winner ELSE MatchDate + ' ' + MatchTime END AS WinnerOrDate,
		   CASE WHEN MatchStatusID IN (100,110) AND @ScheduleOnly != 1 THEN Loser ELSE '' END AS Loser,
		   CASE WHEN MatchStatusID IN (100,110) AND @ScheduleOnly != 1 THEN dbo.Fun_BDTT_GetMatchResultDes(MatchID, 1) ELSE CourtName END AS MatchResOrCourt
	FROM #TMP_TABLE
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

--Proc_Report_BDTT_AllRank_Result 5,8,'CHN'