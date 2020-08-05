IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdatetMatchResultPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdatetMatchResultPoints]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [[Proc_WR_UpdatetMatchResultPoints]
--描    述: 获取Weight数据集 
--创 建 人: 宁顺泽
--日    期: 2011年10月13日 星期
--修改记录：
/*			
	
*/

CREATE PROCEDURE [dbo].[Proc_WR_UpdatetMatchResultPoints]
	@MatchID							INT,
	@Compos								INT,
	@PointsTotal						INT,
	@PointsSplit1st						INT,
	@PointsSplit2nd						INT,
	@PointsSplit3rd						INT,
	@PointsSplit1st_AddTime				int,
	@PointsSplit2nd_AddTime				int,
	@PointsSplit3rd_AddTime				int
AS
BEGIN
SET NOCOUNT ON

		Update TS_Match_Result set F_Points=@PointsTotal where F_MatchID=@MatchID and F_CompetitionPosition=@Compos
		Update TS_Match_Split_Result set F_Points=@PointsSplit1st,F_PointsNumDes3=@PointsSplit1st_AddTime where F_MatchID=@MatchID and F_CompetitionPosition=@Compos and F_MatchSplitID=1
		Update TS_Match_Split_Result set F_Points=@PointsSplit2nd,F_PointsNumDes3=@PointsSplit2nd_AddTime where F_MatchID=@MatchID and F_CompetitionPosition=@Compos and F_MatchSplitID=2
		Update TS_Match_Split_Result set F_Points=@PointsSplit3rd,F_PointsNumDes3=@PointsSplit3rd_AddTime where F_MatchID=@MatchID and F_CompetitionPosition=@Compos and F_MatchSplitID=3
		
SET NOCOUNT OFF
END

------------------
--exec [Proc_JU_UpdatetWeight] 14,N'AFG',N'BAYAT Marzia',N'45',N''
------------------------