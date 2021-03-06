/****** Object:  StoredProcedure [dbo].[proc_EditSport]    Script Date: 11/19/2009 08:23:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditSport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditSport]
GO
/****** Object:  StoredProcedure [dbo].[proc_EditSport]    Script Date: 11/19/2009 08:22:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_EditSport]
----功		  能：添加一个Sport，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-09 

CREATE PROCEDURE [dbo].[proc_EditSport] (	
	@SportID			INT,
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
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	编辑Sport失败，标示没有做任何操作！
					-- @Result = 1; 	编辑Sport成功！

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Sport SET F_SportCode = @SportCode, F_OpenDate = @OpenDate, 
			F_CloseDate = @CloseDate, F_Order = @Order, F_SportInfo = @SportInfo
			WHERE F_SportID = @SportID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		IF NOT EXISTS (SELECT F_SportID FROM TS_Sport_Des WHERE F_SportID = @SportID AND F_LanguageCode = @languageCode)
		BEGIN
			insert into TS_Sport_Des (F_SportID, F_LanguageCode, F_SportLongName, F_SportShortName, F_SportComment)
				VALUES (@SportID, @languageCode, @SportLongName, @SportShortName, @SportComment)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Sport_Des SET F_SportLongName = @SportLongName, F_SportShortName = @SportShortName, F_SportComment = @SportComment
				WHERE F_SportID = @SportID AND F_LanguageCode = @languageCode
		
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
---------------------------------------------
--Edit Sport Config
		DECLARE @ConfigType INT
		DECLARE @ConfigName NVARCHAR(50)
		DECLARE @ConfigValue INT
		DECLARE @ConfigValueDes NVARCHAR(50)
		SET @ConfigType = 1
		SET @ConfigName = 'GroupType'
		SET @ConfigValue = 2
		SET @ConfigValueDes = '1-Federation,2-NOC,3-Club,4-Delegation'
 
        IF NOT EXISTS (SELECT F_SportID FROM TS_Sport_Config WHERE F_SportID = @SportID AND F_ConfigType = @ConfigType)
		BEGIN
			INSERT INTO TS_Sport_Config (F_SportID, F_ConfigType, F_ConfigName, F_ConfigValue, F_ConfigValueDes)
				VALUES (@SportID, @ConfigType, @ConfigName, @SportConfigValue, @ConfigValueDes)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Sport_Config SET F_ConfigName = @ConfigName, F_ConfigValue = @SportConfigValue, F_ConfigValueDes = @ConfigValueDes
				WHERE F_SportID = @SportID AND F_ConfigType = @ConfigType
		
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END
