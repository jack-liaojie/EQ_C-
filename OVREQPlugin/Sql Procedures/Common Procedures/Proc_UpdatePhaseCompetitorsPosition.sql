IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdatePhaseCompetitorsPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdatePhaseCompetitorsPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_UpdatePhaseCompetitorsPosition]
----功		  能：更改运动员签位
----作		  者：张翠霞 
----日		  期: 2009-09-08

CREATE PROCEDURE [dbo].[Proc_UpdatePhaseCompetitorsPosition] (	
	@PhaseID					INT,
	@RegisterID					INT,
    @PhasePosition              INT,
    @Type                       INT, --0:如果该Phase下的Position已存在，返回; 1:直接清除存在的Position,更新传入的数据
	@Result						AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					-- @Result = 1; 	更新成功！
                    -- @Result = -1;    更新失败，存在相同的Position！


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

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF @PhasePosition <> 0
    BEGIN

    IF EXISTS(SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @PhasePosition AND F_RegisterID <> @RegisterID)
        BEGIN
            IF @Type = 0
                BEGIN
                    ROLLBACK   --事务回滚
					SET @Result = -1
					RETURN
                END
            ELSE IF @Type = 1
                BEGIN
                    UPDATE TS_Phase_Position SET F_PhasePosition = NULL WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @PhasePosition AND F_RegisterID <> @RegisterID

                    IF @@error<>0  --事务失败返回  
						BEGIN 
							ROLLBACK   --事务回滚
							SET @Result=0
							RETURN
						END
                END
		END
    END

    UPDATE TS_Phase_Position SET F_PhasePosition = (CASE WHEN @PhasePosition <> 0 THEN @PhasePosition ELSE NULL END) WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegisterID

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

