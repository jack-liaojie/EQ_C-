IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_BDTT_GetTeamMatchSplitTypeDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_BDTT_GetTeamMatchSplitTypeDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--王强 2012-09-13
--获取比赛结果描述
CREATE FUNCTION [dbo].[Func_BDTT_GetTeamMatchSplitTypeDes]
								(
									@Type INT,
									@LanguageCode NVARCHAR(10)
								)
RETURNS NVARCHAR(10)
AS
BEGIN
	
	DECLARE @Res NVARCHAR(200)
	
	IF @Type = 1
		SET @Res = CASE @LanguageCode WHEN 'CHN' THEN '男子单打' WHEN 'ENG' THEN 'MS' ELSE '' END  
	ELSE IF @Type = 2
		SET @Res = CASE @LanguageCode WHEN 'CHN' THEN '女子单打' WHEN 'ENG' THEN 'WS' ELSE '' END  
	ELSE IF @Type = 3
		SET @Res = CASE @LanguageCode WHEN 'CHN' THEN '男子双打' WHEN 'ENG' THEN 'MD' ELSE '' END  
	ELSE IF @Type = 4
		SET @Res = CASE @LanguageCode WHEN 'CHN' THEN '女子双打' WHEN 'ENG' THEN 'WD' ELSE '' END  
	ELSE IF @Type = 5
		SET @Res = CASE @LanguageCode WHEN 'CHN' THEN '混合双打' WHEN 'ENG' THEN 'XD' ELSE '' END  
	
	RETURN @Res
END


GO

--PRINT [dbo].[Fun_BDTT_New_GetMatchResultDes](63,2,5)