IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCommonCountry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCommonCountry]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_AddCommonCountry]
----功		  能：添加一个Country
----作		  者：张翠霞 
----日		  期: 2011-01-17 

CREATE PROCEDURE [dbo].[proc_AddCommonCountry]
    @NOC			        CHAR(3),
    @LanguageCode			CHAR(3),
	@CountryLongName		NVARCHAR(100),
	@CountryShortName	    NVARCHAR(50),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Country失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Country成功！

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	IF NOT EXISTS(SELECT F_NOC FROM TC_Country WHERE F_NOC = @NOC)
	BEGIN
        INSERT INTO TC_Country (F_NOC) VALUES (@NOC)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END

    DELETE FROM TC_Country_Des WHERE F_NOC = @NOC AND F_LanguageCode = @LanguageCode

    INSERT INTO TC_Country_Des (F_NOC, F_LanguageCode, F_CountryLongName, F_CountryShortName)
        VALUES(@NOC, @LanguageCode, @CountryLongName, @CountryShortName)

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

