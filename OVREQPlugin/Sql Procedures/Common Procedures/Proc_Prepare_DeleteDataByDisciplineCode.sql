IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Prepare_DeleteDataByDisciplineCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Prepare_DeleteDataByDisciplineCode]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Prepare_DeleteDataByDisciplineCode]
--��    ��: ���� Discipline Code ɾ��һ�� Discipline �ĳɼ���Ϣ.
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2010��9��14�� ���ڶ�
--�޸ļ�¼��
/*			
			����					�޸���		�޸�����
*/



CREATE PROCEDURE [dbo].[Proc_Prepare_DeleteDataByDisciplineCode]
	@DisciplineCode						NVARCHAR(20),
	@IsDeleteTop						INT		-- �Ƿ�ɾ����������: 0 - ��ɾ��; 1 - ɾ��.
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID				INT
	DECLARE @DType						INT
	
	SET @DType = 1
	
	SELECT @DisciplineID = D.F_DisciplineID
	FROM TS_Discipline AS D
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	EXEC [Proc_Prepare_DeleteDataBySDEPMID] @DisciplineID, @DType, @IsDeleteTop

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'KR', 0
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'CR', 0
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'CR', 1
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'SL', 1
EXEC [Proc_Prepare_DeleteDataByDisciplineCode] 'KR', 1

*/