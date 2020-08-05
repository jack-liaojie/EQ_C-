IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_TS_GetMatchDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_TS_GetMatchDays]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_BD_TS_GetMatchDays]
--描    述: 获取 MatchDay
--创 建 人: 王强
--日    期: 2011-6-28
--修改记录：
/*			
			日期					修改人		修改内容
			
*/



CREATE PROCEDURE [dbo].[Proc_BD_TS_GetMatchDays]
AS
BEGIN
SET NOCOUNT ON

	SELECT DD.F_DisciplineDateID AS DateID, dbo.Func_SCB_GetDateTime(DD.F_Date, 1, 'ENG') AS [DateName]--[Date_ENG]
		--, dbo.Func_SCB_GetDateTime(DD.F_Date, 1, 'CHN') AS [Date_CHN]
	FROM TS_DisciplineDate AS DD
	INNER JOIN TS_Discipline AS D
		ON DD.F_DisciplineID = D.F_DisciplineID
	WHERE D.F_DisciplineCode = 'BD'
	ORDER BY DD.F_Date

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_GetMatchDays] 'RO'

*/