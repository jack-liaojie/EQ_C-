IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddNation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddNation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_AddNation]
----功		  能：添加一个Nation
----作		  者：张翠霞 
----日		  期: 2009-05-20

CREATE PROCEDURE [dbo].[Proc_AddNation]
    @LanguageCode		CHAR(3),
	@NationLongName		NVARCHAR(50),
	@NationShortName	NVARCHAR(50),
	@NationComment		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	添加Nation失败，标示没有做任何操作！
					  -- @Result>=1; 	添加Nation成功，返回NationID

    DECLARE @NewNationID INT
    SELECT @NewNationID = (CASE WHEN MAX(F_NationID) IS NULL THEN 0 ELSE MAX(F_NationID) END) + 1 FROM TC_Nation

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_Nation (F_NationID) VALUES (@NewNationID)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TC_Nation_Des (F_NationID, F_LanguageCode, F_NationLongName, F_NationShortName, F_NationComment) VALUES(@NewNationID, @LanguageCode, @NationLongName, @NationShortName, @NationComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewNationID
	RETURN

SET NOCOUNT OFF
END

GO


