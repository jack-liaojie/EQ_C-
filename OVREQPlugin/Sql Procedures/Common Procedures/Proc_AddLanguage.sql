IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddLanguage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddLanguage]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddLanguage]
--描    述: 添加一种语言
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_AddLanguage]
	@LanguageCode				CHAR(3),
	@LanguageDescription		NVARCHAR(50),
	@Order						INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result = 1; 	添加成功！
					  -- @Result = -1;	添加失败，@LanguageCode 重复！

	IF EXISTS (SELECT F_LanguageCode FROM TC_Language WHERE F_LanguageCode = @LanguageCode)
	BEGIN
		SET @Result = -1
		RETURN
	END

	INSERT INTO TC_Language 
		(F_Active, F_LanguageCode, F_LanguageDescription, F_Order)
		VALUES
		(0, @LanguageCode, @LanguageDescription, @Order)

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

-- Add right
exec [Proc_AddLanguage]  'ITA', '水星语', 6, @TestResult OUTPUT
SELECT @TestResult AS [Result 1]
SELECT * FROM TC_Language

-- Add, @LanguageCode 重复！
exec [Proc_AddLanguage]  'ITA', '水星语', 6, @TestResult OUTPUT
SELECT @TestResult AS [Result -1]
SELECT * FROM TC_Language

-- Delete that added for test
exec [Proc_DelLanguage] 'ITA', @TestResult OUTPUT

*/