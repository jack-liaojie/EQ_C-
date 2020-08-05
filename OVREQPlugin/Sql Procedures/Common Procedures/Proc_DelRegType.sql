IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelRegType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelRegType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_DelRegType]
--��    ��: ɾ��һ��ע������ (RegType)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_DelRegType]
	@RegTypeID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ��, ��ʾû�����κβ���!
					  -- @Result = 1; 	ɾ���ɹ�!
					  -- @Result = -1;	ɾ��ʧ��, @RegTypeID ������!
					  -- @Result = -2;  ɾ��ʧ�ܣ��� RegType �ѱ�ʹ��

	IF NOT EXISTS (SELECT F_RegTypeID FROM TC_RegType WHERE F_RegTypeID = @RegTypeID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_RegTypeID FROM TR_Register WHERE F_RegTypeID = @RegTypeID)
    BEGIN
        SET @Result = -2
        RETURN
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_RegType WHERE F_RegTypeID = @RegTypeID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

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
DECLARE @RegTypeID INT
DECLARE @TestResult INT

-- Add one RegType
exec [Proc_AddRegType]  'CHN', 'Ъ��', 'Ъ��', 'Ъ��', @RegTypeID OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID

-- Delete One RegType
exec [Proc_DelRegType] @RegTypeID, @TestResult OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
DELETE FROM TC_RegType WHERE F_RegTypeID = @RegTypeID

*/