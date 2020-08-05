IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetClubList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetClubList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetClubList]
----��		  �ܣ��õ����еľ��ֲ��б�
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetClubList](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_ClubCode AS [Code]
		, B.F_ClubLongName AS [Long Name]
		, B.F_ClubShortName AS [Short Name]
		, A.F_CLubID AS [ID]
	FROM TC_Club AS A 
	LEFT JOIN TC_Club_Des AS B 
		ON A.F_CLubID = B.F_CLubID AND B.F_LanguageCode= @LanguageCode

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetClubList] 'CHN'
--exec [Proc_GetClubList] 'ENG'