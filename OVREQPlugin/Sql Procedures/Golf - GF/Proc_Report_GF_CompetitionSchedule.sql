IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_CompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----名    称：[Proc_Report_GF_CompetitionSchedule]
----功	  能：得到该项目下的全部竞赛日程
----作	  者：张翠霞
----日	  期: 2010-09-15
----修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月13日      吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/



CREATE PROCEDURE [dbo].[Proc_Report_GF_CompetitionSchedule] 
                   (	
					@DisciplineID			INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

   SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_Date          NVARCHAR(11),
                                   F_DateEx        NVARCHAR(11),
                                   F_EventName     NVARCHAR(100),
                                   F_RoundName     NVARCHAR(100),
                                   F_StartTime     NVARCHAR(5),
                                   F_FinishTime    NVARCHAR(5),
                                   
                                )

        INSERT INTO #Temp_Table(F_Date, F_DateEx, F_StartTime, F_FinishTime, F_EventName, F_RoundName)
        SELECT UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)) + ' ' + [dbo].[Func_Report_GF_GetDateTime](A.F_MatchDate, 7)
        ,CONVERT(VARCHAR,F_MatchDate,111)
        ,[dbo].[Func_Report_GF_GetDateTime](A.F_StartTime, 3), [dbo].[Func_Report_GF_GetDateTime](A.F_EndTime, 3)
        , H.F_EventLongName, F.F_PhaseLongName
        FROM TS_Match AS A
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS F ON B.F_PhaseID = F.F_PhaseID AND F.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS H ON C.F_EventID= H.F_EventID AND H.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_DisciplineDate AS G ON A.F_MatchDate = G.F_Date
        WHERE G.F_DisciplineID = @DisciplineID AND C.F_DisciplineID = @DisciplineID ORDER BY A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), C.F_Order

        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END

GO


