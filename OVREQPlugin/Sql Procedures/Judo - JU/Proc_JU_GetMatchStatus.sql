IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatchStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatchStatus]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_GetMatchStatus]
--描    述: 获取Match状态
--创 建 人: 宁顺泽
--日    期: 2011年7月11日 星期1
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatchStatus]
	@SessionNumber					INT,
	@CourtID						INT,
	@MatchNo						INT,
	@MatchSplitID					INT,
	@MatchStatus					INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	DECLARE @PlayerRegTypeID		INT
	declare @MatchID INT
	
	Declare @CourtCode				NVARCHAR(20)
	set @CourtCode=N'F25JU0'+CONVERT(NVARCHAR(10),@CourtID)
	
	DECLARE @RaceNum				NVARCHAR(10)
	if(@MatchNo>0 and @MatchNo<10)
	begin
		set @RaceNum=N'0'+CONVERT(NVARCHAR(5),@MatchNo)
	end
	else
	begin
		set @RaceNum=CONVERT(NVARCHAR(5),@MatchNo)
	end

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
	
	if @PlayerRegTypeID=1
		begin
			select @MatchStatus= ISNULL(F_MatchStatusID,0) from TS_Match where F_MatchID=@MatchID
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