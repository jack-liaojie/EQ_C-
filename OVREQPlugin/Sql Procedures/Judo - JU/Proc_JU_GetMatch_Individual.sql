IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_JU_GetMatch_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_JU_GetMatch_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_JU_GetMatch_Individual]
--��    ��: ���������Ŀ��ȡһ����������Ϣ.
--�� �� ��: �����
--��    ��: 2010��11��5�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_JU_GetMatch_Individual]
	@MatchID						INT,
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
	
	SELECT [GoldenScore] = CASE M.F_MatchComment3 WHEN N'1' THEN 1 ELSE 0 END
		, M.F_MatchComment4 AS [ContestTime]
		, M.F_MatchComment5 AS [Technique]
		, M.F_MatchStatusID AS [StatusID]
		, D.F_DecisionCode AS [DecisionCode]
	FROM TS_Match AS M
	LEFT JOIN TC_Decision AS D
		ON M.F_DecisionID = D.F_DecisionID
	WHERE M.F_MatchID = @MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetMatch_Individual] 2

*/