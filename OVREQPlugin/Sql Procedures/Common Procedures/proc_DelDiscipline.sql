if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelDiscipline]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelDiscipline]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_DelDiscipline
----功		  能：删除一个Discipline，将删除此Discipline下所有的子Event、子Phase，并且删除所有的Match，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09

CREATE PROCEDURE proc_DelDiscipline 
	@DisciplineID		INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Discipline失败，标示没有做任何操作！
					-- @Result=1; 	删除Discipline成功！
					-- @Result=-1; 	删除Discipline失败，该DisciplineID无效
					-- @Result=-2; 	删除Discipline失败，该Discipline的状态不允许删除

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
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
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_ActiveFederation WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_ActiveClub WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Session WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Discipline_Des WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

