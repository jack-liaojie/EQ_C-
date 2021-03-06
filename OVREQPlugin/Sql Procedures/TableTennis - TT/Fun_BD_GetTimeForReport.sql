
GO

/****** Object:  UserDefinedFunction [dbo].[Fun_BD_GetTimeForReport]    Script Date: 10/15/2010 11:26:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_GetTimeForReport]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_GetTimeForReport]
GO


GO

/****** Object:  UserDefinedFunction [dbo].[Fun_BD_GetTimeForReport]    Script Date: 10/15/2010 11:26:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		张翠霞
-- Create date: 2010/7/14
-- Description:	得到报表所需的时间格式**小时**分钟**秒
-- =============================================

CREATE FUNCTION [dbo].[Fun_BD_GetTimeForReport]
								(
									@SpendTimeINT   INT,
									@LanguageCode   CHAR(3)
								)
RETURNS NVARCHAR(10)
AS
BEGIN

    DECLARE @TimeCHAR AS NVARCHAR(10)
    SET @TimeCHAR = ''

	DECLARE @Hour AS INT
	DECLARE @Minute AS INT
	DECLARE @Second AS INT
	
	SET @Hour = @SpendTimeINT / 3600
	SET @Minute = (@SpendTimeINT - @Hour * 3600) / 60
	SET @Second = (@SpendTimeINT - @Hour * 3600) % 60
	
	IF @LanguageCode = 'ENG'
	BEGIN
	  SET @TimeCHAR = (CASE WHEN @Hour <> 0 THEN CAST(@Hour AS NVARCHAR(2)) + 'h' ELSE '' END) + (CASE WHEN @Minute <> 0 THEN CAST(@Minute AS NVARCHAR(2)) + 'm' ELSE '' END) + (CASE WHEN @Second <> 0 THEN CAST(@Second AS NVARCHAR(2)) + 's' ELSE '' END)
	END
	ELSE IF @LanguageCode = 'CHN'
	BEGIN
	  SET @TimeCHAR = (CASE WHEN @Hour <> 0 THEN CAST(@Hour AS NVARCHAR(2)) + '小时' ELSE '' END) + (CASE WHEN @Minute <> 0 THEN CAST(@Minute AS NVARCHAR(2)) + '分' ELSE '' END) + (CASE WHEN @Second <> 0 THEN CAST(@Second AS NVARCHAR(2)) + '秒' ELSE '' END)
	END
	
	RETURN @TimeCHAR

END

GO

