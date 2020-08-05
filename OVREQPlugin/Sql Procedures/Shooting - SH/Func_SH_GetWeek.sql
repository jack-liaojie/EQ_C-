
	
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetWeek]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetWeek]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Func_SH_GetWeek]
(
	@para_datetime	datetime, 
	@LanguageCode	CHAR(3)
)
RETURNS NvarCHAR(30)
AS
BEGIN

	DECLARE @week NVARCHAR(20)
	SET @week = UPPER(SUBSTRING(DATENAME(dw, getdate()),1,3))	
	IF @LanguageCode = 'ENG'
	BEGIN
		IF @week = '星期一' SET @week = 'MON'
		IF @week = '星期二' SET @week = 'TUE'
		IF @week = '星期三' SET @week = 'WED'
		IF @week = '星期四' SET @week = 'THU'
		IF @week = '星期五' SET @week = 'FRI'
		IF @week = '星期六' SET @week = 'SAT'
		IF @week = '星期日' SET @week = 'SUN'
	END

	RETURN @week
END
GO
