if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_ProgressByes]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_ProgressByes]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_ProgressByes]
----��		  �ܣ�Ϊ��̭�������ֿյı���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-17 
/*
	�޸ļ�¼
	���	����			�޸���		�޸�����
	1		2010-06-21		֣����		Phase�ֿս���������Ӧ�ý���Ӱ���Match���б����������ֿյ�Match��ѯ���س�����

*/
CREATE PROCEDURE [dbo].[Proc_ProgressByes] (	
	@PhaseID			INT
)	
AS
BEGIN
	
SET NOCOUNT ON
	
	--����ʱ�������г������߷����仯��ȫ������
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = 1��ʾ��Match�Ĳ����߷����仯����Ӧ���͵���Ϣ��emMatchCompetitor
														 -- F_Type = 2��ʾ��Match�ı������ֿս������������Match��״̬�����仯���������Զ������ֿ��߻�ʤ��һ�������Ӧ�ķ�����ϢemMatchResult.
									F_MatchID		INT
								  )

	CREATE TABLE #table_Tree (
									F_SportID           INT,
									F_DisciplineID      INT,
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_PhaseCode			NVARCHAR(10),
									F_PhaseNodeType		INT,
									F_MatchID			INT,
									F_NodeType			INT,--ע��: -3��ʾSport��-2��ʾDiscipline��-1��ʾEvent��0��ʾPhase��1��ʾMatch
									F_NodeLevel			INT,
									F_Order             INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100)
								 )

	INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeType, F_NodeLevel, F_Order, F_NodeKey)
		SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey
		  FROM TS_Phase AS A LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID

	DECLARE @NodeLevel INT
	SET @NodeLevel = 0

	WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
				FROM TS_Phase AS A INNER JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	END

	--���Match�ڵ�
	INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey)
		SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_NodeType = 0

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

	INSERT INTO #table_Competitors (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_CompetitionPosition, F_RegisterID, F_ResultID, F_Rank)
		SELECT  B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, B.F_MatchID, D.F_CompetitionPosition, D.F_RegisterID, D.F_ResultID, D.F_Rank
			FROM #table_Tree AS B LEFT JOIN TS_Match_Result AS D ON B.F_MatchID = D.F_MatchID WHERE B.F_NodeType = 1
		
	DELETE FROM #table_Competitors WHERE F_MatchID IN (SELECT F_MatchID FROM (SELECT F_MatchID, Count(F_CompetitionPosition) AS CompetitorNum FROM #table_Competitors  group BY F_MatchID) AS A WHERE A.CompetitorNum != 2)--where CompetitorNum <> 2
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




--	EXEC Proc_ProgressByes 1
