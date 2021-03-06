IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetEventInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetEventInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_SL_GetEventInfo]
----功		  能：得到当前Event信息
----作		  者：
----日		  期: 
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年7月31日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetEventInfo]
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
        F_EventCloseDate_YYYYMMDD NVARCHAR(30),
        F_EventCloseDate_YYYYMMDDhhmm NVARCHAR(30),
        F_DisciplineCode    NVARCHAR(2),
        F_ReportName        NVARCHAR(9),
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
        F_Report_CreateDate_YYYYMMDDhhmm NVARCHAR(30)
    )

    INSERT INTO #table_Event(F_DisciplineName, F_EventName, F_GenderCode, F_EventCode, 
    F_EventCloseDate_YYYYMMDD, F_EventCloseDate_YYYYMMDDhhmm, F_DisciplineCode, F_VenueName)
    SELECT UPPER(DD.F_DisciplineLongName), UPPER(ED.F_EventLongName), S.F_GenderCode, E.F_EventCode,
    [dbo].[Func_Report_SL_GetDateTime](E.F_CloseDate, 10), 
    [dbo].[Func_Report_SL_GetDateTime](E.F_CloseDate, 9), 
    D.F_DisciplineCode, UPPER(VD.F_VenueShortName)
    FROM TS_Event AS E
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode
    LEFT JOIN TD_Discipline_Venue AS DV ON E.F_DisciplineID = DV.F_DisciplineID
    LEFT JOIN TC_Venue_Des AS VD ON DV.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode
    WHERE E.F_EventID = @EventID
    
    UPDATE #table_Event SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000',
    F_Report_TitleDate = [dbo].[Func_Report_SL_GetDateTime](GETDATE(), 4), 
    F_Report_CreateDate = [dbo].[Func_Report_SL_GetDateTime](GETDATE(), 1),
    F_Report_CreateDate_YYYYMMDDhhmm = [dbo].[Func_Report_SL_GetDateTime](GETDATE(), 9)
    
    
    SELECT * FROM #table_Event

Set NOCOUNT OFF
End

GO


