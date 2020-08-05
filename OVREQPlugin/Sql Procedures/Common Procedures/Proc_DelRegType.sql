IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelRegType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelRegType]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_DelRegType]
--描    述: 删除一种注册类型 (RegType)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_DelRegType]
	@RegTypeID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败, 标示没有做任何操作!
					  -- @Result = 1; 	删除成功!
					  -- @Result = -1;	删除失败, @RegTypeID 不存在!
					  -- @Result = -2;  删除失败，该 RegType 已被使用

	IF NOT EXISTS (SELECT F_RegTypeID FROM TC_RegType WHERE F_RegTypeID = @RegTypeID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_RegTypeID FROM TR_Register WHERE F_RegTypeID = @RegTypeID)
    BEGIN
        SET @Result = -2
        RETURN
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_RegType WHERE F_RegTypeID = @RegTypeID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 添加成功
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
DECLARE @RegTypeID INT
DECLARE @TestResult INT

-- Add one RegType
exec [Proc_AddRegType]  'CHN', '歇菜', '歇菜', '歇菜', @RegTypeID OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID

-- Delete One RegType
exec [Proc_DelRegType] @RegTypeID, @TestResult OUTPUT
SELECT * FROM TC_RegType WHERE F_RegTypeID = @RegTypeID
SELECT * FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TC_RegType_Des WHERE F_RegTypeID = @RegTypeID
DELETE FROM TC_RegType WHERE F_RegTypeID = @RegTypeID

*/