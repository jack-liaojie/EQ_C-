IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_AddDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_AddDisciplineDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_AddDisciplineDate]
--描    述: 添加一个比赛日 (TS_DisciplineDate)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年11月10日
--修改记录：
/*			
			时间				修改人		修改内容	
			2010年6月23日		邓年彩		当 DateOrder 为 NULL 时, 自动赋为最大值 + 1.
			2010年6月24日		邓年彩		当此大项上存在此 Date 时, 则不添加.
			2010年7月2日		邓年彩		当存在此 Date时, 返回参数为 -1.
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_AddDisciplineDate]
	@DisciplineID					INT,
	@DateOrder						INT,
	@Date							NVARCHAR(50),
	@DateLongDescription			NVARCHAR(100),
	@DateShortDescription			NVARCHAR(50),
	@DateComment					NVARCHAR(100),
	@LanguageCode					CHAR(3),
	@Result							AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = -1;	存在此 Date时
					  -- @Result = 0; 	添加失败，标示没有做任何操作！
					  -- @Result >= 1; 	添加成功！此值即为 DisciplineDateID
					  
	-- 如果存在此 Date, 则不添加
	IF EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineID = @DisciplineID AND DATEDIFF(DAY, @Date, F_Date) = 0)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @NewDisciplineDateID AS INT

    IF EXISTS(SELECT F_DisciplineDateID FROM TS_DisciplineDate)
	BEGIN
      SELECT @NewDisciplineDateID = MAX(F_DisciplineDateID) FROM TS_DisciplineDate
      SET @NewDisciplineDateID = @NewDisciplineDateID + 1
	END
	ELSE
	BEGIN
		SET @NewDisciplineDateID = 1
	END
	
	IF @DateOrder = 0 OR @DateOrder IS NULL
	BEGIN
		SELECT @DateOrder = (CASE WHEN MAX(F_DateOrder) IS NULL THEN 0 ELSE MAX(F_DateOrder) END) + 1 FROM TS_DisciplineDate WHERE F_DisciplineID = @DisciplineID
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_DisciplineDate 
			(F_DisciplineDateID, F_DisciplineID, F_DateOrder, F_Date) 
		VALUES
			(@NewDisciplineDateID, @DisciplineID, @DateOrder, @Date)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        INSERT INTO TS_DisciplineDate_Des 
			(F_DisciplineDateID, F_LanguageCode, F_DateLongDescription, F_DateShortDescription, F_DateComment) 
			VALUES
			(@NewDisciplineDateID, @LanguageCode, @DateLongDescription, @DateShortDescription, @DateComment)

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

	SET @Result = @NewDisciplineDateID
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
DECLARE @TestResult INT

-- Add right
exec [Proc_Schedule_AddDisciplineDate]  1, 2, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @TestResult
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @TestResult

-- Delete that added for test
DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @TestResult
DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @TestResult

*/