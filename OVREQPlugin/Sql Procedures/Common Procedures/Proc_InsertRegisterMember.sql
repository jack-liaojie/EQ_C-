IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_InsertRegisterMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_InsertRegisterMember]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_InsertRegisterMember]
----功		  能：添加队员到参赛队中
----作		  者：张翠霞
----日		  期: 09-05-29

CREATE PROCEDURE [dbo].[Proc_InsertRegisterMember] 
	@RegisterID			INT,
	@MemberID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	增加失败，标示没有做任何操作！
					-- @Result=1; 	增加成功！
					-- @Result=-1; 	增加失败，@RegisterID无效、@MemberID无效
					-- @Result=-2; 	@RegisterID下已经存在@MemberID

	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @RegisterID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT EXISTS(SELECT F_RegisterID FROM TR_Register WHERE F_RegisterID = @MemberID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_RegisterID FROM TR_Register_Member WHERE F_RegisterID = @RegisterID AND F_MemberRegisterID = @MemberID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID)
			VALUES (@RegisterID, @MemberID)

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

