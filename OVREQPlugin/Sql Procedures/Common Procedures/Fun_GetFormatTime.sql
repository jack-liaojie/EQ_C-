IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetFormatTime]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetFormatTime]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_GetFormatTime]
								(
									@SecondCount			INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	if(@SecondCount<=0 or @SecondCount is null)
		return null

	DECLARE @ResultDes AS NVARCHAR(100)
	DECLARE @tmpHour as INT
	DECLARE @tmpMinute as INT
	DECLARE @tmpSecond as INT

	SET @tmpHour = @SecondCount/3600
	SET @tmpMinute = (@SecondCount%3600)/60
	Set @tmpSecond = (@SecondCount%3600)%60

	set @ResultDes = cast(@tmpHour as nvarchar(20)) + ':' + right(100+cast(@tmpMinute as nvarchar(20)),2)
		
	
	RETURN @ResultDes

END



GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO