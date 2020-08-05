IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelPhaseModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelPhaseModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--��    �ƣ�[Proc_DelPhaseModel]
--��    ����ɾ��һPhase�Ľ�������ģ��
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��12��10��



CREATE PROCEDURE [dbo].[Proc_DelPhaseModel](
				@PhaseID			INT,
				@PhaseModelID		INT,
				@Result			AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result=0; 	ɾ����Phase�Ľ�������ģ��ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ����Phase�Ľ�������ģ�ͳɹ���

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TS_Phase_Model_Match_Result_Des WHERE F_PhaseID = @PhaseID AND F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Match_Result WHERE F_PhaseID = @PhaseID AND F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Phase_Position WHERE F_PhaseID = @PhaseID AND F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Phase_Resut WHERE F_PhaseID = @PhaseID AND F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

		DELETE FROM TS_Phase_Model WHERE F_PhaseID = @PhaseID AND F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

