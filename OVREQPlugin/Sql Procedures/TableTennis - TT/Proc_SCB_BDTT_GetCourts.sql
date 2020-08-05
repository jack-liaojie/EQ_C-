IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetCourts]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_BDTT_GetCourts]
--描    述: SCB 获取场地参数列表.
--创 建 人: 王强
--日    期: 2011年2月16日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetCourts]
	@SessionID							INT
AS
BEGIN
SET NOCOUNT ON

	SELECT DISTINCT CD.F_CourtShortName AS [Court]
			, M.F_CourtID, CD2.F_CourtShortName,
			(		SELECT B1.F_VenueLongName FROM TD_Discipline_Venue AS A
					LEFT JOIN TC_Venue_Des AS B1 ON B1.F_VenueID = A.F_VenueID AND B1.F_LanguageCode = 'ENG'),
			(		SELECT B2.F_VenueLongName FROM TD_Discipline_Venue AS A
					LEFT JOIN TC_Venue_Des AS B2 ON B2.F_VenueID = A.F_VenueID AND B2.F_LanguageCode = 'CHN')
		FROM TS_Match AS M
		LEFT JOIN TC_Court_Des AS CD
			ON M.F_CourtID = CD.F_CourtID AND CD.F_LanguageCode = 'ENG'
		LEFT JOIN TC_Court_Des AS CD2
			ON M.F_CourtID = CD2.F_CourtID AND CD2.F_LanguageCode = 'CHN'
		WHERE M.F_SessionID = @SessionID
		ORDER BY CD.F_CourtShortName
		

		


SET NOCOUNT OFF
END