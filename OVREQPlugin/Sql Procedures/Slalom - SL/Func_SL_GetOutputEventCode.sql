IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SL_GetOutputEventCode]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SL_GetOutputEventCode]
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


CREATE FUNCTION [dbo].[Func_SL_GetOutputEventCode]
(
    @GenderCode NVARCHAR(10),
	@EventCode	NVARCHAR(30)
)
RETURNS NvarCHAR(30)
AS
BEGIN
	DECLARE @OutputEventCode AS NVARCHAR(30)
    
	IF @GenderCode = 'M' AND @EventCode = '110'
	BEGIN
	  SET @OutputEventCode = '101'
	END
	ELSE IF @GenderCode = 'M' AND @EventCode = '210'
	BEGIN
	  SET @OutputEventCode = '102'
	END
	ELSE IF @GenderCode = 'M' AND @EventCode = '220'
	BEGIN
	  SET @OutputEventCode = '203'
	END
	ELSE IF @GenderCode = 'W' AND @EventCode = '110'
	BEGIN
	  SET @OutputEventCode = '001'
	END


	RETURN @OutputEventCode
END



GO


