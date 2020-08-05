IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddRegType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddRegType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_AddRegType]
--��    ��: ���һ��ע������ (RegType)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_AddRegType]
	@LanguageCode				CHAR(3),
	@RegTypeLongDescription		NVARCHAR(50),
	@RegTypeShortDescription	NVARCHAR(50),
	@RegTypeComment				NVARCHAR(100),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	���ʧ�ܣ���ʾû�����κβ�����
					  -- @Result >= 1; 	��ӳɹ�����ֵ��Ϊ RegTypeID

	DECLARE @NewRegTypeID AS INT

    IF EXISTS(SELECT F_RegTypeID FROM TC_RegType)
	BEGIN
      SELECT @NewRegTypeID = MAX(F_RegTypeID) FROM TC_RegType
      SET @NewRegTypeID = @NewRegTypeID + 1
	END
	ELSE
	BEGIN
		SET @NewRegTypeID = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		INSERT INTO TC_RegType (F_RegTypeID) VALUES(@NewRegTypeID)

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_RegType_Des 
			(F_RegTypeID, F_LanguageCode, F_RegTypeLongDescription, F_RegTypeShortDescription, F_RegTypeComment) 
			VALUES
			(@NewRegTypeID, @LanguageCode, @RegTypeLongDescription, @RegTypeShortDescription, @RegTypeComment)

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = @NewRegTypeID
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
exec [Proc_AddRegType]  'CHN', 'Ъ��', 'Ъ��', 'Ъ��', @TestResult OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @TestResult
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @TestResult

-- Delete that added for test
DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @TestResult
DELETE FROM TC_RegType WHERE F_RegTypeID = @TestResult

*/