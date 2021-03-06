IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditComment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_EditComment]
----功		  能：修改一个运动员的备注信息
----作		  者：张翠霞 
----日		  期: 2009-05-21 

CREATE PROCEDURE [dbo].[Proc_EditComment]
    @CommentID          INT,
    @RegisterID			INT,
    @Order		        INT,
	@Title		        NVARCHAR(50),
	@Comment		    NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改Comment失败，标示没有做任何操作！
					  -- @Result=1; 	修改Comment成功！
					  -- @Result=-1; 	修改Comment失败, @CommentID无效
                      -- @Result=-2;    该@RegisterID已经存在相同的@Title
                      -- @Result=-3;    该@CommentID下的RegisterID与传入的@RegisterID不同，不能更改

	IF NOT EXISTS(SELECT F_CommentID FROM TR_Register_Comment WHERE F_CommentID = @CommentID)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF EXISTS (SELECT F_CommentID FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID AND F_Title = @Title AND F_CommentID <> @CommentID AND @Title IS NOT NULL)
    BEGIN
      SET @Result = -2
      RETURN
    END

    IF @RegisterID <> (SELECT F_RegisterID FROM TR_Register_Comment WHERE F_CommentID = @CommentID)
    BEGIN
      SET @Result = -3
      RETURN
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        UPDATE TR_Register_Comment SET F_RegisterID = @RegisterID, F_Comment_Order = @Order, F_Title = @Title,
        F_Comment = @Comment WHERE F_CommentID = @CommentID

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





