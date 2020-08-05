IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetEventInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetEventInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_BD_GetEventInfo]
----功		  能：得到当前Event信息
----作		  者：张翠霞
----日		  期: 2010-01-20 

CREATE PROCEDURE [dbo].[Proc_Report_BD_GetEventInfo]
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
        F_Gender            NVARCHAR(20),
        F_GenderCode        NVARCHAR(10),
        F_EventCode         NVARCHAR(10),
        F_DisciplineCode    NVARCHAR(2),
        F_ReportName        NVARCHAR(9),
        F_DisciplineID      INT,
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
        F_EventTypeID       INT,
        F_GroupNum          INT
    )

    INSERT INTO #table_Event(F_DisciplineName, F_Gender, F_GenderCode, F_EventCode, F_EventTypeID, F_DisciplineID)
    SELECT D.F_DisciplineLongName, B.F_SexShortName, E.F_GenderCode, A.F_EventCode, A.F_PlayerRegTypeID, A.F_DisciplineID FROM TS_Event AS A LEFT JOIN TC_Sex_Des AS B ON
    A.F_SexCode = B.F_SexCode AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Discipline_Des AS D ON A.F_DisciplineID = D.F_DisciplineID
    AND D.F_LanguageCode = @LanguageCode LEFT JOIN TC_Sex AS E ON A.F_SexCode = E.F_SexCode WHERE A.F_EventID = @EventID

    UPDATE #table_Event SET F_EventName = F_EventLongName FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode

    UPDATE #table_Event SET F_VenueName = UPPER(B.F_VenueShortName) FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN #table_Event AS C ON A.F_DisciplineID = C.F_DisciplineID

    UPDATE #table_Event SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Event
    AS A ON B.F_DisciplineID = A.F_DisciplineID
    
    DECLARE @Count AS INT
    SELECT @Count = COUNT(F_PhaseID) FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseIsPool = 1
    
    UPDATE #table_Event SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000', F_GroupNum = @Count,
    F_Report_TitleDate = [dbo].[Fun_Report_BD_GetDateTime](GETDATE(), 8), F_Report_CreateDate = CONVERT( NVARCHAR(30), GETDATE(), 20 )
    
    SELECT F_DisciplineName, F_VenueName, F_EventName, F_Gender, F_ReportName, F_Report_TitleDate, F_Report_CreateDate, F_EventTypeID, F_GroupNum FROM #table_Event

Set NOCOUNT OFF
End


GO

