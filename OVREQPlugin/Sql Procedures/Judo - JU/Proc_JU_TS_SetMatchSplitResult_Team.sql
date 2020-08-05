IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_TS_SetMatchSplitResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_TS_SetMatchSplitResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_JU_TS_SetMatchSplitResult_Team]
--��    ��: �����ʱ�Ʒֵ�����Ŀ�趨һ������һ�������ߵı����ɼ�.
--�� �� ��: ��˳��
--��    ��: 2011��6��18�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_TS_SetMatchSplitResult_Team]
	@SessionNumber					INT,
	@CourtID						INT,
	@MatchNo						INT,
	@SplitID					INT,
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

	
	UPDATE TS_Match_Split_Result
	SET F_PointsNumDes1 = @IPP
		, F_PointsNumDes2 = @WAZ
		, F_PointsNumDes3 = @YUK
		, F_SplitPointsNumDes3 = @S
		, F_PointsCharDes3 = CASE
			WHEN @SH = 1 THEN N'H'
			WHEN @SX = 1 THEN N'X'
			ELSE N''
		END
		,F_PointsCharDes1=CONVERT(NVARCHAR(100), @Hantei)
		, F_IRMID =case when  @IRMID=0 then NULL else @IRMID end
	WHERE F_MatchID = @MatchID AND F_MatchSplitID=@SplitID AND F_CompetitionPosition = @CompPos
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatchResult_Individual] 

*/
GO


