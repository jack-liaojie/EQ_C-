IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetEvents]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetEvents]
	@SessionID							INT
AS
BEGIN
SET NOCOUNT ON

		SELECT DISTINCT ED1.F_EventShortName AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, P.F_EventID
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event AS E			ON E.F_EventID = P.F_EventID
		LEFT JOIN TS_Event_Des AS ED1 	ON P.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2	ON P.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		WHERE M.F_SessionID = @SessionID
			--AND E.F_EventCode NOT IN ('002', '004', '006', '008', '010', '012', '014', '102', '104', '106', '108', '110')
		ORDER BY ED1.F_EventShortName

SET NOCOUNT OFF
END
/*
EXEC [Proc_SCB_SH_GetEvents] 941
*/