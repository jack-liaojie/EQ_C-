IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddWeatherType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddWeatherType]
--描    述: 添加一种天气类型 (WeatherType)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_AddWeatherType]
	@LanguageCode					CHAR(3),
	@WeatherCode					NVARCHAR(10),
	@WeatherTypeLongDescription		NVARCHAR(50),
	@WeatherTypeShortDescription	NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 WeatherTypeID

	DECLARE @NewWeatherTypeID AS INT

    IF EXISTS(SELECT F_WeatherTypeID FROM TC_WeatherType)
	BEGIN
      SELECT @NewWeatherTypeID = MAX(F_WeatherTypeID) FROM TC_WeatherType
      SET @NewWeatherTypeID = @NewWeatherTypeID + 1
	END
	ELSE
	BEGIN
		SET @NewWeatherTypeID = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_WeatherType (F_WeatherTypeID, F_WeatherCode) VALUES(@NewWeatherTypeID, @WeatherCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_WeatherType_Des 
			(F_WeatherTypeID, F_LanguageCode, F_WeatherTypeLongDescription, F_WeatherTypeShortDescription) 
			VALUES
			(@NewWeatherTypeID, @LanguageCode, @WeatherTypeLongDescription, @WeatherTypeShortDescription)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewWeatherTypeID
	RETURN

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for Test
DECLARE @TestResult INT

-- Add right
exec [Proc_AddWeatherType]  'CHN', 'BigRain', '好大的雨', '好大的雨', @TestResult OUTPUT
SELECT * FROM TC_WeatherType WHERE F_WeatherTypeID = @TestResult
SELECT * FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @TestResult

-- Delete that added for test
DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @TestResult
DELETE FROM TC_WeatherType WHERE F_WeatherTypeID = @TestResult

*/