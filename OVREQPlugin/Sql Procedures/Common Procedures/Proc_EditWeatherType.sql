IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditWeatherType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_EditWeatherType]
--描    述: 修改一种天气类型 (WeatherType)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_EditWeatherType]
	@WeatherTypeID					INT,
	@LanguageCode					CHAR(3),
	@WeatherCode					NVARCHAR(10),
	@WeatherTypeLongDescription		NVARCHAR(50),
	@WeatherTypeShortDescription	NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					  -- @Result = 1; 	更新成功！
					  -- @Result = -1;	更新失败，@WeatherTypeID 不存在！

	IF NOT EXISTS (SELECT F_WeatherTypeID FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	UPDATE TC_WeatherType
	SET F_WeatherCode = @WeatherCode
	WHERE F_WeatherTypeID = @WeatherTypeID
		
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result = 0
		RETURN
	END

	-- Des 表中有该语言的描述就更新, 没有则添加
	IF EXISTS (SELECT F_WeatherTypeID FROM TC_WeatherType_Des 
				WHERE F_WeatherTypeID = @WeatherTypeID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TC_WeatherType_Des 
		SET F_WeatherTypeLongDescription = @WeatherTypeLongDescription
			, F_WeatherTypeShortDescription = @WeatherTypeShortDescription
		WHERE F_WeatherTypeID = @WeatherTypeID
			AND F_LanguageCode = @LanguageCode
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
		INSERT INTO TC_WeatherType_Des 
			(F_WeatherTypeID, F_LanguageCode, F_WeatherTypeLongDescription, F_WeatherTypeShortDescription) 
			VALUES
			(@WeatherTypeID, @LanguageCode, @WeatherTypeLongDescription, @WeatherTypeShortDescription)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

	COMMIT TRANSACTION --成功提交事务

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 更新成功
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
DECLARE @WeatherTypeID INT
DECLARE @TestResult INT

-- Add one WeatherType
exec [Proc_AddWeatherType]  'CHN', 'BigRain', '好大的雨', '好大的雨', @WeatherTypeID OUTPUT
SELECT * FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID
SELECT * FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID

-- Update One WeatherType
exec [Proc_EditWeatherType] @WeatherTypeID, 'CHN', 'SmallRain', '好小的雨', '好小的雨', @TestResult OUTPUT
exec [Proc_EditWeatherType] @WeatherTypeID, 'ENG', 'SmallRain', 'Small Rain', 'Small Rain', @TestResult OUTPUT
SELECT * FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID
SELECT * FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID
SELECT @TestResult AS [RESULT 1]

-- Update, @WeatherTypeID 不存在
SET @WeatherTypeID = @WeatherTypeID + 1
exec [Proc_EditWeatherType] @WeatherTypeID, 'CHN', 'BigRain', '好大的雨', '好大的雨', @TestResult OUTPUT
SELECT * FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID
SELECT * FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID
SELECT @TestResult AS [RESULT -1]

-- Delete that added for test
SET @WeatherTypeID = @WeatherTypeID - 1
DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID
DELETE FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID

*/