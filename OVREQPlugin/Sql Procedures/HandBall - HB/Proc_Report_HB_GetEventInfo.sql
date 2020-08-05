

/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetEventInfo]    Script Date: 08/29/2012 08:28:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HB_GetEventInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HB_GetEventInfo]
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_HB_GetEventInfo]    Script Date: 08/29/2012 08:28:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Report_HB_GetEventInfo]
----功		  能：得到当前Event信息
----作		  者：李燕
----日		  期: 2010-03-21 

CREATE PROCEDURE [dbo].[Proc_Report_HB_GetEventInfo]
             @EventID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Event(
								F_DisciplineName	NVARCHAR(50),
								F_VenueName         NVARCHAR(100),
                                F_EventCode         NVARCHAR(10),
								F_EventName         NVARCHAR(100),
								F_Gender            NVARCHAR(20),
								F_GenderCode        NVARCHAR(10),
								F_DisciplineCode    NVARCHAR(2),
								F_ReportName        NVARCHAR(9),
								F_DisciplineID      INT,
								F_Report_TitleDate  NVARCHAR(20),
								F_Report_CreateDate NVARCHAR(30),
								F_EventCloseDate    NVARCHAR(30),
								F_WEEKENG           NVARCHAR(30),
								F_WEEKCHN           NVARCHAR(30),
								F_EventDate         DATETIME,
								F_EventStatus       INT
							)

    INSERT INTO #table_Event(F_DisciplineName, F_Gender, F_GenderCode, F_EventCode, F_EventName, F_DisciplineID, F_EventDate, F_EventStatus)
    SELECT UPPER(D.F_DisciplineLongName), UPPER(B.F_SexShortName), E.F_GenderCode, A.F_EventCode, UPPER(F.F_EventShortName), A.F_DisciplineID, A.F_CloseDate, A.F_EventStatusID
          FROM TS_Event AS A LEFT JOIN TC_Sex_Des AS B ON A.F_SexCode = B.F_SexCode AND B.F_LanguageCode = @LanguageCode
                             LEFT JOIN TS_Discipline_Des AS D ON A.F_DisciplineID = D.F_DisciplineID AND D.F_LanguageCode = @LanguageCode 
                             LEFT JOIN TC_Sex AS E ON A.F_SexCode = E.F_SexCode 
                             LEFT JOIN TS_Event_Des AS F ON A.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode 
              WHERE A.F_EventID = @EventID

    UPDATE #table_Event SET F_VenueName = UPPER(B.F_VenueShortName) FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN #table_Event AS C ON A.F_DisciplineID = C.F_DisciplineID

    UPDATE #table_Event SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Event
    AS A ON B.F_DisciplineID = A.F_DisciplineID

    UPDATE #table_Event SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000'

    UPDATE #table_Event SET F_Report_TitleDate = [dbo].[Func_HB_GetChineseDate](GETDATE())
    UPDATE #table_Event SET F_Report_CreateDate = [dbo].[Func_HB_GetChineseDateTime](GETDATE())
    
    UPDATE #table_Event SET F_EventCloseDate = UPPER(LEFT(CONVERT (NVARCHAR(100), F_EventDate, 113), 11))
    
    SET LANGUAGE 'ENGLISH'
    UPDATE #table_Event SET F_WEEKENG = UPPER(LEFT(DATENAME(WEEKDAY, F_EventDate), 3))
        
    SET LANGUAGE N'简体中文'
    UPDATE #table_Event SET F_WEEKCHN = DATENAME(WEEKDAY, F_EventDate)
    
    SELECT F_DisciplineName, F_VenueName, F_EventName, F_Gender, F_ReportName, F_Report_TitleDate, F_Report_CreateDate, F_EventCloseDate, F_WEEKCHN, F_WEEKENG, F_EventStatus FROM #table_Event

Set NOCOUNT OFF
End


GO


