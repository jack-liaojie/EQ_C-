IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoSwitch_GetFunctionInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoSwitch_GetFunctionInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    �ƣ�[Proc_AutoSwitch_GetFunctionInfo]
--��    �������ݲ�ѯ������ѯ���ϵ�Function�б� --�Զ����Һ��ʵĵ�������Ĵ洢���̽��е���
--����˵���� 
--˵    ����
--�� �� �ˣ�����
--��    �ڣ�2010��09��25��

CREATE PROCEDURE [dbo].[Proc_AutoSwitch_GetFunctionInfo](
				 @DisciplineID   	INT,
				 @RegType			INT,
				 @LanguageCode      NVARCHAR(3)
)
As
Begin
SET NOCOUNT ON 

    DECLARE @DisciplineCode      CHAR(2)
    SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE  F_DisciplineID = @DisciplineID
    
	DECLARE @SQL				AS NVARCHAR(MAX)
	DECLARE @DisciplineProcName AS NVARCHAR(50)
	SET @DisciplineProcName = N'[dbo].[Proc_' + @DisciplineCode + '_GetFunctionInfo' +  + N']'
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@DisciplineProcName) AND type in (N'P', N'PC'))
	BEGIN
		SET @SQL = N'EXEC ' + @DisciplineProcName +  CAST(@DisciplineID AS NVARCHAR(MAX)) + N', '+CAST(@RegType AS NVARCHAR(MAX)) + N', '''+ CAST(@LanguageCode AS NVARCHAR(MAX)) + N' '''
		EXEC (@SQL)
		RETURN
	END
	ELSE
	BEGIN
		EXEC [dbo].[Proc_GetFunctionInfo] @DisciplineID, @RegType, @LanguageCode
		RETURN
	END
	
	RETURN
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO