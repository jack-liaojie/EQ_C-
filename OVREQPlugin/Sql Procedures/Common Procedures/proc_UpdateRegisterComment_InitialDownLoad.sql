IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_UpdateRegisterComment_InitialDownLoad]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_UpdateRegisterComment_InitialDownLoad]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[proc_UpdateRegisterComment_InitialDownLoad]
----功		  能：InitialDownLoad，增加或修改一个运动员的备注信息
----作		  者：李燕 
----日		  期: 2011-07-14 

CREATE PROCEDURE [dbo].[proc_UpdateRegisterComment_InitialDownLoad]
    @RegisterID			INT,
	@Title		        NVARCHAR(50),
	@Comment		    NVARCHAR(250),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改Comment失败，标示没有做任何操作！
					  -- @Result=1; 	修改Comment成功！
					  -- @Result=-1;    修改Comment失败，不存在该Register!
					
	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
	    SET @Result = -1
	    RETURN
	END		
			
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        IF NOT EXISTS (SELECT F_CommentID FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID AND F_Title = @Title)
        BEGIN
             DECLARE @MaxOrder  INT
             SELECT @MaxOrder = Max(F_Comment_Order)FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID
             SET @MaxOrder = ISNULL(@MaxOrder, 0) + 1
             
             DECLARE @CommentID  INT
             SELECT @CommentID = Max(F_CommentID) FROM TR_Register_Comment
             SET @CommentID = ISNULL(@CommentID, 0) + 1
             
             INSERT INTO TR_Register_Comment (F_CommentID, F_Comment_Order, F_Title, F_Comment, F_RegisterID) VALUES (@CommentID, @MaxOrder, @Title, @Comment,@RegisterID) 
        END
        ELSE 
        BEGIN
            UPDATE TR_Register_Comment SET F_Comment = @Comment WHERE F_RegisterID = @RegisterID AND F_Title = @Title 
        END
       
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





