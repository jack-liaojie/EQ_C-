/****** Object:  StoredProcedure [dbo].[proc_AddDelegation]    Script Date: 11/19/2009 14:13:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddDelegation]
GO
/****** Object:  StoredProcedure [dbo].[proc_AddDelegation]    Script Date: 11/19/2009 14:13:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_AddDelegation]
----功		  能：添加一个Delegation
----作		  者：李燕 
----日		  期: 2009-11-19 

CREATE PROCEDURE [dbo].[proc_AddDelegation]
    @DelegationCode			NVARCHAR(10),
    @LanguageCode			CHAR(3),
	@DelegationLongName		NVARCHAR(50),
	@DelegationShortName	NVARCHAR(50),
	@DelegationComment		NVARCHAR(50),
    @DelegationType         NVARCHAR(10),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Delegation失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Delegation成功！此值即为DelegationID
					  -- @Result=-1;	添加Delegation失败，@DelegationCode重复！

	IF EXISTS(SELECT F_DelegationID FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode)
	BEGIN
			SET @Result = -1
			RETURN
	END

	DECLARE @NewDelegationID AS INT

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_Delegation (F_DelegationCode, F_DelegationType) VALUES (@DelegationCode, @DelegationType)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewDelegationID = @@IDENTITY

        INSERT INTO TC_Delegation_Des (F_DelegationID, F_LanguageCode, F_DelegationLongName, F_DelegationShortName, F_DelegationComment) VALUES(@NewDelegationID, @LanguageCode, @DelegationLongName, @DelegationShortName, @DelegationComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewDelegationID
	RETURN

SET NOCOUNT OFF
END

