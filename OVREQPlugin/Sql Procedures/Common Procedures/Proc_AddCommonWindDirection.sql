IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddCommonWindDirection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddCommonWindDirection]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddCommonWindDirection]
--描    述: 添加一种风向 (WindDirection)
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2011-01-17


CREATE PROCEDURE [dbo].[Proc_AddCommonWindDirection]
    @WindCode					    NVARCHAR(10),
    @Order                          NCHAR(10),
	@LanguageCode					CHAR(3),
	@WindDirectionLongName		    NVARCHAR(100),
	@WindDirectionShortName	        NVARCHAR(50),
    @WindDirectionComment		    NVARCHAR(100),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 WindDirectionID

	DECLARE @WinderDirectionID AS INT

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

    IF EXISTS(SELECT F_WindDirectionID FROM TC_WindDirection WHERE F_WindDirectionCode = @WindCode)
	BEGIN
      SELECT TOP 1 @WinderDirectionID = F_WindDirectionID FROM TC_WindDirection WHERE F_WindDirectionCode = @WindCode

      IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
        SELECT @WinderDirectionID = (CASE WHEN MAX(F_WindDirectionID) IS NULL THEN 0 ELSE MAX(F_WindDirectionID) END) + 1 FROM TC_WindDirection
        INSERT INTO TC_WindDirection (F_WindDirectionID, F_WindDirectionCode, F_Order) VALUES(@WinderDirectionID, @WindCode, @Order)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

    DELETE FROM TC_WindDirection_Des WHERE F_WindDirectionID = @WinderDirectionID AND F_LanguageCode = @LanguageCode

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_WindDirection_Des (F_WindDirectionID, F_LanguageCode, F_WindDirectionLongName, F_WindDirectionShortName, F_WindDirectionComment) 
			VALUES(@WinderDirectionID, @LanguageCode, @WindDirectionLongName, @WindDirectionShortName, @WindDirectionComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @WinderDirectionID
	RETURN

SET NOCOUNT OFF
END

GO


