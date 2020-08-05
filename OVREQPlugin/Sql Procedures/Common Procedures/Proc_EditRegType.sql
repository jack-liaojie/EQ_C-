IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditRegType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditRegType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_EditRegType]
--��    ��: �޸�һ��ע������ (RegType)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_EditRegType]
	@RegTypeID					INT,
	@LanguageCode				CHAR(3),
	@RegTypeLongDescription		NVARCHAR(50),
	@RegTypeShortDescription	NVARCHAR(50),
	@RegTypeComment				NVARCHAR(100),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	����ʧ�ܣ���ʾû�����κβ�����
					  -- @Result = 1; 	���³ɹ���
					  -- @Result = -1;	����ʧ�ܣ�@RegTypeID �����ڣ�

	IF NOT EXISTS (SELECT F_RegTypeID FROM TC_RegType WHERE F_RegTypeID = @RegTypeID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	-- Des �����и����Ե������͸���, û�������
	IF EXISTS (SELECT F_RegTypeID FROM TC_RegType_Des 
				WHERE F_RegTypeID = @RegTypeID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TC_RegType_Des 
		SET F_RegTypeLongDescription = @RegTypeLongDescription
			, F_RegTypeShortDescription = @RegTypeShortDescription
			, F_RegTypeComment = @RegTypeComment
		WHERE F_RegTypeID = @RegTypeID
			AND F_LanguageCode = @LanguageCode
	END
	ELSE
	BEGIN
		INSERT INTO TC_RegType_Des 
			(F_RegTypeID, F_LanguageCode, F_RegTypeLongDescription, F_RegTypeShortDescription, F_RegTypeComment) 
			VALUES
			(@RegTypeID, @LanguageCode, @RegTypeLongDescription, @RegTypeShortDescription, @RegTypeComment)
	END

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- ���³ɹ�
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
DECLARE @RegTypeID INT
DECLARE @TestResult INT

-- Add one RegType
exec [Proc_AddRegType]  'CHN', 'Ъ��', 'Ъ��', 'Ъ��', @RegTypeID OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID

-- Update One RegType
exec [Proc_EditRegType] @RegTypeID, 'CHN', '��ƨ', '��ƨ', '��ƨ', @TestResult OUTPUT
exec [Proc_EditRegType] @RegTypeID, 'ENG', 'Die', 'Die', 'Die', @TestResult OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
SELECT @TestResult AS [RESULT 1]

-- Update, @RegTypeID ������
SET @RegTypeID = @RegTypeID + 1
exec [Proc_EditRegType] @RegTypeID, 'CHN', '��ƨ', '��ƨ', '��ƨ', @TestResult OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
SELECT @TestResult AS [RESULT -1]

-- Delete that added for test
SET @RegTypeID = @RegTypeID - 1
DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
DELETE FROM TC_RegType WHERE F_RegTypeID = @RegTypeID

*/