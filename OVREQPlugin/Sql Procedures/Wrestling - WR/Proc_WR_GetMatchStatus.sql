IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchStatus]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetMatchStatus]
--描    述: 获取Match状态
--创 建 人: 宁顺泽
--日    期: 2011年11月13日 星期4
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchStatus]
	@MatchID						INT,
	@MatchSplitID					INT,
	@MatchStatus					INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	if @MatchSplitID=0
	begin	
	select @MatchStatus=F_MatchStatusID from TS_Match where F_MatchID=@MatchID
	end
	else 
	begin
	select @MatchStatus=ISNULL(F_MatchSplitStatusID,0) from TS_Match_Split_Info where F_MatchID=@MatchID and F_MatchSplitID=@MatchSplitID
	end

SET NOCOUNT OFF
END

/*

-- Just for test


*/