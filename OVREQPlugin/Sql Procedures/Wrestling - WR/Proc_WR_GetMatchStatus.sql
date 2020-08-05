IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchStatus]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetMatchStatus]
--��    ��: ��ȡMatch״̬
--�� �� ��: ��˳��
--��    ��: 2011��11��13�� ����4
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
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