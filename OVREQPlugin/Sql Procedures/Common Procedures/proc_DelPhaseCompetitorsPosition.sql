IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelPhaseCompetitorsPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelPhaseCompetitorsPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[proc_DelPhaseCompetitorsPosition]
----功		  能：取消已经指定位置的运动员的签位
----作		  者：张翠霞 
----日		  期: 2009-09-07 

CREATE PROCEDURE [dbo].[proc_DelPhaseCompetitorsPosition]
    @PhaseID			INT,
    @PhasePosition      INT,
    @RegisterID		    INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	取消签位失败，标示没有做任何操作！
					  -- @Result=1; 	取消成功！

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

        IF (@PhasePosition = -1)
        BEGIN
		    DELETE FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_PhasePosition IS NULL AND F_RegisterID = @RegisterID

            IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result = 0
				    RETURN
		        END
        END
        ELSE
        BEGIN
            DELETE FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @PhasePosition AND F_RegisterID = @RegisterID
    
            IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result = 0
					RETURN
				END
        END

	COMMIT TRANSACTION --成功提交事务

    SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


