IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelComment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DelComment]
----功		  能：删除一条运动员备注信息
----作		  者：张翠霞 
----日		  期: 2009-05-21 

CREATE PROCEDURE [dbo].[Proc_DelComment] 
	@CommentID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Comment失败，标示没有做任何操作！
					-- @Result=1; 	删除Comment成功！
					-- @Result=-1; 	删除Comment失败，该@CommentID无效
	
	IF NOT EXISTS(SELECT F_CommentID FROM TR_Register_Comment WHERE F_CommentID = @CommentID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TR_Register_Comment WHERE F_CommentID = @CommentID

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




