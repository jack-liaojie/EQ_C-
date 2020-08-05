IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TV_APP_GetDateSessions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TV_APP_GetDateSessions]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----�洢�������ƣ�[Proc_TV_APP_GetDateSessions]
----��		  �ܣ�ΪTV Ӧ�ó������, �õ�һ��һ�����������µ�����Session
----��		  �ߣ�֣����
----��		  ��: 2009-2-2 
----�� ��  �� ¼��
/*			
	����					�޸���		�޸�����
	2011��6��23�� ������	�����		Session ����Ϊ��λ.
*/


CREATE PROCEDURE [dbo].[Proc_TV_APP_GetDateSessions]
							@DisciplineCode			CHAR(2),
	                        @DateID					INT
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @DisciplineID AS INT
	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	CREATE TABLE #Temp_Sessions (F_SessionID	INT,
								 F_SessionName	NVARCHAR(100))

	IF @DateID = -1
	BEGIN
		INSERT INTO #Temp_Sessions (F_SessionID, F_SessionName) VALUES (-1, 'ALL')
		INSERT INTO #Temp_Sessions (F_SessionID, F_SessionName) SELECT A.F_SessionID, 'Session ' + CAST(@DisciplineCode AS NVARCHAR(100)) + RIGHT(N'0' + CAST(A.F_SessionNumber AS NVARCHAR(100)), 2) AS F_SessionName FROM TS_Session AS A LEFT JOIN TS_DisciplineDate AS B ON DATEDIFF(DAY, A.F_SessionDate, B.F_Date) = 0
					WHERE A.F_DisciplineID = @DisciplineID AND B.F_DisciplineID = @DisciplineID ORDER BY A.F_SessionNumber

	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Sessions (F_SessionID, F_SessionName) VALUES (-1, 'ALL')
		INSERT INTO #Temp_Sessions (F_SessionID, F_SessionName) SELECT A.F_SessionID, 'Session ' + CAST(@DisciplineCode AS NVARCHAR(100)) + RIGHT(N'0' + CAST(A.F_SessionNumber AS NVARCHAR(100)), 2) AS F_SessionName FROM TS_Session AS A LEFT JOIN TS_DisciplineDate AS B ON DATEDIFF(DAY, A.F_SessionDate, B.F_Date) = 0
					WHERE A.F_DisciplineID = @DisciplineID AND B.F_DisciplineID = @DisciplineID AND B.F_DisciplineDateID = @DateID ORDER BY A.F_SessionNumber
	END
	
	SELECT * FROM #Temp_Sessions
SET NOCOUNT OFF
END

GO

--EXEC [Proc_TV_APP_GetDateSessions] 'CR', -1
