IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddPhaseCompetitorsPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddPhaseCompetitorsPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[proc_AddPhaseCompetitorsPosition]
----功		  能：将Phase中的运动员指定签位
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_AddPhaseCompetitorsPosition]
    @PhaseID			INT,
    @RegisterID		    INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加位置失败，标示没有做任何操作！
					  -- @Result=1; 	添加位置成功！

	IF NOT EXISTS(SELECT @PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
		BEGIN
			SET @Result = 0
			RETURN
		END

    IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
		BEGIN
			SET @Result = 0
			RETURN
		END

    IF EXISTS(SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID)
		BEGIN
			SET @Result = 0
			RETURN
		END

    DECLARE @PhasePosition AS INT
    IF EXISTS(SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID)
	BEGIN
      SELECT @PhasePosition = MAX(F_PhasePosition) FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID
      SET @PhasePosition = @PhasePosition + 1
	END
	ELSE
	BEGIN
		SET @PhasePosition = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Phase_Position (F_PhaseID, F_PhasePosition, F_RegisterID) VALUES (@PhaseID, @PhasePosition, @RegisterID)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

    SET @Result = 1

	COMMIT TRANSACTION --成功提交事务

	RETURN

SET NOCOUNT OFF
END

GO



