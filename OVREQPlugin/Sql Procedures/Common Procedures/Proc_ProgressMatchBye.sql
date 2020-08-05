if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_ProgressMatchBye]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_ProgressMatchBye]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_ProgressMatchBye]
----功		  能：为淘汰赛晋级轮空的比赛仅仅一场比赛
----作		  者：郑金勇 
----日		  期: 2009-09-23 

/*
	修改记录
	序号	日期			修改者		修改内容
	1		2010-06-21		郑金勇		Match轮空晋级操作后，应该将所影响的Match的列表，包括自身查询返回出来！

*/

CREATE PROCEDURE [dbo].[Proc_ProgressMatchBye] (	
	@MatchID			INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	--此临时表用于列出参赛者发生变化的全部对象
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = 1表示是Match的参赛者发生变化，对应发送的消息是emMatchCompetitor
														 -- F_Type = 2表示是Match的本身发生轮空晋级，即本身的Match的状态发生变化啊，比赛自动生成轮空者获胜这一结果！对应的发送消息emMatchResult.
									F_MatchID		INT
								  )

	CREATE TABLE #table_Competitors (
                                F_SportID				INT,
                                F_DisciplineID			INT,
								F_EventID				INT, 
								F_PhaseID				INT,
								F_PhaseName				NVARCHAR(100),
								F_MatchID				INT,
								F_MatchOrder			INT,
								F_MatchName				NVARCHAR(150),
                                F_CompetitionPosition   INT,
								F_RegisterID			INT,
								F_ResultID				INT,
                                F_Rank					INT
							 )

	INSERT INTO #table_Competitors (F_PhaseID, F_MatchID, F_MatchOrder, F_CompetitionPosition, F_RegisterID, F_ResultID, F_Rank)
		SELECT   A.F_PhaseID, A.F_MatchID, A.F_Order, D.F_CompetitionPosition, D.F_RegisterID, D.F_ResultID, D.F_Rank
			FROM TS_Match AS A LEFT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID WHERE A.F_MatchID = @MatchID
		

	DELETE FROM #table_Competitors WHERE F_MatchID IN (SELECT F_MatchID FROM (SELECT F_MatchID, Count(F_CompetitionPosition) AS CompetitorNum FROM #table_Competitors  group BY F_MatchID) AS A WHERE A.CompetitorNum != 2)
	DELETE FROM #table_Competitors WHERE F_MatchID NOT IN (SELECT F_MatchID FROM #table_Competitors WHERE F_RegisterID = -1)

	DELETE FROM #table_Competitors WHERE F_MatchID IN (SELECT A.F_MatchID FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchStatusID = 110)

	DELETE FROM #table_Competitors WHERE F_RegisterID IS NULL
	UPDATE #table_Competitors SET F_ResultID = 1, F_Rank = 1 WHERE F_RegisterID <> -1
	UPDATE #table_Competitors SET F_ResultID = 2, F_Rank = 2 WHERE F_RegisterID = -1

	UPDATE TS_Match_Result SET F_ResultID = B.F_ResultID, F_Rank = B.F_Rank FROM TS_Match_Result AS A RIGHT JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
	UPDATE TS_Match SET F_MatchStatusID = 110 WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Competitors)
	INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 2 AS F_Type, F_MatchID FROM #table_Competitors

	INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1 AS F_Type, A.F_MatchID FROM TS_Match_Result AS A RIGHT JOIN #table_Competitors AS B 
		ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank 
		LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID < 40

	UPDATE TS_Match_Result SET F_RegisterID = B.F_RegisterID FROM TS_Match_Result AS A RIGHT JOIN #table_Competitors AS B 
		ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank
		LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID < 40

	SELECT DISTINCT * FROM #Temp_ChangeList
	RETURN
SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




--	EXEC Proc_ProgressMatchBye 1
