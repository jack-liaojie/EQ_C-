/****** Object:  StoredProcedure [dbo].[Proc_AddFunction]    Script Date: 12/29/2009 16:24:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddFunction]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddFunction]    Script Date: 12/29/2009 15:48:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddFunction]
--描    述: 添加一种 Function 类型 (Function)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日



CREATE PROCEDURE [dbo].[Proc_AddFunction]   
	@LanguageCode					CHAR(3),
	@DisciplineID					INT,
	@FunctionLongName				NVARCHAR(50),
	@FunctionShortName				NVARCHAR(50),
	@FunctionComment				NVARCHAR(50),
    @FunctionCode                   NVARCHAR(10),
    @FunctionCategoryCode           NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 FunctionID
                      -- @Result = -1;  添加失败！存在相同CategoryCode的FunctionCode

	DECLARE @NewFunctionID AS INT
    
    IF EXISTS(SELECT F_FunctionID FROM TD_Function WHERE F_DisciplineID = @DisciplineID AND F_FunctionCode = @FunctionCode AND F_FunctionCategoryCode = @FunctionCategoryCode)
    BEGIN
          SET @Result = -1
          RETURN
    END
    
    IF EXISTS(SELECT F_FunctionID FROM TD_Function)
	BEGIN
      SELECT @NewFunctionID = MAX(F_FunctionID) FROM TD_Function
      SET @NewFunctionID = @NewFunctionID + 1
	END
	ELSE
	BEGIN
		SET @NewFunctionID = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TD_Function (F_FunctionID, F_DisciplineID, F_FunctionCode, F_FunctionCategoryCode) VALUES(@NewFunctionID, @DisciplineID, @FunctionCode, @FunctionCategoryCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TD_Function_Des 
			(F_FunctionID, F_LanguageCode, F_FunctionLongName, F_FunctionShortName, F_FunctionComment) 
			VALUES
			(@NewFunctionID, @LanguageCode, @FunctionLongName, @FunctionShortName, @FunctionComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = @NewFunctionID
	RETURN

SET NOCOUNT OFF
END 
