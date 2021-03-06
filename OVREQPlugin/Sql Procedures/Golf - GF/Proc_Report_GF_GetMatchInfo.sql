IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----名    称：[Proc_Report_GF_GetMatchInfo]
----功	  能：得到当前Match信息
----作	  者：张翠霞
----日	  期: 2010-09-1 
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月13日      吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_GF_GetMatchInfo]
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
        F_VenueName         NVARCHAR(100),
        F_StartDate         DATETIME,
        F_StartDateTime_YYYYMMDDhhmm NVARCHAR(30),
        F_Date              NVARCHAR(11),
        F_StartTime         NVARCHAR(5),
        F_EndTime           NVARCHAR(5),
        F_DisciplineCode    NVARCHAR(2),
        F_GenderCode        NVARCHAR(1),
        F_EventCode         NVARCHAR(10),
        F_PhaseCode         NVARCHAR(10),
        F_MatchCode         NVARCHAR(10),
        F_ReportName        NVARCHAR(20),
        F_VenueID           INT,
        F_WeekENG           NVARCHAR(10),
        F_WeekCHN           NVARCHAR(10),
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
        F_Report_CreateDate_YYYYMMDDhhmm NVARCHAR(30)
    )

    INSERT INTO #table_Match(F_StartDate, F_StartDateTime_YYYYMMDDhhmm, F_Date, F_StartTime, F_EndTime, F_DisciplineCode, F_EventCode, F_PhaseCode, F_GenderCode, F_MatchCode, F_VenueID, F_WeekENG, F_DisciplineName, F_PhaseName, F_EventName)
    SELECT A.F_MatchDate, [dbo].[Func_Report_GF_GetDateTime](A.F_MatchDate, 10) + ' ' + [dbo].[Func_Report_GF_GetDateTime](A.F_StartTime, 11)
    ,[dbo].[Func_Report_GF_GetDateTime](A.F_MatchDate, 4), [dbo].[Func_Report_GF_GetDateTime](A.F_StartTime, 3), [dbo].[Func_Report_GF_GetDateTime](A.F_EndTime, 3)
    , D.F_DisciplineCode, E.F_EventCode, B.F_PhaseCode, S.F_GenderCode, A.F_MatchCode, A.F_VenueID
    , UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)), DD.F_DisciplineLongName, PD.F_PhaseLongName, ED.F_EventLongName
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Phase_Des AS PD ON B.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS E ON B.F_EventID = E.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
    LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    WHERE A.F_MatchID = @MatchID

    UPDATE #table_Match SET F_VenueName = UPPER(B.F_VenueShortName) FROM #table_Match AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID AND B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + F_PhaseCode + F_MatchCode
    UPDATE #table_Match SET F_Report_TitleDate = [dbo].[Func_Report_GF_GetDateTime](GETDATE(), 4)
    UPDATE #table_Match SET F_Report_CreateDate = [dbo].[Func_Report_GF_GetDateTime](GETDATE(), 1)
    UPDATE #table_Match SET F_Report_CreateDate_YYYYMMDDhhmm = [dbo].[Func_Report_GF_GetDateTime](GETDATE(), 9)

    SET LANGUAGE N'简体中文'
    UPDATE #table_Match SET F_WeekCHN = DATENAME(WEEKDAY, F_StartDate)

    SELECT * FROM #table_Match

Set NOCOUNT OFF
End

GO




