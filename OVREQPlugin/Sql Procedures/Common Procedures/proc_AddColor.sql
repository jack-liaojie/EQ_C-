IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddColor]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddColor]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[proc_AddColor]
----功		  能：添加一个Color
----作		  者：张翠霞 
----日		  期: 2009-04-24 

CREATE PROCEDURE [dbo].[proc_AddColor]
    @LanguageCode		CHAR(3),
	@ColorLongName		NVARCHAR(100),
	@ColorShortName		NVARCHAR(50),
	@ColorComment		NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Color失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Color成功！此值即为ColorID

	DECLARE @NewColorID AS INT
    IF EXISTS(SELECT F_ColorID FROM TC_Color)
      BEGIN
      SELECT @NewColorID = MAX(F_ColorID) FROM TC_Color
      SET @NewColorID = @NewColorID + 1
      END
    ELSE
      BEGIN
      SET @NewColorID = 1
      END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_Color (F_ColorID) VALUES(@NewColorID)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_Color_Des (F_ColorID, F_LanguageCode, F_ColorLongName, F_ColorShortName, F_ColorComment) VALUES(@NewColorID, @LanguageCode, @ColorLongName, @ColorShortName, @ColorComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewColorID
	RETURN

SET NOCOUNT OFF
END

GO

