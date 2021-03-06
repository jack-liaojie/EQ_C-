if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].proc_AddMemberRegister') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddMemberRegister]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go







----存储过程名称：proc_AddMemberRegister
----功		  能：添加单个队或双打中的成员
----作		  者：李燕 
----日		  期: 2009-04-17 

CREATE PROCEDURE [dbo].[proc_AddMemberRegister] 
    @RegisterID          INT,
    @MemberRegisterID    INT,
    @FunctionID          INT,
    @PositionID          INT,
    @Order               INT,
    @ShirtNum            INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Register失败，标示没有做任何操作！
					-- @Result>=1; 	添加Register成功！
					-- @Result=-1; 	添加Register失败，@RegisterID无效
                    ---@Result= -2; 添加MemberRegister失败，@MemberRegisterID无效

	IF NOT EXISTS(SELECT @RegisterID FROM TR_Register)
	BEGIN
		SET @Result = -1
		RETURN
	END

    IF NOT EXISTS(SELECT @MemberRegisterID FROM TR_Register)
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TR_Register_Member (F_RegisterID, F_MemberRegisterID, F_Order, F_FunctionID, F_PositionID, F_ShirtNumber)
			VALUES (@RegisterID, @MemberRegisterID, @Order, @FunctionID, @PositionID, @ShirtNum)

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
GO


set ANSI_NULLS OFF
set QUOTED_IDENTIFIER OFF
GO



