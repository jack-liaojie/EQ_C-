IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_UpdateTeamRate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_UpdateTeamRate]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_JU_UpdateTeamRate]
--��    ��: StartList�޸������Ŀ�����������ս��.
--�� �� ��: ��˳��
--��    ��: 2011��6��2�� ����4
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_UpdateTeamRate]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	update TS_Match_Result set F_Rank=NULL,F_ResultID=NULL WHere F_MatchID=@MatchID

SET NOCOUNT OFF
END

/*

-- Just for test

*/





