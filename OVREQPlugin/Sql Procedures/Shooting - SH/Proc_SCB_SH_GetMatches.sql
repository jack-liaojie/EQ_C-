IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetMatches]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_SH_GetMatches]
--描    述: SCB 获取比赛参数列表.
--创 建 人: 吴定昉
--日    期: 2011-02-24
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetMatches]
    @DayID					    INT,
	@PhaseID                    INT
AS
BEGIN
SET NOCOUNT ON
	
	SELECT case when MD.F_MatchLongName = '' then 'NULL' 
	            else ISNULL(MD.F_MatchLongName, N'NULL') end AS Match
	    , case when MDCHN.F_MatchLongName = '' then 'NULL' 
	           else ISNULL(MDCHN.F_MatchLongName, N'NULL') end AS Match_CHN
		, M.F_MatchID
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Des AS MD
		ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match_Des AS MDCHN
		ON M.F_MatchID = MDCHN.F_MatchID AND MDCHN.F_LanguageCode = 'CHN'
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_DisciplineDate AS D
	    ON M.F_MatchDate = D.F_Date
	WHERE M.F_PhaseID = @PhaseID
	AND D.F_DisciplineDateID = @DayID
	ORDER BY M.F_MatchNum

SET NOCOUNT OFF
END

GO

/*
EXEC [Proc_SCB_SH_GetMatches] 1,1
*/