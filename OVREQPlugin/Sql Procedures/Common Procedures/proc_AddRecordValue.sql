IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddRecordValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddRecordValue]

GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：proc_AddRecordValue
----功		  能：添加RecordValue
----作		  者：张翠霞
----日		  期: 2009-11-10 
----修        改：管仁良 2009-12-14

CREATE PROCEDURE [dbo].[proc_AddRecordValue] 
	@RecordID		    INT,
	@bAddNew			BIT = 1,			-- 1: 添加，0：修改
	@ValueNum			INT = NULL,			-- 如果 @bAddNew = 0，此参数必须不为空
	@ValueType		    NVARCHAR(50) = NULL,
	@IntValue1			INT = NULL,
	@IntValue2			INT = NULL,
	@CharValue1			NVARCHAR(50) = NULL,
	@CharValue2			NVARCHAR(50) = NULL,
	@Result 			AS INT  = 0 OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加RecordValue失败，标示没有做任何操作！
					-- @Result=1; 	添加RecordValue成功！如果是添加 @Result = NewValueNum
					-- @Result=-1; 	添加RecordValue失败，@RecordID无效	

	IF NOT EXISTS(SELECT F_RecordID FROM TS_Event_Record WHERE F_RecordID = @RecordID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	-- 添加
	IF @bAddNew = 1
	BEGIN

		DECLARE @NewValueNum INT
		SELECT @NewValueNum = (CASE WHEN MAX(F_ValueNum) IS NULL THEN 0 ELSE MAX(F_ValueNum) END) + 1 FROM TS_Record_Values WHERE F_RecordID = @RecordID

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			INSERT INTO TS_Record_Values (F_RecordID, F_ValueNum, F_ValueType, F_IntValue1, F_IntValue2, F_CharValue1, F_CharValue2)
				VALUES (@RecordID, @NewValueNum, @ValueType, @IntValue1, @IntValue2, @CharValue1, @CharValue2)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务

		SET @Result = @NewValueNum
		RETURN
	END

	-- 修改
	ELSE
	BEGIN

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			UPDATE TS_Record_Values SET
				F_ValueType = @ValueType, 
				F_IntValue1 = @IntValue1, 
				F_IntValue2 = @IntValue2,
				F_CharValue1 = @CharValue1,
				F_CharValue2 = @CharValue2
			WHERE F_RecordID = @RecordID AND F_ValueNum = @ValueNum

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

		COMMIT TRANSACTION --成功提交事务

		SET @Result = 1
		RETURN

	END

SET NOCOUNT OFF
END



