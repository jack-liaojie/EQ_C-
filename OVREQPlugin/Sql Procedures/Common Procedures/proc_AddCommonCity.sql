IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddCommonCity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddCommonCity]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_AddCommonCity]
----功		  能：添加一个City(CommonCode导入)
----作		  者：张翠霞 
----日		  期: 2011-01-17

CREATE PROCEDURE [dbo].[proc_AddCommonCity]
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加City失败，标示没有做任何操作！
					  -- @Result>=1; 	添加City成功！此值即为CityID

	DECLARE @CityID AS INT

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS(SELECT F_CityID FROM TC_City WHERE F_CityCode = 'SZR')
    BEGIN
        SELECT @CityID = F_CityID FROM TC_City WHERE F_CityCode = 'SZR'
    END
    ELSE
    BEGIN
        INSERT INTO TC_City (F_CityCode) VALUES ('SZR')

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SET @CityID = @@IDENTITY
    END

        DELETE FROM TC_City_Des WHERE F_CityID = @CityID
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TC_City_Des (F_CityID, F_LanguageCode, F_CityLongName, F_CityShortName, F_CityComment) VALUES(@CityID, 'CHN', '深圳', '深圳', '')

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TC_City_Des (F_CityID, F_LanguageCode, F_CityLongName, F_CityShortName, F_CityComment) VALUES(@CityID, 'ENG', 'ShengZhen', 'ShengZhen', '')

        IF @@error<>0  --事务失败返回
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @CityID
	RETURN

SET NOCOUNT OFF
END

GO


