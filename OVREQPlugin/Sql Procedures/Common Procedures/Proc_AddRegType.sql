IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddRegType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddRegType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddRegType]
--描    述: 添加一种注册类型 (RegType)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_AddRegType]
	@LanguageCode				CHAR(3),
	@RegTypeLongDescription		NVARCHAR(50),
	@RegTypeShortDescription	NVARCHAR(50),
	@RegTypeComment				NVARCHAR(100),
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 RegTypeID

	DECLARE @NewRegTypeID AS INT

    IF EXISTS(SELECT F_RegTypeID FROM TC_RegType)
	BEGIN
      SELECT @NewRegTypeID = MAX(F_RegTypeID) FROM TC_RegType
      SET @NewRegTypeID = @NewRegTypeID + 1
	END
	ELSE
	BEGIN
		SET @NewRegTypeID = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TC_RegType (F_RegTypeID) VALUES(@NewRegTypeID)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_RegType_Des 
			(F_RegTypeID, F_LanguageCode, F_RegTypeLongDescription, F_RegTypeShortDescription, F_RegTypeComment) 
			VALUES
			(@NewRegTypeID, @LanguageCode, @RegTypeLongDescription, @RegTypeShortDescription, @RegTypeComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewRegTypeID
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
DECLARE @TestResult INT

-- Add right
exec [Proc_AddRegType]  'CHN', '歇菜', '歇菜', '歇菜', @TestResult OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @TestResult
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @TestResult

-- Delete that added for test
DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @TestResult
DELETE FROM TC_RegType WHERE F_RegTypeID = @TestResult

*/