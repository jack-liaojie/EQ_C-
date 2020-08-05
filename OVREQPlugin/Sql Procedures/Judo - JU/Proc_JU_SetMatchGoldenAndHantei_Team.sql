IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_SetMatchGoldenAndHantei_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_SetMatchGoldenAndHantei_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_SetMatchGoldenAndHantei_Team]
--描    述: 柔道项目团体赛的最终结果.
--创 建 人: 宁顺泽
--日    期: 2011年1月4日 星期二
--修改记录：
/*			
	日期					修改人		修改内容
*/


CREATE PROCEDURE [dbo].[Proc_JU_SetMatchGoldenAndHantei_Team]
	@MatchID						INT,
	@GoldenScore					INT,
	@HanteiA						INT,
	@HanteiB						INT,							
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0
	
	UPDATE TS_Match
	SET F_MatchComment3 = CONVERT(NVARCHAR(100), @GoldenScore)
	WHERE F_MatchID=@MatchID
		
	UPDATE TS_Match_Result
	SET F_PointsCharDes1 = CONVERT(NVARCHAR(100), @HanteiA)
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=1
	
	UPDATE TS_Match_Result
	SET F_PointsCharDes1 = CONVERT(NVARCHAR(100), @HanteiB)
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=2
	
	SET @Result = 1

SET NOCOUNT OFF
END

GO