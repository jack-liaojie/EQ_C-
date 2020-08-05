IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetFunction]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetFunction]
----��		  �ܣ��õ����еĹ�����Ϣ
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetFunction](
                                         @DisciplineID    INT,
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_FunctionLongName, A.F_FunctionID 
	FROM TD_Function AS A 
	LEFT JOIN TD_Function_Des AS B 
		ON A.F_FunctionID = B.F_FunctionID AND B.F_LanguageCode= @LanguageCode
	WHERE A. F_DisciplineID  = @DisciplineID 

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetFunction] 5, 'CHN'
--exec [Proc_GetFunction] 5, 'ENG'