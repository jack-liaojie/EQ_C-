/****** Object:  StoredProcedure [dbo].[proc_EditSport_Config]    Script Date: 11/17/2009 16:44:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditSport_Config]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditSport_Config]
GO
/****** Object:  StoredProcedure [dbo].[proc_EditSport_Config]    Script Date: 11/17/2009 16:39:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[proc_EditSport_Config]
----功		  能：修改SportConfig
----作		  者：李燕 
----日		  期: 2009-11-17

CREATE PROCEDURE [dbo].[proc_EditSport_Config] (	
	@SportID			INT,
	@ConfigType			INT,
	@ConfigName			NVARCHAR(50),
	@ConfigValue		int,
	@ConfigValueDes	    NVARCHAR(50),
	@Result 			AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	编辑SportConfig失败，标示没有做任何操作！
					-- @Result = 1; 	编辑SportConfig成功！

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		IF NOT EXISTS (SELECT F_SportID FROM TS_Sport_Config WHERE F_SportID = @SportID AND F_ConfigType = @ConfigType)
		BEGIN
			INSERT INTO TS_Sport_Config (F_SportID, F_ConfigType, F_ConfigName, F_ConfigValue, F_ConfigValueDes)
				VALUES (@SportID, @ConfigType, @ConfigName, @ConfigValue, @ConfigValueDes)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Sport_Config SET F_ConfigName = @ConfigName, F_ConfigValue = @ConfigValue, F_ConfigValueDes = @ConfigValueDes
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
