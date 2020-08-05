IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_UpdateTeamRate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_UpdateTeamRate]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_UpdateTeamRate]
--描    述: StartList修改柔道项目团体赛的最终结果.
--创 建 人: 宁顺泽
--日    期: 2011年6月2日 星期4
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_UpdateTeamRate]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	update TS_Match_Result set F_Rank=NULL,F_ResultID=NULL WHere F_MatchID=@MatchID

SET NOCOUNT OFF
END

/*

-- Just for test

*/





