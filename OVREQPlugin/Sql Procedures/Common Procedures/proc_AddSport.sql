/****** Object:  StoredProcedure [dbo].[proc_AddSport]    Script Date: 11/19/2009 08:18:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddSport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddSport]
GO
/****** Object:  StoredProcedure [dbo].[proc_AddSport]    Script Date: 11/19/2009 08:18:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：proc_AddSport
----功		  能：添加一个Sport，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09 

CREATE PROCEDURE [dbo].[proc_AddSport] 
	@SportCode			NVARCHAR(10),
	@OpenDate			DATETIME,
	@CloseDate			DATETIME,
	@Order				INT,
	@SportInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@SportLongName		NVARCHAR(100),
	@SportShortName		NVARCHAR(50),
	@SportComment		NVARCHAR(100),
    @SportConfigValue   INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Sport失败，标示没有做任何操作！
					-- @Result>=1; 	添加Sport成功！此值即为SportID
	DECLARE @NewSportID AS INT

	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Sport
	END

    DECLARE @ConfigType INT
    DECLARE @ConfigName NVARCHAR(50)
    DECLARE @ConfigValue INT
    DECLARE @ConfigValueDes NVARCHAR(50)
    SET @ConfigType = 1
    SET @ConfigName = 'GroupType'
    SET @ConfigValue = 2
    SET @ConfigValueDes = '1-Federation,2-NOC,3-Club,4-Delegation'
    
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Sport (F_SportCode, F_OpenDate, F_CloseDate, F_Order, F_SportInfo, F_Active)
			VALUES (@SportCode, @OpenDate, @CloseDate, @Order, @SportInfo, 0)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewSportID = @@IDENTITY

		INSERT INTO TS_Sport_Des (F_SportID, F_LanguageCode, F_SportLongName, F_SportShortName, F_SportComment)
			VALUES (@NewSportID, @languageCode, @SportLongName, @SportShortName, @SportComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
        INSERT INTO TS_Sport_Config (F_SportID, F_ConfigType, F_ConfigName, F_ConfigValue, F_ConfigValueDes)
			VALUES (@NewSportID, @ConfigType, @ConfigName, @SportConfigValue, @ConfigValueDes)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewSportID
	RETURN

SET NOCOUNT OFF
END




