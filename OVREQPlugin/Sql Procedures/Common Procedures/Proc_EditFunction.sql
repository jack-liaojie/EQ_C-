IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditFunction]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_EditFunction]
--描    述: 修改一种 Function 类型 (Function)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_EditFunction]
	@FunctionID						INT,
	@LanguageCode					CHAR(3),
	@DisciplineID					INT,
	@FunctionLongName				NVARCHAR(100),
	@FunctionShortName				NVARCHAR(50),
	@FunctionComment				NVARCHAR(100),
    @FunctionCode                   NVARCHAR(10),
    @FunctionCategoryCode           NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					  -- @Result = 1; 	更新成功！
					  -- @Result = -1;	更新失败，@FunctionID 不存在！
                      -- @Result = -2;  更新失败，存在相同的FunctionCode

	IF NOT EXISTS (SELECT F_FunctionID FROM TD_Function WHERE F_FunctionID = @FunctionID)
	BEGIN
		SET @Result = -1
		RETURN
	END
   
    IF EXISTS (SELECT F_FunctionID FROM TD_Function WHERE F_DisciplineID = @DisciplineID AND F_FunctionCode = @FunctionCode AND F_FunctionCategoryCode = @FunctionCategoryCode AND F_FunctionID <> @FunctionID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	UPDATE TD_Function
	SET F_DisciplineID = @DisciplineID, F_FunctionCode = @FunctionCode, F_FunctionCategoryCode = @FunctionCategoryCode
	WHERE F_FunctionID = @FunctionID
		
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result = 0
		RETURN
	END
    
	-- Des 表中有该语言的描述就更新, 没有则添加
	IF EXISTS (SELECT F_FunctionID FROM TD_Function_Des 
				WHERE F_FunctionID = @FunctionID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TD_Function_Des 
		SET F_FunctionLongName = @FunctionLongName
			, F_FunctionShortName = @FunctionShortName
			, F_FunctionComment = @FunctionComment
		WHERE F_FunctionID = @FunctionID
			AND F_LanguageCode = @LanguageCode
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
		INSERT INTO TD_Function_Des 
			(F_FunctionID, F_LanguageCode, F_FunctionLongName, F_FunctionShortName, F_FunctionComment) 
			VALUES
			(@FunctionID, @LanguageCode, @FunctionLongName, @FunctionShortName, @FunctionComment)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

	COMMIT TRANSACTION --成功提交事务

	IF @@error <> 0
	BEGIN
		SET @Result = 0
		RETURN
	END

	SET @Result = 1		-- 更新成功
	RETURN

SET NOCOUNT OFF
END
