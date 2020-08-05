IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_SetMatchCodeByTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_SetMatchCodeByTime]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称: [Proc_Schedule_SetMatchCodeByTime]
--描    述: 赛事安排根据时间顺序排出指定比赛的 MatchCode
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年12月11日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_SetMatchCodeByTime]
	@MatchIDList			NVARCHAR(MAX),
	@Prefix					NVARCHAR(10),
	@StartNum				INT,
	@Step					INT,
	@Length					INT,
	@Result					INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL			NVARCHAR(MAX)

	CREATE TABLE #tmp_table
	(
		F_MatchID		INT,
		F_MatchDate		DateTime,
		F_StartTime		NVARCHAR(10),
		F_RowNum		INT,
		F_MatchCode		NVARCHAR(20)
	)

	-- 添加 MatchID, MatchDate, StartTime 等基础信息
	SET @SQL = '
		INSERT INTO #tmp_table
		(F_MatchID, F_MatchDate, F_StartTime)
		(
			SELECT F_MatchID, F_MatchDate, CONVERT(NVARCHAR(10), F_StartTime, 108)
			FROM TS_Match
			WHERE F_MatchID IN (' + @MatchIDList + ')
		)
	'

	EXEC (@SQL)

	-- 根据 MatchDate, StartTime 排序给出 RowNum
	UPDATE #tmp_table
	SET F_RowNum = B.F_RowNum
	FROM #tmp_table AS A
	LEFT JOIN ( 
		SELECT F_MatchID, ROW_NUMBER() OVER (ORDER BY F_MatchDate, F_StartTime) AS F_RowNum
		FROM #tmp_table
	) AS B
		ON A.F_MatchID = B.F_MatchID
	
	-- 根据 RowNum 计算出 MatchCode
	IF @Length <> 0			-- 当 Length 不为 0 时, 前面补 0 ; 当 Length 为 0, 清空 MatchCode
	BEGIN
		UPDATE #tmp_table
		SET F_MatchCode = @Prefix 
				+ REPLICATE(N'0'
					, CASE 
						WHEN @Length - LEN(CONVERT(NVARCHAR(10), (F_RowNum - 1) * @Step  + @StartNum)) < 0 THEN 0
						ELSE @Length - LEN(CONVERT(NVARCHAR(10), (F_RowNum - 1) * @Step  + @StartNum))
					END
				)
				+ CONVERT(NVARCHAR(10), (F_RowNum - 1) * @Step  + @StartNum)
	END
		
	SET Implicit_Transactions off
	BEGIN TRANSACTION		-- 设定事务

	-- 更新 TS_Match 中的 F_MatchCode 字段
	UPDATE TS_Match
	SET F_MatchCode = B.F_MatchCode
	FROM TS_Match AS A
	INNER JOIN #tmp_table AS B
		ON A.F_MatchID = B.F_MatchID

	IF @@error<>0 
	BEGIN 
		ROLLBACK			-- 事务回滚
		SET @Result = 0		-- 更新失败
		RETURN
	END

	COMMIT TRANSACTION		-- 成功提交事务
	SET @Result = 1			-- 更新成功
	RETURN

SET NOCOUNT OFF
END

/*

DECLARE @Result		INT
EXEC [Proc_Schedule_SetMatchCodeByTime] N'1515, 1512, 1513, 1511', N'A', 3, 5, 5, @Result OUT
SELECT F_MatchID, F_MatchCode FROM TS_Match

*/