IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetWindDirection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetWindDirection]
GO
set ANSI_NULLS ON
go
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_TE_GetWindDirection]
--描    述: 获取 WindDirection 列表  
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2011年4月12日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_TE_GetWindDirection]
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT A.F_WindDirectionID AS [WindDirectionID]
		, B.F_WindDirectionLongName AS [WindDirection]
	FROM TC_WindDirection AS A LEFT JOIN TC_WindDirection_Des AS B
		ON A.F_WindDirectionID = B.F_WindDirectionID AND B.F_LanguageCode = @LanguageCode


SET NOCOUNT OFF
END
GO
set QUOTED_IDENTIFIER OFF
go
set ANSI_NULLS OFF
go

