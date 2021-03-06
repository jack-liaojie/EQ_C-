IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCommonDelegation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCommonDelegation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_AddCommonDelegation]
----功		  能：添加一个Delegation
----作		  者：张翠霞 
----日		  期: 2011-01-17 
--修改记录：


CREATE PROCEDURE [dbo].[proc_AddCommonDelegation]
    @DelegationCode			        NVARCHAR(10),
    @DelegationType			        NVARCHAR(10),
    @LanguageCode			        CHAR(3),
	@DeleLongName		            NVARCHAR(100),
	@DeleShortName	                NVARCHAR(100),
    @DeleComment	                NVARCHAR(50),
	@Result 				        AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Delegation失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Delegation成功！

    DECLARE @DelegationID AS INT

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    --IF EXISTS(SELECT F_DelegationCode FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode)
    IF EXISTS(SELECT F_DelegationID FROM TC_Delegation_Des WHERE F_DelegationComment = @DeleComment)
	BEGIN
      --SELECT TOP 1 @DelegationID = F_DelegationID FROM TC_Delegation WHERE F_DelegationCode = @DelegationCode
       
      SELECT TOP 1 @DelegationID = F_DelegationID FROM TC_Delegation_Des WHERE F_DelegationComment = @DeleComment
      UPDATE TC_Delegation SET F_DelegationType = @DelegationType WHERE F_DelegationID = @DelegationID

      IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
        INSERT INTO TC_Delegation (F_DelegationCode, F_DelegationType) VALUES(@DelegationCode, @DelegationType)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        SET @DelegationID = @@IDENTITY
	END

    DELETE FROM TC_Delegation_Des WHERE F_DelegationID = @DelegationID AND F_LanguageCode = @LanguageCode

    INSERT INTO TC_Delegation_Des (F_DelegationID, F_LanguageCode, F_DelegationLongName, F_DelegationShortName, F_DelegationComment)
        VALUES(@DelegationID, @LanguageCode, @DeleLongName, @DeleShortName, @DeleComment)

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



