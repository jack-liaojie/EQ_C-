IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatchDecisionCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatchDecisionCode]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetMatchDecisionCode]
--��    ��: ˤ����Ŀ������Ŀ�趨һ����������Ϣ.
--�� �� ��: ��˳��
--��    ��: 2011��10��15�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatchDecisionCode]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	select D.F_DecisionCode AS [DecisionCode]
	from TS_Match AS M
	LEFT JOIN TC_Decision AS D
		ON M.F_DecisionID=D.F_DecisionID 
	where F_MatchID=@MatchID

	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/