IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_BK_GetDateTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_BK_GetDateTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		张翠霞
-- Create date: 2010/09/15
-- Description:	得到报表样式的日期时间格式  " THU 7 AUG 2008 16:06 "
--修改记录： 
/*			
			时间				修改人		修改内容	
			2012年9月20日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/
-- =============================================


CREATE FUNCTION [dbo].[Func_Report_BK_GetDateTime]
(
	@para_datetime	datetime, 
	@para_type	int -- 1 WEEK+DATE+TIME, 2 WEEK+DATE, 3 TIME, 4 BIRTH DATE, 5 WEEK+DAY+MON, 
	                -- 6 "15 SEP 2010", 7 "15 SEP", 8 "2010-9-15", 9 "2010-09-15 02:34"
	                -- 10"2010-09-15", 11 "02:34"
)
RETURNS NvarCHAR(30)
AS
BEGIN
	DECLARE @ResultVar AS NVARCHAR(30)
	DECLARE @TempVar1 AS NVARCHAR(30)
	DECLARE @TempVar2 AS NVARCHAR(30)

    SET @TempVar1 = ''
    SET @TempVar2 = ''
    
	IF @para_type = 1
	BEGIN
	SELECT @ResultVar = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3)) + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) + ' '
		+ DATENAME(yyyy,@para_datetime) + ' ' + DATENAME(hh,@para_datetime) + ':' + RIGHT('00' + DATENAME(n,@para_datetime), 2)
	END

	IF @para_type = 2
	BEGIN
	SELECT @ResultVar = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3)) + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) + ' '	+ DATENAME(yyyy,@para_datetime) 
	END

	IF @para_type = 3
	BEGIN
		SELECT @ResultVar =  DATENAME(hh,@para_datetime) + ':' + RIGHT('00' + DATENAME(n,@para_datetime),2)
	END

	IF @para_type = 4
	BEGIN
		SELECT @ResultVar =  datename(dd, @para_datetime) + ' ' + upper(substring(datename(month, @para_datetime),1,3)) + ' ' + cast(year(@para_datetime) as char(4))
	END

	IF @para_type = 5
	BEGIN
	SELECT @ResultVar = UPPER(SUBSTRING(DATENAME(dw, @para_datetime),1,3)) + ' ' + DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) 
	END

	IF @para_type = 6
	BEGIN
	SELECT @ResultVar = DATENAME(d,@para_datetime) 
		+ ' ' + UPPER(SUBSTRING(DATENAME(m, @para_datetime),1,3)) + ' '	+ DATENAME(yyyy,@para_datetime) 
	END
	
	IF @para_type = 7
	BEGIN
		SELECT @ResultVar =  datename(dd, @para_datetime) + ' ' + upper(substring(datename(month, @para_datetime),1,3))
	END
	
	IF @para_type = 8
	BEGIN
	    SELECT @ResultVar = CAST(DATENAME(yyyy, @para_datetime) AS NVARCHAR(10)) + '-' + CAST(DATEPART(month, @para_datetime) AS NVARCHAR(10)) + '-' + CAST(DATENAME(d,@para_datetime) AS NVARCHAR(10))
	END

	IF @para_type = 9
	BEGIN
	    SELECT @TempVar1 = CAST(DATENAME(yyyy, @para_datetime) AS NVARCHAR(10)) 
	    + '-' + RIGHT('00' + CAST(DATEPART(month, @para_datetime) AS NVARCHAR(10)), 2) 
	    + '-' + RIGHT('00' + CAST(DATENAME(d,@para_datetime) AS NVARCHAR(10)), 2)
	    SELECT @TempVar2 = RIGHT('00' + CAST(DATENAME(hh, @para_datetime) AS NVARCHAR(10)), 2)
	    + ':' + RIGHT('00' + CAST(DATEPART(n, @para_datetime) AS NVARCHAR(10)), 2) 
	    
	    SET @ResultVar = @TempVar1 + ' ' + @TempVar2
	END

	IF @para_type = 10
	BEGIN
	    SELECT @TempVar1 = CAST(DATENAME(yyyy, @para_datetime) AS NVARCHAR(10)) 
	    + '-' + RIGHT('00' + CAST(DATEPART(month, @para_datetime) AS NVARCHAR(10)), 2) 
	    + '-' + RIGHT('00' + CAST(DATENAME(d,@para_datetime) AS NVARCHAR(10)), 2)
	    SELECT @TempVar2 = '' 
	    
	    SET @ResultVar = @TempVar1
	END

	IF @para_type = 11
	BEGIN
	    SELECT @TempVar1 = ''
	    SELECT @TempVar2 = RIGHT('00' + CAST(DATENAME(hh, @para_datetime) AS NVARCHAR(10)), 2)
	    + ':' + RIGHT('00' + CAST(DATEPART(n, @para_datetime) AS NVARCHAR(10)), 2) 
	    
	    SET @ResultVar = @TempVar2
	END

	SET @ResultVar = RTRIM(LTRIM(@ResultVar))

	RETURN @ResultVar
END



GO


