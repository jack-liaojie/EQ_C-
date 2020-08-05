IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetLanguageByCode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetLanguageByCode]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_GetLanguageByCode]
--描    述: 根据 LanguageCode 获取一种语言的信息
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_GetLanguageByCode]
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT *
	FROM TC_Language
	WHERE F_LanguageCode = @LanguageCode

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

--exec [Proc_GetLanguageByCode] 'ENG'