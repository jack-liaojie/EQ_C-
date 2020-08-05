if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdatePhaseRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdatePhaseRegister]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdatePhaseRegister]
----��		  �ܣ�����С������ǩλ
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-17

CREATE PROCEDURE [dbo].[Proc_UpdatePhaseRegister] (	
	@PhaseID					INT,
	@PhasePosition		INT,
	@RegisterID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	�༭Sportʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�༭Sport�ɹ���

	IF (@RegisterID = -2 OR @RegisterID = 0)
	BEGIN
		SET @RegisterID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Phase_Position SET F_RegisterID = @RegisterID 
			WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @PhasePosition
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END
		
		UPDATE TS_Match_Result SET F_RegisterID = @RegisterID
			WHERE F_StartPhaseID = @PhaseID AND F_StartPhasePosition = @PhasePosition

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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

