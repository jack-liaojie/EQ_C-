IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_UpdateTeamResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_UpdateTeamResult]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_JU_UpdateTeamResult]
--��    ��: �����Ŀ�����������ս��.
--�� �� ��: ��˳��
--��    ��: 2010��12��29�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_UpdateTeamResult]
	@MatchID						INT,
	@CompPos						INT,
	@ResultID						INT,
	@RankID							INT
AS
BEGIN
SET NOCOUNT ON

	UPDATE TS_Match_Result SET F_ResultID=@ResultID,F_Rank=@RankID
	WHERE F_MatchID=@MatchID AND F_CompetitionPosition=@CompPos

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/