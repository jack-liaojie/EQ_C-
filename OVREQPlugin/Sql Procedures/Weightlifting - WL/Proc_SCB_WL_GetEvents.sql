IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetEvents]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_SCB_WL_GetEvents]
--描    述: SCB 获取 Event 参数列表.
--创 建 人: 邓年彩
--日    期: 2010年7月7日 星期三
--修改记录：
/*			
			日期					修改人		修改内容
			2010年7月8日 星期四		邓年彩		添加参数 SessionID, 用于选出一个 Session 中有比赛的 Session.
			2010年7月12日 星期一	邓年彩		当单项有对应的存储过程时, 调用单项的存储过程.
*/



CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetEvents]
	@DisciplineCode						CHAR(2),
	@SessionID							INT = -1
AS
BEGIN
SET NOCOUNT ON

	IF @SessionID = -1
	BEGIN
		SELECT ED1.F_EventShortName + N' (' + ED2.F_EventShortName+ N')' AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, E.F_EventID
			, ED1.F_EventShortName
		FROM TS_Event AS E
		LEFT JOIN TS_Event_Des AS ED1
			ON E.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2
			ON E.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		INNER JOIN TS_Discipline AS D
			ON E.F_DisciplineID = D.F_DisciplineID
		WHERE D.F_DisciplineCode = @DisciplineCode
		ORDER BY ED1.F_EventShortName
	END
	ELSE
	BEGIN
		SELECT distinct (ED1.F_EventShortName + N' (' + ED2.F_EventShortName+ N')')  AS [Event]
			, ED2.F_EventShortName AS [Event_CHN]
			, P.F_EventID
			, ED1.F_EventShortName
		FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Event_Des AS ED1
			ON P.F_EventID = ED1.F_EventID AND ED1.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Event_Des AS ED2
			ON P.F_EventID = ED2.F_EventID AND ED2.F_LanguageCode = 'CHN'
		WHERE M.F_SessionID = @SessionID
		ORDER BY ED1.F_EventShortName
	END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_GetEvents] 'WL', 1

*/
GO


