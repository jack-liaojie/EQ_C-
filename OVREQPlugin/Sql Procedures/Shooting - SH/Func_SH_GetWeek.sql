
	
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
		IF @week = '����һ' SET @week = 'MON'
		IF @week = '���ڶ�' SET @week = 'TUE'
		IF @week = '������' SET @week = 'WED'
		IF @week = '������' SET @week = 'THU'
		IF @week = '������' SET @week = 'FRI'
		IF @week = '������' SET @week = 'SAT'
		IF @week = '������' SET @week = 'SUN'
	END

	RETURN @week
END
GO
