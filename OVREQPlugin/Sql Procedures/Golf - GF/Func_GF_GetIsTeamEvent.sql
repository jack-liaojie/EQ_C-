IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_GF_GetIsTeamEvent]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_GF_GetIsTeamEvent]
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


CREATE FUNCTION [dbo].[Func_GF_GetIsTeamEvent]
(
    @GenderCode NVARCHAR(10),
	@EventCode	NVARCHAR(30)
)
RETURNS INT
AS
BEGIN
	DECLARE @IsTeamEvent AS INT
	SET @IsTeamEvent = 0
    
    --男子个人
	IF @GenderCode = 'M' AND @EventCode = '001'    
	BEGIN
	  SET @IsTeamEvent = 0
	END
	--男子团体
	ELSE IF @GenderCode = 'M' AND @EventCode = '002'
	BEGIN
	  SET @IsTeamEvent = 1
	END
    --女子个人
	ELSE IF @GenderCode = 'W' AND @EventCode = '101'
	BEGIN
	  SET @IsTeamEvent = 0
	END
	--女子团体
	ELSE IF @GenderCode = 'W' AND @EventCode = '102'
	BEGIN
	  SET @IsTeamEvent = 1
	END


	RETURN @IsTeamEvent
END



GO


