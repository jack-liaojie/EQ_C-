if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].proc_RemoveMemberRegister') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_RemoveMemberRegister]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go








----存储过程名称：proc_RemoveMemberRegister
----功		  能：移除某个队或组合中的运动员
----作		  者：李燕 
----日		  期: 2009-04-17 

CREATE PROCEDURE [dbo].[proc_RemoveMemberRegister] 
    @RegisterID          INT,
    @MemberRegisterID    INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	移除MemberRegister失败，标示没有做任何操作！
					-- @Result>=1; 	移除MemberRegister成功！
					-- @Result=-1; 	移除MemberRegister失败，@RegisterID无效
                    ---@Result= -2; 移除MemberRegister失败，@MemberRegisterID无效

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
        
		DELETE FROM TR_Register_Member WHERE F_RegisterID = @RegisterID AND F_MemberRegisterID = @MemberRegisterID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
        
        DELETE FROM TR_Register_Member 
                    WHERE F_MemberRegisterID = @MemberRegisterID 
                          AND F_RegisterID IN (SELECT A.F_MemberRegisterID FROM TR_Register_Member AS A LEFT JOIN TR_Register AS B ON A.F_MemberRegisterID = B.F_RegisterID AND B.F_RegTypeID IN(2,3) WHERE A.F_RegisterID = @RegisterID )
	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END
GO

set ANSI_NULLS OFF
GO
set QUOTED_IDENTIFIER OFF
GO





