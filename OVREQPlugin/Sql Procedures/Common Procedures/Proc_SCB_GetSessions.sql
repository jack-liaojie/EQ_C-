IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_GetSessions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_GetSessions]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_SCB_GetSessions]
--��    ��: SCB ��ȡ Session �����б�.
--�� �� ��: �����
--��    ��: 2010��7��7�� ������
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_SCB_GetSessions]
	@DisciplineDateID						INT
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID		INT
	DECLARE @Date				DateTime
	
	SELECT @DisciplineID = F_DisciplineID
		, @Date = F_Date
	FROM TS_DisciplineDate 
	WHERE F_DisciplineDateID = @DisciplineDateID
	
	SELECT (
		'S.' + CONVERT(NVARCHAR(10), S.F_SessionNumber) + ' '
		+	CASE
				WHEN S.F_SessionTime IS NULL THEN ''
				ELSE dbo.Func_SCB_GetDateTime(S.F_SessionTime, 4, 'ENG')
			END
		) AS [Session]
		, S.F_SessionID
	FROM TS_Session AS S
	WHERE S.F_DisciplineID = @DisciplineID
		AND DATEDIFF(DAY, S.F_SessionDate, @Date) = 0

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SCB_GetSessions] 1

*/