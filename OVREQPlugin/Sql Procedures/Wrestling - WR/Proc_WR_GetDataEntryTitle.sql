IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetDataEntryTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetDataEntryTitle]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetDataEntryTitle]
--描    述: 柔道项目 DataEntry 中获取标题名称.
--创 建 人: 邓年彩
--日    期: 2010年10月6日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetDataEntryTitle]
	@MatchID						INT,
	@Title							NVARCHAR(200) OUTPUT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	END
	
	SELECT @Title = ISNULL(ED.F_EventLongName + N' - ', N'')
		+ ISNULL(PD.F_PhaseLongName + N' - ', N'')
		+ ISNULL(MD.F_MatchLongName + N' - ', N'')
		+ ISNULL(CD.F_CourtShortName + N' - ', N'')
		+ ISNULL(N'Contest No.' + M.F_RaceNum, N'')
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Des AS MD
		ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event_Des AS ED
		ON P.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Court_Des AS CD
		ON M.F_CourtID = CD.F_CourtID AND CD.F_LanguageCode = @LanguageCode
	
	WHERE M.F_MatchID = @MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/