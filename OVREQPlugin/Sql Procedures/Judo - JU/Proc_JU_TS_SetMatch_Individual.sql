IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_TS_SetMatch_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_TS_SetMatch_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_TS_SetMatch_Individual]
--描    述: 柔道计时计分接口项目单人项目设定一场比赛的信息.
--创 建 人: 宁顺泽
--日    期: 2011年6月18日 星期6
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_TS_SetMatch_Individual]
	@SessionNumber					INT,
	@CourtID						INT,
	@MatchNo						INT,
	@SplitID						INT,
	@GoldenScore					INT,
	@ContestTime					NVARCHAR(100),
	@Technique						NVARCHAR(100),
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0
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
	
	DECLARE @MatchID				INT
	select @MatchID=M.F_MatchID from TS_Match AS M
	Left Join TS_Session AS S
		On M.F_SessionID=S.F_SessionID
	LEFt JOIN TC_Court AS C
		ON M.F_CourtID=c.F_CourtID
	where S.F_SessionNumber=@SessionNumber AND C.F_CourtCode= @CourtCode AND M.F_RaceNum=@RaceNum

	if(@SplitID=0)
	begin
	UPDATE TS_Match
	SET F_MatchComment3 = CONVERT(NVARCHAR(100), @GoldenScore)
		, F_MatchComment4 = @ContestTime
		, F_MatchComment5 = @Technique
	WHERE F_MatchID = @MatchID
	end
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test


*/