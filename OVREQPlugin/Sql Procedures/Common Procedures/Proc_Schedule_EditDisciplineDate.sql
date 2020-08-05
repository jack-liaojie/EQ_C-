IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_EditDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_EditDisciplineDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_EditDisciplineDate]
--描    述: 修改一个比赛日 (TS_DisciplineDate)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年11月10日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_EditDisciplineDate]
	@DisciplineDateID					INT,
	@DateOrder							INT,
	@Date								NVARCHAR(50),
	@DateLongDescription				NVARCHAR(100),
	@DateShortDescription				NVARCHAR(50),
	@DateComment						NVARCHAR(100),
	@LanguageCode						CHAR(3),
	@Result								INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	更新失败，标示没有做任何操作！
					  -- @Result = 1; 	更新成功！
					  -- @Result = -1;	更新失败，@DisciplineDateID 不存在！

	IF NOT EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	UPDATE TS_DisciplineDate
	SET F_DateOrder = @DateOrder, F_Date = @Date
	WHERE F_DisciplineDateID = @DisciplineDateID
		
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result = 0
		RETURN
	END

	-- Des 表中有该语言的描述就更新, 没有则添加
	IF EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate_Des 
				WHERE F_DisciplineDateID = @DisciplineDateID AND F_LanguageCode = @LanguageCode)
	BEGIN
		UPDATE TS_DisciplineDate_Des 
		SET F_DateLongDescription = @DateLongDescription
			, F_DateShortDescription = @DateShortDescription
			, F_DateComment = @DateComment
		WHERE F_DisciplineDateID = @DisciplineDateID
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
		INSERT INTO TS_DisciplineDate_Des 
			(F_DisciplineDateID, F_LanguageCode, F_DateLongDescription, F_DateShortDescription, F_DateComment) 
			VALUES
			(@DisciplineDateID, @LanguageCode, @DateLongDescription, @DateShortDescription, @DateComment)
		
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
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for Test
DECLARE @DisciplineDateID INT
DECLARE @TestResult INT

-- Add one DisciplineDate
exec [Proc_Schedule_AddDisciplineDate]  1, 2, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SET @DisciplineDateID = @TestResult
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID

-- Update One DisciplineDate
exec [Proc_Schedule_EditDisciplineDate] @DisciplineDateID, 2, '2009-09-27', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
exec [Proc_Schedule_EditDisciplineDate] @DisciplineDateID, 2, '2009-09-27', '第二天', '第二天', '第二天', 'CHN', @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
SELECT @TestResult AS [RESULT 1]

-- Update, @DisciplineDateID 不存在
SET @DisciplineDateID = @DisciplineDateID + 1
exec [Proc_Schedule_EditDisciplineDate] @DisciplineDateID, 3, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
SELECT @TestResult AS [RESULT -1]

-- Delete that added for test
SET @DisciplineDateID = @DisciplineDateID - 1
DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID

*/