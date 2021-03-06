IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_HO_GetMatchInfo]
----功		  能：得到当前Match的基础信息
----作		  者：张翠霞
----日		  期: 2010-09-05 

CREATE PROCEDURE [dbo].[Proc_Report_HO_GetMatchInfo]
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
        F_StartDate         DATETIME,
        F_StartTime         NVARCHAR(100),
        F_EndTime           NVARCHAR(100),
        F_DisciplineCode    NVARCHAR(2),
        F_GenderCode        NVARCHAR(1),
        F_Gender            NVARCHAR(10),
        F_EventCode         NVARCHAR(10),
        F_PhaseCode         NVARCHAR(10),
        F_MatchCode         NVARCHAR(10),
        F_ReportName        NVARCHAR(100),
        F_DisciplineID      INT,
        F_VenueID           INT,
        F_SexCode           INT,
        F_WeekENG           NVARCHAR(10),
        F_WeekCHN           NVARCHAR(10),
        F_Report_TitleDate  NVARCHAR(30),
        F_Report_CreateDate NVARCHAR(30),
        F_MatchComment      NVARCHAR(100),
    )

    INSERT INTO #table_Match(F_StartDate, F_StartTime, F_EndTime, F_MatchCode, F_PhaseCode, F_EventCode, F_DisciplineCode, F_SexCode, F_DisciplineID, F_DisciplineName, F_EventName, F_PhaseName, F_UniteName, F_VenueID, F_VenueName, F_WeekENG, F_MatchComment)
    SELECT M.F_MatchDate, LEFT(CONVERT(NVARCHAR(30), M.F_StartTime, 20), 16), LEFT(CONVERT(NVARCHAR(30), M.F_EndTime, 20), 16)
    , M.F_MatchCode, P.F_PhaseCode, E.F_EventCode, D.F_DisciplineCode, E.F_SexCode, E.F_DisciplineID, DD.F_DisciplineLongName
    , LEFT(ED.F_EventLongName, 2), PD.F_PhaseLongName, MD.F_MatchLongName, M.F_VenueID, VD.F_VenueShortName
    , UPPER(LEFT(DATENAME(WEEKDAY, M.F_MatchDate), 3)), M.F_MatchComment1
    FROM TS_Match AS M
    LEFT JOIN TS_Match_Des AS MD ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Venue_Des AS VD ON M.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode
    WHERE M.F_MatchID = @MatchID

    UPDATE #table_Match SET F_GenderCode = B.F_GenderCode FROM #table_Match AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode

    UPDATE #table_Match SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + F_PhaseCode + F_MatchCode  
    UPDATE #table_Match SET F_Report_TitleDate = LEFT(CONVERT(NVARCHAR(30), GETDATE(), 20), 16)
    UPDATE #table_Match SET F_Report_CreateDate = LEFT(CONVERT(NVARCHAR(30), GETDATE(), 20), 16)

    SET LANGUAGE N'简体中文'
    UPDATE #table_Match SET F_WeekCHN = DATENAME(WEEKDAY, F_StartDate)

    SELECT * FROM #table_Match

Set NOCOUNT OFF
End

GO

