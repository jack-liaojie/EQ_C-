IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCommonFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCommonFunction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_DelCommonFunction]
----功		  能：删除一个项目下所有的Function
----作		  者：张翠霞 
----日		  期: 2011-01-17 

CREATE PROCEDURE [dbo].[proc_DelCommonFunction]
    @DisciplineID	    INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result = 0   -- @Result=0; 	删除Function失败，标示没有做任何操作！
					  -- @Result=1; 	删除Function成功！
					  -- @Result=-1; 	删除Function失败，该@DisciplineID无效
    
    IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TD_Function_Des WHERE F_FunctionID NOT IN (SELECT F_FunctionID FROM TR_Register WHERE F_FunctionID IS NOT NULL UNION SELECT F_FunctionID
        FROM TS_Match_Servant WHERE F_FunctionID IS NOT NULL UNION SELECT F_FunctionID FROM TR_Register_Member WHERE F_FunctionID IS NOT NULL) AND F_FunctionID
        IN (SELECT F_FunctionID FROM TD_Function WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
            SET @Result = 0
			RETURN
		END

        DELETE FROM TC_RegtypeFunction WHERE F_FunctionID NOT IN (SELECT F_FunctionID FROM TR_Register WHERE F_FunctionID IS NOT NULL UNION SELECT F_FunctionID
        FROM TS_Match_Servant WHERE F_FunctionID IS NOT NULL UNION SELECT F_FunctionID FROM TR_Register_Member WHERE F_FunctionID IS NOT NULL) AND F_FunctionID
        IN (SELECT F_FunctionID FROM TD_Function WHERE F_DisciplineID = @DisciplineID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
            SET @Result = 0
			RETURN
		END

        DELETE FROM TD_Function WHERE F_FunctionID NOT IN (SELECT F_FunctionID FROM TR_Register WHERE F_FunctionID IS NOT NULL UNION SELECT F_FunctionID
        FROM TS_Match_Servant WHERE F_FunctionID IS NOT NULL UNION SELECT F_FunctionID FROM TR_Register_Member WHERE F_FunctionID IS NOT NULL) AND F_FunctionID
        IN (SELECT F_FunctionID FROM TD_Function WHERE F_DisciplineID = @DisciplineID)

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


