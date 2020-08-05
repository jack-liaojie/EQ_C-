IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_DelDisciplineDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_DelDisciplineDate]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_DelDisciplineDate]
--描    述: 删除一个比赛日 (TS_DisciplineDate)
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年11月10日
--修改记录：
/*			
			时间				修改人		修改内容	
			2010年6月24日		邓年彩		当此大项的 TS_Session 的 F_Date 与该 Date 相同, 则不允许删除, 返回结果为 -2.
*/




CREATE PROCEDURE [dbo].[Proc_Schedule_DelDisciplineDate]
	@DisciplineDateID					INT,
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	删除失败, 标示没有做任何操作!
					  -- @Result = 1; 	删除成功!
					  -- @Result = -1;	删除失败, @DisciplineDateID 不存在!
					  -- @Result = -2;	删除失败, 此 Date 下已建 Session.

	IF NOT EXISTS (SELECT F_DisciplineDateID FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF EXISTS (SELECT S.F_SessionID FROM TS_Session AS S, TS_DisciplineDate AS D 
		WHERE D.F_DisciplineDateID = @DisciplineDateID AND S.F_DisciplineID = D.F_DisciplineID AND DATEDIFF(day, D.F_Date, S.F_SessionDate) = 0 ) 
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

        DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID

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
DECLARE @DisciplineDateID INT
DECLARE @TestResult INT

-- Add one DisciplineDate
exec [Proc_Schedule_AddDisciplineDate]  1, 2, '2009-09-26', 'Day 2', 'D2', 'Day 2', 'ENG', @TestResult OUTPUT
SET @DisciplineDateID = @TestResult
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID

-- Delete One DisciplineDate
exec [Proc_Schedule_DelDisciplineDate] @DisciplineDateID, @TestResult OUTPUT
SELECT * FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID
SELECT * FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
SELECT @TestResult AS [RESULT 1]

-- Delete that added for test
DELETE FROM TS_DisciplineDate_Des WHERE F_DisciplineDateID = @DisciplineDateID
DELETE FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DisciplineDateID

*/