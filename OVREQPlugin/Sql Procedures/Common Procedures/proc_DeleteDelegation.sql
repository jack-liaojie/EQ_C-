/****** Object:  StoredProcedure [dbo].[proc_DeleteFederation]    Script Date: 11/19/2009 09:13:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DeleteDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DeleteDelegation]
GO
/****** Object:  StoredProcedure [dbo].[proc_DeleteDelegation]    Script Date: 11/19/2009 09:12:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_DeleteDelegation]
----功		  能：删除Delegation
----作		  者：李燕
----日		  期: 2009-11-19 

CREATE PROCEDURE [dbo].[proc_DeleteDelegation]
	@DelegationID			INT,
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	删除Delegation失败，标示没有做任何操作！
					  -- @Result=1; 	删除Delegation成功！
					  -- @Result=-1;	删除Delegation失败，@DelegationID无效！
					  -- @Result=-2;	删除Delegation失败，@DelegationID被注册人员引用

	IF NOT EXISTS(SELECT F_DelegationID FROM TC_Delegation WHERE F_DelegationID = @DelegationID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF EXISTS(SELECT F_DelegationID FROM TR_Register WHERE F_DelegationID = @DelegationID)
	BEGIN
			SET @Result = -2
			RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_Delegation_Des WHERE F_DelegationID = @DelegationID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

       DELETE FROM TS_ActiveDelegation WHERE F_DelegationID = @DelegationID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TC_Delegation WHERE F_DelegationID = @DelegationID

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

