if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateDisciplineActive]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateDisciplineActive]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdateDisciplineActive]
----功		  能：更改Discipline激活状态
----作		  者：郑金勇 
----日		  期: 2009-08-13

CREATE PROCEDURE [dbo].[Proc_UpdateDisciplineActive] (	
	@DisciplineID					INT,
	@Active							INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	编辑Discipline激活状态失败，标示没有做任何操作！
					-- @Result = 1; 	编辑Discipline激活状态成功！
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务



		IF (@Active = 1)
		BEGIN
			UPDATE TS_Discipline SET F_Active = @Active 
				WHERE F_DisciplineID = @DisciplineID
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

			UPDATE TS_Discipline SET F_Active = 0 WHERE F_DisciplineID != @DisciplineID
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
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
					IF @@error<>0  --事务失败返回  
					BEGIN 
						ROLLBACK   --事务回滚
						SET @Result=0
						RETURN
					END
				END
			END
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

