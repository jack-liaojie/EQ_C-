IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelRSCEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelRSCEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：proc_DelRSCEvent
----功		  能：删除一个项目下所有的Event
----作		  者：张翠霞 
----日		  期: 2009-12-17

CREATE PROCEDURE [dbo].[proc_DelRSCEvent] 
	@DisciplineCode	    CHAR(2),
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Event失败，标示没有做任何操作！
					-- @Result=1; 	删除Event成功！
                    -- @Result=-1; 	删除Event失败！该Discipline不存在

	IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode)
	BEGIN
		SET @Result = -1
		RETURN
	END

    DECLARE @DisciplineID INT
    SELECT TOP 1 @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        DELETE FROM TS_Event_Des WHERE F_EventID NOT IN (SELECT F_EventID FROM TS_Phase UNION SELECT F_EventID FROM TS_Round WHERE F_EventID IS NOT NULL
        UNION SELECT F_EventID FROM TR_Inscription UNION SELECT F_EventID FROM TS_Event_Result) AND F_EventID IN (SELECT F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID)
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DELETE FROM TS_Event WHERE F_EventID NOT IN (SELECT F_EventID FROM TS_Phase UNION SELECT F_EventID FROM TS_Round WHERE F_EventID IS NOT NULL
        UNION SELECT F_EventID FROM TR_Inscription UNION SELECT F_EventID FROM TS_Event_Result) AND F_DisciplineID = @DisciplineID
            
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


