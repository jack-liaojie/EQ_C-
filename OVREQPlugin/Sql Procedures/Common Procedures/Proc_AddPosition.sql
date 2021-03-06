/****** Object:  StoredProcedure [dbo].[Proc_AddPosition]    Script Date: 11/11/2009 14:50:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddPosition]
GO
/****** Object:  StoredProcedure [dbo].[Proc_AddPosition]    Script Date: 11/11/2009 14:43:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddPosition]
--描    述: 添加一种 Position 类型 (Position)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日
--修 改 人：李燕
--修改时间：2009-11-11
---修改内容：增加PositionCode



CREATE PROCEDURE [dbo].[Proc_AddPosition]
	@LanguageCode					CHAR(3),
	@DisciplineID					INT,
    @PositionCode                   NVARCHAR(10),
	@PositionLongName				NVARCHAR(50),
	@PositionShortName				NVARCHAR(50),
	@PositionComment				NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 PositionID
                      ---@Result = -1;   添加失败，PositionCode有重复

    IF EXISTS(SELECT F_PositionID FROM TD_Position WHERE F_PositionCode = @PositionCode AND F_DisciplineID = @DisciplineID)
    BEGIN
      SET @Result = -1
      RETURN
	END


	DECLARE @NewPositionID AS INT

    IF EXISTS(SELECT F_PositionID FROM TD_Position)
	BEGIN
      SELECT @NewPositionID = MAX(F_PositionID) FROM TD_Position
      SET @NewPositionID = @NewPositionID + 1
	END
	ELSE
	BEGIN
		SET @NewPositionID = 1
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TD_Position (F_PositionID, F_DisciplineID, F_PositionCode) VALUES(@NewPositionID, @DisciplineID, @PositionCode)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TD_Position_Des 
			(F_PositionID, F_LanguageCode, F_PositionLongName, F_PositionShortName, F_PositionComment) 
			VALUES
			(@NewPositionID, @LanguageCode, @PositionLongName, @PositionShortName, @PositionComment)

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

	SET @Result = @NewPositionID
	RETURN

SET NOCOUNT OFF
END
