/****** Object:  StoredProcedure [dbo].[Proc_DelAllComment]    Script Date: 11/27/2009 10:36:33 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelAllComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelAllComment]
GO
/****** Object:  StoredProcedure [dbo].[Proc_DelAllComment]    Script Date: 11/27/2009 10:36:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DelAllComment]
----功		  能：删除运动员所有备注信息
----作		  者：李燕
----日		  期: 2009-11-27 

CREATE PROCEDURE [dbo].[Proc_DelAllComment] 
	@RegisterID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Comment失败，标示没有做任何操作！
					-- @Result=1; 	删除Comment成功！
					-- @Result=-1; 	删除Comment失败，该@RegisterID无效
	
	IF NOT EXISTS(SELECT F_CommentID FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID

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

