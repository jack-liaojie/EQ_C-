IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_UpdateTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_UpdateTeamResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_UpdateTeamResult]
--描    述: 柔道项目团体赛的最终结果.
--创 建 人: 宁顺泽
--日    期: 2010年12月29日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_UpdateTeamResult]
	@MatchID						INT,
	@CompPos						INT,
	@ResultID						INT,
	@RankID							INT
AS
BEGIN
SET NOCOUNT ON

	UPDATE TS_Match_Result SET F_ResultID=@ResultID,F_Rank=@RankID
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/