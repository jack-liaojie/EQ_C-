IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_ConvertNumberToChinese]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_ConvertNumberToChinese]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		王强
-- Create date: 2011/5/4
-- Description:	将阿拉伯数字转中文
-- =============================================

CREATE FUNCTION [dbo].[Fun_ConvertNumberToChinese]
								(
									@Number   INT
								)
RETURNS NVARCHAR(20)
AS
BEGIN
	IF @Number <= 0 OR @Number >=100
		RETURN ''
	
	DECLARE @Res NVARCHAR(20)	
	DECLARE @HighNum INT
	DECLARE @LowNum INT
	SET @HighNum = @Number/10
	SET @LowNum = @Number%10
	

	SET @Res = CASE @HighNum
				WHEN 2 THEN '二'
				WHEN 3 THEN '三'
				WHEN 4 THEN '四'
				WHEN 5 THEN '五'
				WHEN 6 THEN '六'
				WHEN 7 THEN '七'
				WHEN 8 THEN '八'
				WHEN 9 THEN '九'
				ELSE ''
				END
			
	IF @HighNum > 0
	BEGIN
		SET @Res += '十'	
	END	
	
	SET @Res += CASE @LowNum
				WHEN 1 THEN '一'
				WHEN 2 THEN '二'
				WHEN 3 THEN '三'
				WHEN 4 THEN '四'
				WHEN 5 THEN '五'
				WHEN 6 THEN '六'
				WHEN 7 THEN '七'
				WHEN 8 THEN '八'
				WHEN 9 THEN '九'
				ELSE ''
				END
	RETURN @Res
	
END

GO

