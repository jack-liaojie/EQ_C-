IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SCB_GetDateTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SCB_GetDateTime]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Func_SCB_GetDateTime]
--描    述: 报表中将 DateTime 类型转化成字符串
--参数说明: @Type 为转化成字符串的类型的形式, 
	/*
		1 - Date(in Title and Birth date), "D MMM YYYY", "YYYY年M月D日"
		2 - Weekday(in Title), "WWW" "星期W"
		3 - Weekday + Date + Time(Created Date And Time) "WWW D MMM YYYY H:NN" "YYYY年M月D日 星期W H:NN"
		4 - Time "H:NN"
		5 - Weekday + Date "WWW D MMM YYYY" "YYYY年M月D日 星期W"
	*/
--创 建 人: 邓年彩
--日    期: 2010年7月7日 星期三
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE FUNCTION [Func_SCB_GetDateTime]
(
	@DateTime				DateTime,
	@Type					INT,
	@LanguageCode			CHAR(3) = 'ENG'
)
RETURNS NVARCHAR(30)
AS
BEGIN

	DECLARE @ResultVar		NVARCHAR(30)
	
	DECLARE @D				NVARCHAR(10)			-- the day of the month without leading zeros (1-31)
	DECLARE @MMM			NVARCHAR(10)			-- the abbreviation of the month
	DECLARE @YYYY			NVARCHAR(10)			-- the year
	DECLARE @WWW			NVARCHAR(10)			-- the day of the week
	DECLARE @H				NVARCHAR(10)			-- hours (with leading zeros)
	DECLARE @NN				NVARCHAR(10)			-- minutes (with leading zeros)
	
	SET @D = DATEPART(d, @DateTime)
	SET @MMM = DATEPART(m, @DateTime)
	SET @YYYY = DATEPART(yy, @DateTime)
	SET @WWW = DATEPART(dw, @DateTime)
	SET @H = DATEPART(hh, @DateTime)
	SET @NN = RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(n, @DateTime)), 2)
	
	-- 英文对 @MMM 进行调整
	IF @LanguageCode = 'ENG'
	BEGIN
		-- JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC
		IF @MMM = N'1'		SET @MMM = N'JAN'
		IF @MMM = N'2'		SET @MMM = N'FEB'
		IF @MMM = N'3'		SET @MMM = N'MAR'
		IF @MMM = N'4'		SET @MMM = N'APR'
		IF @MMM = N'5'		SET @MMM = N'MAY'
		IF @MMM = N'6'		SET @MMM = N'JUN'
		IF @MMM = N'7'		SET @MMM = N'JUL'
		IF @MMM = N'8'		SET @MMM = N'AUG'
		IF @MMM = N'9'		SET @MMM = N'SEP'
		IF @MMM = N'10'		SET @MMM = N'OCT'
		IF @MMM = N'11'		SET @MMM = N'NOV'
		IF @MMM = N'12'		SET @MMM = N'DEC'
	END
	
	-- 对 @WWW 进行调整
	IF @LanguageCode = 'CHN'
	BEGIN
		IF @WWW = N'1'		SET @WWW = N'星期日'
		IF @WWW = N'2'		SET @WWW = N'星期一'
		IF @WWW = N'3'		SET @WWW = N'星期二'
		IF @WWW = N'4'		SET @WWW = N'星期三'
		IF @WWW = N'5'		SET @WWW = N'星期四'
		IF @WWW = N'6'		SET @WWW = N'星期五'
		IF @WWW = N'7'		SET @WWW = N'星期六'
	END
	ELSE
	BEGIN
		-- SUN,MON,TUE,WED,THU,FRI,SAT
		IF @WWW = N'1'		SET @WWW = N'SUN'
		IF @WWW = N'2'		SET @WWW = N'MON'
		IF @WWW = N'3'		SET @WWW = N'TUE'
		IF @WWW = N'4'		SET @WWW = N'WED'
		IF @WWW = N'5'		SET @WWW = N'THU'
		IF @WWW = N'6'		SET @WWW = N'FRI'
		IF @WWW = N'7'		SET @WWW = N'SAT'
	END
	
	IF @Type = 1
	BEGIN
		IF @LanguageCode = 'CHN'
		BEGIN
			SET @ResultVar = @YYYY + N'年' + @MMM + N'月' + @D + N'日'
		END
		ELSE
		BEGIN
			SET @ResultVar = @D + N' ' + @MMM + N' ' + @YYYY
		END
	END
	ELSE IF @Type = 2
	BEGIN
		SET @ResultVar = @WWW
	END
	ELSE IF @Type = 3
	BEGIN
		IF @LanguageCode = 'CHN'
		BEGIN
			SET @ResultVar = @YYYY + N'年' + @MMM + N'月' + @D + N'日 ' + @WWW + N' ' + @H + N':' + @NN
		END
		ELSE
		BEGIN
			SET @ResultVar = @WWW + N' ' + @D + N' ' + @MMM + N' ' + @YYYY + N' ' + @H + N':' + @NN
		END
	END
	ELSE IF @Type = 4
	BEGIN
		SET @ResultVar = @H + N':' + @NN
	END
	ELSE IF @Type = 5
	BEGIN
		IF @LanguageCode = 'CHN'
		BEGIN
			SET @ResultVar = @YYYY + N'年' + @MMM + N'月' + @D + N'日 ' + @WWW
		END
		ELSE
		BEGIN
			SET @ResultVar = @WWW + N' ' + @D + N' ' + @MMM + N' ' + @YYYY
		END
	END

	RETURN @ResultVar

END

/*

-- Just for test
select dbo.[Func_SCB_GetDateTime](GETDATE(), 1, 'ENG')
select dbo.[Func_SCB_GetDateTime](GETDATE(), 2, 'ENG')
select dbo.[Func_SCB_GetDateTime](GETDATE(), 3, 'ENG')
select dbo.[Func_SCB_GetDateTime](GETDATE(), 4, 'ENG')

select dbo.[Func_SCB_GetDateTime](GETDATE(), 1, 'CHN')
select dbo.[Func_SCB_GetDateTime](GETDATE(), 2, 'CHN')
select dbo.[Func_SCB_GetDateTime](GETDATE(), 3, 'CHN')
select dbo.[Func_SCB_GetDateTime](GETDATE(), 4, 'CHN')

*/