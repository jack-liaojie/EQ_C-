IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetSexInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetSexInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




----�洢�������ƣ�[Proc_GetSexInfo]
----��		  �ܣ��õ����е��Ա���Ϣ
----��		  �ߣ�����
----��		  ��: 2009-08-17 
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetSexInfo](
                                         @LanguageCode    Char(3)
                                         )  	

AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_SexLongName,A.F_SexCode FROM TC_Sex as A LEFT JOIN TC_Sex_Des as B ON A.F_SexCode = B.F_SexCode WHERE B.F_LanguageCode= @LanguageCode

	RETURN

Set NOCOUNT OFF
End	


SET QUOTED_IDENTIFIER OFF

go

--exec [Proc_GetSexInfo] 'CHN'
--exec [Proc_GetSexInfo] 'ENG'