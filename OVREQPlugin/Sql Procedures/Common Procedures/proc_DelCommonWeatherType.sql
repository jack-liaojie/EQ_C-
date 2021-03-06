IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DelCommonWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DelCommonWeatherType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_DelCommonWeatherType]
----功		  能：删除所有的WeatherType
----作		  者：张翠霞 
----日		  期: 2011-01-17 

CREATE PROCEDURE [dbo].[proc_DelCommonWeatherType]
AS
BEGIN
	
SET NOCOUNT ON
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID NOT IN (SELECT F_WeatherTypeID FROM TS_Weather_Conditions WHERE F_WeatherTypeID IS NOT NULL)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			RETURN
		END

        DELETE FROM TC_WeatherType WHERE F_WeatherTypeID NOT IN (SELECT F_WeatherTypeID FROM TS_Weather_Conditions WHERE F_WeatherTypeID IS NOT NULL)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	RETURN

SET NOCOUNT OFF
END

GO



