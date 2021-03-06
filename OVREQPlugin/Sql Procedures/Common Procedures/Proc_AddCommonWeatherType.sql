IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddCommonWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddCommonWeatherType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddCommonWeatherType]
--描    述: 添加一种天气类型 (WeatherType)
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2011-01-17



CREATE PROCEDURE [dbo].[Proc_AddCommonWeatherType]
    @WeatherCode					NVARCHAR(10),
	@LanguageCode					CHAR(3),
	@WeatherTypeLongDescription		NVARCHAR(50),
	@WeatherTypeShortDescription	NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 WeatherTypeID

	DECLARE @WeatherTypeID AS INT

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS(SELECT F_WeatherTypeID FROM TC_WeatherType WHERE F_WeatherCode = @WeatherCode)
	BEGIN
      SELECT TOP 1 @WeatherTypeID = F_WeatherTypeID FROM TC_WeatherType WHERE F_WeatherCode = @WeatherCode

      IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
        SELECT @WeatherTypeID = (CASE WHEN MAX(F_WeatherTypeID) IS NULL THEN 0 ELSE MAX(F_WeatherTypeID) END) + 1 FROM TC_WeatherType
        INSERT INTO TC_WeatherType (F_WeatherTypeID, F_WeatherCode) VALUES(@WeatherTypeID, @WeatherCode)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

    DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID AND F_LanguageCode = @LanguageCode

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_WeatherType_Des (F_WeatherTypeID, F_LanguageCode, F_WeatherTypeLongDescription, F_WeatherTypeShortDescription) 
			VALUES(@WeatherTypeID, @LanguageCode, @WeatherTypeLongDescription, @WeatherTypeShortDescription)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @WeatherTypeID
	RETURN

SET NOCOUNT OFF
END

GO


