IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_TS_SetMatchSplitInfo_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_TS_SetMatchSplitInfo_Team]
GO
/****** Object:  StoredProcedure [dbo].[Proc_JU_SetMatchSplitInfo_Team]    Script Date: 12/27/2010 14:39:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_JU_TS_SetMatchSplitInfo_Team]
--��    ��: �����ʱ�Ʒ���Ŀ������Ŀ���趨һ����������Ϣ.
--�� �� ��: ��˳��
--��    ��: 2011��6��18�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_TS_SetMatchSplitInfo_Team]
	@SessionNumber					INT,
	@CourtID						INT,
	@MatchNo						INT,
	@SplitID					INT,
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
	
	DECLARE @MatchID	INT
	select @MatchID=M.F_MatchID from TS_Match AS M
	Left Join TS_Session AS S
		On M.F_SessionID=S.F_SessionID
	LEFt JOIN TC_Court AS C
		ON M.F_CourtID=c.F_CourtID
	where S.F_SessionNumber=@SessionNumber AND C.F_CourtCode= @CourtCode AND M.F_RaceNum=@RaceNum

	
	
	UPDATE TS_Match_Split_Info
	SET 
		F_MatchSplitComment1=CONVERT(NVARCHAR(100), @GoldenScore)
		,F_MatchSplitComment2 = @ContestTime
		, F_MatchSplitComment3 = @Technique
	WHERE F_MatchID = @MatchID AND F_MatchSplitID=@SplitID
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
*/

GO


