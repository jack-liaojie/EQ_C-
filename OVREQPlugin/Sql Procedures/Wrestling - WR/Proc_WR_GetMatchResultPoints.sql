IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchResultPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchResultPoints]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetMatchResultPoints]
--描    述: 获取Weight数据集 
--创 建 人: 宁顺泽
--日    期: 2011年10月13日 星期
--修改记录：
/*			
	
*/

CREATE PROCEDURE [dbo].[Proc_WR_GetMatchResultPoints]
	@MatchID							INT,
	@Compos								INT
AS
BEGIN
SET NOCOUNT ON

	select 
		MR.F_Points AS PointsTotal
		,MRA.F_Points as PointsSplit1st
		,MRB.F_Points aS PointsSplit2nd
		,MRC.F_Points aS PointsSplit3rd
		,MR.F_WinSets AS WinSets
		,MRA.F_PointsNumDes3 AS PointsSplit1stAddTime
		,MRB.F_PointsNumDes3 AS PointsSplit2ndAddTime
		,MRC.F_PointsNumDes3 aS PointsSplit3rdAddTime
	from TS_Match_Result AS MR 
	LEFT JOIN TS_Match_Split_Result AS MRA
		ON MR.F_MatchID=MRA.F_MatchID and MR.F_CompetitionPosition=MRA.F_CompetitionPosition and MRA.F_MatchSplitID=1
	LEFT JOIN TS_Match_Split_Result AS MRB
		ON MR.F_MatchID=MRB.F_MatchID and MR.F_CompetitionPosition=MRB.F_CompetitionPosition and MRB.F_MatchSplitID=2
	LEFT JOIN TS_Match_Split_Result AS MRC
		ON MR.F_MatchID=MRC.F_MatchID and MR.F_CompetitionPosition=MRC.F_CompetitionPosition and MRC.F_MatchSplitID=3
	where MR.F_MatchID=@MatchID and MR.F_CompetitionPosition=@Compos
		
SET NOCOUNT OFF
END

------------------
--exec [Proc_JU_UpdatetWeight] 14,N'AFG',N'BAYAT Marzia',N'45',N''
------------------------