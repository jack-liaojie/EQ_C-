IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_SL_GetMatchInfo]
----功		  能：得到当前Match信息
----作		  者：吴定昉
----日		  期: 2010-01-13
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年7月31日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/
 

CREATE PROCEDURE [dbo].[Proc_Report_SL_GetMatchInfo]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Match(
		F_SportName	NVARCHAR(100),
		F_DisciplineName	NVARCHAR(50),
        F_EventName         NVARCHAR(100),
        F_PhaseName         NVARCHAR(100),
        F_UniteName         NVARCHAR(100),
        F_VenueName         NVARCHAR(100),
        F_StartDate         DATETIME,
        F_StartDateTime_YYYYMMDDhhmm NVARCHAR(30),
        F_Date              NVARCHAR(11),
        F_StartTime         NVARCHAR(5),
        F_EndTime           NVARCHAR(5),
        F_Gender            NVARCHAR(10),
        F_DisciplineCode    NVARCHAR(2),
        F_GenderCode        NVARCHAR(1),
        F_EventCode         NVARCHAR(10),
        F_PhaseCode         NVARCHAR(10),
        F_MatchCode         NVARCHAR(10),
        F_ReportName        NVARCHAR(20),
        F_SportID      INT,
        F_DisciplineID      INT,
        F_EventID           INT,
        F_PhaseID           INT,
        F_VenueID           INT,
        F_SexCode           INT,
        F_WeekENG           NVARCHAR(10),
        F_WeekCHN           NVARCHAR(10),
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
        F_MatchComment      NVARCHAR(100),
        F_Report_CreateDate_YYYYMMDDhhmm NVARCHAR(30)
    )

    INSERT INTO #table_Match(F_StartDate, F_StartDateTime_YYYYMMDDhhmm, F_Date, F_StartTime, F_EndTime, F_PhaseCode, F_MatchCode, F_EventID, F_PhaseID, F_VenueID, F_WeekENG, F_MatchComment)
    SELECT A.F_MatchDate, 
    [dbo].[Func_Report_SL_GetDateTime](A.F_MatchDate, 10) + ' ' + [dbo].[Func_Report_SL_GetDateTime](A.F_StartTime, 11),
    LEFT(CONVERT(NVARCHAR(100), A.F_MatchDate, 113), 11), 
    LEFT(CONVERT(NVARCHAR(100), A.F_StartTime, 114), 5), 
    LEFT(CONVERT(NVARCHAR(100), A.F_EndTime, 114), 5), 
    B.F_PhaseCode, A.F_MatchCode, B.F_EventID, B.F_PhaseID, A.F_VenueID, 
    UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)), A.F_MatchComment1
    FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    UPDATE #table_Match SET F_EventCode = B.F_EventCode, F_SexCode = B.F_SexCode, F_DisciplineID = B.F_DisciplineID FROM #table_Match AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    
    UPDATE #table_Match SET F_GenderCode = B.F_GenderCode FROM #table_Match AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode

    UPDATE #table_Match SET F_SportID = B.F_SportID FROM #table_Match AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID

    UPDATE #table_Match SET F_SportName = B.F_SportLongName FROM #table_Match AS A LEFT JOIN TS_Sport_Des AS B ON A.F_SportID = B.F_SportID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_DisciplineName = B.F_DisciplineLongName FROM #table_Match AS A LEFT JOIN TS_Discipline_Des AS B ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_EventName = B.F_EventLongName FROM #table_Match AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_PhaseName = B.F_PhaseLongName FROM #table_Match AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_UniteName = B.F_MatchLongName FROM #table_Match AS A LEFT JOIN TS_Match_Des AS B ON B.F_MatchID = @MatchID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_VenueName = B.F_VenueLongName FROM #table_Match AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Match
    AS A ON B.F_DisciplineID = A.F_DisciplineID

    UPDATE #table_Match SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + F_PhaseCode + F_MatchCode
    
    UPDATE #table_Match SET F_StartTime = RIGHT(F_StartTime, 4) WHERE LEFT(F_StartTime, 1) = '0'

    UPDATE #table_Match SET F_EndTime = RIGHT(F_EndTime, 4) WHERE LEFT(F_EndTime, 1) = '0'

    UPDATE #table_Match SET F_Gender = B.F_SexShortName FROM #table_Match AS A LEFT JOIN TC_Sex_Des AS B ON A.F_SexCode = B.F_SexCode AND B.F_LanguageCode = @LanguageCode
    
    UPDATE #table_Match SET F_Report_TitleDate = [dbo].[Func_Report_GetDateTime](GETDATE(), 2)

    UPDATE #table_Match SET F_Report_CreateDate = [dbo].[Func_Report_GetDateTime](GETDATE(), 1)

	UPDATE #table_Match SET F_Report_CreateDate_YYYYMMDDhhmm = [dbo].[Func_Report_SL_GetDateTime](GETDATE(), 9)
    
    SET LANGUAGE N'简体中文'
    UPDATE #table_Match SET F_WeekCHN = DATENAME(WEEKDAY, F_StartDate)

    IF @LanguageCode = N'CHN'
    BEGIN
        DECLARE @tDate	NVARCHAR(100)
        SELECT @tDate = CONVERT(NVARCHAR(12),F_MatchDate, 105) from TS_Match as m where m.F_MatchID = @MatchID
		SET LANGUAGE N'简体中文'
		IF @tDate IS NOT NULL AND @tDate <> ''
			UPDATE #table_Match SET F_Date = RIGHT(@tDate,4) + N'年' + cast(cast(SUBSTRING(@tDate,4,2) as int) as NVARCHAR) + N'月' + cast(cast(LEFT(@tDate,2) as int) as NVARCHAR) + N'日'
    END
    
    SELECT * FROM #table_Match

Set NOCOUNT OFF
End
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
