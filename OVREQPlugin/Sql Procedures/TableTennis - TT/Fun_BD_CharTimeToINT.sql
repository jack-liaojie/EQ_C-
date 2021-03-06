IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_CharTimeToINT]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_CharTimeToINT]
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

CREATE FUNCTION [dbo].[Fun_BD_CharTimeToINT]
								(
									@SpendTimeCHAR   NVARCHAR(10)
								)
RETURNS INT
AS
BEGIN

    DECLARE @TimeINT AS INT
    SET @TimeINT = 0
    
    IF @SpendTimeCHAR IS NULL
    BEGIN
        RETURN 0
    END

	DECLARE @Hour AS NVARCHAR(2)
	DECLARE @Minute AS NVARCHAR(2)
	DECLARE @Second AS NVARCHAR(2)
	
	DECLARE @SecondIndex AS INT
	DECLARE @MiniteIndex AS INT
	
	SET @MiniteIndex = CHARINDEX(':', @SpendTimeCHAR)
	IF @MiniteIndex > 0
	BEGIN
	    SET @Hour = LEFT(@SpendTimeCHAR, @MiniteIndex-1)
	    SET @SpendTimeCHAR = RIGHT(@SpendTimeCHAR, LEN(@SpendTimeCHAR) - @MiniteIndex)
	END
	ELSE
	BEGIN
	    RETURN 0
	END
	
	SET @SecondIndex = CHARINDEX(':', @SpendTimeCHAR)
	IF @SecondIndex > 0
	BEGIN
	    SET @Minute = LEFT(@SpendTimeCHAR, @SecondIndex-1)
	    SET @Second = RIGHT(@SpendTimeCHAR, LEN(@SpendTimeCHAR) - @MiniteIndex)
	END
	ELSE
	BEGIN
	    RETURN 0
	END
	
	SET @TimeINT = CAST(@Hour AS INT) * 3600 + CAST(@Minute AS INT) * 60 + CAST(@Second AS INT)
	
	IF @TimeINT IS NULL
	SET @TimeINT = 0
	RETURN @TimeINT

END

GO

