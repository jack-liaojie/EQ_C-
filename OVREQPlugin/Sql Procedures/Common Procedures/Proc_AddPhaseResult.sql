IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddPhaseResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddPhaseResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_AddPhaseResult]
----功		  能：TS_Phase_Result中添加一条记录
----作		  者：郑金勇 
----日		  期: 2009-09-03 

CREATE PROCEDURE [dbo].[Proc_AddPhaseResult]
    @PhaseID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功,返回@EventResultNumber
                      -- @Result = -1; 	添加失败，该PhaseID不存在

    IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
    BEGIN
      SET @Result = -1
      RETURN
    END

	DECLARE @PhaseResultNumber AS INT
    SELECT @PhaseResultNumber = (CASE WHEN MAX(F_PhaseResultNumber) IS NULL THEN 0 ELSE MAX(F_PhaseResultNumber) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID

	DECLARE @PhaseRank AS INT
    SELECT @PhaseRank = (CASE WHEN MAX(F_PhaseRank) IS NULL THEN 0 ELSE MAX(F_PhaseRank) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID

	DECLARE @PhaseDiplayPosition AS INT
    SELECT @PhaseDiplayPosition = (CASE WHEN MAX(F_PhaseDisplayPosition) IS NULL THEN 0 ELSE MAX(F_PhaseDisplayPosition) END) + 1 FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Phase_Result (F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_PhaseDisplayPosition) VALUES (@PhaseID, @PhaseResultNumber, @PhaseRank, @PhaseDiplayPosition)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @PhaseResultNumber
	RETURN

SET NOCOUNT OFF
END
