IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoProgress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoProgress]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�[Proc_AutoProgress]
----��		  �ܣ��Զ�����,����Match������Phase����--��һ������Match����--�ڶ�������Phase
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-20 
/*
	�� ��  �� ��������Match��Phase���Զ�������
				  ��ǰ�Ĳ��������ǿ���TS_MatchResult�еĲ����ߵı仯��
				  ��û��ȥ����TS_Phase_Position��TS_Phase_Result�Ĳ����ߵı仯��
				  ���ң���ϣ����Ӧ��TS_Phase_Position��TS_Phase_Result�ֱ��ṩ����Ĳ����˶�Ա��ץȡ������
				  ��TS_Event_Result�Ĳ����ߵı仯�����ڽ��Ƽ�������ʱ���еģ�Ҳ�����ڴ˴���Ӧ����ץȡ�Ĳ�����
*/

/*
	�޸ļ�¼
	���	����			�޸���		�޸�����
	1		2010-06-18		֣����		Match�Ľ�����Ҫ�������������
											һ���棬Match�����״̬�����С��StartList�ģ�Ӧ�ý�������ץȡ������ץȡʱ������Դ��PhaseResult����������
											��һ���棬Match�����״̬�����Unoffical������Finished,Ӧ�ø��ݱ��������Ľ��������������

	2		2010-06-18		֣����		Phase�Ľ���������һ�������
											һ���棬���Phase��״̬ΪС��StartList�ģ��������κεĲ�����ץȡ������ԭ����Ӱ��ϴ����ò���
											��һ���棬���Phase��״̬ΪFinished, Ӧ�ø��ݱ����׶εĽ�������������ߡ�

	3		2010-06-18		֣����		Match��Phase����������Ӧ�ý���Ӱ���Match���б��Լ�Phase���б��ѯ���س�����

	
	4		2011-03-25		֣����		���������Ӱ���Match����MatchCompetitor��Ϣ��
	
	5		2011-06-12		֣����		��������Ӧ�ÿ��ǣ�С������ǩλ��ν���,��ʱ����������ץȡ����,����Ҳ���ǽ���������
*/
CREATE PROCEDURE [dbo].[Proc_AutoProgress] (	
	@PhaseID			INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	--����ʱ�������г������߷����仯��ȫ������
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = 1��ʾ��Match�Ĳ����߷����仯����Ӧ���͵���Ϣ��emMatchCompetitor
									F_MatchID		INT
								  )

	--����ʱ�����ڴ洢��Phase�ڵ��µ�PhaseTree
	CREATE TABLE #table_Tree (
								F_EventID			INT, 
								F_PhaseID			INT,
								F_FatherPhaseID		INT,
								F_PhaseNodeType		INT,
								F_MatchID			INT,
								F_NodeType			INT,--ע��: -3��ʾSport��-2��ʾDiscipline��-1��ʾEvent��0��ʾPhase��1��ʾMatch
								F_NodeLevel			INT,
								F_Order             INT
							 )

	--����Match����
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

	--����������������Ҫ�������ʱ��ͱ���
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

	--����Phase����
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
	
	--�洢��Ҫ������PhasePosition
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
--	--����ʱ�����ڴ洢��Phase�ڵ��µĽ����ı���
--	CREATE TABLE #table_FinishedMatch(F_MatchID		INT)

	--����ʱ�����ڴ洢��Phase�ڵ��µĿ��ظ�ָ��������Ա�ı���
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

	--���Match�ڵ�/�����Ǳ���������
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



	--��տ��Խ����ı���λ�õ����в�����Ա
	UPDATE TS_Match_Result SET  F_SourceMatchRank = NULL WHERE F_SourceMatchRank <= 0
	UPDATE TS_Match_Result SET  F_HistoryMatchRank = NULL WHERE F_HistoryMatchRank <= 0
	UPDATE TS_Match_Result SET  F_HistoryLevel = NULL WHERE F_HistoryLevel <= 0


	IF EXISTS(SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)--��Phase�ڵ��µĽ����ı�����������
	BEGIN

		--///////////////////////////////////////////////////////////////////////////////////
		--//��ͨ��Match���ν���
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
		---�˴��޸�,�����������ܹ�������,Ҳ������������״̬StartList֮ǰ�Ĳſ���.
		
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
		--//һ�µĲ����ǶԽ�Match�Ľ��������PhasePosition��ȥ
		--///////////////////////////////////////////////////////////////////////////////////

		INSERT INTO #Temp_Match2Phase (F_PhaseID, F_PhasePosition, F_SourceMatchID, F_SourceMatchRank, F_SourceMatchStatusID, F_SourceRankNum)
			SELECT A.F_PhaseID, A.F_PhasePosition, A.F_SourceMatchID, A.F_SourceMatchRank, B.F_MatchStatusID, 0
				FROM TS_Phase_Position AS A INNER JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID
						WHERE A.F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1) AND A.F_SourceMatchRank IS NOT NULL
								AND C.F_PhaseStatusID IN (0, 10, 20, 30)
								
		UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Match2Phase AS A INNER JOIN (SELECT F_MatchID, F_Rank, COUNT(F_Rank) AS RankNum FROM TS_Match_Result GROUP BY F_MatchID, F_Rank) AS B
			ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		UPDATE A SET A.F_PhaseStatusID = ISNULL(B.F_PhaseStatusID, 0) FROM #Temp_Match2Phase AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID

		DELETE FROM #Temp_Match2Phase WHERE F_PhaseStatusID > 30	--Phase�Ѿ�Running�Ͳ������ظ�����
		DELETE FROM #Temp_Match2Phase WHERE F_SourceMatchStatusID NOT IN (100, 110)
		DELETE FROM #Temp_Match2Phase WHERE F_SourceRankNum != 1
		
		UPDATE #Temp_Match2Phase SET F_SourceCompetitionPosition = B.F_CompetitionPosition, F_SourceRegisterID = B.F_RegisterID
			FROM #Temp_Match2Phase AS A LEFT JOIN TS_Match_Result AS B ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank

		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Phase_Position AS A INNER JOIN #Temp_Match2Phase AS B
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition

		--��ǩλ�ϵĲ�����,ָ������Ӧ��Match��ȥ
		UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Match2Phase AS B
			ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
			LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
			
		INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) 
			SELECT 1 AS F_Type, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #Temp_Match2Phase AS B
			ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
			LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
		
		--///////////////////////////////////////////////////////////////////////////////////
		--//һ�µĲ����Ƕ�ĳЩ������Ҫ���У����̱����ĸ��²�������ҪΪ��������Ա�趨������
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
					WHERE C.F_MatchStatusID IN (0, 10, 20, 30)  -- A.F_RegisterID IS NULL AND �����ظ�����

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
					WHERE C.F_MatchStatusID IN (0, 10, 20, 30)  -- A.F_RegisterID IS NULL AND �����ظ�����

	END
	
	IF EXISTS(SELECT F_MatchID FROM #table_BeforeStartListMatch)--��Phase�ڵ��µĿ��ظ������ı����Ĳ�����ץȡ����
	BEGIN
		
		TRUNCATE TABLE #Temp_Match2Match
		TRUNCATE TABLE #TempMatchHistory
		TRUNCATE TABLE #Temp_Phase2Match
		TRUNCATE TABLE #Temp_PhaseChildMatch
		--///////////////////////////////////////////////////////////////////////////////////
		--//��ͨ��Match���ν���
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
		--//һ�µĲ����Ƕ�ĳЩ������Ҫ���У����̱����ĸ��²�������ҪΪ��������Ա�趨������
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
		--//������Phase����
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
--//���ϵĲ���������Match�Զ��������������Ĳ����ǽ�PhaseRank���н���
--///////////////////////////////////////////////////////////////////////////////////
	DECLARE @PhaseStatus AS INT
	DECLARE @PhaseType	AS INT
	SELECT @PhaseStatus = ISNULL(F_PhaseStatusID, 0), @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID
	
	IF @PhaseStatus = 110 --//˵����Phase����������
	BEGIN

			--Phase����ʱӦ�ý�������Ľ���λ�õ�F_RegisterID�ÿ�
			UPDATE A SET F_RegisterID = NULL FROM TS_Match_Result AS A RIGHT JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID = @PhaseID  AND C.F_MatchStatusID IN (0, 10, 20, 30)

			UPDATE A SET F_RegisterID = B.F_RegisterID FROM TS_Match_Result AS A RIGHT JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID
					WHERE A.F_SourcePhaseRank IS NOT NULL AND B.F_PhaseID = @PhaseID  AND C.F_MatchStatusID IN (0, 10, 20, 30) --AND A.F_RegisterID IS NULL

			--���Phase�ж���������ͬ�Ͳ�������
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
			--//һ�µĲ����ǶԽ�Phase�Ľ��������PhasePosition��ȥ
			--///////////////////////////////////////////////////////////////////////////////////
			
			INSERT INTO #Temp_Phase2Phase (F_PhaseID, F_PhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourcePhaseStatusID, F_SourceRankNum)
				SELECT A.F_PhaseID, A.F_PhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, B.F_PhaseStatusID, 0
					FROM TS_Phase_Position AS A INNER JOIN TS_Phase AS B ON A.F_SourcePhaseID = B.F_PhaseID
							WHERE A.F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0) AND A.F_SourcePhaseRank IS NOT NULL

			UPDATE A SET A.F_SourceRankNum = B.RankNum FROM #Temp_Phase2Phase AS A INNER JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank

			UPDATE A SET A.F_PhaseStatusID = ISNULL(B.F_PhaseStatusID, 0) FROM #Temp_Phase2Phase AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID

			DELETE FROM #Temp_Phase2Phase WHERE F_PhaseStatusID > 30	--Phase�Ѿ�Running�Ͳ������ظ�����
			DELETE FROM #Temp_Phase2Phase WHERE F_SourcePhaseStatusID != 110
			DELETE FROM #Temp_Phase2Phase WHERE F_SourceRankNum != 1
						
			UPDATE #Temp_Phase2Phase SET F_SourcePhasePosition = B.F_PhaseResultNumber, F_SourceRegisterID = B.F_RegisterID
				FROM #Temp_Phase2Phase AS A LEFT JOIN TS_Phase_Result AS B ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank

			UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Phase_Position AS A INNER JOIN #Temp_Phase2Phase AS B
				ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition

			--��ǩλ�ϵĲ�����,ָ������Ӧ��Match��ȥ
			UPDATE A SET A.F_RegisterID = B.F_SourceRegisterID FROM TS_Match_Result AS A INNER JOIN #Temp_Phase2Phase AS B
				ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
				
			INSERT INTO  #Temp_ChangeList(F_Type, F_MatchID) 
				SELECT 1 AS F_Type, A.F_MatchID FROM TS_Match_Result AS A INNER JOIN #Temp_Phase2Phase AS B
				ON A.F_StartPhaseID = B.F_PhaseID AND A.F_StartPhasePosition = B.F_PhasePosition 
				LEFT JOIN TS_Match AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_MatchStatusID IN (0, 10, 20, 30)
		
	END
	ELSE IF @PhaseStatus <= 30  --//˵����Phase��ץȡ��������
	BEGIN
		--IF @PhaseType = 2 --�˴��Ƕ�С������ǩλ����Դ����ץȡ,ͬʱ���µ�С��������ĸ���������
		--BEGIN
							--�����ǲ���С������������ͳһ�Ľ���PhasePosition��ץȡ����
			--С����ǩλλ�ã�����н�����ԴʱӦ���Ƚ�F_RegisterID�ÿ�
			UPDATE TS_Phase_Position SET F_RegisterID = NULL WHERE F_SourceMatchID IS NOT NULL AND F_SourceMatchRank IS NOT NULL
			UPDATE TS_Phase_Position SET F_RegisterID = NULL WHERE F_SourcePhaseID IS NOT NULL AND F_SourcePhaseRank IS NOT NULL
			
			--С����ǩλ��Դ�ڱ������
			UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A INNER JOIN TS_Match_Result AS B 
				ON A.F_SourceMatchID = B.F_MatchID AND A.F_SourceMatchRank = B.F_Rank LEFT JOIN TS_Match AS C 
				ON B.F_MatchID = C.F_MatchID WHERE A.F_PhaseID = @PhaseID AND C.F_MatchStatusID IN (100, 110)
				
			--С����ǩλ��Դ�ڽ׶α������
			UPDATE A SET A.F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A INNER JOIN TS_Phase_Result AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
				WHERE A.F_PhaseID = @PhaseID AND C.F_PhaseStatusID = 110
				
			--���Phase�ж���������ͬ�Ͳ�������
			UPDATE A SET A.F_RegisterID = NULL FROM TS_Phase_Position AS A INNER JOIN (SELECT F_PhaseID, F_PhaseRank, COUNT(F_PhaseRank) AS RankNum FROM TS_Phase_Result GROUP BY F_PhaseID, F_PhaseRank) AS B 
				ON A.F_SourcePhaseID = B.F_PhaseID AND A.F_SourcePhaseRank = B.F_PhaseRank LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
					WHERE A.F_PhaseID = @PhaseID AND A.F_SourcePhaseRank IS NOT NULL AND C.F_PhaseStatusID = 110 AND B.RankNum > 1
	
			--��С������ǩλ�ϵĲ�����,ָ������Ӧ��Match��ȥ
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