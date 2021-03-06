IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetKnockOutTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetKnockOutTree]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--名    称：[Proc_GetKnockOutTree]
--描    述：展开一个所有Sport下信息
--参数说明： 
--说    明：
--创 建 人：余远华
--日    期：2009年09月07日

CREATE PROCEDURE [dbo].[Proc_GetKnockOutTree](
				 @ID			INT,--对应类型的ID，与Type相关
                 @Type          INT,--注释: -1表示Event，0表示Phase
                 @LanguageCode  char(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #table_Tree (
                                    F_SportID           INT,
                                    F_DisciplineID      INT,
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_PhaseType			INT,
									F_MatchID			INT,
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
									F_NodeLevel			INT,
								 )

	CREATE TABLE #table_Match (
								F_EventID				INT, 
								F_PhaseID				INT,
								F_PhaseType				INT,
								F_PhaseLongName			NVARCHAR(100),
								F_MatchID				INT,
								F_MatchNum				INT,
								F_MatchLongName			NVARCHAR(100),
								F_MatchSessionNum		INT,
								F_MatchTime				NVARCHAR(50),
								F_MatchStatusID			INT,
								F_ParticipantID			INT,
								F_ParLongName			NVARCHAR(100),
								F_SourcePhaseLongName	NVARCHAR(100),
								F_MatchRank				INT,
								F_MatchPoints			INT,
                                F_CompetitionPosition	INT,
								F_StartPhaseID			INT, 
								F_StartPhasePosition	INT,
								F_SourcePhaseID			INT, 
								F_SourcePhaseRank		INT,
								F_SourceMatchID			INT, 
								F_SourceMatchRank		INT,
								F_NodeLevel				INT  --注释: 表示比赛是否作为其它比赛的源. 0: 是，1: 不是
							 )

	CREATE TABLE #table_Advance (
								F_MatchID				INT,
                                F_CompetitionPosition	INT,
								F_ParticipantID			INT,
								F_MatchRank				INT,
								F_MatchPoints			INT,
								F_StartPhaseID			INT, 
								F_StartPhasePosition	INT,
								F_SourcePhaseID			INT, 
								F_SourcePhaseRank		INT,
								F_SourceMatchID			INT, 
								F_SourceMatchRank		INT,
								F_NodeLevel				INT  --注释: 表示比赛是否作为其它比赛的源. 0: 是，1: 不是
							 )

	DECLARE @KnockOut INT
	SET @KnockOut = 0
	--判断是否为淘汰赛
	
	
	  --获得当前Phase或Event下的所有比赛
	  DECLARE @NodeLevel INT
	  SET @NodeLevel = 0

	  IF @Type = -1
	  BEGIN

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeType, F_NodeLevel)
			SELECT C.F_SportID, A.F_DisciplineID, A.F_EventID, -1 as F_NodeType, @NodeLevel as F_NodeLevel
			  FROM TS_Event AS A LEFT JOIN TS_Discipline AS C ON A.F_DisciplineID = C.F_DisciplineID WHERE A.F_EventID = @ID
		  
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseType, F_NodeType, F_NodeLevel)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseType, 0 as F_NodeType, 0 as F_NodeLevel
			  FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_EventID = B.F_EventID WHERE B.F_NodeLevel = @NodeLevel AND A.F_FatherPhaseID = 0

	  END

      IF @Type = 0

	  BEGIN

		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseType, F_NodeType, F_NodeLevel)
			SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseType, 0 as F_NodeType, 0 as F_NodeLevel
			  FROM TS_Phase AS A LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @ID

	  END

      WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	  BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
	
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseType, F_NodeType, F_NodeLevel)
		  SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseType, 0 as F_NodeType,0 as F_NodeLevel
			FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	  END
	

	--添加Match节点
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_NodeType, F_NodeLevel)
		  SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_NodeType = 0
	
	--获得所有比赛的晋级关系
		INSERT INTO #table_Advance(F_MatchID, F_CompetitionPosition, F_ParticipantID, F_MatchRank, F_MatchPoints, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_NodeLevel)
		  SELECT F_MatchID, F_CompetitionPosition, F_RegisterID, F_Rank, F_Points, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, 0 AS F_NodeLevel 
			FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
			
      WHILE EXISTS ( SELECT F_MatchID, F_CompetitionPosition, F_RegisterID, F_Rank, F_Points, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, 0 AS F_NodeLevel 
					FROM TS_Match_Result 
					WHERE F_MatchID NOT IN (SELECT F_MatchID FROM #table_Advance) AND ( F_MatchID IN (SELECT F_SourceMatchID FROM #table_Advance) OR F_SourceMatchID IN (SELECT F_MatchID FROM #table_Advance) )
					)
	  BEGIN
		INSERT INTO #table_Advance(F_MatchID, F_CompetitionPosition, F_ParticipantID, F_MatchRank, F_MatchPoints, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_NodeLevel )
		  SELECT F_MatchID, F_CompetitionPosition, F_RegisterID, F_Rank, F_Points, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, 0 AS F_NodeLevel 
			FROM TS_Match_Result 
			WHERE F_MatchID NOT IN (SELECT F_MatchID FROM #table_Advance) AND ( F_MatchID IN (SELECT F_SourceMatchID FROM #table_Advance) OR F_SourceMatchID IN (SELECT F_MatchID FROM #table_Advance) )
	  END
		
	
	--删除参加人数不为2的比赛
	DELETE FROM #table_Advance WHERE F_MatchID IN (SELECT F_MatchID FROM (SELECT F_MatchID, COUNT(F_MatchID) AS CountNumber FROM #table_Advance  GROUP BY F_MatchID) AS A WHERE A.CountNumber != 2)

	
	--存放到#table_Match表
		INSERT INTO #table_Match(F_EventID, F_PhaseID, F_PhaseType, F_PhaseLongName, F_MatchID, F_MatchNum, F_MatchLongName,  F_MatchSessionNum, F_MatchTime, F_MatchStatusID,
								 F_CompetitionPosition, F_ParticipantID, F_ParLongName, F_SourcePhaseLongName,  F_MatchRank, F_MatchPoints, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_NodeLevel)
			SELECT D.F_EventID, D.F_PhaseID, D.F_PhaseType, E.F_PhaseLongName, A.F_MatchID, B.F_MatchNum, C.F_MatchLongName, G.F_SessionNumber, CONVERT(nvarchar, B.F_MatchDate, 101) + left(CONVERT(nvarchar, B.F_StartTime, 114), 5) AS F_MatchTime, B.F_MatchStatusID,
				   A.F_CompetitionPosition, A.F_ParticipantID, F.F_LongName, H.F_PhaseLongName, A.F_MatchRank, A.F_MatchPoints, A.F_StartPhaseID, A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, A.F_NodeLevel 
			FROM
				#table_Advance AS A
				LEFT JOIN (SELECT * FROM TS_Match) AS B ON A.F_MatchID = B.F_MatchID
				LEFT JOIN (SELECT * FROM TS_Match_Des WHERE F_LanguageCode = @LanguageCode) AS C ON B.F_MatchID = C.F_MatchID
				LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
				LEFT JOIN (SELECT * FROM TS_Phase_Des WHERE F_LanguageCode = @LanguageCode) AS E ON D.F_PhaseID = E.F_PhaseID
				LEFT JOIN (SELECT * FROM TR_Register_Des WHERE F_LanguageCode = @LanguageCode) AS F ON A.F_ParticipantID = F.F_RegisterID
				LEFT JOIN (SELECT * FROM TS_Session) AS G ON B.F_SessionID = G.F_SessionID
				LEFT JOIN (SELECT * FROM TS_Phase_Des WHERE F_LanguageCode = @LanguageCode) AS H ON A.F_SourcePhaseID = H.F_PhaseID

	UPDATE #table_Match SET F_NodeLevel = 1 WHERE F_MatchID IN (SELECT DISTINCT F_SourceMatchID FROM #table_Match)
	
			
	SELECT * FROM #table_Match

Set NOCOUNT OFF
End	