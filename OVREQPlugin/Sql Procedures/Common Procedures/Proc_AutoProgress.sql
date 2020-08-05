IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoProgress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoProgress]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_AutoProgress]
----功		  能：自动晋级,包括Match晋级，Phase晋级--第一步先做Match晋级--第二步晋级Phase
----作		  者：郑金勇 
----日		  期: 2009-04-20 
/*
	功 能  描 述：关于Match和Phase的自动晋级，
				  当前的操作仅仅是考虑TS_MatchResult中的参赛者的变化，
				  并没有去处理TS_Phase_Position和TS_Phase_Result的参赛者的变化。
				  并且，我希望对应的TS_Phase_Position和TS_Phase_Result分别提供两类的参赛运动员的抓取操作。
				  而TS_Event_Result的参赛者的变化则是在奖牌计算排名时进行的，也不用在此处理，应该是抓取的操作。
*/

/*
	修改记录
	序号	日期			修改者		修改内容
	1		2010-06-18		郑金勇		Match的晋级需要进行两类操作，
											一方面，Match本身的状态如果是小于StartList的，应该将参赛者抓取过来。抓取时考虑来源是PhaseResult里面的情况！
											另一方面，Match本身的状态如果是Unoffical或者是Finished,应该根据本场比赛的结果，晋级参赛者

	2		2010-06-18		郑金勇		Phase的晋级仅仅做一类操作，
											一方面，如果Phase的状态为小于StartList的，并不作任何的参赛者抓取操作，原因是影响较大，作用不大！
											另一方面，如果Phase的状态为Finished, 应该根据本场阶段的结果，晋级参赛者。

	3		2010-06-18		郑金勇		Match和Phase晋级操作后，应该将所影响的Match的列表，以及Phase的列表查询返回出来！

	
	4		2011-03-25		郑金勇		复活晋级所影响的Match发送MatchCompetitor消息。
	
	5		2011-06-12		郑金勇		晋级操作应该考虑，小组赛的签位如何晋级,此时不仅仅考虑抓取操作,而且也考虑晋级操作。
*/
CREATE PROCEDURE [dbo].[Proc_AutoProgress] (	
	@PhaseID			INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	--此临时表用于列出参赛者发生变化的全部对象
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = 1表示是Match的参赛者发生变化，对应发送的消息是emMatchCompetitor
									F_MatchID		INT
								  )

	--此临时表用于存储该Phase节点下的PhaseTree
	CREATE TABLE #table_Tree (
								F_EventID			INT, 
								F_PhaseID			INT,
								F_FatherPhaseID		INT,
								F_PhaseNodeType		INT,
								F_MatchID			INT,
								F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
								F_NodeLevel			INT,
								F_Order             INT
							 )

	--处理Match晋级
	CREATE TABLE #Temp_Match2Match(
										F_MatchID					INT,
										F_CompetitionPosition		INT,
										F_SourceMatchID				INT,
										F_SourceMatchRank			INT,
										F_SourceCompetitionPosition	INT,
										F_SourceRegisterID			INT,
										F_SourceMatchStatusID		INT,
										F_SourceRankNum				INT
									)

	--处理复活赛晋级而需要定义的临时表和变量
	CREATE TABLE #TempMatchHistory(
									   F_StartMatchID				INT,
									   F_StartMatchRank				INT,
									   F_Level						INT,
									   F_MatchID					INT,
									   F_CompetitionPosition		INT,
									   F_Rank						INT,
									   F_RegisterID					INT,
									   F_SourceMatchID				INT,
									   F_SourceMatchRank			INT,
									   F_LoseRegisterID				INT,
									   F_LoseCompetitionPosition	INT
								  )

	--处理Phase晋级
	CREATE TABLE #Temp_Phase2Match(
										F_MatchID					INT,
										F_CompetitionPosition		INT,
										F_SourcePhaseID				INT,
										F_SourcePhaseRank			INT,
										F_SourceRegisterID			INT,
										F_SourcePhaseStatusID		INT,
										F_SourceRankNum				INT
									)

	CREATE TABLE #Temp_PhaseChildMatch(
										F_TopPhaseID				INT,
										F_PhaseID					INT,
										F_FatherPhaseID				INT,
										F_Level						INT,
										F_Type						INT,
										F_MatchID					INT
										)
	
	--存储需要晋级的PhasePosition
	CREATE TABLE #Temp_Match2Phase(
										F_PhaseID					INT,
										F_PhasePosition				INT,
										F_SourceMatchID				INT,
										F_SourceMatchRank			INT,
										F_SourceMatchStatusID		INT,
										F_SourceCompetitionPosition	INT,
										F_SourceRegisterID			INT,
										F_SourceRankNum				INT,
										F_PhaseType					INT,
										F_PhaseStatusID				INT
									)
									
	CREATE TABLE #Temp_Phase2Phase(
										F_PhaseID					INT,
										F_PhasePosition				INT,
										F_SourcePhaseID				INT,
										F_SourcePhaseRank			INT,
										F_SourcePhaseStatusID		INT,
										F_SourcePhasePosition		INT,
										F_SourceRegisterID			INT,
										F_SourceRankNum				INT,
										F_PhaseType					INT,
										F_PhaseStatusID				INT
									)
--	--此临时表用于存储该Phase节点下的结束的比赛
--	CREATE TABLE #table_FinishedMatch(F_MatchID		INT)

	--此临时表用于存储该Phase节点下的可重复指定参赛人员的比赛
	CREATE TABLE #table_BeforeStartListMatch(F_MatchID		INT)

	INSERT INTO #table_Tree(F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel, F_Order)
		SELECT A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order
		  FROM TS_Phase AS A  WHERE A.F_PhaseID = @PhaseID

	DECLARE @NodeLevel INT
	SET @NodeLevel = 0

	WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

		INSERT INTO #table_Tree(F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel, F_Order)
			SELECT A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order
				FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	END

	--添加Match节点/仅仅是比赛结束的
	INSERT INTO #table_Tree(F_EventID, F_PhaseID, F_MatchID, F_NodeType, F_NodeLevel, F_Order)
		SELECT B.F_EventID, B.F_PhaseID, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID
				WHERE A.F_MatchStatusID IN (100, 110) AND B.F_NodeType = 0

--	INSERT INTO #table_FinishedMatch(F_MatchID) 
--		SELECT  A.F_MatchID
--			FROM TS_Match AS A INNER JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID
--				WHERE A.F_MatchStatusID IN (100, 110) AND B.F_NodeType = 0

	INSERT INTO #table_BeforeStartListMatch(F_MatchID) 
		SELECT  A.F_MatchID
			FROM TS_Match AS A INNER JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID
				WHERE A.F_MatchStatusID < 40 AND B.F_NodeType = 0



	--清空可以晋级的比赛位置的现有参赛人员
	UPDATE TS_Match_Result SET  F_SourceMatchRank = NULL WHERE F_SourceMatchRank <= 0
	UPDATE TS_Match_Result SET  F_HistoryMatchRank = NULL WHERE F_HistoryMatchRank <= 0
	UPDATE TS_Match_Result SET  F_HistoryLevel = NULL WHERE F_HistoryLevel <= 0


	IF EXISTS(SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)--该Phase节点下的结束的比赛晋级处理
	BEGIN

		--///////////////////////////////////////////////////////////////////////////////////
		--//普通的Match名次晋级
		--///////////////////////////////////////////////////////////////////////////////////
		INSERT INTO TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode)
			SELECT D.F_MatchID, D.F_CompetitionPosition, D.F_LanguageCode FROM (SELECT A.F_MatchID, A.F_CompetitionPosition, B.F_LanguageCode FROM TS_Match_Result AS A, TC_Language AS B) AS D LEFT JOIN TS_Match_Result_Des
				AS C ON D.F_MatchID = C.F_MatchID AND D.F_CompetitionPosition = C.F_CompetitionPosition AND D.F_LanguageCode = C.F_LanguageCode
					WHERE D.F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1) AND C.F_MatchID IS NULL

		INSERT INTO #Temp_Match2Match (F_MatchID, F_CompetitionPosition, F_SourceMatchID, F_SourceMatchRank, F_SourceMatchStatusID, F_SourceRankNum)
			SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_SourceMatchID, A.F_SourceMatchRank, B.F_MatchStatusID, 0
				FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
						WHERE A.F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1) AND A.F_SourceMatchRank IS NOT NULL AND B.F_MatchID IS NOT NULL
						AND C.F_MatchStatusID IN (0, 10, 20, 30)
		---此处修改,比赛必须是能够晋级的,也就是所比赛的状态StartList之前的才可以.
		
		UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Match2Match AS A INNER JOIN (SELECT F_MatchID, F_Rank, COUNT(F_Rank) AS RankNum FROM TS_Match_Result GROUP BY F_MatchID, F_Rank) AS B
			ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		DELETE FROM #Temp_Match2Match WHERE F_SourceMatchStatusID NOT IN (100, 110)
		DELETE FROM #Temp_Match2Match WHERE F_SourceRankNum != 1

		UPDATE #Temp_Match2Match SET F_SourceCompetitionPosition = B.F_CompetitionPosition, F_SourceRegisterID = B.F_RegisterID
			FROM #Temp_Match2Match AS A LEFT JOIN TS_Match_Result AS B ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Match2Match AS B
			ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition 

		UPDATE C SET C.F_ProgressDes = B.F_SouceProgressDes, C.F_ProgressType = B.F_SouceProgressType FROM #Temp_Match2Match AS A 
			LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
			LEFT JOIN TS_Match_Result_Des AS C ON A.F_SourceMatchID = C.F_MatchID AND A.F_SourceCompetitionPosition = C.F_CompetitionPosition AND B.F_LanguageCode = C.F_LanguageCode
			
		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, F_SourceMatchID FROM #Temp_Match2Match UNION ALL
			SELECT 1, F_MatchID FROM #Temp_Match2Match

		--///////////////////////////////////////////////////////////////////////////////////
		--//一下的操作是对将Match的结果晋级到PhasePosition中去
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Match2Phase (F_PhaseID, F_PhasePosition, F_SourceMatchID, F_SourceMatchRank, F_SourceMatchStatusID, F_SourceRankNum)
			SELECT A.F_PhaseID, A.F_PhasePosition, A.F_SourceMatchID, A.F_SourceMatchRank, B.F_MatchStatusID, 0
				FROM TS_Phase_Position AS A INNER JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID
						WHERE A.F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1) AND A.F_SourceMatchRank IS NOT NULL
								AND C.F_PhaseStatusID IN (0, 10, 20, 30)
								
		UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Match2Phase AS A INNER JOIN (SELECT F_MatchID, F_Rank, COUNT(F_Rank) AS RankNum FROM TS_Match_Result GROUP BY F_MatchID, F_Rank) AS B
			ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		UPDATE A SET A.F_PhaseStatusID = ISNULL(B.F_PhaseStatusID, 0) FROM #Temp_Match2Phase AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID

		DELETE FROM #Temp_Match2Phase WHERE F_PhaseStatusID > 30	--Phase已经Running就不允许重复晋级
		DELETE FROM #Temp_Match2Phase WHERE F_SourceMatchStatusID NOT IN (100, 110)
		DELETE FROM #Temp_Match2Phase WHERE F_SourceRankNum != 1
		
		UPDATE #Temp_Match2Phase SET F_SourceCompetitionPosition = B.F_CompetitionPosition, F_SourceRegisterID = B.F_RegisterID
			FROM #Temp_Match2Phase AS A LEFT JOIN TS_Match_Result AS B ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Phase_Position AS A INNER JOIN #Temp_Match2Phase AS B
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition

		--将签位上的参赛者,指定到对应的Match中去
		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Match2Phase AS B
			ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
			LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
			
		INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) 
			SELECT 1 AS F_Type, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #Temp_Match2Phase AS B
			ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
			LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
		
		--///////////////////////////////////////////////////////////////////////////////////
		--//一下的操作是对某些比赛需要进行，历程遍历的更新操作，主要为复活赛人员设定而服务
		--///////////////////////////////////////////////////////////////////////////////////

		DECLARE @Level AS INT
		SET @Level = 0
		INSERT INTO #TempMatchHistory(F_StartMatchID, F_StartMatchRank, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, F_Level)
			SELECT F_MatchID AS F_StartMatchID, F_Rank AS F_RankIndex, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, 0 AS F_Level
				FROM TS_Match_Result WHERE F_MatchID IN 
					(SELECT A.F_MatchID FROM #table_Tree AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_HistoryMatchID AND B.F_HistoryMatchRank IS NOT NULL AND B.F_HistoryLevel IS NOT NULL WHERE A.F_NodeType = 1)

		WHILE EXISTS (SELECT F_MatchID FROM #TempMatchHistory WHERE F_Level = 0)
		BEGIN
			SET @Level = @Level + 1
			UPDATE #TempMatchHistory SET F_Level = @Level WHERE F_Level = 0
			INSERT INTO #TempMatchHistory (F_StartMatchID, F_StartMatchRank, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, F_Level)
				SELECT A.F_StartMatchID, A.F_StartMatchRank, B.F_MatchID, B.F_CompetitionPosition, B.F_Rank, B.F_RegisterID, B.F_SourceMatchID, B.F_SourceMatchRank, 0 AS F_Level
					FROM #TempMatchHistory AS A INNER JOIN TS_Match_Result AS B ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank 
						WHERE F_Level = @Level
		END

		DELETE FROM #TempMatchHistory WHERE F_Level = 1
		UPDATE #TempMatchHistory SET F_Level = (F_Level - 1)
		UPDATE #TempMatchHistory SET F_LoseRegisterID = B.F_RegisterID, F_LoseCompetitionPosition = B.F_CompetitionPosition FROM #TempMatchHistory AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_Rank = 2

		UPDATE A SET F_RegisterID = B.F_LoseRegisterID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE C.F_MatchStatusID IN (0, 10, 20, 30)  -- A.F_RegisterID IS NULL AND 可以重复晋级

		UPDATE A SET A.F_ProgressDes = D.F_SouceProgressDes, A.F_ProgressType = D.F_SouceProgressType FROM TS_Match_Result_Des AS A 
			RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
			INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
			LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID)  SELECT 1, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE C.F_MatchStatusID IN (0, 10, 20, 30)  -- A.F_RegisterID IS NULL AND 可以重复晋级

	END
	
	IF EXISTS(SELECT F_MatchID FROM #table_BeforeStartListMatch)--该Phase节点下的可重复晋级的比赛的参赛者抓取处理
	BEGIN
		
		TRUNCATE TABLE #Temp_Match2Match
		TRUNCATE TABLE #TempMatchHistory
		TRUNCATE TABLE #Temp_Phase2Match
		TRUNCATE TABLE #Temp_PhaseChildMatch
		--///////////////////////////////////////////////////////////////////////////////////
		--//普通的Match名次晋级
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Match2Match (F_MatchID, F_CompetitionPosition, F_SourceMatchID, F_SourceMatchRank, F_SourceMatchStatusID, F_SourceRankNum)
			SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_SourceMatchID, A.F_SourceMatchRank, B.F_MatchStatusID, 0
				FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID
						WHERE A.F_MatchID IN (SELECT F_MatchID FROM #table_BeforeStartListMatch) AND A.F_SourceMatchRank IS NOT NULL AND B.F_MatchID IS NOT NULL

		UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Match2Match AS A INNER JOIN (SELECT F_MatchID, F_Rank, COUNT(F_Rank) AS RankNum FROM TS_Match_Result GROUP BY F_MatchID, F_Rank) AS B
			ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		DELETE FROM #Temp_Match2Match WHERE F_SourceMatchStatusID NOT IN (100, 110)
		DELETE FROM #Temp_Match2Match WHERE F_SourceRankNum != 1

		UPDATE #Temp_Match2Match SET F_SourceCompetitionPosition = B.F_CompetitionPosition, F_SourceRegisterID = B.F_RegisterID
			FROM #Temp_Match2Match AS A LEFT JOIN TS_Match_Result AS B ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Match2Match AS B
			ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition

		UPDATE C SET C.F_ProgressDes = B.F_SouceProgressDes, C.F_ProgressType = B.F_SouceProgressType FROM #Temp_Match2Match AS A 
			LEFT JOIN TS_Match_Result_Des AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
			LEFT JOIN TS_Match_Result_Des AS C ON A.F_SourceMatchID = C.F_MatchID AND A.F_SourceCompetitionPosition = C.F_CompetitionPosition AND B.F_LanguageCode = C.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, F_SourceMatchID FROM #Temp_Match2Match UNION ALL
			SELECT 1, F_MatchID FROM #Temp_Match2Match

		--///////////////////////////////////////////////////////////////////////////////////
		--//一下的操作是对某些比赛需要进行，历程遍历的更新操作，主要为复活赛人员设定而服务
		--///////////////////////////////////////////////////////////////////////////////////

		SET @Level = 0
		INSERT INTO #TempMatchHistory(F_StartMatchID, F_StartMatchRank, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, F_Level)
			SELECT F_MatchID AS F_StartMatchID, F_Rank AS F_RankIndex, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, 0 AS F_Level
				FROM TS_Match_Result WHERE F_MatchID IN 
					(SELECT DISTINCT (A.F_HistoryMatchID) FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_HistoryMatchID = B.F_MatchID
							WHERE A.F_MatchID IN (SELECT F_MatchID FROM #table_BeforeStartListMatch) AND A.F_HistoryMatchRank IS NOT NULL AND B.F_MatchStatusID IN (100, 110) )

		WHILE EXISTS (SELECT F_MatchID FROM #TempMatchHistory WHERE F_Level = 0)
		BEGIN
			SET @Level = @Level + 1
			UPDATE #TempMatchHistory SET F_Level = @Level WHERE F_Level = 0
			INSERT INTO #TempMatchHistory (F_StartMatchID, F_StartMatchRank, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, F_Level)
				SELECT A.F_StartMatchID, A.F_StartMatchRank, B.F_MatchID, B.F_CompetitionPosition, B.F_Rank, B.F_RegisterID, B.F_SourceMatchID, B.F_SourceMatchRank, 0 AS F_Level
					FROM #TempMatchHistory AS A INNER JOIN TS_Match_Result AS B ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank 
						WHERE F_Level = @Level
		END

		DELETE FROM #TempMatchHistory WHERE F_Level = 1
		UPDATE #TempMatchHistory SET F_Level = (F_Level - 1)
		UPDATE #TempMatchHistory SET F_LoseRegisterID = B.F_RegisterID, F_LoseCompetitionPosition = B.F_CompetitionPosition FROM #TempMatchHistory AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_Rank = 2

		UPDATE A SET F_RegisterID = B.F_LoseRegisterID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON B.F_MatchID = C.F_MatchID
					WHERE A.F_MatchID IN (SELECT F_MatchID FROM #table_BeforeStartListMatch) AND C.F_MatchStatusID IN (100, 110)

		UPDATE A SET A.F_ProgressDes = D.F_SouceProgressDes, A.F_ProgressType = D.F_SouceProgressType FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID)  SELECT 1, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON B.F_MatchID = C.F_MatchID
					WHERE A.F_MatchID IN (SELECT F_MatchID FROM #table_BeforeStartListMatch) AND C.F_MatchStatusID IN (100, 110)
					
		--///////////////////////////////////////////////////////////////////////////////////
		--//以下是Phase晋级
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Phase2Match (F_MatchID, F_CompetitionPosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourcePhaseStatusID, F_SourceRankNum)
			SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, B.F_PhaseStatusID, 0  FROM TS_Match_Result AS A LEFT JOIN TS_Phase AS B ON A.F_SourcePhaseID = B.F_PhaseID 
				WHERE A.F_MatchID IN (SELECT F_MatchID FROM #table_BeforeStartListMatch) AND A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID IS NOT NULL
		
			UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Phase2Match AS A INNER JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B
			ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank
		
		DELETE FROM #Temp_Phase2Match WHERE F_SourcePhaseStatusID != 110
		DELETE FROM #Temp_Phase2Match WHERE F_SourceRankNum != 1

		UPDATE A SET F_SourceRegisterID = B.F_RegisterID
			FROM #Temp_Phase2Match AS A LEFT JOIN TS_Phase_Result AS B ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank

		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Phase2Match AS B 
			ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition


		INSERT INTO #Temp_PhaseChildMatch (F_TopPhaseID, F_PhaseID, F_FatherPhaseID, F_Level, F_Type)
			SELECT DISTINCT A.F_SourcePhaseID, A.F_SourcePhaseID, B.F_FatherPhaseID, 0, 0 FROM #Temp_Phase2Match AS A LEFT JOIN TS_Phase AS B ON A.F_SourcePhaseID = B.F_PhaseID 
				WHERE A.F_SourcePhaseID IS NOT NULL

		SET @Level = 1
		WHILE EXISTS(SELECT A.F_PhaseID FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_FatherPhaseID AND A.F_Level = 0)
		BEGIN

			UPDATE #Temp_PhaseChildMatch SET F_Level = @Level WHERE F_Level = 0
			INSERT INTO #Temp_PhaseChildMatch (F_TopPhaseID, F_PhaseID, F_FatherPhaseID, F_Level, F_Type)
				SELECT A.F_TopPhaseID, B.F_PhaseID, B.F_FatherPhaseID, (A.F_Level + 1), 0 FROM #Temp_PhaseChildMatch AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_FatherPhaseID AND A.F_Level = 0
			SET @Level = @Level + 1

		END
		
		INSERT INTO #Temp_PhaseChildMatch (F_TopPhaseID, F_FatherPhaseID, F_MatchID, F_Level, F_Type)
			SELECT A.F_TopPhaseID, A.F_PhaseID, B.F_MatchID, (A.F_Level + 1), 1 FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Match AS B ON A.F_PhaseID = B.F_PhaseID 

		UPDATE D SET D.F_ProgressDes = E.F_SouceProgressDes, D.F_ProgressType = E.F_SouceProgressType FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID INNER JOIN #Temp_Phase2Match AS C 
			ON B.F_RegisterID = C.F_SourceRegisterID AND A.F_TopPhaseID = C.F_SourcePhaseID LEFT JOIN TS_Match_Result_Des AS D ON B.F_MatchID = D.F_MatchID AND B.F_CompetitionPosition = D.F_CompetitionPosition
				LEFT JOIN TS_Match_Result_Des AS E ON C.F_MatchID = E.F_MatchID AND C.F_CompetitionPosition = E.F_CompetitionPosition AND D.F_LanguageCode = E.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID INNER JOIN #Temp_Phase2Match AS C 
			ON B.F_RegisterID = C.F_SourceRegisterID AND A.F_TopPhaseID = C.F_SourcePhaseID 
	END 

--///////////////////////////////////////////////////////////////////////////////////
--//以上的操作仅仅是Match自动晋级，接下来的操作是将PhaseRank进行晋级
--///////////////////////////////////////////////////////////////////////////////////
	DECLARE @PhaseStatus AS INT
	DECLARE @PhaseType	AS INT
	SELECT @PhaseStatus = ISNULL(F_PhaseStatusID, 0), @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID
	
	IF @PhaseStatus = 110 --//说明：Phase做晋级处理。
	BEGIN

			--Phase晋级时应该将不合理的晋级位置的F_RegisterID置空
			UPDATE A SET F_RegisterID = NULL FROM TS_Match_Result AS A RIGHT JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID = @PhaseID  AND C.F_MatchStatusID IN (0, 10, 20, 30)

			UPDATE A SET F_RegisterID = B.F_RegisterID FROM TS_Match_Result AS A RIGHT JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID = @PhaseID  AND C.F_MatchStatusID IN (0, 10, 20, 30) --AND A.F_RegisterID IS NULL

			--如果Phase中多人名次相同就不晋级了
			UPDATE TS_Match_Result SET F_RegisterID = NULL FROM TS_Match_Result AS A RIGHT JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID = @PhaseID  AND C.F_MatchStatusID IN (0, 10, 20, 30) AND B.RankNum > 1

			INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) SELECT 1 AS F_Type, A.F_MatchID FROM TS_Match_Result AS A RIGHT JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID = @PhaseID  AND C.F_MatchStatusID IN (0, 10, 20, 30) --AND A.F_RegisterID IS NULL

			CREATE TABLE #TempPhaseResultSource(F_PhaseID						INT,
												F_PhaseRank						INT,
												F_MatchID						INT,
												F_CompetitionPosition			INT,
												F_RegisterID					INT,
												F_SourceMatchID					INT,
												F_SourceCompetitionPosition		INT,
												F_RankNum						INT
												)

			INSERT INTO #TempPhaseResultSource(F_PhaseID, F_PhaseRank, F_MatchID, F_CompetitionPosition, F_RegisterID, F_SourceMatchID, F_SourceCompetitionPosition, F_RankNum)
				SELECT A.F_SourcePhaseID AS F_PhaseID, A.F_SourcePhaseRank AS F_PhaseRank, A.F_MatchID, A.F_CompetitionPosition, B.F_RegisterID, 
					C.F_MatchID AS F_SourceMatchID, D.F_CompetitionPosition AS F_SourceCompetitionPosition, 0
					FROM TS_Match_Result AS A INNER JOIN TS_Phase_Result AS B ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank
						INNER JOIN TS_Match AS C ON A.F_SourcePhaseID = C.F_PhaseID 
						INNER JOIN TS_Match_Result AS D ON C.F_MatchID = D.F_MatchID AND B.F_RegisterID = D.F_RegisterID
						WHERE A.F_SourcePhaseID = @PhaseID

			UPDATE A SET A.F_RankNum = B.RankNum FROM #TempPhaseResultSource AS A LEFT JOIN 
				(SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM #TempPhaseResultSource GROUP BY F_PhaseID, F_PhaseRank) AS B 
				ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseRank = B.F_PhaseRank

			DELETE FROM #TempPhaseResultSource WHERE F_RankNum != 1

			UPDATE A SET A.F_ProgressDes = D.F_SouceProgressDes, A.F_ProgressType = D.F_SouceProgressType FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempPhaseResultSource AS B ON A.F_MatchID = B.F_SourceMatchID AND A.F_CompetitionPosition = B.F_SourceCompetitionPosition
				LEFT JOIN TS_Match_Result_Des AS D ON B.F_MatchID = D.F_MatchID AND B.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode


			INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) SELECT 1 AS F_Type, F_SourceMatchID FROM #TempPhaseResultSource
			
			
			--///////////////////////////////////////////////////////////////////////////////////
			--//一下的操作是对将Phase的结果晋级到PhasePosition中去
			--///////////////////////////////////////////////////////////////////////////////////
			
			INSERT INTO #Temp_Phase2Phase (F_PhaseID, F_PhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourcePhaseStatusID, F_SourceRankNum)
				SELECT A.F_PhaseID, A.F_PhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, B.F_PhaseStatusID, 0
					FROM TS_Phase_Position AS A INNER JOIN TS_Phase AS B ON A.F_SourcePhaseID = B.F_PhaseID
							WHERE A.F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0) AND A.F_SourcePhaseRank IS NOT NULL

			UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Phase2Phase AS A INNER JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank

			UPDATE A SET A.F_PhaseStatusID = ISNULL(B.F_PhaseStatusID, 0) FROM #Temp_Phase2Phase AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID

			DELETE FROM #Temp_Phase2Phase WHERE F_PhaseStatusID > 30	--Phase已经Running就不允许重复晋级
			DELETE FROM #Temp_Phase2Phase WHERE F_SourcePhaseStatusID != 110
			DELETE FROM #Temp_Phase2Phase WHERE F_SourceRankNum != 1
						
			UPDATE #Temp_Phase2Phase SET F_SourcePhasePosition = B.F_PhaseResultNumber, F_SourceRegisterID = B.F_RegisterID
				FROM #Temp_Phase2Phase AS A LEFT JOIN TS_Phase_Result AS B ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank

			UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Phase_Position AS A INNER JOIN #Temp_Phase2Phase AS B
				ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition

			--将签位上的参赛者,指定到对应的Match中去
			UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Phase2Phase AS B
				ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
				
			INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) 
				SELECT 1 AS F_Type, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #Temp_Phase2Phase AS B
				ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
		
	END
	ELSE IF @PhaseStatus <= 30  --//说明：Phase做抓取操作处理。
	BEGIN
		--IF @PhaseType = 2 --此处是对小组赛的签位的来源进行抓取,同时更新到小组赛具体的各场比赛中
		--BEGIN
							--无论是不是小组赛。都可以统一的进行PhasePosition的抓取操作
			--小组赛签位位置，如果有晋级来源时应该先将F_RegisterID置空
			UPDATE TS_Phase_Position SET F_RegisterID = NULL WHERE F_SourceMatchID IS NOT NULL AND F_SourceMatchRank IS NOT NULL
			UPDATE TS_Phase_Position SET F_RegisterID = NULL WHERE F_SourcePhaseID IS NOT NULL AND F_SourcePhaseRank IS NOT NULL
			
			--小组赛签位来源于比赛结果
			UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A INNER JOIN TS_Match_Result AS B 
				ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank LEFT JOIN TS_Match AS C 
				ON B.F_MatchID = C.F_MatchID WHERE A.F_PhaseID = @PhaseID AND C.F_MatchStatusID IN (100, 110)
				
			--小组赛签位来源于阶段比赛结果
			UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A INNER JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
				WHERE A.F_PhaseID = @PhaseID AND C.F_PhaseStatusID = 110
				
			--如果Phase中多人名次相同就不晋级了
			UPDATE A SET A.F_RegisterID = NULL FROM TS_Phase_Position AS A INNER JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
					WHERE A.F_PhaseID = @PhaseID AND A.F_SourcePhaseRank IS NOT NULL AND C.F_PhaseStatusID = 110 AND B.RankNum > 1
	
			--将小组赛的签位上的参赛者,指定到对应的Match中去
			UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM TS_Match_Result AS A INNER JOIN TS_Phase_Position AS B
				ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE A.F_StartPhaseID = @PhaseID AND C.F_MatchStatusID IN (0, 10, 20, 30)
			
			INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) SELECT 1 AS F_Type, A.F_MatchID 
				FROM TS_Match_Result AS A INNER JOIN TS_Phase_Position AS B
				ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition LEFT JOIN TS_Match AS C 
				ON A.F_MatchID = C.F_MatchID WHERE A.F_StartPhaseID = @PhaseID AND C.F_MatchStatusID IN (0, 10, 20, 30)
		--END
	END
	
	SELECT DISTINCT * FROM #Temp_ChangeList
	RETURN


SET NOCOUNT OFF
END







GO


--EXEC Proc_AutoProgress 31

--EXEC Proc_AutoProgress 32

--EXEC Proc_AutoProgress 33

--EXEC Proc_AutoProgress 34