IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchSplitResultAndWinset]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchSplitResultAndWinset]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_UpdateMatchSplitResultAndWinset]
--��    ��: ˤ����Ŀ���¾�ʤ��.
--�� �� ��: ��˳��
--��    ��: 2011��10��15�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchSplitResultAndWinset]
	@MatchID						INT,
	@MatchSplitID					INT,
	@Compos							int,
	@ResultSplitID					int
AS
BEGIN
SET NOCOUNT ON

	update TS_Match_Split_Result Set F_ResultID=@ResultSplitID 
	where F_MatchID=@MatchID and F_MatchSplitID=@MatchSplitID and F_CompetitionPosition=@Compos
	
	update TS_Match_Result set F_WinSets=
	(select COUNT(*) from TS_Match_Split_Result where F_MatchID=@MatchID  and F_CompetitionPosition=@Compos and F_ResultID=1)
	where F_MatchID=@MatchID and F_CompetitionPosition=@Compos

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/