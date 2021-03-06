IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCity]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_AddCity]
----功		  能：添加一个City
----作		  者：张翠霞 
----日		  期: 2009-04-16 

CREATE PROCEDURE [dbo].[proc_AddCity]
    @CityCode			NVARCHAR(10),
    @LanguageCode		CHAR(3),
	@CityLongName		NVARCHAR(50),
	@CityShortName		NVARCHAR(50),
	@CityComment		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加City失败，标示没有做任何操作！
					  -- @Result>=1; 	添加City成功！此值即为CityID

	DECLARE @NewCityID AS INT

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_City (F_CityCode) VALUES (@CityCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewCityID = @@IDENTITY

        INSERT INTO TC_City_Des (F_CityID, F_LanguageCode, F_CityLongName, F_CityShortName, F_CityComment) VALUES(@NewCityID, @LanguageCode, @CityLongName, @CityShortName, @CityComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewCityID
	RETURN

SET NOCOUNT OFF
END

GO

