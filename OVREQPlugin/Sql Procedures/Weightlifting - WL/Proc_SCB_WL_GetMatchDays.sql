IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetMatchDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetMatchDays]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_WL_GetMatchDays]
--描    述: SCB 获取单项信息.
--创 建 人: 崔凯
--日    期: 2011-03-4
--修改记录：


CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetMatchDays]
	@DisciplineCode						CHAR(2)
AS
BEGIN
SET NOCOUNT ON

	SELECT D.F_DisciplineCode
		, DDE.F_DisciplineLongName AS ENG_Sport
		, DDC.F_DisciplineLongName AS CHN_Sport
		, VD1.F_VenueLongName AS ENG_Venue
		, VD2.F_VenueLongName AS CHN_Venue
		, CONVERT(VARCHAR(100),GETDATE(),23) AS ENG_Date
	FROM TS_Discipline AS D 
	LEFT JOIN TS_Discipline_Des AS DDE ON DDE.F_DisciplineID= D.F_DisciplineID AND DDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Discipline_Des AS DDC ON DDC.F_DisciplineID= D.F_DisciplineID AND DDC.F_LanguageCode='CHN'
	LEFT JOIN TD_Discipline_Venue AS DV ON D.F_DisciplineID = DV.F_DisciplineID
	LEFT JOIN TC_Venue_Des AS VD1 ON DV.F_VenueID = VD1.F_VenueID AND VD1.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Venue_Des AS VD2 ON DV.F_VenueID = VD2.F_VenueID AND VD2.F_LanguageCode = 'CHN'
	WHERE D.F_DisciplineCode = @DisciplineCode


SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_WL_GetMatchDays] 'WL'
EXEC Proc_SCB_GetSessions 1
*/
