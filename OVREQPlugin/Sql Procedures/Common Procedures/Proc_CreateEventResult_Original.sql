if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_CreateEventResult_Original]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_CreateEventResult_Original]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_CreateEventResult_Original]
----功		  能：生成项目成绩排名
----作		  者：郑金勇 
----日		  期: 2009-09-08
/*
	修改记录
	序号	日期			修改者		修改内容
	1		2010-12-15		郑金勇		仅仅是为当前的Event项目指定金银铜牌，以往的做法是为所有项目有名次的指定金银铜牌。
	2       2011-02-22      李燕        修改存储过程名字

*/
CREATE PROCEDURE [dbo].[Proc_CreateEventResult_Original] (	
													@EventID			INT
)	
AS
BEGIN
SET NOCOUNT ON

--Step 1: 首先将MatchResult中的参赛者写入 PhaseResult 和 EventResult
	
	UPDATE TS_Phase_Result SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Result AS A LEFT JOIN TS_Match_Result AS B 
			ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank WHERE A.F_PhaseID IN
				(SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID) AND A.F_SourceMatchRank IS NOT NULL AND A.F_SourceMatchRank <> 0

	UPDATE TS_Event_Result SET F_RegisterID = B.F_RegisterID FROM TS_Event_Result AS A LEFT JOIN TS_Match_Result AS B 
			ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank WHERE A.F_EventID = @EventID AND A.F_SourceMatchRank IS NOT NULL AND A.F_SourceMatchRank <> 0

--Step 2: 保证各Phase之间晋级关系成功
	CREATE TABLE #Temp_Table (F_PhaseID				INT,
						F_PhaseResultNumber		INT,
						F_PhaseRank				INT,
						F_RegisterID			INT,
						F_SourcePhaseID			INT,
						F_SourcePhaseRank		INT,
						F_Level					INT)
	INSERT INTO #Temp_Table (F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_RegisterID, F_SourcePhaseID, F_SourcePhaseRank, F_Level)
		SELECT F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_RegisterID, F_SourcePhaseID, F_SourcePhaseRank, 1 AS F_Level 
			FROM TS_Phase_Result WHERE F_PhaseID IN	(SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID)

	DECLARE @CurLevel AS INT
	SET @CurLevel = 1

	WHILE EXISTS (SELECT F_PhaseID FROM #Temp_Table WHERE F_PhaseID IN (SELECT F_SourcePhaseID FROM #Temp_Table WHERE F_Level = @CurLevel AND F_SourcePhaseRank IS NOT NULL))
	BEGIN

		UPDATE #Temp_Table SET F_Level = @CurLevel + 1 WHERE F_PhaseID IN (SELECT F_SourcePhaseID FROM #Temp_Table WHERE F_Level = @CurLevel AND F_SourcePhaseRank IS NOT NULL)
		SET @CurLevel = @CurLevel + 1

	END

	DELETE FROM #Temp_Table WHERE F_SourcePhaseID IS NULL OR F_SourcePhaseRank IS NULL

	WHILE (@CurLevel > 0)
	BEGIN

		UPDATE A SET F_RegisterID = C.F_RegisterID FROM TS_Phase_Result AS A RIGHT JOIN #Temp_Table AS B 
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber LEFT JOIN TS_Phase_Result AS C
				ON B.F_SourcePhaseID = C.F_PhaseID AND B.F_SourcePhaseRank = C.F_PhaseRank 
					WHERE B.F_Level = @CurLevel
		SET @CurLevel = @CurLevel -1

	END

--Step 3: 将PhaseResult中的参赛者写入 EventResult

	UPDATE TS_Event_Result SET F_RegisterID = B.F_RegisterID FROM TS_Event_Result AS A LEFT JOIN TS_Phase_Result AS B 
			ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank WHERE A.F_EventID = @EventID AND A.F_SourcePhaseRank IS NOT NULL AND A.F_SourcePhaseRank <> 0

--Step 4: 为EventResult中的参赛者指定奖牌

	UPDATE TS_Event_Result SET F_MedalID = ( CASE F_EventRank WHEN 1 THEN 1 WHEN  2 THEN 2 WHEN  3 THEN 3 ELSE NULL END) WHERE F_EventID = @EventID

SET NOCOUNT OFF
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*
exec [Proc_CreateEventResult] 1
*/