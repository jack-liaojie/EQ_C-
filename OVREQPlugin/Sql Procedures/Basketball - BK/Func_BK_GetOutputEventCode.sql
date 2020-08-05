IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_BK_GetOutputEventCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_BK_GetOutputEventCode]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



---- =============================================
---- Author:		Wu Dingfang
---- Create date: 2012/09/12
---- Description:	得到输出格式的EventCode，满足不同的赛事，执行不同的公共代码。
----修改记录： 
/*			
			时间				修改人		修改内容	
*/
---- =============================================


CREATE FUNCTION [dbo].[Func_BK_GetOutputEventCode]
(
    @GenderCode NVARCHAR(10),
	@EventCode	NVARCHAR(30)
)
RETURNS NvarCHAR(30)
AS
BEGIN
	DECLARE @OutputEventCode AS NVARCHAR(30)
    
	IF @GenderCode = 'M' AND @EventCode = '101'
	BEGIN
	  SET @OutputEventCode = '511'
	END
	ELSE IF @GenderCode = 'M' AND @EventCode = '102'
	BEGIN
	  SET @OutputEventCode = '512'
	END
	ELSE IF @GenderCode = 'W' AND @EventCode = '001'
	BEGIN
	  SET @OutputEventCode = '501'
	END
	ELSE IF @GenderCode = 'W' AND @EventCode = '002'
	BEGIN
	  SET @OutputEventCode = '502'
	END


	RETURN @OutputEventCode
END



GO


