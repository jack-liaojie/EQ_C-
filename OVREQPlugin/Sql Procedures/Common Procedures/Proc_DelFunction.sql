IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelFunction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_DelFunction]
--��    ��: ɾ��һ��Function���� (Function)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_DelFunction]
	@FunctionID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ��, ��ʾû�����κβ���!
					  -- @Result = 1; 	ɾ���ɹ�!
					  -- @Result = -1;	ɾ��ʧ��, @FunctionID ������!

	IF NOT EXISTS (SELECT F_FunctionID FROM TD_Function WHERE F_FunctionID = @FunctionID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TD_Function_Des WHERE F_FunctionID = @FunctionID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        DELETE FROM TD_Function WHERE F_FunctionID = @FunctionID

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

	SET @Result = 1		-- ɾ���ɹ�
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
DECLARE @FunctionID INT
DECLARE @TestResult INT

-- Add one Function
exec [Proc_AddFunction]  'CHN', 3, '��������', '��������', '��������', @FunctionID OUTPUT
SELECT * FROM TD_Function WHERE F_FunctionID = @FunctionID
SELECT * FROM TD_Function_Des WHERE F_FunctionID = @FunctionID

-- Delete One Function
exec [Proc_DelFunction] @FunctionID, @TestResult OUTPUT
SELECT * FROM TD_Function WHERE F_FunctionID = @FunctionID
SELECT * FROM TD_Function_Des WHERE F_FunctionID = @FunctionID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TD_Function_Des WHERE F_FunctionID = @FunctionID
DELETE FROM TD_Function WHERE F_FunctionID = @FunctionID

*/