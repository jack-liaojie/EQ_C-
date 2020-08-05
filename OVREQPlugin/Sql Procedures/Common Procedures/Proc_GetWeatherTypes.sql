IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetWeatherTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetWeatherTypes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_GetWeatherTypes]
--��    ��: ��ȡ���е�����������Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��25��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��09��04��		�����		�޸Ĳ�ͬ�����԰汾û�м�¼��ʾ���¼��ʾ��ȫ������			
*/



CREATE PROCEDURE [dbo].[Proc_GetWeatherTypes]
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT a.F_WeatherCode AS [WeatherCode]
		, b.F_WeatherTypeLongDescription AS [Long Description]
		, b.F_WeatherTypeShortDescription AS [Short Description]
		, a.F_WeatherTypeID AS [ID]
	FROM TC_WeatherType a
	LEFT JOIN TC_WeatherType_Des b
		ON a.F_WeatherTypeID = b.F_WeatherTypeID AND b.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetWeatherTypes] 'CHN'
--exec [Proc_GetWeatherTypes] 'GRE'