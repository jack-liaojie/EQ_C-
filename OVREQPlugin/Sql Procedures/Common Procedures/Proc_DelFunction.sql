IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DelFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DelFunction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_DelFunction]
--描    述: 删除一种Function类型 (Function)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_DelFunction]
	@FunctionID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败, 标示没有做任何操作!
					  -- @Result = 1; 	删除成功!
					  -- @Result = -1;	删除失败, @FunctionID 不存在!

	IF NOT EXISTS (SELECT F_FunctionID FROM TD_Function WHERE F_FunctionID = @FunctionID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TD_Function_Des WHERE F_FunctionID = @FunctionID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TD_Function WHERE F_FunctionID = @FunctionID

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

	SET @Result = 1		-- 删除成功
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
DECLARE @FunctionID INT
DECLARE @TestResult INT

-- Add one Function
exec [Proc_AddFunction]  'CHN', 3, '超级主力', '超级主力', '超级主力', @FunctionID OUTPUT
SELECT * FROM TD_Function WHERE F_FunctionID = @FunctionID
SELECT * FROM TD_Function_Des WHERE F_FunctionID = @FunctionID

-- Delete One Function
exec [Proc_DelFunction] @FunctionID, @TestResult OUTPUT
SELECT * FROM TD_Function WHERE F_FunctionID = @FunctionID
SELECT * FROM TD_Function_Des WHERE F_FunctionID = @FunctionID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TD_Function_Des WHERE F_FunctionID = @FunctionID
DELETE FROM TD_Function WHERE F_FunctionID = @FunctionID

*/