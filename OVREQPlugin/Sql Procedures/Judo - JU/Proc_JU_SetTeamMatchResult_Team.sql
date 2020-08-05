IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_SetTeamMatchResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_SetTeamMatchResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--��    ��: [[[Proc_JU_SetTeamMatchResult_Team]]]
--��    ��: ���������TeamMatchResult.����TS_Match_Split_Result��F_Points�ֶα���С�ֵ÷�
--TS_Match_Result��F_WinSets�ֶα��汾��ʤ�ĳ���,F_Points�ֶα��渺�ĳ���,
--F_DrawSetsƽ�ֳ���,F_PointsNumDes4������ֵ��ܵ÷�
--�� �� ��: ��˳��
--��    ��: 2010��12��29�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_SetTeamMatchResult_Team]
	@MatchID						INT,
	@MatchSplitID					INT,
	@CompPos						INT,
	@Score							INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0
	
	UPDATE TS_Match_Split_Result
	SET F_Points=@Score
	WHERE F_MatchID=@MatchID AND F_MatchSplitID=@MatchSplitID AND F_CompetitionPosition=@CompPos
	
	DECLARE @WinNum INT
	SELECT @WinNum=COUNT(F_ResultID) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos AND F_ResultID=1
	
	DECLARE @LosNum INT
	SELECT @LosNum=COUNT(F_ResultID) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos AND F_ResultID=2
	
	DECLARE @DrawNum INT
	SELECT @DrawNum=COUNT(F_ResultID) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos AND F_ResultID=3
	
	DECLARE @ScoreTotal INT
	SELECT @ScoreTotal=SUM(F_Points) FROM TS_Match_Split_Result
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos
	
	UPDATE TS_Match_Result
	SET F_WinSets=@WinNum,F_LoseSets=@LosNum,F_DrawSets=@DrawNum,F_Points=@ScoreTotal
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos
	
	SET @Result = 1

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/

GO


