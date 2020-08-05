IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelWeatherType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_DelWeatherType]
--描    述: 删除一种天气类型 (WeatherType)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_DelWeatherType]
	@WeatherTypeID					INT,
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败, 标示没有做任何操作!
					  -- @Result = 1; 	删除成功!
					  -- @Result = -1;	删除失败, @WeatherTypeID 不存在!

	IF NOT EXISTS (SELECT F_WeatherTypeID FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 删除成功
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

-- Delete One WeatherType
exec [Proc_DelWeatherType] @WeatherTypeID, @TestResult OUTPUT
SELECT * FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID
SELECT * FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID
DELETE FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID

*/