IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetEventInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetEventInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_HO_GetEventInfo]
----功		  能：得到当前Event信息
----作		  者：张翠霞
----日		  期: 2012-09-03 

CREATE PROCEDURE [dbo].[Proc_Report_HO_GetEventInfo]
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
        F_DisciplineID      INT,
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
    )

    INSERT INTO #table_Event(F_DisciplineName, F_EventName, F_GenderCode, F_EventCode, F_DisciplineCode, F_DisciplineID)
    SELECT DD.F_DisciplineLongName, LEFT(ED.F_EventLongName, 2), S.F_GenderCode, E.F_EventCode, D.F_DisciplineCode, D.F_DisciplineID
    FROM TS_Event AS E
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Sex AS S ON S.F_SexCode = E.F_SexCode
    WHERE E.F_EventID = @EventID
    
    UPDATE #table_Event SET F_VenueName = UPPER(B.F_VenueShortName) FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN #table_Event AS C ON A.F_DisciplineID = C.F_DisciplineID

    UPDATE #table_Event SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000'

    UPDATE #table_Event SET F_Report_TitleDate = LEFT(CONVERT(NVARCHAR(30), GETDATE(), 20), 16)
    UPDATE #table_Event SET F_Report_CreateDate = LEFT(CONVERT(NVARCHAR(30), GETDATE(), 20), 16)
    
    SELECT F_DisciplineName, F_VenueName, F_EventName, F_ReportName, F_Report_TitleDate, F_Report_CreateDate FROM #table_Event

Set NOCOUNT OFF
End

GO



