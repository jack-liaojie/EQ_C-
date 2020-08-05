if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelEvent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelEvent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_DelEvent
----功		  能：删除一个Event，将删除此Event下所有的子Phase，并且删除所有的Match，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09

CREATE PROCEDURE proc_DelEvent 
	@EventID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Event失败，标示没有做任何操作！
					-- @Result=1; 	删除Event成功！
					-- @Result=-1; 	删除Event失败，该EventID无效！
					-- @Result=-2; 	删除Event失败，该Event的状态不允许删除！
					-- @Result=-3; 	删除Event失败，该Event下的子Phase的状态不允许删除！
					-- @Result=-4; 	删除Event失败，该Event下的子Match的状态不允许删除！
					-- @Result=-5; 	删除Event失败，该Event下的有已经报项的参赛者或裁判等！

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS (SELECT F_EventID	FROM TS_Event WHERE F_EventID = @EventID AND F_EventStatusID > 10)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF EXISTS (SELECT F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseStatusID > 10)
	BEGIN
		SET @Result = -3
		RETURN
	END

	IF EXISTS (SELECT F_MatchID	FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID AND A.F_MatchStatusID > 10)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS (SELECT F_EventID FROM TR_Inscription WHERE F_EventID = @EventID )
	BEGIN
		SET @Result = -5
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
		DECLARE @PhaseID		AS INT
		DECLARE @DelPhaseResult	AS INT

		DECLARE Phase_Cursor CURSOR FOR 
			SELECT F_PhaseID
				FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = 0

		OPEN Phase_Cursor
		FETCH NEXT FROM Phase_Cursor INTO @PhaseID
   
		WHILE @@FETCH_STATUS = 0
		BEGIN

			EXEC proc_DelPhase @PhaseID, @DelPhaseResult output

			IF @DelPhaseResult != 1
			BEGIN
				ROLLBACK
				CLOSE Phase_Cursor
				DEALLOCATE Phase_Cursor
				SET @Result = 0
				RETURN
			END

			FETCH NEXT FROM Phase_Cursor INTO @PhaseID

		END

		CLOSE Phase_Cursor
		DEALLOCATE Phase_Cursor
		

		DELETE FROM TS_Round_Des WHERE F_RoundID IN (SELECT F_RoundID FROM TS_Round WHERE F_EventID = @EventID)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	
		DELETE FROM TS_Round WHERE F_EventID = @EventID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Inscription WHERE F_EventID = @EventID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Event_Result WHERE F_EventID = @EventID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Event_Des WHERE F_EventID = @EventID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Event WHERE F_EventID = @EventID
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

