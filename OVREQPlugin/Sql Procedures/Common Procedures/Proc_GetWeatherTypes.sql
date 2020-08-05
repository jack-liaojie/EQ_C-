IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetWeatherTypes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetWeatherTypes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetWeatherTypes]
--描    述: 获取所有的天气类型信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日
--修改记录：
/*			
			时间				修改人		修改内容
			2009年09月04日		邓年彩		修改不同的语言版本没有记录显示或记录显示不全的问题			
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