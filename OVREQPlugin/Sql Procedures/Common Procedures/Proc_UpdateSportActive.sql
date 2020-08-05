if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateSportActive]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateSportActive]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateSportActive]
----��		  �ܣ�����Sport����״̬
----��		  �ߣ�֣���� 
----��		  ��: 2009-08-13

CREATE PROCEDURE [dbo].[Proc_UpdateSportActive] (	
	@SportID					INT,
	@Active						INT,
	@Result						INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	�༭Sport����״̬ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�༭Sport����״̬�ɹ���
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		IF (@Active = 1)
		BEGIN
			UPDATE TS_Sport SET F_Active = @Active 
				WHERE F_SportID = @SportID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END

			UPDATE TS_Sport SET F_Active = 0 WHERE F_SportID != @SportID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			IF (@Active = 0)
			BEGIN
				IF EXISTS(SELECT F_SportID FROM TS_Sport WHERE F_Active = 1 AND F_SportID <> @SportID)
				BEGIN
					UPDATE TS_Sport SET F_Active = @Active 
						WHERE F_SportID = @SportID
					IF @@error<>0  --����ʧ�ܷ���  
					BEGIN 
						ROLLBACK   --����ع�
						SET @Result=0
						RETURN
					END
				END
			END
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

