IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetPhaseInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetPhaseInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









----存储过程名称：[Proc_Report_BK_GetPhaseInfo]
----功		  能：得到当前Event信息
----作		  者：吴定昉
----日		  期: 2011-06-08 
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年9月20日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_BK_GetPhaseInfo]
             @PhaseID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Phase(
								F_DisciplineName	NVARCHAR(50),
								F_VenueName         NVARCHAR(100),
                                F_EventCode         NVARCHAR(10),
								F_EventName         NVARCHAR(100),
								F_PhaseName         NVARCHAR(100),
								F_Gender            NVARCHAR(20),
								F_GenderCode        NVARCHAR(10),
								F_DisciplineCode    NVARCHAR(2),
								F_ReportName        NVARCHAR(9),
								F_DisciplineID      INT,
								F_Report_TitleDate  NVARCHAR(20),
								F_Report_CreateDate NVARCHAR(30),
								F_Report_CreateDate_YYYYMMDDhhmm NVARCHAR(30),
								F_EventOpenDate     NVARCHAR(30),
								F_EventCloseDate    NVARCHAR(30),
								F_EventCloseDate_YYYYMMDD NVARCHAR(30),
								F_PhaseCloseDate    NVARCHAR(30),
								F_PhaseCloseDate_YYYYMMDD NVARCHAR(30),
								F_PhaseCloseDate_YYYYMMDDhhmm NVARCHAR(30),
								F_WEEKENG           NVARCHAR(30),
								F_WEEKCHN           NVARCHAR(30),
								F_DT_EventOpenDate     DATETIME,
								F_DT_EventCloseDate    DATETIME,
								F_DT_PhaseOpenDate     DATETIME,
								F_DT_PhaseCloseDate    DATETIME,
								F_EventStatus       INT
							)

    INSERT INTO #table_Phase(F_DisciplineName, F_Gender, F_GenderCode, F_EventCode, F_EventName,F_PhaseName, 
    F_DisciplineID, F_DT_EventOpenDate, F_DT_EventCloseDate, F_DT_PhaseOpenDate, F_DT_PhaseCloseDate, F_EventStatus)
    SELECT UPPER(D.F_DisciplineLongName), UPPER(B.F_SexShortName), S.F_GenderCode, E.F_EventCode, 
    UPPER(ED.F_EventShortName), UPPER(PD.F_PhaseShortName), E.F_DisciplineID, E.F_OpenDate ,E.F_CloseDate,
    P.F_OpenDate ,P.F_CloseDate, E.F_EventStatusID
    FROM TS_Phase AS P
    LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode 
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode 
    LEFT JOIN TC_Sex_Des AS B ON E.F_SexCode = B.F_SexCode AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline_Des AS D ON E.F_DisciplineID = D.F_DisciplineID AND D.F_LanguageCode = @LanguageCode 
    LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode 
    WHERE P.F_PhaseID = @PhaseID

    UPDATE #table_Phase SET F_VenueName = UPPER(B.F_VenueShortName) 
    FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN #table_Phase AS C ON A.F_DisciplineID = C.F_DisciplineID

    UPDATE #table_Phase SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Phase
    AS A ON B.F_DisciplineID = A.F_DisciplineID

    UPDATE #table_Phase SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + '000'

    UPDATE #table_Phase SET F_Report_TitleDate = CONVERT (NVARCHAR(100),GETDATE(), 23)
    UPDATE #table_Phase SET F_Report_CreateDate = CONVERT (NVARCHAR(100),GETDATE(), 120)
    UPDATE #table_Phase SET F_Report_CreateDate_YYYYMMDDhhmm = [dbo].[Func_Report_BK_GetDateTime](GETDATE(), 9)
    
    UPDATE #table_Phase SET F_EventOpenDate = substring(CONVERT (NVARCHAR(100), F_DT_EventOpenDate, 20),1,16)
    UPDATE #table_Phase SET F_EventCloseDate = substring(CONVERT (NVARCHAR(100), F_DT_EventCloseDate, 20),1,16)
    UPDATE #table_Phase SET F_EventCloseDate_YYYYMMDD = [dbo].[Func_Report_BK_GetDateTime](F_DT_EventCloseDate, 10)
 
    UPDATE #table_Phase SET F_PhaseCloseDate = substring(CONVERT (NVARCHAR(100), F_DT_PhaseCloseDate, 20),1,16)
    UPDATE #table_Phase SET F_PhaseCloseDate_YYYYMMDD = [dbo].[Func_Report_BK_GetDateTime](F_DT_PhaseCloseDate, 10)
    UPDATE #table_Phase SET F_PhaseCloseDate_YYYYMMDDhhmm = [dbo].[Func_Report_BK_GetDateTime](F_DT_PhaseCloseDate, 9)
    
    SELECT * FROM #table_Phase

Set NOCOUNT OFF
End

GO



