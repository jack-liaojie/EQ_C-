IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetTeamMatchStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetTeamMatchStatus]
GO

/****** Object:  StoredProcedure [dbo].[Proc_JU_GetMatchType]    Script Date: 12/27/2010 18:30:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称: [[Proc_JU_GetTeamMatchStatus]]
--描    述: 柔道项目团体赛的状态.
--创 建 人: 宁顺泽
--日    期: 2010年12月26日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_JU_GetTeamMatchStatus]
	@MatchID						INT,
	@MatchStatusID					INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SELECT @MatchStatusID=F_MatchStatusID
	FROM TS_Match WHERE F_MatchID=@MatchID

SET NOCOUNT OFF
END

GO


