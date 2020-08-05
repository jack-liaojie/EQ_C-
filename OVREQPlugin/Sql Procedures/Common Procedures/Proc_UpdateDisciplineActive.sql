if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateDisciplineActive]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateDisciplineActive]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateDisciplineActive]
----��		  �ܣ�����Discipline����״̬
----��		  �ߣ�֣���� 
----��		  ��: 2009-08-13

CREATE PROCEDURE [dbo].[Proc_UpdateDisciplineActive] (	
	@DisciplineID					INT,
	@Active							INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	�༭Discipline����״̬ʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�༭Discipline����״̬�ɹ���
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����



		IF (@Active = 1)
		BEGIN
			UPDATE TS_Discipline SET F_Active = @Active 
				WHERE F_DisciplineID = @DisciplineID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END

			UPDATE TS_Discipline SET F_Active = 0 WHERE F_DisciplineID != @DisciplineID
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
				IF EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_Active = 1 AND F_DisciplineID <> @DisciplineID)
				BEGIN
					UPDATE TS_Discipline SET F_Active = @Active 
						WHERE F_DisciplineID = @DisciplineID
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

