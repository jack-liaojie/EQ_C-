IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditCountry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditCountry]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_EditCountry]
----功		  能：编辑Country
----作		  者：张翠霞 
----日		  期: 2009-10-10 

CREATE PROCEDURE [dbo].[proc_EditCountry]
	@NOC			        CHAR(3),
    @LanguageCode			CHAR(3),
	@CountryLongName		NVARCHAR(50),
	@CountryShortName	    NVARCHAR(50),
	@Result 				AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	编辑Federation失败，标示没有做任何操作！
					  -- @Result=1; 	编辑Federation成功！
					  -- @Result=-1;	编辑Federation失败，@NOC无效！

	IF NOT EXISTS(SELECT F_NOC FROM TC_Country WHERE F_NOC = @NOC)
	BEGIN
			SET @Result = -1
			RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		IF NOT EXISTS(SELECT F_NOC FROM TC_Country_Des WHERE F_NOC = @NOC AND F_LanguageCode = @LanguageCode)
		BEGIN
			INSERT INTO TC_Country_Des (F_NOC, F_LanguageCode, F_CountryLongName, F_CountryShortName)
                VALUES(@NOC, @LanguageCode, @CountryLongName, @CountryShortName)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TC_Country_Des SET F_CountryLongName = @CountryLongName, F_CountryShortName = @CountryShortName
				WHERE F_NOC = @NOC AND F_LanguageCode = @LanguageCode

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

GO


