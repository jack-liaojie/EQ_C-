

/****** Object:  StoredProcedure [dbo].[Proc_HB_ListWeatherType]    Script Date: 08/30/2012 08:44:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_ListWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_ListWeatherType]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_ListWeatherType]    Script Date: 08/30/2012 08:44:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--��    ��: [Proc_HB_ListWeatherType]
--��    ��: Ƥ��ͧ��Ŀ��ȡ WeatherType �б�  
--����˵��: 
--˵    ��: �����
--�� �� ��: 
--��    ��: 2009��12��28��
--�޸ļ�¼��


Create PROCEDURE [dbo].[Proc_HB_ListWeatherType]
	@LanguageCode					CHAR(3) = 'ANY'		-- Ĭ��ȡ��ǰ���������
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT A.F_WeatherTypeID AS [WeatherTypeID]
		, B.F_WeatherTypeShortDescription AS [WeatherTypeShortDescription]
		, B.F_WeatherTypeLongDescription AS [WeatherTypeLongDescription]
	FROM TC_WeatherType AS A
	LEFT JOIN TC_WeatherType_Des AS B
		ON A.F_WeatherTypeID = B.F_WeatherTypeID AND B.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END

GO


