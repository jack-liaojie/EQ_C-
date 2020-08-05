IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelWeatherType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelWeatherType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--��    ��: [Proc_DelWeatherType]
--��    ��: ɾ��һ���������� (WeatherType)
--����˵��: 
--˵    ��: 
--�� �� ��: �����
--��    ��: 2009��8��26��



CREATE PROCEDURE [dbo].[Proc_DelWeatherType]
	@WeatherTypeID					INT,
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	ɾ��ʧ��, ��ʾû�����κβ���!
					  -- @Result = 1; 	ɾ���ɹ�!
					  -- @Result = -1;	ɾ��ʧ��, @WeatherTypeID ������!

	IF NOT EXISTS (SELECT F_WeatherTypeID FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		DELETE FROM TC_WeatherType_Des WHERE F_WeatherTypeID = @WeatherTypeID

        IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_WeatherType WHERE F_WeatherTypeID = @WeatherTypeID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- ɾ���ɹ�
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
exec [Proc_AddWeatherType]  'CHN', 'BigRain', '�ô����', '�ô����', @WeatherTypeID OUTPUT
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