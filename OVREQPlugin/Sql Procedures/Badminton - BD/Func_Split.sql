IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Split]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


---分割字符串
----作		  者：王强
----日		  期: 2012-05-28 
----修改	记录:


CREATE FUNCTION [dbo].[Func_Split]
(
	@InputString NVARCHAR(1000),
	@Keyword NVARCHAR(1)
)
RETURNS @retTable TABLE(
							F_Value NVARCHAR(10)
							)
AS
BEGIN

	WHILE(CHARINDEX(@Keyword,@InputString)<>0)
		BEGIN
		  INSERT @retTable(F_Value) VALUES (SUBSTRING(@InputString,1,CHARINDEX(@Keyword,@InputString)-1))
		  SET @InputString = STUFF(@InputString,1,CHARINDEX(@Keyword,@InputString),'')
		END
    INSERT @retTable(F_Value) VALUES (@InputString)
    RETURN
END

GO


