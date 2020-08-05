IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WR_GetMatchs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WR_GetMatchs]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_TVG_WR_GetMatchs]
--��    ��: TVG ��ȡ���������б�.
--�� �� ��: ��˳��
--��    ��: 2011��5��20�� ����5
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����

*/



CREATE PROCEDURE [dbo].[Proc_TVG_WR_GetMatchs]
	@SessionID					INT,
	@EventID					INT,
	@CourtCode					NVARCHAR(10),
	@LanguageCode				CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

	
	SELECT ISNULL(PD.F_PhaseLongName, N'') + N' ' + ISNULL(MD.F_MatchLongName, N'')+N' Num:'+ISNULL(M.F_RaceNum,N'') AS Match
		, M.F_MatchID
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Des AS MD
		ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Court AS C
		ON C.F_CourtID=M.F_CourtID
	WHERE (P.F_EventID = @EventID OR @EventID = -1)
		AND (M.F_SessionID = @SessionID OR @SessionID = -1)
		AND C.F_CourtCode=@CourtCode
	ORDER BY convert(decimal,isnull(M.F_RaceNum,N'0'))

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_TVG_JU_GetMatchs] 944,17,N'F25TK04'

*/