IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WL_GetPhases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WL_GetPhases]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_TVG_WL_GetPhases]
--描    述: SCB 获取比赛参数列表.
--创 建 人: 崔凯
--日    期: 2011年4月20日 星期三
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WL_GetPhases]
	@SessionID					INT,
	@EventID					INT
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ProcName			NVARCHAR(100)
	DECLARE @DisciplineCode		CHAR(2)
	
	SELECT @DisciplineCode = D.F_DisciplineCode
	FROM TS_Event AS E
	LEFT JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventID = @EventID
	
	SELECT PDE.F_PhaseLongName + N' ' + 
		   CASE WHEN MDE.F_MatchLongName = 'CleanJerk' THEN 'Clean&Jerk' ELSE MDE.F_MatchLongName END  AS Phase_ENG
		, PDE.F_PhaseLongName + N' ' + MDC.F_MatchLongName AS Phase_CHN
		, EE.F_EventLongName + N' ' + PDE.F_PhaseLongName AS EventName_ENG
		, EC.F_EventLongName + N' ' + PDC.F_PhaseLongName AS EventName_ENG
		, P.F_PhaseID 
		, M.F_MatchID
		, PDE.F_PhaseLongName AS [Group]
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Des AS MDE
		ON M.F_MatchID = MDE.F_MatchID AND MDE.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Des AS MDC
		ON M.F_MatchID = MDC.F_MatchID AND MDC.F_LanguageCode = 'CHN'
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PDE
		ON P.F_PhaseID = PDE.F_PhaseID AND PDE.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS PDC
		ON P.F_PhaseID = PDC.F_PhaseID AND PDC.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Event_Des AS EE 
		ON EE.F_EventID = P.F_EventID AND EE.F_LanguageCode='ENG'
	LEFT JOIN TS_Event_Des AS EC 
		ON EC.F_EventID = P.F_EventID AND EC.F_LanguageCode='CHN'
	WHERE (P.F_EventID = @EventID OR @EventID = -1) --AND M.F_MatchCode ='01'
		AND (M.F_SessionID = @SessionID OR @SessionID = -1)
	ORDER BY M.F_MatchNum 

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_TVG_WL_GetPhases] -1, 2

*/
GO


