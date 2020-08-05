IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoProgressMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoProgressMatch]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_AutoProgressMatch]
----功		  能：自动晋级,仅仅晋级此一场比赛
----作		  者：郑金勇 
----日		  期：2009-05-11 
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
	2		2010-06-18		郑金勇		Match晋级操作后，应该将所影响的Match的列表，以及Phase的列表查询返回出来！
	3		2010-07-05		郑金勇		如果Match的Rank存在并列或者Phase的Rank存在并列，此情形下将不晋级。
	4		2011-03-25		郑金勇		复活晋级所影响的Match发送MatchCompetitor消息。
	5		2011-06-12		郑金勇		晋级操作应该考虑，小组赛的签位如何晋级,此时不仅仅考虑抓取操作,而且也考虑晋级操作。
	
*/
CREATE PROCEDURE [dbo].[Proc_AutoProgressMatch] (	
	@MatchID			INT
)	
AS
BEGIN
SET NOCOUNT ON

	DECLARE @MatchStatusID AS INT
	SELECT @MatchStatusID = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
	
	--此临时表用于列出参赛者发生变化的全部对象
	CREATE TABLE #Temp_ChangeList(
										F_Type						INT, -- F_Type = 1表示是Match的参赛者发生变化，对应发送的消息是emMatchCompetitor
										F_MatchID					INT
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
									
									
	DECLARE @Level AS INT

	--进行晋级操作之前，首先要整理晋级关系描述的有效性，将不合格的晋级关系描述清理掉。
	UPDATE TS_Match_Result SET  F_SourceMatchRank = NULL WHERE F_SourceMatchRank <= 0
	UPDATE TS_Match_Result SET  F_HistoryMatchRank = NULL WHERE F_HistoryMatchRank <= 0
	UPDATE TS_Match_Result SET  F_HistoryLevel = NULL WHERE F_HistoryLevel <= 0
	UPDATE TS_Match_Result SET  F_SourcePhaseRank = NULL WHERE F_SourcePhaseRank <= 0

	IF (@MatchStatusID < 40)				--	StartList之前，是可以随时重复晋级的，抓取参赛者时，不对参赛者的晋级状态作修改。
	BEGIN
		--清空可以晋级的比赛位置的现有参赛人员

		--///////////////////////////////////////////////////////////////////////////////////
		--//普通的Match名次晋级
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Match2Match (F_MatchID, F_CompetitionPosition, F_SourceMatchID, F_SourceMatchRank, F_SourceMatchStatusID, F_SourceRankNum)
			SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_SourceMatchID, A.F_SourceMatchRank, B.F_MatchStatusID, 0
				FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID
						WHERE A.F_MatchID = @MatchID AND A.F_SourceMatchRank IS NOT NULL AND B.F_MatchID IS NOT NULL

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
		--//以下的操作是对某些比赛需要进行，历程遍历的更新操作，主要为复活赛人员设定而服务
		--///////////////////////////////////////////////////////////////////////////////////

		SET @Level = 0
		INSERT INTO #TempMatchHistory(F_StartMatchID, F_StartMatchRank, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, F_Level)
			SELECT F_MatchID AS F_StartMatchID, F_Rank AS F_RankIndex, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, 0 AS F_Level
				FROM TS_Match_Result WHERE F_MatchID IN 
					(SELECT DISTINCT (A.F_HistoryMatchID) FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_HistoryMatchID = B.F_MatchID
							WHERE A.F_MatchID = @MatchID AND A.F_HistoryMatchRank IS NOT NULL AND B.F_MatchStatusID IN (100, 110) )

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
					WHERE A.F_MatchID = @MatchID AND C.F_MatchStatusID IN (100, 110)

		UPDATE A SET A.F_ProgressDes = D.F_SouceProgressDes, A.F_ProgressType = D.F_SouceProgressType FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON B.F_MatchID = C.F_MatchID
					WHERE A.F_MatchID = @MatchID AND C.F_MatchStatusID IN (100, 110)
		
		--///////////////////////////////////////////////////////////////////////////////////
		--//以下是Phase晋级
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Phase2Match (F_MatchID, F_CompetitionPosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourcePhaseStatusID, F_SourceRankNum)
			SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, B.F_PhaseStatusID, 0  FROM TS_Match_Result AS A LEFT JOIN TS_Phase AS B ON A.F_SourcePhaseID = B.F_PhaseID 
				WHERE A.F_MatchID = @MatchID AND A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID IS NOT NULL
		
		UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Phase2Match AS A LEFT JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B
			ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank
		
		DELETE FROM #Temp_Phase2Match WHERE F_SourcePhaseStatusID != 110
		DELETE FROM #Temp_Phase2Match WHERE F_SourceRankNum != 1

		UPDATE #Temp_Phase2Match SET F_SourceRegisterID = B.F_RegisterID
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
				SELECT A.F_TopPhaseID, B.F_PhaseID, B.F_FatherPhaseID, (A.F_Level + 1), 0 FROM #Temp_Phase2Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_FatherPhaseID AND A.F_Level = 0
			SET @Level = @Level + 1

		END
		
		INSERT INTO #Temp_PhaseChildMatch (F_TopPhaseID, F_FatherPhaseID, F_MatchID, F_Level, F_Type)
			SELECT A.F_TopPhaseID, A.F_PhaseID, B.F_MatchID, (A.F_Level + 1), 1 FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Match AS B ON A.F_PhaseID = B.F_PhaseID 


		UPDATE D SET D.F_ProgressDes = E.F_SouceProgressDes, D.F_ProgressType = E.F_SouceProgressType FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID INNER JOIN #Temp_Phase2Match AS C 
			ON B.F_RegisterID = C.F_SourceRegisterID AND A.F_TopPhaseID = C.F_SourcePhaseID LEFT JOIN TS_Match_Result_Des AS D ON B.F_MatchID = D.F_MatchID AND B.F_CompetitionPosition = D.F_CompetitionPosition
				LEFT JOIN TS_Match_Result_Des AS E ON C.F_MatchID = E.F_MatchID AND C.F_CompetitionPosition = E.F_CompetitionPosition AND D.F_LanguageCode = E.F_LanguageCode

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM #Temp_PhaseChildMatch AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID INNER JOIN #Temp_Phase2Match AS C 
			ON B.F_RegisterID = C.F_SourceRegisterID AND A.F_TopPhaseID = C.F_SourcePhaseID 

		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) VALUES (1, @MatchID)
		
		SELECT DISTINCT * FROM #Temp_ChangeList
		RETURN
	END
	ELSE IF (@MatchStatusID IN (110, 100))	--	Unoffical/Finished，晋级参赛者时，是会将参赛者的晋级状态作修改的。
	BEGIN
	
		INSERT INTO TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode)
			SELECT D.F_MatchID, D.F_CompetitionPosition, D.F_LanguageCode FROM (SELECT A.F_MatchID, A.F_CompetitionPosition, B.F_LanguageCode FROM TS_Match_Result AS A, TC_Language AS B) AS D LEFT JOIN TS_Match_Result_Des
				AS C ON D.F_MatchID = C.F_MatchID AND D.F_CompetitionPosition = C.F_CompetitionPosition AND D.F_LanguageCode = C.F_LanguageCode
					WHERE D.F_MatchID = @MatchID AND C.F_MatchID IS NULL


		--///////////////////////////////////////////////////////////////////////////////////
		--//普通的Match名次晋级
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Match2Match (F_MatchID, F_CompetitionPosition, F_SourceMatchID, F_SourceMatchRank, F_SourceMatchStatusID, F_SourceRankNum)
			SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_SourceMatchID, A.F_SourceMatchRank, B.F_MatchStatusID, 0
				FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID
						WHERE A.F_SourceMatchID = @MatchID AND A.F_SourceMatchRank IS NOT NULL AND B.F_MatchID IS NOT NULL

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
				FROM TS_Phase_Position AS A INNER JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID
						WHERE A.F_SourceMatchID = @MatchID AND A.F_SourceMatchRank IS NOT NULL

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
		SET @Level = 0
		INSERT INTO #TempMatchHistory(F_StartMatchID, F_StartMatchRank, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, F_Level)
			SELECT F_MatchID AS F_StartMatchID, F_Rank AS F_RankIndex, F_MatchID, F_CompetitionPosition, F_Rank, F_RegisterID, F_SourceMatchID, F_SourceMatchRank, 0 AS F_Level
				FROM TS_Match_Result WHERE F_MatchID = @MatchID

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
		UPDATE #TempMatchHistory SET F_LoseRegisterID = B.F_RegisterID, F_LoseCompetitionPosition = B.F_CompetitionPosition 
			FROM #TempMatchHistory AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_Rank = 2

		UPDATE A SET F_RegisterID = B.F_LoseRegisterID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE C.F_MatchStatusID IN (0, 10, 20, 30) --A.F_RegisterID IS NULL AND 可以重复晋级

		UPDATE A SET A.F_ProgressDes = D.F_SouceProgressDes, A.F_ProgressType = D.F_SouceProgressType FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode


		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM TS_Match_Result_Des AS A 
				RIGHT JOIN #TempMatchHistory AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_LoseCompetitionPosition
				INNER JOIN TS_Match_Result AS C ON B.F_StartMatchID = C.F_HistoryMatchID AND B.F_StartMatchRank = C.F_HistoryMatchRank AND B.F_Level = C.F_HistoryLevel
				LEFT JOIN TS_Match_Result_Des AS D ON C.F_MatchID = D.F_MatchID AND C.F_CompetitionPosition = D.F_CompetitionPosition AND A.F_LanguageCode = D.F_LanguageCode


		INSERT INTO #Temp_ChangeList(F_Type, F_MatchID) SELECT 1, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #TempMatchHistory AS B 
			ON A.F_HistoryMatchID = B.F_StartMatchID AND A.F_HistoryMatchRank = B.F_StartMatchRank AND A.F_HistoryLevel = B.F_Level
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE C.F_MatchStatusID IN (0, 10, 20, 30) --A.F_RegisterID IS NULL AND 可以重复晋级


		SELECT DISTINCT * FROM #Temp_ChangeList
		RETURN
	END
	ELSE
	BEGIN
		SELECT DISTINCT * FROM #Temp_ChangeList
		RETURN
	END

SET NOCOUNT OFF
END





GO


--Proc_AutoProgressMatch 264