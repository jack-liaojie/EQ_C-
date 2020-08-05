IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelLanguage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelLanguage]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_DelLanguage]
--描    述: 删除一种语言
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_DelLanguage]
	@LanguageCode				CHAR(3),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败，标示没有做任何操作！
					  -- @Result = 1; 	删除成功！
					  -- @Result = -1;	删除失败，@LanguageCode 不存在！

	IF NOT EXISTS (SELECT F_LanguageCode FROM TC_Language WHERE F_LanguageCode = @LanguageCode)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DELETE FROM TC_Language 
	WHERE F_LanguageCode = @LanguageCode

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 添加成功
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*
-- Just for Test
DECLARE @TestResult INT

-- Add one language
exec [Proc_AddLanguage]  'ITA', '水星语', 6, @TestResult OUTPUT
SELECT * FROM TC_Language

-- Delete right
exec [Proc_DelLanguage] 'ITA', @TestResult OUTPUT
SELECT * FROM TC_Language
SELECT @TestResult AS [Result 1]

-- Delete, languagecode don't exist
exec [Proc_DelLanguage] 'ITB', @TestResult OUTPUT
SELECT * FROM TC_Language
SELECT @TestResult AS [Result -1]
*/