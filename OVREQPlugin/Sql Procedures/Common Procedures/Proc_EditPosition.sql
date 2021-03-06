/****** Object:  StoredProcedure [dbo].[Proc_EditPosition]    Script Date: 11/11/2009 15:02:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_EditPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_EditPosition]
GO
/****** Object:  StoredProcedure [dbo].[Proc_EditPosition]    Script Date: 11/11/2009 14:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_EditPosition]
--描    述: 修改一种 Position 类型 (Position)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年8月26日
--修 改 人：李燕
--修改时间：2009-11-11
--修改内容：增加PositionCode


CREATE PROCEDURE [dbo].[Proc_EditPosition]
	@PositionID						INT,
	@LanguageCode					CHAR(3),
	@DisciplineID					INT,
    @PositionCode                   NVARCHAR(10),
	@PositionLongName				NVARCHAR(100),
	@PositionShortName				NVARCHAR(50),
	@PositionComment				NVARCHAR(100),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					  -- @Result = 1; 	更新成功！
					  -- @Result = -1;	更新失败，@PositionID 不存在！
					  -- @Result = -2;	更新失败，@PositionCode重复！

	IF NOT EXISTS (SELECT F_PositionID FROM TD_Position WHERE F_PositionID = @PositionID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_PositionID FROM TD_Position WHERE F_PositionCode = @PositionCode AND F_PositionID <> @PositionID AND F_DisciplineID = @DisciplineID)
	BEGIN
			SET @Result = -2
			RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	UPDATE TD_Position
	SET F_PositionCode = @PositionCode
	WHERE F_PositionID = @PositionID
		
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result = 0
		RETURN
	END

	-- Des 表中有该语言的描述就更新, 没有则添加
	IF EXISTS (SELECT F_PositionID FROM TD_Position_Des 
				WHERE F_PositionID = @PositionID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TD_Position_Des 
		SET F_PositionLongName = @PositionLongName
			, F_PositionShortName = @PositionShortName
			, F_PositionComment = @PositionComment
		WHERE F_PositionID = @PositionID
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
		INSERT INTO TD_Position_Des 
			(F_PositionID, F_LanguageCode, F_PositionLongName, F_PositionShortName, F_PositionComment) 
			VALUES
			(@PositionID, @LanguageCode, @PositionLongName, @PositionShortName, @PositionComment)
		
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
