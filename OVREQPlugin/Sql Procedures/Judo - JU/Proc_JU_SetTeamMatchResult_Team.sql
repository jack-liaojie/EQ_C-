IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_SetTeamMatchResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_SetTeamMatchResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [[[Proc_JU_SetTeamMatchResult_Team]]]
--描    述: 柔道团体赛TeamMatchResult.其中TS_Match_Split_Result的F_Points字段保存小局得分
--TS_Match_Result的F_WinSets字段保存本局胜的场数,F_Points字段保存负的场数,
--F_DrawSets平局场数,F_PointsNumDes4保存各局的总得分
--创 建 人: 宁顺泽
--日    期: 2010年12月29号 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_SetTeamMatchResult_Team]
	@MatchID						INT,
	@MatchSplitID					INT,
	@CompPos						INT,
	@Score							INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0
	
	UPDATE TS_Match_Split_Result
	SET F_Points=@Score
	WHERE F_MatchID=@MatchID AND F_MatchSplitID=@MatchSplitID AND F_CompetitionPosition=@CompPos
	
	DECLARE @WinNum INT
	SELECT @WinNum=COUNT(F_ResultID) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos AND F_ResultID=1
	
	DECLARE @LosNum INT
	SELECT @LosNum=COUNT(F_ResultID) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos AND F_ResultID=2
	
	DECLARE @DrawNum INT
	SELECT @DrawNum=COUNT(F_ResultID) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos AND F_ResultID=3
	
	DECLARE @ScoreTotal INT
	SELECT @ScoreTotal=SUM(F_Points) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos
	
	UPDATE TS_Match_Result
	SET F_WinSets=@WinNum,F_LoseSets=@LosNum,F_DrawSets=@DrawNum,F_Points=@ScoreTotal
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/

GO


