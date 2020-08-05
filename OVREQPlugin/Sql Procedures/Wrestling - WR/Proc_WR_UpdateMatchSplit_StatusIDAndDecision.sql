IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_UpdateMatchSplit_StatusIDAndDecision]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_UpdateMatchSplit_StatusIDAndDecision]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_UpdateMatchSplit_StatusIDAndDecision]
--��    ��: ���������Ŀ��ȡһ����������Ϣ.
--�� �� ��: �����
--��    ��: 2010��11��5�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_UpdateMatchSplit_StatusIDAndDecision]
	@MatchID						INT,
	@MatchSplitID					INT,
	@MatchSplitStatusID				INT,
	@MatchSplitDecisionCode			Nvarchar(100),
	@LanguageCode					CHAR(3) = NULLa
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END
	
	DECLARE @DecisionID					INT
	SELECT @DecisionID = D.F_DecisionID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	INNER JOIN TC_Decision AS D
		ON E.F_DisciplineID = D.F_DisciplineID AND D.F_DecisionCode = @MatchSplitDecisionCode
	WHERE M.F_MatchID = @MatchID
	
	Update TS_Match_Split_Info set F_DecisionID=@DecisionID,F_MatchSplitStatusID=@MatchSplitStatusID
		where F_MatchID=@MatchID and F_MatchSplitID=@MatchSplitID
			
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatch_Individual] 2

*/