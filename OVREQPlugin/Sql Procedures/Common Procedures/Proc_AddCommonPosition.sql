IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddCommonPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddCommonPosition]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AddCommonPosition]
--描    述: 为一个项目添加Position
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2011-01-17



CREATE PROCEDURE [dbo].[Proc_AddCommonPosition]
    @DisciplineID                   INT,
    @PositionCode                   NVARCHAR(10),
	@LanguageCode					CHAR(3),
	@PositionLongName				NVARCHAR(50),
	@PositionShortName				NVARCHAR(50),
	@PositionComment				NVARCHAR(50),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为PositionID
                      -- @Result = -1; 	添加失败，DisciplineID无效！

    IF NOT EXISTS(SELECT F_DisciplineID FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID)
    BEGIN
      SET @Result = -1
      RETURN
    END

    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	DECLARE @PositionID AS INT

    IF EXISTS(SELECT F_PositionID FROM TD_Position WHERE F_PositionCode = @PositionCode AND F_DisciplineID = @DisciplineID)
	BEGIN
      SELECT TOP 1 @PositionID = F_PositionID FROM TD_Position WHERE F_PositionCode = @PositionCode AND F_DisciplineID = @DisciplineID
	END
	ELSE
	BEGIN
        SELECT @PositionID = (CASE WHEN MAX(F_PositionID) IS NULL THEN 0 ELSE MAX(F_PositionID) END) + 1 FROM TD_Position
        INSERT INTO TD_Position (F_PositionID, F_DisciplineID, F_PositionCode) VALUES(@PositionID, @DisciplineID, @PositionCode)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END
	END

        DELETE FROM TD_Position_Des WHERE F_PositionID = @PositionID AND F_LanguageCode = @LanguageCode

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TD_Position_Des (F_PositionID, F_LanguageCode, F_PositionLongName, F_PositionShortName, F_PositionComment) 
			VALUES(@PositionID, @LanguageCode, @PositionLongName, @PositionShortName, @PositionComment)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @PositionID
	RETURN

SET NOCOUNT OFF
END

GO

