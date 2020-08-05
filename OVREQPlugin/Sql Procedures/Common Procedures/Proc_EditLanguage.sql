IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditLanguage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditLanguage]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_EditLanguage]
--描    述: 修改一种语言
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_EditLanguage]
	@OldLanguageCode			CHAR(3),
	@NewLanguageCode			CHAR(3),
	@LanguageDescription		NVARCHAR(50),
	@Order						INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					  -- @Result = 1; 	更新成功！
					  -- @Result = -1;	更新失败，@OldLanguageCode 不存在！
					  -- @Result = -2;  更新失败, @OldLanguageCode 与 @NewLanguageCode 不相同, 而 @NewLanguageCode 重复

	IF NOT EXISTS (SELECT F_LanguageCode FROM TC_Language WHERE F_LanguageCode = @OldLanguageCode)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF ( 
		@NewLanguageCode <> @OldLanguageCode 
		AND
		EXISTS (SELECT F_LanguageCode FROM TC_Language WHERE F_LanguageCode = @NewLanguageCode)
		)
	BEGIN
		SET @Result = -2
		RETURN
	END

	Update TC_Language 
	SET F_LanguageCode = @NewLanguageCode
		, F_LanguageDescription = @LanguageDescription
		, F_Order = @Order
	WHERE F_LanguageCode = @OldLanguageCode

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 更新成功
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

-- Add there languages
exec [Proc_AddLanguage]  'ITA', '水星语', 6, @TestResult OUTPUT
exec [Proc_AddLanguage]  'ITB', '金星语', 7, @TestResult OUTPUT
exec [Proc_AddLanguage]  'ITC', '火星语', 8, @TestResult OUTPUT
SELECT * FROM TC_Language

-- Update right
exec [Proc_EditLanguage] 'ITB', 'ITD', '木星语', 9, @TestResult OUTPUT
SELECT * FROM TC_Language
SELECT @TestResult AS [Result 1]

-- Update, old languagecode don't exist
exec [Proc_EditLanguage] 'ITE', 'ITE', '土星语', 10, @TestResult OUTPUT
SELECT * FROM TC_Language
SELECT @TestResult AS [Result -1]

-- Update, @OldLanguageCode 与 @NewLanguageCode 不相同, 而 @NewLanguageCode 重复
exec [Proc_EditLanguage] 'ITA', 'ITC', '火星语', 8, @TestResult OUTPUT
SELECT * FROM TC_Language
SELECT @TestResult AS [Result -2]

-- Delete that added for test
exec [Proc_DelLanguage] 'ITA', @TestResult OUTPUT
exec [Proc_DelLanguage] 'ITC', @TestResult OUTPUT
exec [Proc_DelLanguage] 'ITD', @TestResult OUTPUT
SELECT * FROM TC_Language

*/