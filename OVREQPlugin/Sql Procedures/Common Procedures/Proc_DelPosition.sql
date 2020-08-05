IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_DelPosition]
--��    ��: ɾ��һ��Position���� (Position)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_DelPosition]
	@PositionID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ��, ��ʾû�����κβ���!
					  -- @Result = 1; 	ɾ���ɹ�!
					  -- @Result = -1;	ɾ��ʧ��, @PositionID ������!

	IF NOT EXISTS (SELECT F_PositionID FROM TD_Position WHERE F_PositionID = @PositionID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TD_Position_Des WHERE F_PositionID = @PositionID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        DELETE FROM TD_Position WHERE F_PositionID = @PositionID

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
DECLARE @PositionID INT
DECLARE @TestResult INT

-- Add one Position
exec [Proc_AddPosition]  'CHN', 3, '��������', '��������', '��������', @PositionID OUTPUT
SELECT * FROM TD_Position WHERE F_PositionID = @PositionID
SELECT * FROM TD_Position_Des WHERE F_PositionID = @PositionID

-- Delete One Position
exec [Proc_DelPosition] @PositionID, @TestResult OUTPUT
SELECT * FROM TD_Position WHERE F_PositionID = @PositionID
SELECT * FROM TD_Position_Des WHERE F_PositionID = @PositionID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TD_Position_Des WHERE F_PositionID = @PositionID
DELETE FROM TD_Position WHERE F_PositionID = @PositionID

*/