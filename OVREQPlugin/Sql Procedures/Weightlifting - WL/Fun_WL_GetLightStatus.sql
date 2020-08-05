IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_WL_GetLightStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_WL_GetLightStatus]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_WL_GetLightStatus]
								(
									@AttemptRes					INT,
									@LightNum				INT
								)
RETURNS CHAR(1)
AS
BEGIN

	DECLARE @CurrentDes	    nvarchar(10)
	SET @CurrentDes = Convert(varchar(10),right('000'+Convert(varchar(3),@AttemptRes),3))

	RETURN SUBSTRING(@CurrentDes,@LightNum,1)

END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO