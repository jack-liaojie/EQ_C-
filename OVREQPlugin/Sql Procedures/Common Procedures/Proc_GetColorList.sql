IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetColorList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetColorList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetColorList]
----��		  �ܣ��õ����еľ��ֲ��б�
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetColorList](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_LanguageCode AS [Language Code]
		, B.F_ColorLongName AS [Long Name]
		, B.F_ColorShortName AS [Short Name]
		, B.F_ColorComment AS [Comment]
		, A.F_ColorID AS [ID]
	FROM TC_Color AS A 
	LEFT JOIN TC_Color_Des AS B 
		ON A.F_ColorID = B.F_ColorID AND B.F_LanguageCode= @LanguageCode

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetColorList] 'CHN'
--exec [Proc_GetColorList] 'ENG'