IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetCompetitionSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_AR_GetCompetitionSchedule]
--描    述: 射箭项目报表获取 C08 - Competition Schedule 的详细内容.
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月12日




CREATE PROCEDURE [dbo].[Proc_Report_AR_GetCompetitionSchedule]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID
		FROM TS_Discipline AS D
		WHERE D.F_Active = 1
	END

	CREATE TABLE #Temp_Schedules(F_MatchDate				DATETIME,
								 F_EventID					INT,
								 F_PhaseID					INT,
								 F_SessionStartTime			DATETIME,
								 F_SessionID		        INT,
								 F_SessionNumber	        INT,
								 F_StartTime		        DATETIME,
								 F_PhaseCode				NVARCHAR(10)
								 )
	INSERT INTO #Temp_Schedules (F_MatchDate, F_EventID, F_PhaseID,F_SessionID,F_StartTime,F_PhaseCode)
	SELECT DISTINCT A.F_MatchDate, C.F_EventID, B.F_PhaseID, A.F_SessionID, A.F_StartTime,B.F_PhaseCode
	    FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID 
		WHERE C.F_DisciplineID = @DisciplineID AND A.F_MatchDate IS NOT NULL

	UPDATE A SET  A.F_SessionStartTime = B.F_SessionTime FROM #Temp_Schedules AS A 
		LEFT JOIN TS_Session AS B ON A.F_MatchDate =B.F_SessionDate WHERE B.F_DisciplineID = @DisciplineID 
	UPDATE A SET A.F_SessionNumber = B.F_SessionNumber
		FROM #Temp_Schedules AS A 
		LEFT JOIN TS_Session AS B ON A.F_MatchDate =B.F_SessionDate AND A.F_SessionID = B.F_SessionID WHERE B.F_DisciplineID = @DisciplineID

	SELECT A.*
			, dbo.FUN_AR_GetDatetime(A.F_MatchDate, 1, @LanguageCode) AS [Date_Show] 
			, B.F_EventLongName
			, C.F_PhaseLongName
			, LEFT(CAST(CAST(A.F_SessionStartTime AS TIME(0)) AS NVARCHAR(10)), 5) AS DaySessionStartTime
			, dbo.FUN_AR_GetDatetime(A.F_StartTime, 4, @LanguageCode) AS StartTime
			,dbo.Fun_AR_GetMatchNumbersString(A.F_EventID,A.F_PhaseID,A.F_SessionID,A.F_StartTime) AS MatchNumbers
			, ROW_NUMBER() over(order by RIGHT('000000' + dbo.FUN_AR_GetDatetime(A.F_StartTime, 4, @LanguageCode),6),A.F_EventID) AS StartTimeOrder
		FROM #Temp_Schedules AS A 
			LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
			ORDER BY A.F_MatchDate,A.F_SessionID,StartTimeOrder,F_EventID,F_PhaseCode desc
SET NOCOUNT OFF
END



GO

/*
exec Proc_Report_AR_GetCompetitionSchedule 1,'eng'
*/
