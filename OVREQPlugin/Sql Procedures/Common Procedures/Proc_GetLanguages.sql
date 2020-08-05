IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLanguages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLanguages]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetLanguages]
--描    述: 获取所有的语言信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月25日



CREATE PROCEDURE [dbo].[Proc_GetLanguages]
AS
BEGIN
SET NOCOUNT ON

	SELECT F_Active AS [Active]
		, F_Order AS [Order]
		, F_LanguageCode AS [Code]
		, F_LanguageDescription AS [Description]
	FROM TC_Language
	ORDER by F_Order

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetLanguages]