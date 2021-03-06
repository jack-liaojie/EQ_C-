/****** Object:  StoredProcedure [dbo].[proc_EditDelegation]    Script Date: 11/19/2009 14:24:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditDelegation]
GO
/****** Object:  StoredProcedure [dbo].[proc_EditDelegation]    Script Date: 11/19/2009 14:24:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_AddDelegation]
----功		  能：编辑Delegation
----作		  者：李燕 
----日		  期: 2009-11-19 

CREATE PROCEDURE [dbo].[proc_EditDelegation]
	@DelegationID			INT,
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

	SET @Result = 0;  -- @Result=0; 	编辑Delegation失败，标示没有做任何操作！
					  -- @Result=1; 	编辑Delegation成功！此值即为FederationID
					  -- @Result=-1;	编辑Delegation失败，@DelegationID无效！
					  -- @Result=-2;	编辑Delegation失败，@DelegationCode重复！

	IF NOT EXISTS(SELECT F_DelegationID FROM TC_Delegation WHERE F_DelegationID = @DelegationID)
	BEGIN
			SET @Result = -1
			RETURN
	END

	IF EXISTS(SELECT F_DelegationID FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode AND F_DelegationID <> @DelegationID)
	BEGIN
			SET @Result = -2
			RETURN
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TC_Delegation SET F_DelegationCode = @DelegationCode,F_DelegationType = @DelegationType WHERE F_DelegationID = @DelegationID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		IF NOT EXISTS(SELECT F_DelegationID FROM TC_Delegation_Des WHERE F_DelegationID = @DelegationID AND F_LanguageCode = @LanguageCode)
		BEGIN
			INSERT INTO TC_Delegation_Des (F_DelegationID, F_LanguageCode, F_DelegationLongName, F_DelegationShortName, F_DelegationComment) VALUES(@DelegationID, @LanguageCode, @DelegationLongName, @DelegationShortName, @DelegationComment)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TC_Delegation_Des SET  F_DelegationLongName = @DelegationLongName, F_DelegationShortName = @DelegationShortName, F_DelegationComment = @DelegationComment
				WHERE F_DelegationID = @DelegationID AND F_LanguageCode = @LanguageCode

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

