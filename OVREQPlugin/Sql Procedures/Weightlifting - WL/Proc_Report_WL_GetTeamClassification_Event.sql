IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTeamClassification_Event]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Event]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WL_GetTeamClassification_Event]
--描    述: 获取 C76 - Unofficial Team Classification 的项目信息, 分性别.
--创 建 人: 邓年彩
--日    期: 2011年3月26日 星期六
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Event]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
	END
	
	SELECT E.F_SexCode
		, E.F_EventID
		, REPLACE(REPLACE(ED.F_EventLongName, N'Women''s ', N''), N'Men''s ', N'') AS [Event]
		, COUNT(I.F_RegisterID) AS TotalParticipants
	FROM TS_Event AS E
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Inscription AS I
		ON E.F_EventID = I.F_EventID
	WHERE E.F_DisciplineID = @DisciplineID
	GROUP BY E.F_SexCode, E.F_EventID, E.F_EventCode, ED.F_EventLongName
	ORDER BY E.F_SexCode, E.F_EventCode

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetTeamClassification_Event] -1

*/