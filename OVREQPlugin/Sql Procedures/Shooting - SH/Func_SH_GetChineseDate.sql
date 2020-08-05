
	
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetChineseDate]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetChineseDate]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [Func_SH_GetChineseDate]
(
	@para_datetime	datetime
)
RETURNS NvarCHAR(30)
AS
BEGIN

	return 
	 cast(DATEPART(year, @para_datetime ) as nvarchar(4)) + '-'
		+ right(N'00' + cast(DATEPART(month, @para_datetime ) as nvarchar(2)),2) + '-'
		+ right(N'00' + cast(DATEPART(day, @para_datetime ) as nvarchar(2)),2) 

END
GO


-- select  dbo.[Func_SH_GetChineseDate] (  getdate() )