IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CopyPhaseCompetitorsPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CopyPhaseCompetitorsPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称: [Proc_CopyPhaseCompetitorsPosition]
--描    述: 拷贝签位信息
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2009-09-08



CREATE PROCEDURE [dbo].[Proc_CopyPhaseCompetitorsPosition]
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	表示拷贝失败，什么动作也没有！
					  -- @Result = 1; 	拷贝成功！

	IF @NodeType = -1
	BEGIN
	
		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			DELETE FROM TS_OldEvent_Position WHERE F_EventID = @EventID

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			
			INSERT INTO TS_OldEvent_Position (F_EventID, F_EventPosition, F_RegisterID)
					SELECT F_EventID, F_EventPosition, F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务
		
	END
	ELSE IF @NodeType = 0
	BEGIN
	
		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			DELETE FROM TS_OldPhase_Position WHERE F_PhaseID = @PhaseID

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			
			INSERT INTO TS_OldPhase_Position (F_PhaseID, F_PhasePosition, F_RegisterID)
					SELECT F_PhaseID, F_PhasePosition, F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务
		
	END
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


