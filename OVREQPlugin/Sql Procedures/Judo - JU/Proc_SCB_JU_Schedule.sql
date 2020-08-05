IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_Schedule]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_Schedule]
--描    述: 获取 Medallists 屏幕数据集 
--创 建 人: 宁顺泽
--日    期: 2011年2月25日 星期5
--修改记录：
/*			
	
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_Schedule]
	@SessionID							INT
AS
BEGIN
SET NOCOUNT ON

	SELECT
		N'Today '+ISNULL(STD.F_SessionTypeLongName,N'')+N'''s Schedule' AS [Title] 
		,dbo.[Func_SCB_GetDateTime](S.F_SessionDate, 1, 'ENG') AS [Date_ENG]
		, dbo.[Func_SCB_GetDateTime](S.F_SessionDate, 1, 'CHN') AS [Date_CHN]
		, dbo.[Func_SCB_GetDateTime](T1.[Time], 4, 'ENG') AS [Time]
		, ED1.F_EventShortName AS [Event_ENG]
		, ED2.F_EventShortName AS [Event_CHN]
		, PD1.F_PhaseLongName AS [Phase_ENG]
		, PD2.F_PhaseLongName AS [Phase_CHN]
		, CD1.F_CourtShortName AS [Court_ENG]
		, CD2.F_CourtShortName AS [Court_CHN]
		,ISNULL(STD_CHN.F_SessionTypeLongName,N'')+N'竞赛日程' AS Title_CHN
	FROM 
	(
		SELECT P.F_EventID, M.F_PhaseID, M.F_CourtID, M.F_StartTime AS [Time]
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E
			ON P.F_EventID = E.F_EventID
		WHERE M.F_SessionID = @SessionID
		GROUP BY P.F_EventID, M.F_PhaseID, M.F_CourtID,M.F_StartTime
	) AS T1
	LEFT JOIN TS_Session AS S
		ON S.F_SessionID = @SessionID
	LEFT JOIN TC_SessionType_Des AS STD
		ON S.F_SessionTypeID=STD.F_SessionTypeID AND STD.F_LanguageCode=N'ENG'
	LEFT JOIN TC_SessionType_Des AS STD_CHN
		ON S.F_SessionTypeID=STD_CHN.F_SessionTypeID AND STD_CHN.F_LanguageCode=N'CHN'
	LEFT JOIN TS_Event_Des AS ED1
		ON T1.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED2
		ON T1.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Phase_Des AS PD1
		ON T1.F_PhaseID = PD1.F_PhaseID AND PD1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS PD2
		ON T1.F_PhaseID = PD2.F_PhaseID AND PD2.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=T1.F_CourtID
	LEFT JOIN TC_Court_Des AS CD1
		ON T1.F_CourtID = CD1.F_CourtID AND CD1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Court_Des AS CD2
		ON T1.F_CourtID = CD2.F_CourtID AND CD2.F_LanguageCode = 'CHN'
	ORDER BY DATEPART(HH, T1.[Time]), DATEPART(MI, T1.[Time]), C.F_CourtCode

SET NOCOUNT OFF
END

/*

exec [Proc_SCB_JU_Schedule] 940
*/