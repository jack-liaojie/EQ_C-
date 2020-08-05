

/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchWeather]    Script Date: 08/30/2012 08:39:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetMatchWeather]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetMatchWeather]
GO


/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchWeather]    Script Date: 08/30/2012 08:39:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_HB_GetMatchWeather]
--描    述: 皮划艇项目获取一场比赛的天气情况  
--参数说明: 
--说    明: 
--创 建 人: 杨佳鹏
--日    期: 2009年12月28日
--修改记录：




CREATE PROCEDURE [dbo].[Proc_HB_GetMatchWeather]
	@MatchID						INT,
	@LanguageCode					CHAR(3) = 'ANY'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT B.F_Air_Temperature AS [AirTemp]
		, B.F_Water_Temperature AS [WaterTemp]
		, B.F_Humidity AS [Humidity]
		, C.F_WeatherTypeID AS [WeatherTypeID]
		, C.F_WeatherTypeLongDescription AS [WeatherTypeLongDescription]
		, C.F_WeatherTypeShortDescription AS [WeatherTypeShortDescription]
		, B.F_Wind_Speed AS [WindSpeed]
		, D.F_WindDirectionID AS [WindDirectionID]
		, D.F_WindDirectionLongName AS [WindDirection]
	FROM TS_Match AS A
	LEFT JOIN TS_Weather_Conditions AS B
		ON A.F_WeatherID = B.F_WeatherID
	LEFT JOIN TC_WeatherType_Des AS C
		ON B.F_WeatherTypeID = C.F_WeatherTypeID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_WindDirection_Des AS D
		ON B.F_WindDirectionID = D.F_WindDirectionID AND D.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID


SET NOCOUNT OFF
END

GO


