IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_GetMatchDays]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_GetMatchDays]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_SCB_GetMatchDays]
--��    ��: SCB ��ȡ MatchDay �����б�.
--�� �� ��: �����
--��    ��: 2010��7��7�� ������
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_SCB_GetMatchDays]
	@DisciplineCode						CHAR(2)
AS
BEGIN
SET NOCOUNT ON

	SELECT dbo.Func_SCB_GetDateTime(DD.F_Date, 1, 'ENG') AS [Date_ENG]
		, dbo.Func_SCB_GetDateTime(DD.F_Date, 1, 'CHN') AS [Date_CHN]
		, DD.F_DisciplineDateID
	FROM TS_DisciplineDate AS DD
	INNER JOIN TS_Discipline AS D
		ON DD.F_DisciplineID = D.F_DisciplineID
	WHERE D.F_DisciplineCode = @DisciplineCode
	ORDER BY DD.F_Date

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_GetMatchDays] 'RO'

*/