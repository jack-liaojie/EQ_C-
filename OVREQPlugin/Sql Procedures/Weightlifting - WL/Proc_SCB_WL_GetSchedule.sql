IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_SCB_WL_GetSchedule]
--描    述：得到Schedule列表
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年02月28日


CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetSchedule](
												
			@SessionID		    INT
                                                
)
As
BEGIN
SET NOCOUNT ON

	SELECT dbo.[Func_SCB_GetDateTime](S.F_SessionDate, 1, 'ENG') AS [Date_ENG]
		, dbo.[Func_SCB_GetDateTime](T1.[Time], 4, 'ENG') AS [Time]
		, ED1.F_EventShortName AS [Event_ENG]
		, ED2.F_EventShortName AS [Event_CHN]
		, PD1.F_PhaseLongName AS [Phase_ENG]
		, PD2.F_PhaseLongName AS [Phase_CHN]
		, V1.F_VenueLongName AS [Venue_ENG]
		, V2.F_VenueLongName AS [Venue_CHN]
	FROM 
	(
		SELECT P.F_EventID, M.F_PhaseID, M.F_VenueID, M.F_StartTime AS [Time]
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E
			ON P.F_EventID = E.F_EventID
		WHERE M.F_SessionID = @SessionID AND M.F_MatchCode='01'
		GROUP BY P.F_EventID, M.F_PhaseID, M.F_VenueID,M.F_StartTime
	) AS T1
	LEFT JOIN TS_Session AS S
		ON S.F_SessionID = @SessionID
	LEFT JOIN TS_Event_Des AS ED1
		ON T1.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS ED2
		ON T1.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Phase_Des AS PD1
		ON T1.F_PhaseID = PD1.F_PhaseID AND PD1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS PD2
		ON T1.F_PhaseID = PD2.F_PhaseID AND PD2.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Venue_Des AS V1
		ON T1.F_VenueID = V1.F_VenueID AND V1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Venue_Des AS V2
		ON T1.F_VenueID = V2.F_VenueID AND V2.F_LanguageCode = 'CHN'
	ORDER BY LEFT(CONVERT(NVARCHAR(100), T1.[Time], 114), 5)

SET NOCOUNT OFF
END
/*
exec Proc_SCB_WL_GetSchedule 5
*/
GO


