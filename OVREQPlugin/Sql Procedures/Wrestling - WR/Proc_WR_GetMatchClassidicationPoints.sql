IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchClassidicationPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchClassidicationPoints]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetMatchClassidicationPoints]
--描    述: 摔跤项目单人项目设定一场比赛的信息.
--创 建 人: 宁顺泽
--日    期: 2011年10月15日 星期6
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchClassidicationPoints]
	@MatchID						INT,
	@Compos							INT
AS
BEGIN
SET NOCOUNT ON

	select F_PointsNumDes2 as [ClassidicationPoints] from TS_Match_Result where F_MatchID=@MatchID and F_CompetitionPosition=@Compos

	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/