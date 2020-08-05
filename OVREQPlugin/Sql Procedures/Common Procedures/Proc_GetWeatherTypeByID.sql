IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetWeatherTypeByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetWeatherTypeByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetWeatherTypeByID]
--��    ��: ���� WeatherTypeID ��ȡһ���������͵���Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��03��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetWeatherTypeByID]
	@LanguageCode				CHAR(3),
	@WeatherTypeID				INT
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_WeatherType a
	LEFT JOIN TC_WeatherType_Des b
		ON a.F_WeatherTypeID = b.F_WeatherTypeID AND b.F_LanguageCode = @LanguageCode
	WHERE a.F_WeatherTypeID = @WeatherTypeID

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetWeatherTypeByID] 'CHN', 1
--exec [Proc_GetWeatherTypeByID] 'GRE', 1