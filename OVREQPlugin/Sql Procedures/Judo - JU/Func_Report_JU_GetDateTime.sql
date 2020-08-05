IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_JU_GetDateTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_JU_GetDateTime]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Func_Report_JU_GetDateTime]
--��    ��: �����н� DateTime ����ת�����ַ���
--����˵��: @Type Ϊת�����ַ��������͵���ʽ, 
	/*
		1 - Date(in Title and Birth date), "D MMM YYYY", "YYYY-M-D"
		2 - Weekday(in Title), "WWW" "����W"
		3 - Weekday + Date + Time(Created Date And Time) "WWW D MMM YYYY H:NN" "YYYY��M��D�� ����W H:NN"
		4 - Time "H:NN"
		5 - Weekday + Date "WWW D MMM YYYY" "YYYY��M��D�� ����W"
		6 - Weekday + Date "WWW D MMM" "M��D�� ����W"
	*/
--�� �� ��: �����
--��    ��: 2010��9��15�� ������
--�޸ļ�¼��
/*			
	����					�޸���		�޸�����
*/



CREATE FUNCTION [Func_Report_JU_GetDateTime]
(
	@DateTime				DateTime,
	@Type					INT,
	@LanguageCode			CHAR(3)
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
	Declare @Month			NVARCHAR(10)
	
	SET @D = DATEPART(d, @DateTime)
	SET @Month=DATEPART(m, @DateTime)
	SET @MMM = DATEPART(m, @DateTime)
	SET @YYYY = DATEPART(yy, @DateTime)
	SET @WWW = DATEPART(dw, @DateTime)
	SET @H = DATEPART(hh, @DateTime)
	SET @NN = RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(n, @DateTime)), 2)
	
	-- Ӣ�Ķ� @MMM ���е���
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
	
	-- �� @WWW ���е���
	IF @LanguageCode = 'CHN'
	BEGIN
		IF @WWW = N'1'		SET @WWW = N'������'
		IF @WWW = N'2'		SET @WWW = N'����һ'
		IF @WWW = N'3'		SET @WWW = N'���ڶ�'
		IF @WWW = N'4'		SET @WWW = N'������'
		IF @WWW = N'5'		SET @WWW = N'������'
		IF @WWW = N'6'		SET @WWW = N'������'
		IF @WWW = N'7'		SET @WWW = N'������'
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
			SET @ResultVar = @YYYY + N'-' + @MMM + N'-' + @D
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
			SET @ResultVar = @YYYY + N'��' + @MMM + N'��' + @D + N'�� ' + @WWW + N' ' + @H + N':' + @NN
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
			SET @ResultVar = @YYYY + N'��' + @MMM + N'��' + @D + N'�� ' + @WWW
		END
		ELSE
		BEGIN
			SET @ResultVar = @WWW + N' ' + @D + N' ' + @MMM + N' ' + @YYYY
		END
	END
	ELSE IF @Type = 6
	BEGIN
		IF @LanguageCode = 'CHN'
		BEGIN
			SET @ResultVar = @MMM + N'��' + @D + N'�� ' + @WWW
		END
		ELSE
		BEGIN
			SET @ResultVar = @WWW + N' ' + @D + N' ' + @MMM
		END
	END
	ELSE IF @Type = 7
	BEGIN
		IF @LanguageCode = 'CHN'
		BEGIN
			SET @ResultVar = @YYYY + N'��' +  @Month+ N'��' +@D+N'��' 
		END
		ELSE
		BEGIN
			SET @ResultVar = @YYYY + N'-' +  @Month+ N'-' +@D 
		END
	END
	RETURN @ResultVar

END

/*

-- Just for test
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 1, 'ENG')
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 2, 'ENG')
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 3, 'ENG')
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 4, 'ENG')

select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 1, 'CHN')
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 2, 'CHN')
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 3, 'CHN')
select dbo.[Func_Report_JU_GetDateTime](GETDATE(), 4, 'CHN')

*/