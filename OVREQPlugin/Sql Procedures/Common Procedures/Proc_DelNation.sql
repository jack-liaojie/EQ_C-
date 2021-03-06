IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelNation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelNation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_DelNation]
----功		  能：删除一个Nation
----作		  者：张翠霞 
----日		  期: 2009-05-20 

CREATE PROCEDURE [dbo].[Proc_DelNation] 
	@NationID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Nation失败，标示没有做任何操作！
					-- @Result=1; 	删除Nation成功！
					-- @Result=-1; 	删除Nation失败，该@NationID无效
                    -- @Result=-2;  删除Nation失败，该Nation下有运动员存在
	
	IF NOT EXISTS(SELECT F_NationID FROM TC_Nation WHERE F_NationID = @NationID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF EXISTS(SELECT F_NationID FROM TR_Register WHERE F_NationID = @NationID)
    BEGIN
        SET @Result = -2
        RETURN
    END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Nation_Des WHERE F_NationID = @NationID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DELETE FROM TC_Nation WHERE F_NationID = @NationID

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

