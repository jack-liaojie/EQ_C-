IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_INTTimeToChar]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_INTTimeToChar]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		张翠霞
-- Create date: 2010/7/14
-- Description:	改变时间格式
-- =============================================

CREATE FUNCTION [dbo].[Fun_BD_INTTimeToChar]
								(
									@SpendTimeINT   INT
								)
RETURNS NVARCHAR(10)
AS
BEGIN

    DECLARE @TimeCHAR AS NVARCHAR(10)
    SET @TimeCHAR = ''

	DECLARE @Hour AS NVARCHAR(2)
	DECLARE @Minute AS NVARCHAR(2)
	DECLARE @Second AS NVARCHAR(2)
	
	SET @Hour = RIGHT('00' + CAST(@SpendTimeINT / 3600 AS NVARCHAR(10)), 2)
	SET @Minute = RIGHT('00' + CAST((@SpendTimeINT - @Hour * 3600) / 60 AS NVARCHAR(10)), 2)
	SET @Second = RIGHT('00' + CAST((@SpendTimeINT - @Hour * 3600) % 60 AS NVARCHAR(10)), 2)
	
	SET @TimeCHAR = @Hour + ':' + @Minute + ':' + @Second
	
	IF @TimeCHAR IS NULL
	SET @TimeCHAR = '00:00:00'
	RETURN @TimeCHAR

END

GO

