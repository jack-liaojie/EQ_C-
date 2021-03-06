IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetWeatherType]
GO
set ANSI_NULLS ON
go
set QUOTED_IDENTIFIER ON
go
--名    称: [Proc_TE_GetWeatherType]
--描    述: 获取 WeatherType 列表  
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2011年04月12日
--修改记录：


Create PROCEDURE [dbo].[Proc_TE_GetWeatherType]
	@LanguageCode					CHAR(3) 
AS
BEGIN
SET NOCOUNT ON

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

