if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelDiscipline]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelDiscipline]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�proc_DelDiscipline
----��		  �ܣ�ɾ��һ��Discipline����ɾ����Discipline�����е���Event����Phase������ɾ�����е�Match����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-09

CREATE PROCEDURE proc_DelDiscipline 
	@DisciplineID		INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ��Disciplineʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��Discipline�ɹ���
					-- @Result=-1; 	ɾ��Disciplineʧ�ܣ���DisciplineID��Ч
					-- @Result=-2; 	ɾ��Disciplineʧ�ܣ���Discipline��״̬������ɾ��

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
		
		DECLARE @EventID		AS INT
		DECLARE @DelEventResult	AS INT

		DECLARE Event_Cursor CURSOR FOR 
			SELECT F_EventID
				FROM TS_Event WHERE F_DisciplineID = @DisciplineID

		OPEN Event_Cursor
		FETCH NEXT FROM Event_Cursor INTO @EventID
   
		WHILE @@FETCH_STATUS = 0
		BEGIN

			EXEC proc_DelEvent @EventID, @DelEventResult output

			IF @DelEventResult != 1
			BEGIN
				ROLLBACK
				SET @Result = 0
				RETURN
			END

			FETCH NEXT FROM Event_Cursor INTO @EventID

		END

		CLOSE Event_Cursor
		DEALLOCATE Event_Cursor


		DELETE FROM TS_ActiveNOC WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_ActiveFederation WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_ActiveClub WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Session WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Discipline_Des WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
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

