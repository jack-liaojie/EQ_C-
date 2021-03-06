IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_ListWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_ListWeatherType]
GO
set ANSI_NULLS ON
go
set QUOTED_IDENTIFIER ON
go
--名    称: [Proc_SL_ListWeatherType]
--描    述: 激流回旋项目获取 WeatherType 列表  
--参数说明: 
--说    明: 
--创 建 人: 
--日    期: 2010年04月09日
--修改记录：


Create PROCEDURE [dbo].[Proc_SL_ListWeatherType]
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

	SELECT A.F_WeatherTypeID AS [WeatherTypeID]
		, B.F_WeatherTypeShortDescription AS [WeatherTypeShortDescription]
		, B.F_WeatherTypeLongDescription AS [WeatherTypeLongDescription]
	FROM TC_WeatherType AS A
	LEFT JOIN TC_WeatherType_Des AS B
		ON A.F_WeatherTypeID = B.F_WeatherTypeID AND B.F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
GO
set QUOTED_IDENTIFIER OFF
go
set ANSI_NULLS OFF
go

