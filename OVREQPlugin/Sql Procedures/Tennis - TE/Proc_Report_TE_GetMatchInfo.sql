IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_Report_TE_GetMatchInfo]
----功		  能：得到当前Match信息
----作		  者：张翠霞
----日		  期: 2010-03-02 




CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMatchInfo]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Match(
		F_DisciplineName	NVARCHAR(50),
        F_EventName         NVARCHAR(100),
        F_PhaseName         NVARCHAR(100),
        F_UniteName         NVARCHAR(100),
        F_VenueName         NVARCHAR(100),
        F_CourtName         NVARCHAR(100),
        F_StartDate         DATETIME,
        F_Date              NVARCHAR(50),
        F_StartTime         NVARCHAR(100),
        F_EndTime           NVARCHAR(100),
        F_DisciplineCode    NVARCHAR(2),
        F_GenderCode        NVARCHAR(1),
        F_EventCode         NVARCHAR(10),
        F_PhaseCode         NVARCHAR(10),
        F_MatchCode         NVARCHAR(10),
        F_ReportName        NVARCHAR(20),
        F_DisciplineID      INT,
        F_EventID           INT,
        F_PhaseID           INT,
        F_VenueID           INT,
        F_CourtID			INT,
        F_SexCode           INT,
        F_WeekENG           NVARCHAR(50),
        F_WeekCHN           NVARCHAR(50),
        F_Report_TitleDate  NVARCHAR(50),
        F_Report_CreateDate NVARCHAR(50),
        F_MatchComment      NVARCHAR(100),
    )

    INSERT INTO #table_Match(F_StartDate, F_Date, F_StartTime, F_EndTime, F_PhaseCode
    , F_MatchCode, F_EventID, F_PhaseID, F_VenueID, F_CourtID, F_WeekENG, F_MatchComment)
    SELECT A.F_MatchDate
    , [dbo].[Func_Report_TE_GetDateTime](A.F_MatchDate, 7, @LanguageCode)
    , [dbo].[Func_Report_TE_GetDateTime](A.F_StartTime, 4, @LanguageCode)
    , [dbo].[Func_Report_TE_GetDateTime](A.F_EndTime, 4, @LanguageCode)
    , B.F_PhaseCode, A.F_MatchCode, B.F_EventID, B.F_PhaseID, A.F_VenueID, F_CourtID
    , UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)), A.F_MatchComment1
    FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    UPDATE #table_Match SET F_EventCode = B.F_EventCode, F_SexCode = B.F_SexCode, F_DisciplineID = B.F_DisciplineID FROM #table_Match AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID   
    UPDATE #table_Match SET F_GenderCode = B.F_GenderCode FROM #table_Match AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode
    UPDATE #table_Match SET F_DisciplineName = B.F_DisciplineLongName FROM #table_Match AS A LEFT JOIN TS_Discipline_Des AS B ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_EventName = B.F_EventLongName FROM #table_Match AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE A SET A.F_PhaseName = B.F_PhaseLongName
           FROM #table_Match AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
           
    UPDATE #table_Match SET F_UniteName = B.F_MatchLongName FROM #table_Match AS A LEFT JOIN TS_Match_Des AS B ON B.F_MatchID = @MatchID AND B.F_LanguageCode = @LanguageCode
   
   --决赛不显示
    UPDATE #table_Match SET F_UniteName = '' FROM #table_Match WHERE (F_PhaseCode = '1' OR F_PhaseCode = 'A') AND F_MatchCode = '01'
    UPDATE #table_Match SET F_VenueName = UPPER(B.F_VenueShortName) FROM #table_Match AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID AND B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_CourtName = UPPER(B.F_CourtShortName) FROM #table_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Match
    AS A ON B.F_DisciplineID = A.F_DisciplineID

    UPDATE #table_Match SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + F_PhaseCode + F_MatchCode  
    UPDATE #table_Match SET F_Report_TitleDate = [dbo].[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode)
    UPDATE #table_Match SET F_Report_CreateDate = [dbo].[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode)

    SET LANGUAGE N'简体中文'
    UPDATE #table_Match SET F_WeekCHN = DATENAME(WEEKDAY, F_StartDate)

    SELECT * FROM #table_Match

Set NOCOUNT OFF
End


GO


--EXEC Proc_Report_TE_GetMatchInfo 50, 'CHN'