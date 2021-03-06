IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelRegister]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelRegister]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：proc_DelRegister
----功		  能：删除一个Register
----作		  者：郑金勇 
----日		  期: 2009-04-08 

CREATE PROCEDURE [dbo].[proc_DelRegister] 
	@RegisterID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Register失败，标示没有做任何操作！
					-- @Result=1; 	删除Register成功！
					-- @Result=-1; 	删除Register失败，该@RegisterID无效
					-- @Result=-2; 	删除Register失败，该@RegisterID的有成员不允许删除
					-- @Result=-3; 	删除Register失败，该@RegisterID的是一成员不允许删除
					-- @Result=-4;	删除Register失败，该@RegisterID的有参加的比赛，不允许删除

	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
--	IF EXISTS(SELECT F_RegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID)
--	BEGIN
--		SET @Result = -2
--		RETURN
--	END
--
	IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Event_Result WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Phase_Result WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Match_Result WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Match_Split_Result WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Match_ActionList WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TS_Match_Statistic WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -4
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TR_Register_Member WHERE F_RegisterID = @RegisterID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Member WHERE F_MemberRegisterID = @RegisterID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Des WHERE F_RegisterID = @RegisterID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register_Comment WHERE F_RegisterID = @RegisterID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Inscription WHERE F_RegisterID = @RegisterID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Uniform WHERE F_RegisterID = @RegisterID 
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Register WHERE F_RegisterID = @RegisterID 
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




