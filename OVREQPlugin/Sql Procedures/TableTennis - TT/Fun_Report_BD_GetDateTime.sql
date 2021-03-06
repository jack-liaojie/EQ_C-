IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetDateTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetDateTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		张翠霞
-- Create date: 2010/09/07
-- Description:	得到报表样式的日期时间格式  " THU 7 AUG 2008 16:06 "
--王强2011-5-10增加类型9   9:YYYYMMDDHHMM
--王强2011-6-7增加类型10，获取YYYYMMDD，增加类型获取HHMM
-- =============================================
CREATE FUNCTION [dbo].[Fun_Report_BD_GetDateTime]
(
	@para_datetime	datetime, 
	@para_type	int -- 1 DATE+TIME, 2 ONLY DATE, 3 ONLY TIME, 4 BIRTH DATE, 7 “30 JUN”
				--
)
RETURNS NvarCHAR(30)
AS
BEGIN
	DECLARE @ResultVar AS NVARCHAR(30)

	IF @para_type = 1
	BEGIN
	SELECT @ResultVar = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3)) + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) + ' '
		+ DATENAME(yyyy,@para_datetime) + ' ' + DATENAME(hh,@para_datetime) + ':' + RIGHT('00' + DATENAME(n,@para_datetime), 2)
	END
	ELSE IF @para_type = 2
	BEGIN
	SELECT @ResultVar = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3)) + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) + ' '	+ DATENAME(yyyy,@para_datetime) 
	END
	ELSE IF @para_type = 3
	BEGIN
		SELECT @ResultVar = RIGHT('0' + DATENAME(hh,@para_datetime),2) + ':' + RIGHT('00' + DATENAME(n,@para_datetime),2)
	END
	ELSE IF @para_type = 4
	BEGIN
		SELECT @ResultVar =  datename(dd, @para_datetime) + ' ' + upper(substring(datename(month, @para_datetime),1,3)) + ' ' + cast(year(@para_datetime) as char(4))
	END
	ELSE IF @para_type = 5
	BEGIN
	SELECT @ResultVar = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3)) + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) 
	END
	ELSE IF @para_type = 6
	BEGIN
	SELECT @ResultVar = DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) + ' '	+ DATENAME(yyyy,@para_datetime) 
	END
	ELSE IF @para_type = 7
	BEGIN
		SELECT @ResultVar =  datename(dd, @para_datetime) + ' ' + upper(substring(datename(month, @para_datetime),1,3))
	END
	ELSE IF @para_type = 8
	BEGIN
	    SELECT @ResultVar = DATENAME(yyyy, @para_datetime) + '-' + RIGHT( '0' + CAST( DATEPART(mm, @para_datetime) AS NVARCHAR(10)),2) 
					+ '-' + RIGHT('0' + DATENAME(dd,@para_datetime),2)
	END
	ELSE IF @para_type = 9
	BEGIN
		SELECT @ResultVar = DATENAME(yyyy,@para_datetime) + RIGHT( '0' + DATENAME(mm, @para_datetime), 2) + RIGHT('0' + DATENAME(dd, @para_datetime), 2) 
		+ RIGHT( '0' + DATENAME(hh, @para_datetime), 2) + RIGHT( '0' + DATENAME(mi, @para_datetime), 2 )
	END
	ELSE IF @para_type = 10
	BEGIN
		SELECT @ResultVar = DATENAME(yyyy,@para_datetime) + RIGHT( '0' + DATENAME(mm, @para_datetime), 2) + RIGHT('0' + DATENAME(dd, @para_datetime), 2)
	END
	ELSE IF @para_type = 11
	BEGIN
		SELECT @ResultVar = RIGHT( '0' + DATENAME(hh, @para_datetime), 2) + RIGHT( '0' + DATENAME(mi, @para_datetime), 2 )
	END
	ELSE IF @para_type = 12
	BEGIN
		SELECT @ResultVar = LEFT( CONVERT( NVARCHAR(30), @para_datetime, 110 ),5)
	END
	ELSE IF @para_type = 13
	BEGIN
		SELECT @ResultVar = DATENAME(mm,@para_datetime) + '月' + RIGHT( '0' + datename(dd, @para_datetime),2) + '日'
	END
	ELSE IF @para_type = 14
	BEGIN
		SELECT @ResultVar = RIGHT( '0' + DATENAME(hh, @para_datetime), 2) + RIGHT( '0' + DATENAME(mi, @para_datetime), 2 )
		+ RIGHT( '0' + DATENAME(ss, @para_datetime), 2)
	END

	SET @ResultVar = RTRIM(LTRIM(@ResultVar))

	RETURN @ResultVar
END

GO
/*示例
DECLARE @Type INT = 1
DECLARE @Time DATETIME
SET @Time = '2011-09-01 12:37:10'
WHILE @Type <= 14
BEGIN
	PRINT CAST(@Type AS NVARCHAR(10)) + ': ' + dbo.Fun_Report_BD_GetDateTime( @Time, @Type)
	SET @Type += 1
END
*/