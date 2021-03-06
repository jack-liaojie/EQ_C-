IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_UpdateMatchWeather]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_UpdateMatchWeather]
GO
set ANSI_NULLS ON
go
set QUOTED_IDENTIFIER ON
go
--名    称: [Proc_TE_UpdateMatchWeather]
--描    述: 设置天气情况
--参数说明: 
--说    明: 
--创 建 人: 李燕
--日    期: 2011年4月12日
--修改记录：




Create PROCEDURE [dbo].[Proc_TE_UpdateMatchWeather]
	@MatchID						INT,
	@AirTemp						NVARCHAR(25),
	@WaterTemp						NVARCHAR(25),
	@Humidity						NVARCHAR(25),
	@WeatherTypeID					INT,
	@WindSpeed						NVARCHAR(25),
	@WindDirectionID				INT,
	@Result							INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	IF @WindDirectionID = -1
	BEGIN
		SET @WindDirectionID = NULL 
	END
	DECLARE @WeatherID				INT
	
	SELECT @WeatherID = F_WeatherID
	FROM TS_Match
	WHERE F_MatchID = @MatchID

	IF @WeatherID IS NOT NULL
	BEGIN
		UPDATE TS_Weather_Conditions
		SET F_Air_Temperature = @AirTemp
			, F_Water_Temperature = @WaterTemp
			, F_Humidity = @Humidity
			, F_WeatherTypeID = @WeatherTypeID
			, F_Wind_Speed = @WindSpeed
			, F_WindDirectionID = @WindDirectionID
		WHERE F_WeatherID = @WeatherID
		
        SET @Result = 1								-- 更新成功
	END
	ELSE
	BEGIN
		DECLARE @NewWeatherID	INT

		SET Implicit_Transactions off
		BEGIN TRANSACTION		-- 设定事务

		-- 添加一条记录
		INSERT TS_Weather_Conditions
		    (F_Air_Temperature, F_Water_Temperature, F_Humidity, F_WeatherTypeID, F_Wind_Speed, F_WindDirectionID)
		VALUES
		    (@AirTemp,@WaterTemp, @Humidity, @WeatherTypeID, @WindSpeed, @WindDirectionID)

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- 事务回滚
			SET @Result = 0		-- 更新失败
			RETURN
		END

		SET @NewWeatherID = @@IDENTITY

		UPDATE TS_Match SET F_WeatherID = @NewWeatherID WHERE F_MatchID = @MatchID

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- 事务回滚
			SET @Result = 0		-- 更新失败
			RETURN
		END

		COMMIT TRANSACTION		-- 成功提交事务
		SET @Result = 1			-- 更新成功
		RETURN
		END

SET NOCOUNT OFF
END
GO
set QUOTED_IDENTIFIER OFF
go
set ANSI_NULLS OFF
go

