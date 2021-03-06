IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelColor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelColor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[proc_DelColor]
----功		  能：删除一个Color
----作		  者：张翠霞 
----日		  期: 2009-04-24

CREATE PROCEDURE [dbo].[proc_DelColor] 
	@ColorID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Color失败，标示没有做任何操作！
					-- @Result=1; 	删除Color成功！
					-- @Result=-1; 	删除Color失败，该@CityID无效
                    -- @Result=-2;  删除Color失败，该Color已被使用
	
	IF NOT EXISTS(SELECT F_ColorID FROM TC_Color WHERE F_ColorID = @ColorID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF EXISTS(SELECT F_UniformID FROM TR_Uniform WHERE F_Shirt = @ColorID OR F_Shorts = @ColorID OR F_Socks = @ColorID)
    BEGIN
        SET @Result = -2
        RETURN
    END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Color_Des WHERE F_ColorID = @ColorID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_Color WHERE F_ColorID = @ColorID

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

