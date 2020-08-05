IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCities]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCities]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_GetCities]
--��    �����õ����е�City
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��08��13��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/

CREATE PROCEDURE [dbo].[Proc_GetCities](
				 @LanguageCode	CHAR(3)
)
AS
Begin
SET NOCOUNT ON 

	SELECT A.F_CityCode AS [Code],
		B.F_CityLongName AS [Long Name],B.F_CityShortName AS [Short Name],
			A.F_CityID AS [ID]
				FROM TC_City AS A left join TC_City_Des AS B
					ON A.F_CityID = B.F_CityID AND B.F_LanguageCode=@LanguageCode

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec [Proc_GetCities] 'ENG'
