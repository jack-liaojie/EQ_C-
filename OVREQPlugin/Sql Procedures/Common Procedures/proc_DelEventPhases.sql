if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelEventPhases]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelEventPhases]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[proc_DelEventPhases]
----功		  能：删除此Event下所有的子Phase，并且删除所有的Match，主要是为Event的重新编排服务编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09

CREATE PROCEDURE [DBO].[proc_DelEventPhases] 
	@EventID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Event下的子Phase失败，标示没有做任何操作！
					-- @Result=1; 	删除Event下的子Phase成功！
					-- @Result=-1; 	删除Event下的子Phase失败，该EventID无效
					-- @Result=-2; 	删除Event下的子Phase失败，该Event下的状态不允许删除
					-- @Result=-3; 	删除Event下的子Phase失败，该Event下的子Phase的状态不允许删除
					-- @Result=-4; 	删除Event下的子Phase失败，该Event下的子Match的状态不允许删除

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

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
		DELETE FROM TS_Event_Result WHERE F_EventID = @EventID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

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
				SET @Result = 0
				RETURN
			END

			FETCH NEXT FROM Phase_Cursor INTO @PhaseID

		END

		CLOSE Phase_Cursor
		DEALLOCATE Phase_Cursor

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

