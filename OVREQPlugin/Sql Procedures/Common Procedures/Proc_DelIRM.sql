IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelIRM]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_DelIRM]
--��    ��: ɾ��һ��IRM���� (IRM)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_DelIRM]
	@IRMID					INT,
	@Result					AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ��, ��ʾû�����κβ���!
					  -- @Result = 1; 	ɾ���ɹ�!
					  -- @Result = -1;	ɾ��ʧ��, @IRMID ������!

	IF NOT EXISTS (SELECT F_IRMID FROM TC_IRM WHERE F_IRMID = @IRMID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TC_IRM_Des WHERE F_IRMID = @IRMID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_IRM WHERE F_IRMID = @IRMID

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
DECLARE @IRMID INT
DECLARE @TestResult INT

-- Add one IRM
exec [Proc_AddIRM]  'CHN', 100, 'DIE', '����', '����', '������', @IRMID OUTPUT
SELECT * FROM TC_IRM WHERE F_IRMID = @IRMID
SELECT * FROM TC_IRM_Des WHERE F_IRMID = @IRMID

-- Delete One IRM
exec [Proc_DelIRM] @IRMID, @TestResult OUTPUT
SELECT * FROM TC_IRM WHERE F_IRMID = @IRMID
SELECT * FROM TC_IRM_Des WHERE F_IRMID = @IRMID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TC_IRM_Des WHERE F_IRMID = @IRMID
DELETE FROM TC_IRM WHERE F_IRMID = @IRMID

*/