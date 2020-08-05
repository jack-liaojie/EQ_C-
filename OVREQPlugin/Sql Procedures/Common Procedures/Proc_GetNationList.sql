IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetNationList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetNationList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetNationList]
----��		  �ܣ��õ����е���ɫ��Ϣ
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetNationList](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_NationLongName AS [Long Name]
		, B.F_NationShortName AS [Short Name]
		, B.F_NationComment AS [Comment]
		, A.F_NationID AS [ID]
	FROM TC_Nation AS A 
	LEFT JOIN TC_Nation_Des AS B 
		ON A.F_NationID = B.F_NationID AND B.F_LanguageCode= @LanguageCode



Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetNationList] 'CHN'
--exec [Proc_GetNationList] 'ENG'