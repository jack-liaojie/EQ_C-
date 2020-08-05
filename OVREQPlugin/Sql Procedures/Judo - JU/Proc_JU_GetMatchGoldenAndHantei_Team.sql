IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchGoldenAndHantei_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchGoldenAndHantei_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_GetMatchGoldenAndHantei_Team]
--描    述: 柔道项目团体赛的最终结果.
--创 建 人: 宁顺泽
--日    期: 2011年1月4日 星期二
--修改记录：
/*			
	日期					修改人		修改内容
*/


CREATE PROCEDURE [dbo].[Proc_JU_GetMatchGoldenAndHantei_Team]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	SELECT [GoldenScore]=CASE M.F_MatchComment3 WHEN N'1' THEN 1 ELSE 0 END,
		   [HanteiA] = CASE MRA.F_PointsCharDes1 WHEN N'1' THEN 1 ELSE 0 END,
		   [HanteiB] = CASE MRB.F_PointsCharDes1 WHEN N'1' THEN 1 ELSE 0 END		
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Result AS MRA
		ON M.F_MatchID=MRA.F_MatchID AND MRA.F_CompetitionPosition=1
	LEFT JOIN TS_Match_Result AS MRB
		ON M.F_MatchID=MRB.F_MatchID AND MRB.F_CompetitionPosition=2
	WHERE M.F_MatchID=@MatchID 


SET NOCOUNT OFF
END

GO