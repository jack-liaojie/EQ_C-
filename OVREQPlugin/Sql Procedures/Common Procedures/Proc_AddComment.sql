IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddComment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_AddComment]
----功		  能：为运动员添加一个备注信息
----作		  者：张翠霞 
----日		  期: 2009-05-21 

CREATE PROCEDURE [dbo].[Proc_AddComment]
    @RegisterID			INT,
    @Order		        INT,
	@Title		        NVARCHAR(50),
	@Comment		    NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Comment失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Comment成功！此值即为CommentID
                      -- @Result=-1;    添加Comment失败，相同的RegisterID已经存在相同的Title

    IF EXISTS (SELECT F_CommentID FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID AND F_Title = @Title AND @Title IS NOT NULL)
    BEGIN
      SET @Result = -1
      RETURN
    END

	DECLARE @NewCommentID AS INT
    DECLARE @NewOrder INT
    SELECT @NewCommentID = (CASE WHEN MAX(F_CommentID) IS NULL THEN 0 ELSE MAX(F_CommentID) END) + 1 FROM TR_Register_Comment
    SELECT @NewOrder = (CASE WHEN MAX(F_Comment_Order) IS NULL THEN 0 ELSE MAX(F_Comment_Order) END) + 1 FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Register_Comment (F_CommentID, F_RegisterID, F_Comment_Order, F_Title, F_Comment) 
        VALUES (@NewCommentID, @RegisterID, @NewOrder, @Title, @Comment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewCommentID
	RETURN

SET NOCOUNT OFF
END

GO

