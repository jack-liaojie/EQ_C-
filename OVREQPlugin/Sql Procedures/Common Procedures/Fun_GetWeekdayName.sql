IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetWeekdayName]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetWeekdayName]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--��    �ƣ�[Fun_GetWeekdayName]
--��    �����������ڻ�ȡ���ڼ����������ƻ�Ӣ����д
--����˵���� 
--˵    ����
--�� �� �ˣ������
--��    �ڣ�2009��12��10��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
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
		SET @WeekdayName_CHN = N'������'
		SET @WeekdayName_ENG = N'SUN'
	END
	ELSE IF @Weekday = 2
	BEGIN
		SET @WeekdayName_CHN = N'����һ'
		SET @WeekdayName_ENG = N'MON'
	END
	ELSE IF @Weekday = 3
	BEGIN
		SET @WeekdayName_CHN = N'���ڶ�'
		SET @WeekdayName_ENG = N'TUE'
	END
	ELSE IF @Weekday = 4
	BEGIN
		SET @WeekdayName_CHN = N'������'
		SET @WeekdayName_ENG = N'WED'
	END
	ELSE IF @Weekday = 5
	BEGIN
		SET @WeekdayName_CHN = N'������'
		SET @WeekdayName_ENG = N'THU'
	END
	ELSE IF @Weekday = 6
	BEGIN
		SET @WeekdayName_CHN = N'������'
		SET @WeekdayName_ENG = N'FRI'
	END
	ELSE
	BEGIN
		SET @WeekdayName_CHN = N'������'
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
