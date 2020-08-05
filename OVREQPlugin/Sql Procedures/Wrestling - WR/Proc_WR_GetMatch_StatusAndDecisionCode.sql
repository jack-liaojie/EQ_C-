IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetMatch_StatusAndDecisionCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetMatch_StatusAndDecisionCode]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetMatch_StatusAndDecisionCode]
--��    ��: ���������Ŀ��ȡһ����������Ϣ.
--�� �� ��: �����
--��    ��: 2010��11��5�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetMatch_StatusAndDecisionCode]
	@MatchID						INT,
	@MatchSplitID					INT,
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END
	
	SELECT 
		 MSI.F_MatchSplitStatusID AS [StatusID]
		, D.F_DecisionCode AS [DecisionCode]
		,MSRA.F_PointsNumDes1 AS [HanteiSplitA]
		,MSRB.F_PointsNumDes1 AS [HanteiSplitB]
	FROM TS_Match_Split_Info AS MsI
	LEFT JOIN TC_Decision AS D
		ON MSI.F_DecisionID = D.F_DecisionID
	LEFT JOIN TS_Match_Split_Result AS MSRA
		ON MSRA.F_MatchID=MsI.F_MatchID and MSRA.F_MatchSplitID=MSI.F_MatchSplitID and msra.F_CompetitionPosition=1
	LEFT JOIN TS_Match_Split_Result AS MSRB
		ON MSRB.F_MatchID=MsI.F_MatchID and MSRb.F_MatchSplitID=MSI.F_MatchSplitID and msrb.F_CompetitionPosition=2
	WHERE MSI.F_MatchID = @MatchID and MSI.F_MatchSplitID=@MatchSplitID
	
SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatch_Individual] 2

*/