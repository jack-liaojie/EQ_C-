
/****** Object:  StoredProcedure [dbo].[Proc_HB_UpdateMatchWeather]    Script Date: 08/30/2012 08:45:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_UpdateMatchWeather]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_UpdateMatchWeather]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_UpdateMatchWeather]    Script Date: 08/30/2012 08:45:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--��    ��: [Proc_HB_UpdateMatchWeather]
--��    ��: �����������
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��11��11��
--�޸ļ�¼��




Create PROCEDURE [dbo].[Proc_HB_UpdateMatchWeather]
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

	-- ������ WeatherID, ����� TS_Weather_Conditions ����ؼ�¼
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
		SET @Result = 1								-- ���³ɹ�
	END

	-- δ���� WeatherID, ���� TS_Weather_Conditions �����������¼����������¼����
	ELSE
	BEGIN
		DECLARE @MaxWeatherID	INT

		SET Implicit_Transactions off
		BEGIN TRANSACTION		-- �趨����

		-- ���һ����¼
		INSERT TS_Weather_Conditions
		(F_Air_Temperature, F_Water_Temperature, F_Humidity, F_WeatherTypeID, F_Wind_Speed, F_WindDirectionID)
		VALUES
		(@AirTemp,@WaterTemp, @Humidity, @WeatherTypeID, @WindSpeed, @WindDirectionID)

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- ����ع�
			SET @Result = 0		-- ����ʧ��
			RETURN
		END

		-- ����ո����������¼�� ID
		SELECT @MaxWeatherID = MAX(F_WeatherID)
		FROM TS_Weather_Conditions

		UPDATE TS_Match
		SET F_WeatherID = @MaxWeatherID
		WHERE F_MatchID = @MatchID

		IF @@error<>0 
		BEGIN 
			ROLLBACK			-- ����ع�
			SET @Result = 0		-- ����ʧ��
			RETURN
		END

		COMMIT TRANSACTION		-- �ɹ��ύ����
		SET @Result = 1			-- ���³ɹ�
		RETURN
		END

SET NOCOUNT OFF
END

GO


