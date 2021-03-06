IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetSecondsFromTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetSecondsFromTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		王强
-- Create date: 2011/5/12
-- Description:	从字符串获取秒数
-- =============================================

CREATE FUNCTION [dbo].[Fun_BDTT_GetSecondsFromTime]
								(
									@TimeStr NVARCHAR(20)
								)
RETURNS INT
AS
BEGIN
	IF @TimeStr = '' OR @TimeStr IS NULL
		RETURN NULL
	DECLARE @Res INT
	DECLARE @Time NVARCHAR(20)
	SET @Time = RIGHT('0000' + @TimeStr, 6 )
	SET @Res = 3600*CAST( SUBSTRING( @Time, 1, 2) AS INT )
				+ 60*CAST( SUBSTRING( @Time, 3, 2) AS INT )
	DECLARE @Sec INT
	SET @Sec = CAST( SUBSTRING( @Time, 5, 2) AS INT )
	DECLARE @RoundTime INT
	IF @Res = 0
		 IF @Sec = 0
			SET @RoundTime = 0
		 ELSE
		    SET @RoundTime = 60
	ELSE
	BEGIN
		SET @RoundTime = CASE WHEN @Sec BETWEEN 0 AND 29 THEN 0
							  WHEN @Sec BETWEEN 30 AND 59 THEN 60
							  ELSE 0 END
	END
	
	SET @Res += @RoundTime
	RETURN @Res
END

GO

