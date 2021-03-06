IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditNation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditNation]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_EditNation]
----功		  能：修改一个Nation
----作		  者：张翠霞 
----日		  期: 2009-05-20

CREATE PROCEDURE [dbo].[Proc_EditNation]
    @NationID             INT,
    @LanguageCode		CHAR(3),
	@NationLongName		NVARCHAR(50),
	@NationShortName    NVARCHAR(50),
    @NationComment		NVARCHAR(50),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改Nation失败，标示没有做任何操作！
					  -- @Result>=1; 	修改Nation成功！
					  -- @Result=-1; 	修改Nation失败, @NationID不存在

	IF NOT EXISTS(SELECT F_NationID FROM TC_Nation WHERE F_NationID = @NationID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

        IF NOT EXISTS (SELECT F_NationID FROM TC_Nation_Des WHERE F_NationID = @NationID AND F_LanguageCode = @LanguageCode)
		BEGIN
			INSERT INTO TC_Nation_Des (F_NationID, F_LanguageCode, F_NationLongName, F_NationShortName, F_NationComment) VALUES(@NationID, @LanguageCode, @NationLongName, @NationShortName, @NationComment)
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
            UPDATE TC_Nation_Des SET F_LanguageCode = @LanguageCode, F_NationLongName = @NationLongName, F_NationShortName = @NationShortName, F_NationComment = @NationComment WHERE F_NationID = @NationID AND F_LanguageCode = @LanguageCode
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

GO


