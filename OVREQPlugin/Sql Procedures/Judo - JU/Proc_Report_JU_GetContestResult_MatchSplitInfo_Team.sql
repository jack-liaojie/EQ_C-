IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetContestResult_MatchSplitInfo_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetContestResult_MatchSplitInfo_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetContestResult_MatchSplitInfo_Team]
--描    述: 报表团体赛结果
--创 建 人: 宁顺泽
--日    期: 2011年1月7日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_Report_JU_GetContestResult_MatchSplitInfo_Team]
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
	SELECT M.F_MatchComment3 AS [GoldenScore] 
		,CASE 
			WHEN M1.F_ResultID=1 THEN M1.F_PrintLongName+N' /W'
			ELSE M1.F_PrintLongName
		END AS [NameA]
		,CASE
			WHEN M2.F_ResultID=1 THEN M2.F_PrintLongName+N' /W'
			ELSE M2.F_PrintLongName
		END AS [NameB]
		,M1.F_DelegationCode AS [CCodeA]
		,M2.F_DelegationCode AS [CCodeB]	
		,M1.F_Points AS [PointsA]
		,M2.F_Points AS [PointsB]
		,M1.WinSets AS [WinSetsA]
		,M2.WinSets AS [WinSetsB]
	FROM TS_Match AS M
	LEFT JOIN 
	(
		SELECT 
			MRA.F_MatchID,
			MRA.F_Points,
			ISNULL(MRA.F_WinSets,0) AS WinSets,
			MRA.F_ResultID,
			RD.F_PrintLongName,
			D.F_DelegationCode
		FROM TS_Match_Result AS MRA
		LEFT JOIN TR_Register AS R
			ON MRA.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE F_MatchID=@MatchID AND F_CompetitionPositionDes1=1
	) AS M1
		ON M.F_MatchID=M1.F_MatchID
	LEFT JOIN 
	(
		SELECT 
			MRB.F_MatchID,
			MRB.F_Points,
			ISNULL(MRB.F_WinSets,0) AS WinSets,
			MRB.F_ResultID,
			RD.F_PrintLongName,
			D.F_DelegationCode
		FROM TS_Match_Result AS MRB
		LEFT JOIN TR_Register AS R
			ON MRB.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE F_MatchID=@MatchID AND F_CompetitionPositionDes1=2
	) AS M2
		ON M.F_MatchID=M2.F_MatchID
	WHERE M.F_MatchID=@MatchID
	
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetContestResult_MatchSplitInfo_Team] 45,'ENG'

*/
GO