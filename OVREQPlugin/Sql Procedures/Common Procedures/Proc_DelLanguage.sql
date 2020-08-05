IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelLanguage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelLanguage]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_DelLanguage]
--��    ��: ɾ��һ������
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_DelLanguage]
	@LanguageCode				CHAR(3),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ�ܣ���ʾû�����κβ�����
					  -- @Result = 1; 	ɾ���ɹ���
					  -- @Result = -1;	ɾ��ʧ�ܣ�@LanguageCode �����ڣ�

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

	SET @Result = 1		-- ��ӳɹ�
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
exec [Proc_AddLanguage]  'ITA', 'ˮ����', 6, @TestResult OUTPUT
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