IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetDecisionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetDecisionList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_WR_GetDecisionList]
--��    ��: ˤ����Ŀ��ȡ Decision �б�.
--�� �� ��: ��˳��
--��    ��: 2011��10��14�� ����5
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetDecisionList]
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

	SELECT 0 AS F_Order
		, N'' AS [Decision]
		, N'' AS [DecisionCode]
	UNION
	SELECT DD.F_Order
		,DCD.F_DecisionLongName AS [Decision]
		,DD.F_DecisionCode AS [DecisionCode]
	FROM TC_Decision AS DD
	LEFT JOIN TC_Decision_Des AS DCD
		ON DD.F_DecisionID = DCD.F_DecisionID AND DCD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Discipline AS D
		ON DD.F_DisciplineID = D.F_DisciplineID AND D.F_Active = 1
	ORDER BY F_Order

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDecisionList] 

*/