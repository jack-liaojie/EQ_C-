IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetWeekdayName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetWeekdayName]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Fun_GetWeekdayName]
--描    述：根据日期获取星期几的中文名称或英文缩写
--参数说明： 
--说    明：
--创 建 人：邓年彩
--日    期：2009年12月10日
--修改记录：
/*			
			时间				修改人		修改内容
*/

CREATE FUNCTION [dbo].[Fun_GetWeekdayName]
	(
		@Date					DateTime,
		@LanguageCode			CHAR(3)
	)
RETURNS NVARCHAR(10)
AS
BEGIN

	DECLARE @WeekdayName		NVARCHAR(10)
	DECLARE @WeekdayName_CHN	NVARCHAR(10)
	DECLARE @WeekdayName_ENG	NVARCHAR(10)
	DECLARE @Weekday			INT				-- Sunday = 1, Saturday = 7

	SET @Weekday = DATEPART(dw, @Date)

	IF @Weekday = 1
	BEGIN
		SET @WeekdayName_CHN = N'星期日'
		SET @WeekdayName_ENG = N'SUN'
	END
	ELSE IF @Weekday = 2
	BEGIN
		SET @WeekdayName_CHN = N'星期一'
		SET @WeekdayName_ENG = N'MON'
	END
	ELSE IF @Weekday = 3
	BEGIN
		SET @WeekdayName_CHN = N'星期二'
		SET @WeekdayName_ENG = N'TUE'
	END
	ELSE IF @Weekday = 4
	BEGIN
		SET @WeekdayName_CHN = N'星期三'
		SET @WeekdayName_ENG = N'WED'
	END
	ELSE IF @Weekday = 5
	BEGIN
		SET @WeekdayName_CHN = N'星期四'
		SET @WeekdayName_ENG = N'THU'
	END
	ELSE IF @Weekday = 6
	BEGIN
		SET @WeekdayName_CHN = N'星期五'
		SET @WeekdayName_ENG = N'FRI'
	END
	ELSE
	BEGIN
		SET @WeekdayName_CHN = N'星期六'
		SET @WeekdayName_ENG = N'SAT'
	END	

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @WeekdayName = @WeekdayName_CHN
	END
	ELSE
	BEGIN
		SET @WeekdayName = @WeekdayName_ENG
	END

	RETURN @WeekdayName

END
