

/****** Object:  StoredProcedure [dbo].[Proc_HB_ListWindDirection]    Script Date: 08/30/2012 08:44:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_ListWindDirection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_ListWindDirection]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_ListWindDirection]    Script Date: 08/30/2012 08:44:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_HB_ListWindDirection]
--描    述: 公路自行车获取 WindDirection 列表  
--参数说明: 
--说    明: 
--创 建 人: 杨佳鹏
--日    期: 2009年12月29日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_HB_ListWindDirection]
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


