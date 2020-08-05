IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetDateTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetDateTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Fun_AR_GetDateTime]
--��    ��: �� DateTime ����ת�����ַ���
--����˵��: @Type Ϊת�����ַ��������͵���ʽ, 
	/*
		1 - Date(in Title and Birth date), "D MMM YYYY", "YYYY��M��D��"
		2 - Weekday(in Title), "WWW" "����W"
		3 - Weekday + Date + Time(Created Date And Time) "WWW D MMM YYYY H:NN" "YYYY��M��D�� ����W H:NN"
		4 - Time "H:NN"
		5 - Weekday + Date "WWW D MMM YYYY" "YYYY��M��D�� ����W"
		6 - Weekday + Date "WWW D MMM" "M��D�� ����W"
		7 - Date "D MMM" "M��D��"
	*/
--�� �� ��: �޿�
--��    ��: 2011-10-17
--�޸ļ�¼��



CREATE FUNCTION [dbo].[Fun_AR_GetDateTime]
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
	DECLARE @SS				NVARCHAR(10)			-- seconds (with leading zeros)
	
	SET @D =  RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(DD, @DateTime)), 2)
	SET @MMM =  RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(MM, @DateTime)), 2)
	SET @YYYY = DATEPART(yy, @DateTime)
	SET @WWW = DATEPART(dw, @DateTime)
	SET @H =  RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(hh, @DateTime)), 2)
	SET @NN = RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(n, @DateTime)), 2)
	SET @SS = RIGHT(N'00' + CONVERT(NVARCHAR(2), DATEPART(SS, @DateTime)), 2)
	
	-- Ӣ�Ķ� @MMM ���е���
	IF @LanguageCode = 'ENG'
	BEGIN
		-- JAN,FEB,MAR,APR,MAY,JUN,JUL,AUG,SEP,OCT,NOV,DEC
		IF @MMM = N'01'		SET @MMM = N'JAN'
		IF @MMM = N'02'		SET @MMM = N'FEB'
		IF @MMM = N'03'		SET @MMM = N'MAR'
		IF @MMM = N'04'		SET @MMM = N'APR'
		IF @MMM = N'05'		SET @MMM = N'MAY'
		IF @MMM = N'06'		SET @MMM = N'JUN'
		IF @MMM = N'07'		SET @MMM = N'JUL'
		IF @MMM = N'08'		SET @MMM = N'AUG'
		IF @MMM = N'09'		SET @MMM = N'SEP'
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
			--SET @ResultVar = @YYYY + N'��' + @MMM + N'��' + @D + N'��'
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
			--SET @ResultVar = @YYYY + N'��' + @MMM + N'��' + @D + N'�� ' + @WWW + N' ' + @H + N':' + @NN
			SET @ResultVar = @YYYY + N'-' + @MMM + N'-' + @D + N' ' + @WWW + N' ' + @H + N':' + @NN
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
			--SET @ResultVar = @YYYY + N'��' + @MMM + N'��' + @D + N'�� ' + @WWW
			SET @ResultVar = @YYYY + N'-' + @MMM + N'-' + @D + N' ' + @WWW
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
			--SET @ResultVar = @YYYY + N'��' + @MMM + N'��' + @D + N'�� ' + @H + N':' + @NN
			SET @ResultVar = @YYYY + N'-' + @MMM + N'-' + @D + N' ' + @H + N':' + @NN
		END
		ELSE
		BEGIN
			SET @ResultVar = @WWW + N' ' + @D + N' ' + @MMM + N' '
		END
	END

	ELSE IF @Type = 7
	BEGIN
		IF @LanguageCode = 'CHN'
		BEGIN
			SET @ResultVar = @MMM + N'��' + @D + N'�� '
		END
		ELSE
		BEGIN
			SET @ResultVar = @D + N' ' + @MMM + N' '
		END
	END	
	ELSE IF @Type = 8
	BEGIN
		SET @ResultVar = @H + N':' + @NN + '.'+@SS
	END
	RETURN @ResultVar
END
GO


/*
select dbo.Fun_AR_GetDateTime(getdate(),1,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),2,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),3,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),4,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),5,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),6,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),7,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),8,'chn')
select dbo.Fun_AR_GetDateTime(getdate(),9,'chn')
*/