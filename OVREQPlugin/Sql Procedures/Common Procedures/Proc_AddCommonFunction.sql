IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddCommonFunction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddCommonFunction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_AddCommonFunction]
--描    述: 添加一种 Function 类型 (Function)
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2011-01-17



CREATE PROCEDURE [dbo].[Proc_AddCommonFunction]
    @DisciplineID                   INT,
    @FunctionCode                   NVARCHAR(10),
    @FunctionCategoryCode           NVARCHAR(50),
	@LanguageCode					CHAR(3),
	@FunctionLongName				NVARCHAR(50),
	@FunctionShortName				NVARCHAR(50),
	@FunctionComment				NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 FunctionID
                      -- @Result = -1; 	添加失败，DisciplineID无效！

    IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
    BEGIN
      SET @Result = -1
      RETURN
    END

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	DECLARE @FunctionID AS INT

    IF EXISTS(SELECT F_FunctionID FROM TD_Function WHERE F_FunctionCode = @FunctionCode AND F_DisciplineID = @DisciplineID)
	BEGIN
      SELECT TOP 1 @FunctionID = F_FunctionID FROM TD_Function WHERE F_FunctionCode = @FunctionCode AND F_DisciplineID = @DisciplineID
      UPDATE TD_Function SET F_FunctionCategoryCode = @FunctionCategoryCode WHERE F_FunctionID = @FunctionID

      IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END
	ELSE
	BEGIN
        SELECT @FunctionID = (CASE WHEN MAX(F_FunctionID) IS NULL THEN 0 ELSE MAX(F_FunctionID) END) + 1 FROM TD_Function
        INSERT INTO TD_Function (F_FunctionID, F_DisciplineID, F_FunctionCode, F_FunctionCategoryCode) VALUES(@FunctionID, @DisciplineID, @FunctionCode, @FunctionCategoryCode)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

        DELETE FROM TD_Function_Des WHERE F_FunctionID = @FunctionID AND F_LanguageCode = @LanguageCode

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TD_Function_Des (F_FunctionID, F_LanguageCode, F_FunctionLongName, F_FunctionShortName, F_FunctionComment) 
			VALUES(@FunctionID, @LanguageCode, @FunctionLongName, @FunctionShortName, @FunctionComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TC_RegtypeFunction WHERE F_FunctionID = @FunctionID
    
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TC_RegtypeFunction (F_RegtypeID, F_FunctionID)
            SELECT TOP 1 F_RegTypeID, @FunctionID AS F_FunctionID FROM TC_RegType WHERE F_RegTypeCode = @FunctionCategoryCode

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @FunctionID
	RETURN

SET NOCOUNT OFF
END

GO



