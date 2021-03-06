IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_ListWindDirection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_ListWindDirection]
GO
set ANSI_NULLS ON
go
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SL_ListWindDirection]
--描    述: 激流回旋获取 WindDirection 列表  
--参数说明: 
--说    明: 
--创 建 人: 
--日    期: 2010年04月09日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_SL_ListWindDirection]
	@LanguageCode					CHAR(3) = 'ANY'		-- 默认取当前激活的语言
AS
BEGIN
SET NOCOUNT ON

	IF @LanguageCode = 'ANY'
	BEGIN
		SELECT @LanguageCode = F_LanguageCode
		FROM TC_Language
		WHERE F_Active = 1
	END

	SELECT A.F_WindDirectionID AS [WindDirectionID]
		, B.F_WindDirectionLongName AS [WindDirection]
	FROM TC_WindDirection AS A
	LEFT JOIN TC_WindDirection_Des AS B
		ON A.F_WindDirectionID = B.F_WindDirectionID AND B.F_LanguageCode = @LanguageCode


SET NOCOUNT OFF
END
GO
set QUOTED_IDENTIFIER OFF
go
set ANSI_NULLS OFF
go

