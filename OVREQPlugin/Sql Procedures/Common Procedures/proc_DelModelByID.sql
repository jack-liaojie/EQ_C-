IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelModelByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelModelByID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[proc_DelModelByID]
----��		  �ܣ�ɾ�����Ŵ洢Ϊģ��
----��		  �ߣ�֣����
----��		  ��: 2009-08-20 

CREATE PROCEDURE [dbo].[proc_DelModelByID]
	@ModelID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	ɾ�����Ŵ洢ģ��ʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	ɾ�����Ŵ洢ģ�ͳɹ���

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����


		DELETE FROM TM_Match_Model_Match_Result_Des WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Match_Model_Match_Result WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Match_Model WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Model_Match_Result_Des WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Model_Match_Result WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Model_Phase_Position WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Model_Phase_Resut WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Model WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Match_Result_Des WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Match_Result WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Match_Des WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Match WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_MatchPoint WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Result WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Position WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase_Des WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Phase WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END


		DELETE FROM TM_Round_Des WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Round WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Event_Result WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TM_Model WHERE F_ModelID = @ModelID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


