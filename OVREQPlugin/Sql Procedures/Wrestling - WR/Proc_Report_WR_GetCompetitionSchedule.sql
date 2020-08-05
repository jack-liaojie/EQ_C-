IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetCompetitionSchedule]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetCompetitionSchedule]
--描    述: 报表 C08 - CompetitionScheduel 获取主要信息.
--创 建 人: 邓年彩
--日    期: 
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetCompetitionSchedule]
	@DisciplineID						INT,
	@LanguageCode						CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
	END
	
	CREATE TABLE #tmpTable
	(
		EventID				INT,
		IsFinal				INT,
		MatchDate			DATETIME,
		StartTime			DATETIME
	)

	INSERT INTO #tmpTable
	(EventID, IsFinal, MatchDate, StartTime)
	SELECT E.F_EventID
		, IsFinal = CASE WHEN P.F_PhaseCode = N'1' THEN 1 ELSE 0 END
		, CONVERT(DATETIME, CONVERT(NVARCHAR(20), M.F_MatchDate, 101), 101)
		,  CONVERT(DATETIME, CONVERT(NVARCHAR(20), M.F_StartTime, 114), 114) 
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE E.F_DisciplineID = @DisciplineID
	
	SELECT dbo.[Func_Report_JU_GetDateTime](Y.MatchDate, 6, @LanguageCode) AS [Date]
		, dbo.[Func_Report_JU_GetDateTime](Y.StartTime, 4, @LanguageCode) AS [StartTime]
		, [WeightCategory_Rounds] = ED.F_EventLongName + CASE Y.IsFinal 
			WHEN 1 THEN N' Finals' 
			ELSE N' Preliminary and Repechage'
		END
	FROM
	(
		SELECT DISTINCT TB1.EventID, TB1.IsFinal, TB1.MatchDate, X.StartTime
		FROM #tmpTable AS TB1
		CROSS APPLY
		(
			SELECT TOP 1 TB2.StartTime
			FROM #tmpTable AS TB2
			WHERE TB1.EventID = TB2.EventID AND TB1.IsFinal = TB2.IsFinal AND TB1.MatchDate = TB2.MatchDate
			ORDER BY TB2.StartTime
		) AS X
	) AS Y
	LEFT JOIN TS_Event_Des AS ED
		ON Y.EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	ORDER BY Y.MatchDate, Y.StartTime

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetCompetitionSchedule] -1, 'ENG'

*/