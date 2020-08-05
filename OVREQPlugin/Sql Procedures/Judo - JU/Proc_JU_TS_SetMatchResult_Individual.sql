IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_TS_SetMatchResult_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_TS_SetMatchResult_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_JU_TS_SetMatchResult_Individual]
--描    述: 柔道计时计分单人项目设定一场比赛一个参赛者的比赛成绩.
--创 建 人: 宁顺泽
--日    期: 2011年6月18日 星期6
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_JU_TS_SetMatchResult_Individual]
	@SessionNumber					INT,
	@CourtID						INT,
	@MatchNo						INT,
	@SplitID						INT,
	@CompPos						INT,
	@IPP							INT,
	@WAZ							INT,
	@YUK							INT,
	@S								INT,
	@Kik							INT,
	@FUS							INT,
	@SH								INT,
	@SX								INT,
	@Hantei							INT,
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
	
	DECLARE   @IRMID	INT
	set @IRMID=0;
	
	if(@Kik<>0)
	BEGIN
		SET @IRMID=1
	END	
	if(@FUS<>0)
	begin
		set @IRMID=2;
	end

	UPDATE TS_Match_Result
	SET F_PointsNumDes1 = @IPP
		, F_PointsNumDes2 = @WAZ
		, F_PointsNumDes3 = @YUK
		, F_PointsNumDes4 = @S
		, F_PointsCharDes4 = CASE
			WHEN @SH = 1 THEN N'H'
			WHEN @SX = 1 THEN N'X'
			ELSE N''
		END
		, F_PointsCharDes1 = CONVERT(NVARCHAR(100), @Hantei)
		, F_IRMID =case when @IRMID=0 then NULL else @IRMID end
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompPos
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatchResult_Individual] 

*/