IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetRegTypeInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetRegTypeInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetRegTypeInfo]
----��		  �ܣ��õ����е�ע��������Ϣ
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetRegTypeInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_RegTypeLongDescription, A.F_RegTypeID 
	FROM TC_RegType AS A 
	LEFT JOIN TC_RegType_Des AS B 
		ON A.F_RegTypeID = B.F_RegTypeID AND B.F_LanguageCode= @LanguageCode

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetRegTypeInfo] 'CHN'
--exec [Proc_GetRegTypeInfo] 'ENG'