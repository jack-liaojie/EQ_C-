IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_GetDateTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_GetDateTime]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		穆学峰
-- Create date: 2009/12/10
-- Description:	得到报表样式的日期时间格式 

-- @para_type OUTPUT SAMPLE IS FOLLOWING
-- 1 " WED 13 OCT 2010 13:41 "
-- 2 " WED 13 OCT 2010		 "
-- 3 " 13:41				 "
-- 4 " 13 OCT 2010			 "
-- 5 " WED 13 OCT			 "
-- 6 " 13 OCT 2010			 "

-- =============================================
CREATE FUNCTION [Func_Report_GetDateTime]
(
	@para_datetime	datetime, 
	@para_type	int -- 1 DATE+TIME, 2 ONLY DATE, 3 ONLY TIME, 4 BIRTH DATE
)
RETURNS NvarCHAR(30)
AS
BEGIN

	DECLARE @ResultVar AS NVARCHAR(30)	
	DECLARE @week AS NVARCHAR(10)
	DECLARE @Month AS NVARCHAR(10)			-- the abbreviation of the month
	SET @week = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3))
	SET @Month = UPPER(SUBSTRING(DATENAME(MM, @para_datetime),1,3))

	IF @week = '星期一' SET @week = 'MON'
	IF @week = '星期二' SET @week = 'TUE'
	IF @week = '星期三' SET @week = 'WED'
	IF @week = '星期四' SET @week = 'THU'
	IF @week = '星期五' SET @week = 'FRI'
	IF @week = '星期六' SET @week = 'SAT'
	IF @week = '星期日' SET @week = 'SUN'
	
	IF @Month = N'01'		SET @Month = 'JAN'
	IF @Month = N'02'		SET @Month = 'FEB'
	IF @Month = N'03'		SET @Month = 'MAR'
	IF @Month = N'04'		SET @Month = 'APR'
	IF @Month = N'05'		SET @Month = 'MAY'
	IF @Month = N'06'		SET @Month = 'JUN'
	IF @Month = N'07'		SET @Month = 'JUL'
	IF @Month = N'08'		SET @Month = 'AUG'
	IF @Month = N'09'		SET @Month = 'SEP'
	IF @Month = N'10'		SET @Month = 'OCT'
	IF @Month = N'11'		SET @Month = 'NOV'
	IF @Month = N'12'		SET @Month = 'DEC'


	IF @para_type = 1
	BEGIN
	SELECT @ResultVar = @week + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + @Month + ' '
		+ DATENAME(yyyy,@para_datetime) + ' ' + DATENAME(hh,@para_datetime) + ':' + RIGHT('00' + DATENAME(n,@para_datetime), 2)
	END

	IF @para_type = 2
	BEGIN
	SELECT @ResultVar = @week + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + @Month + ' '	+ DATENAME(yyyy,@para_datetime) 
	END

	IF @para_type = 3
	BEGIN
		SELECT @ResultVar =  DATENAME(hh,@para_datetime) + ':' + RIGHT('00' + DATENAME(n,@para_datetime),2)
	END

	IF @para_type = 4
	BEGIN
		SELECT @ResultVar =  datename(dd, @para_datetime) + ' ' + @Month + ' ' + cast(year(@para_datetime) as char(4))
	END

	IF @para_type = 5
	BEGIN
	SELECT @ResultVar = @week + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + @Month 
	END

	IF @para_type = 6
	BEGIN
	SELECT @ResultVar = DATENAME(d,@para_datetime) 
		+ ' ' + @Month + ' '	+ DATENAME(yyyy,@para_datetime) 
	END

	SET @ResultVar = RTRIM(LTRIM(@ResultVar))



	RETURN @ResultVar
END
GO

--	test this function
/*
	select dbo.Func_report_GetDateTime(GETDATE(),1)
	select dbo.Func_report_GetDateTime(GETDATE(),2)
	select dbo.Func_report_GetDateTime(GETDATE(),3)
	select dbo.Func_report_GetDateTime(GETDATE(),4)
	select dbo.Func_report_GetDateTime(GETDATE(),5)
	select dbo.Func_report_GetDateTime(GETDATE(),6)

*/