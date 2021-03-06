IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCommonPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCommonPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_DelCommonPosition]
----功		  能：删除一个项目下所有的Position
----作		  者：张翠霞 
----日		  期: 2011-01-17 

CREATE PROCEDURE [dbo].[proc_DelCommonPosition]
    @DisciplineID	    INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result = 0   -- @Result=0; 	删除Position失败，标示没有做任何操作！
					  -- @Result=1; 	删除Position成功！
					  -- @Result=-1; 	删除Position失败，该@DisciplineID无效
    
    IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TD_Position_Des WHERE F_PositionID NOT IN (SELECT DISTINCT F_PositionID FROM TR_Register_Member WHERE F_PositionID IS NOT NULL UNION SELECT DISTINCT F_PositionID FROM TS_Match_Member WHERE F_PositionID IS NOT NULL
        UNION SELECT DISTINCT F_PositionID FROM TS_Match_Split_Member WHERE F_PositionID IS NOT NULL UNION SELECT F_FunctionID FROM TS_Match_Servant WHERE F_FunctionID IS NOT NULL) AND F_PositionID IN (SELECT F_PositionID FROM TD_Position WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
            SET @Result = 0
			RETURN
		END

        DELETE FROM TD_Position WHERE F_PositionID NOT IN (SELECT DISTINCT F_PositionID FROM TR_Register_Member WHERE F_PositionID IS NOT NULL UNION SELECT DISTINCT F_PositionID FROM TS_Match_Member WHERE F_PositionID IS NOT NULL
        UNION SELECT DISTINCT F_PositionID FROM TS_Match_Split_Member WHERE F_PositionID IS NOT NULL  UNION SELECT F_FunctionID FROM TS_Match_Servant WHERE F_FunctionID IS NOT NULL) AND F_DisciplineID = @DisciplineID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
            SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

    SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


