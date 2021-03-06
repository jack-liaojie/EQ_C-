/****** Object:  StoredProcedure [dbo].[proc_DeleteFederation]    Script Date: 11/11/2009 16:09:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DeleteFederation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DeleteFederation]
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteFederation]    Script Date: 11/11/2009 16:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_DeleteFederation]
----功		  能：删除Federation
----作		  者：郑金勇 
----日		  期: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_DeleteFederation]
	@FederationID			INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Federation失败，标示没有做任何操作！
					  -- @Result=1; 	删除Federation成功！
					  -- @Result=-1;	删除Federation失败，@FederationID无效！
					  -- @Result=-2;	删除Federation失败，@FederationID被注册人员引用

	IF NOT EXISTS(SELECT F_FederationID FROM TC_Federation WHERE F_FederationID = @FederationID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF EXISTS(SELECT F_FederationID FROM TR_Register WHERE F_FederationID = @FederationID)
	BEGIN
			SET @Result = -2
			RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Federation_Des WHERE F_FederationID = @FederationID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        DELETE FROM TS_ActiveFederation WHERE F_FederationID = @FederationID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TC_Federation WHERE F_FederationID = @FederationID

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

