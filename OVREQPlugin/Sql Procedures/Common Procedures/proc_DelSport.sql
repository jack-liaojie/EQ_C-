/****** Object:  StoredProcedure [dbo].[proc_DelSport]    Script Date: 11/17/2009 11:54:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelSport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelSport]
GO
/****** Object:  StoredProcedure [dbo].[proc_DelSport]    Script Date: 11/17/2009 11:52:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：proc_DelSport
----功		  能：删除一个Sport，将删除此Sport下所有的子Discipline、子Event、子Phase，并且删除所有的Match，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09

CREATE PROCEDURE [dbo].[proc_DelSport] 
	@SportID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Sport失败，标示没有做任何操作！
					-- @Result=1; 	删除Sport成功！
					-- @Result=-1; 	删除Sport失败，该SportID无效
					-- @Result=-2; 	删除Sport失败，该Sport的状态不允许删除

	IF NOT EXISTS(SELECT F_SportID FROM TS_Sport WHERE F_SportID = @SportID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
		DECLARE @DisciplineID			AS INT
		DECLARE @DelDisciplineResult	AS INT

		DECLARE Discipline_Cursor CURSOR FOR 
			SELECT F_DisciplineID
				FROM TS_Discipline WHERE F_SportID = @SportID

		OPEN Discipline_Cursor
		FETCH NEXT FROM Discipline_Cursor INTO @DisciplineID
   
		WHILE @@FETCH_STATUS = 0
		BEGIN

			EXEC proc_DelDiscipline @DisciplineID, @DelDisciplineResult output

			IF @DelDisciplineResult != 1
			BEGIN
				ROLLBACK
				SET @Result = 0
				RETURN
			END

			FETCH NEXT FROM Discipline_Cursor INTO @DisciplineID

		END

		CLOSE Discipline_Cursor
		DEALLOCATE Discipline_Cursor

		DELETE FROM TS_Sport_Des WHERE F_SportID = @SportID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
    

        DELETE FROM TS_Sport_Config WHERE F_SportID = @SportID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Sport WHERE F_SportID = @SportID
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




