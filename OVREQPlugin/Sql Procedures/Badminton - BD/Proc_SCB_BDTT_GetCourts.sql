IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetCourts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetCourts]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_SCB_BDTT_GetCourts]
--��    ��: SCB ��ȡ���ز����б�.
--�� �� ��: ��ǿ
--��    ��: 2011��2��16��
--�޸ļ�¼��



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