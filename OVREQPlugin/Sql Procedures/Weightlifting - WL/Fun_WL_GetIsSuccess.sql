IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_WL_GetIsSuccess]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_WL_GetIsSuccess]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_WL_GetIsSuccess]
								(
									@AttemptRes					INT
								)
RETURNS  NVARCHAR(10)
AS
BEGIN
	
	DECLARE @IsSuccess	    NVARCHAR(10)
	SET @IsSuccess =  N'Y'
	IF (@AttemptRes IS NOT NULL)
	BEGIN
    IF @AttemptRes = '100' OR @AttemptRes = '10' OR @AttemptRes = '1' OR 
       @AttemptRes = '0' OR @AttemptRes = '010' OR @AttemptRes = '001' OR @AttemptRes = '000'
       SET @IsSuccess = N'N' 
       
    ELSE IF @AttemptRes = '222'
       SET @IsSuccess = '_' 
	END
	ELSE BEGIN SET @IsSuccess = N''  END
	
	RETURN @IsSuccess

END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*
SELECT dbo.Fun_WL_GetIsSuccess(222)
*/