IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetEventInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetEventInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_Report_SH_GetEventInfo]
             @EventID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Event(
		F_DisciplineName	NVARCHAR(50),
        F_VenueName         NVARCHAR(100),
        F_EventName         NVARCHAR(100),
        F_GenderCode        NVARCHAR(10),
        F_EventCode         NVARCHAR(10),
        F_DisciplineCode    NVARCHAR(2),
        F_ReportName        NVARCHAR(9),
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30)
    )

    INSERT INTO #table_Event(F_DisciplineName, F_EventName, F_GenderCode, F_EventCode, F_DisciplineCode, F_VenueName)
    SELECT UPPER(DD.F_DisciplineLongName), UPPER(ED.F_EventLongName), S.F_GenderCode, E.F_EventCode, D.F_DisciplineCode, UPPER(VD.F_VenueShortName)
    FROM TS_Event AS E
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
    LEFT JOIN TD_Discipline_Venue AS DV ON E.F_DisciplineID = DV.F_DisciplineID
    LEFT JOIN TC_Venue_Des AS VD ON DV.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode
    WHERE E.F_EventID = @EventID
    
    UPDATE #table_Event SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000',
    F_Report_TitleDate = [dbo].[Func_SH_GetChineseDate](GETDATE()), 
    F_Report_CreateDate = [dbo].[Func_SH_GetChineseDate](GETDATE()) + N' ' + [dbo].[Fun_Report_GF_GetDateTime](GETDATE(), 3)
    
    SELECT F_DisciplineName, F_VenueName, F_EventName, F_ReportName, F_Report_TitleDate, F_Report_CreateDate FROM #table_Event

Set NOCOUNT OFF
End

GO


-- [Proc_Report_SH_GetEventInfo] 1,'CHN'