IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchSplitPoints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchSplitPoints]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetMatchSplitPoints]
--描    述: 获取Match状态
--创 建 人: 宁顺泽
--日    期: 2011年7月11日 星期1
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchSplitPoints]
	@SessionNumber					INT,
	@CourtID						INT,
	@MatchNo						INT,
	@MatchSplitID					INT,
	@Compos							int,
	@MatchSplitPoints				INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	DECLARE @PlayerRegTypeID		INT
	declare @MatchID INT
	
	Declare @CourtCode				NVARCHAR(20)
	set @CourtCode=N'F26WR0'+CONVERT(NVARCHAR(10),@CourtID)
	
	DECLARE @RaceNum				NVARCHAR(10)
	set @RaceNum=CONVERT(NVARCHAR(5),@MatchNo)


	select @MatchID=M.F_MatchID from TS_Match AS M
	Left Join TS_Session AS S
		On M.F_SessionID=S.F_SessionID
	LEFt JOIN TC_Court AS C
		ON M.F_CourtID=c.F_CourtID
	where S.F_SessionNumber=@SessionNumber AND C.F_CourtCode= @CourtCode AND M.F_RaceNum=@RaceNum
			
	SELECT @PlayerRegTypeID = E.F_PlayerRegTypeID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE M.F_MatchID = @MatchID
	
	select @MatchSplitPoints=ISNULL(F_Points,0)+ISNULL(F_PointsNumDes3,0) from TS_Match_Split_Result where F_MatchID=@MatchID and F_MatchSplitID=@MatchSplitID and F_CompetitionPosition=@Compos
	

SET NOCOUNT OFF
END

/*

-- Just for test


*/