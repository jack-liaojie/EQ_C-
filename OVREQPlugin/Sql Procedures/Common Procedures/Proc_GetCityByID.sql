IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCityByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCityByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetCityByID]
--��    ��: ���� ID ��ȡһ�� City ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��17��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetCityByID]
	@CityID					INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_City AS A 
	left join TC_City_Des AS B
		ON A.F_CityID = B.F_CityID AND B.F_LanguageCode=@LanguageCode
	WHERE A.F_CityID = @CityID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetCityByID] 2, 'CHN'
--exec [Proc_GetCityByID] 2, 'ENG'