IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchDecisionCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchDecisionCode]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_UpdateMatchDecisionCode]
--��    ��: ˤ����Ŀ������Ŀ�趨һ����������Ϣ.
--�� �� ��: ��˳��
--��    ��: 2011��10��15�� ����6
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchDecisionCode]
	@MatchID						INT,
	@DecisionCode					NVARCHAR(100)
AS
BEGIN
SET NOCOUNT ON



	DECLARE @DecisionID					INT
	SELECT @DecisionID = D.F_DecisionID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_Decision AS D
		ON E.F_DisciplineID = D.F_DisciplineID AND D.F_DecisionCode = @DecisionCode
	WHERE M.F_MatchID = @MatchID
	
	Update TS_Match set F_DecisionID=@DecisionID where F_MatchID=@MatchID
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_SetMatch_Individual] 

*/