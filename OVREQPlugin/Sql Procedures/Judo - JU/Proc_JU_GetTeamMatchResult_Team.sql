IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetTeamMatchResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetTeamMatchResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_JU_GetTeamMatchResult_Team]
--描    述: 获取柔道团体赛TeamMatchResult
--创 建 人: 宁顺泽
--日    期: 2010年12月29号 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetTeamMatchResult_Team]
	@MatchID						INT,
	@CompPos						INT
AS
BEGIN
SET NOCOUNT ON
	CREATE TABLE #Table_Tmp
		(
			F_MatchID			INT,
			F_SplitScore1		INT,
			F_SplitScore2		INT,
			F_SplitScore3		INT,
			F_SplitScore4		INT,
			F_SplitScore5		INT,
			F_SplitScore6		INT,
			F_WinNum			INT,
			F_LosNum			INT,
			F_DrawNum			INT,
			F_TotalScore		INT
		)
		
	INSERT INTO #Table_Tmp(F_MatchID) VALUES(@MatchID)
	
	UPDATE #Table_Tmp SET F_SplitScore1=MSR.F_Points 
	FROM TS_Match_Split_Result AS MSR 
	WHERE MSR.F_MatchID=@MatchID AND MSR.F_CompetitionPosition=@CompPos AND MSR.F_MatchSplitID=1
	
	UPDATE #Table_Tmp SET F_SplitScore2=MSR.F_Points 
	FROM TS_Match_Split_Result AS MSR 
	WHERE MSR.F_MatchID=@MatchID AND MSR.F_CompetitionPosition=@CompPos AND MSR.F_MatchSplitID=2
	
	UPDATE #Table_Tmp SET F_SplitScore3=MSR.F_Points 
	FROM TS_Match_Split_Result AS MSR 
	WHERE MSR.F_MatchID=@MatchID AND MSR.F_CompetitionPosition=@CompPos AND MSR.F_MatchSplitID=3
	
	UPDATE #Table_Tmp SET F_SplitScore4=MSR.F_Points 
	FROM TS_Match_Split_Result AS MSR 
	WHERE MSR.F_MatchID=@MatchID AND MSR.F_CompetitionPosition=@CompPos AND MSR.F_MatchSplitID=4
	
	UPDATE #Table_Tmp SET F_SplitScore5=MSR.F_Points 
	FROM TS_Match_Split_Result AS MSR 
	WHERE MSR.F_MatchID=@MatchID AND MSR.F_CompetitionPosition=@CompPos AND MSR.F_MatchSplitID=5
	
	UPDATE #Table_Tmp SET F_SplitScore6=MSR.F_Points 
	FROM TS_Match_Split_Result AS MSR 
	WHERE MSR.F_MatchID=@MatchID AND MSR.F_CompetitionPosition=@CompPos AND MSR.F_MatchSplitID=6
	
	UPDATE #Table_Tmp SET F_WinNum=MR.F_WinSets,F_LosNum=MR.F_LoseSets,F_DrawNum=MR.F_DrawSets,F_TotalScore=MR.F_Points 
	FROM TS_Match_Result AS MR WHERE MR.F_MatchID=@MatchID AND MR.F_CompetitionPosition=@CompPos
	
	select F_SplitScore1 AS [SplitScore1],F_SplitScore2 AS [SplitScore2],F_SplitScore3 AS [SplitScore3],F_SplitScore4 AS [SplitScore4],F_SplitScore5 AS [SplitScore5],F_SplitScore6 AS [SplitScore6], F_WinNum AS [WinNum],F_LosNum AS [LoseNum],F_DrawNum AS [DrawNum],F_TotalScore AS [TotalScore] 
	FROM #Table_Tmp WHERE F_MatchID=@MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/

GO


