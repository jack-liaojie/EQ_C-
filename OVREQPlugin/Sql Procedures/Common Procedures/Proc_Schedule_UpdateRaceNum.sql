IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_UpdateRaceNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_UpdateRaceNum]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Schedule_UpdateRaceNum]
--描    述: 更新指定一场比赛的RaceNum, 用于赛事安排
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2009年11月16日
--修改记录：
/*			
			时间				修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Schedule_UpdateRaceNum]
	@MatchID				INT,
	@RaceNum				NVARCHAR(20),
	@Result					AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;	--@Result = 0;	更新失败，标示没有做任何操作！
						--@Result = 1;	更新成功  
						--@Result = -1; 更新失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	UPDATE TS_Match SET F_RaceNum = @RaceNum
	WHERE F_MatchID = @MatchID

	IF @@error<>0
	BEGIN 
		SET @Result = 0
		RETURN
	END

	SET @Result = 1

SET NOCOUNT OFF
END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
DECLARE @MatchID INT
DECLARE @RaceNum NVARCHAR(20)
DECLARE @Result INT

SET @MatchID = 453
SET @RaceNum = N'1111'

EXEC [Proc_Schedule_UpdateRaceNum] @MatchID, @RaceNum, @Result

SELECT @Result AS TestResult
SELECT F_RaceNum
FROM TS_Match
WHERE F_MatchID = @MatchID

*/