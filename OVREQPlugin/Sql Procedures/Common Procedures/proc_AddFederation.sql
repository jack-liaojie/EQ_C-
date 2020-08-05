IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddFederation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddFederation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_AddFederation]
----功		  能：添加一个Federation
----作		  者：郑金勇 
----日		  期: 2009-05-12 

CREATE PROCEDURE [dbo].[proc_AddFederation]
    @FederationCode			NVARCHAR(10),
    @LanguageCode			CHAR(3),
	@FederationLongName		NVARCHAR(50),
	@FederationShortName	NVARCHAR(50),
	@FederationComment		NVARCHAR(50),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Federation失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Federation成功！此值即为FederationID
					  -- @Result=-1;	添加Federation失败，@FederationCode重复！

	IF EXISTS(SELECT F_FederationID FROM TC_Federation WHERE F_FederationCode = @FederationCode)
	BEGIN
			SET @Result = -1
			RETURN
	END

	DECLARE @NewFederationID AS INT

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_Federation (F_FederationCode) VALUES (@FederationCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewFederationID = @@IDENTITY

        INSERT INTO TC_Federation_Des (F_FederationID, F_LanguageCode, F_FederationLongName, F_FederationShortName, F_FederationComment) VALUES(@NewFederationID, @LanguageCode, @FederationLongName, @FederationShortName, @FederationComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewFederationID
	RETURN

SET NOCOUNT OFF
END

GO

