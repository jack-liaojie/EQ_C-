IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCourt]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_DelCourt]
----功		  能：删除一个Court
----作		  者：张翠霞 
----日		  期: 2009-04-16 

CREATE PROCEDURE [dbo].[proc_DelCourt] 
	@CourtID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Court失败，标示没有做任何操作！
					-- @Result=1; 	删除Court成功！
					-- @Result=-1; 	删除Court失败，该@CourtID无效
                    -- @Result=-2;  删除Court失败，有比赛用到，不能删除
	
	IF NOT EXISTS(SELECT F_CourtID FROM TC_Court WHERE F_CourtID = @CourtID)
	BEGIN
		SET @Result = -1
		RETURN
	END
    
    IF EXISTS(SELECT F_CourtID FROM TS_Match WHERE F_CourtID = @CourtID)
    BEGIN
       SET @Result = -2
       RETURN
    END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Court_Des WHERE F_CourtID = @CourtID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_Court WHERE F_CourtID = @CourtID

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


