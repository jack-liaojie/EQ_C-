IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetMatchDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetMatchDays]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_SH_GetMatchDays]
--描    述: SCB 获取 MatchDay 参数列表.
--创 建 人: 穆学峰
--日    期: 2011-03-10
--修改记录：


CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetMatchDays]
	@DisciplineCode						CHAR(2)
AS
BEGIN
SET NOCOUNT ON

	SELECT dbo.Func_SCB_GetDateTime(DD.F_Date, 1, 'ENG') AS [Date_ENG]
		, dbo.Func_SCB_GetDateTime(DD.F_Date, 1, 'CHN') AS [Date_CHN]
		, DD.F_DisciplineDateID
		, VD1.F_VenueLongName
		, VD2.F_VenueLongName
	FROM TS_DisciplineDate AS DD
	INNER JOIN TS_Discipline AS D ON DD.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TD_Discipline_Venue AS DV ON D.F_DisciplineID = DV.F_DisciplineID
	LEFT JOIN TC_Venue_Des AS VD1 ON DV.F_VenueID = VD1.F_VenueID AND VD1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Venue_Des AS VD2 ON DV.F_VenueID = VD2.F_VenueID AND VD2.F_LanguageCode = 'CHN'
	WHERE D.F_DisciplineCode = @DisciplineCode
	ORDER BY DD.F_Date

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_SH_GetMatchDays] 'SH'

*/
