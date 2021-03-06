IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelEventResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DelEventResult]
----功		  能：TS_Event_Result中删除一条记录
----作		  者：张翠霞 
----日		  期: 2009-05-14 

CREATE PROCEDURE [dbo].[Proc_DelEventResult]
    @EventID			INT,
    @EventResultNumber  INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败，标示没有做任何操作！
					  -- @Result = 1; 	删除成功
                      -- @Result = -1; 	删除失败，该EventID不存在

    IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
    BEGIN
      SET @Result = -1
      RETURN
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_Event_Result WHERE F_EventID = @EventID AND F_EventResultNumber = @EventResultNumber

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
SET ANSI_NULLS OFF
GO