IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchCompetitors]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_GetMatchCompetitors]
--描    述：得到一个Phase或者Match节点的所有的运动员，此时如果是Phase需要区分Phase是小组赛还是淘汰赛
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月04日

CREATE PROCEDURE [dbo].[Proc_GetMatchCompetitors](
				 @EventID			INT,
				 @PhaseID			INT,--对应类型的ID，与Type相关
                 @MatchID           INT,
				 @Type				INT,--注释: -4表示所有Sport, -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase, 1表示Match
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
									F_PhaseCode			NVARCHAR(10),
									F_NodeLongName		NVARCHAR(100),
									F_NodeShortName	    NVARCHAR(50),
									F_PhaseNodeType		INT,
									F_MatchID			INT,
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
									F_NodeLevel			INT,
                                    F_Order             INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100),
									F_NodeName			NVARCHAR(100)
								 )


	CREATE TABLE #table_Phase_Position(
									[F_PhaseName] [NVARCHAR] (100),
									[F_PhasePosition] [int],
									[F_RegisterID] [int],
									[F_RegisterName] [NVARCHAR] (100),
									[F_FederationLongName] [NVARCHAR] (100),
									[F_PhasePoints] [int],
									[F_PhaseRank] [int],
									[F_PhaseDisplayPosition] [int],
									[F_PhaseID] [int],
									[F_SourcePhaseID] [int],
									[F_SourcePhaseName] [NVARCHAR] (100),
									[F_SourcePhaseRank] [int],
									[F_Seed] [int]
								)
	DECLARE @curEventID	AS INT
	DECLARE @curEventName AS NVARCHAR(100)
	DECLARE @NodeLevel	AS INT
	SET @NodeLevel = 0

	IF @Type = -1
	BEGIN
				SET @curEventID = @EventID
				INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
					SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
					  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_EventID = @EventID AND A.F_FatherPhaseID = 0

				WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
				BEGIN
					SET @NodeLevel = @NodeLevel + 1
					UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

					INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
						SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
							FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel
				END

				--添加Match节点
				INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
					SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
						FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Match_Des AS C ON A.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeType = 0

	END
	ELSE
	BEGIN

		IF @Type = 0
		BEGIN
			
			DECLARE @PhaseType AS INT
			SELECT @curEventID = F_EventID, @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID

			IF @PhaseType = 2 -- 小组循环赛
			BEGIN

				INSERT INTO #table_Phase_Position ([F_PhaseName],F_PhasePosition,[F_RegisterID],[F_PhaseID],
						[F_SourcePhaseID],[F_SourcePhaseName],[F_SourcePhaseRank])
					SELECT B.F_PhaseLongName AS [F_PhaseName], A.F_PhasePosition AS F_PhasePosition, A.[F_RegisterID],
							A.[F_PhaseID],A.[F_SourcePhaseID],C.F_PhaseLongName AS [F_SourcePhaseName],
								A.[F_SourcePhaseRank] FROM TS_Phase_Position AS A LEFT JOIN TS_Phase_Des AS B 
						ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Phase_Des AS C 
							ON A.F_SourcePhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE A.F_PhaseID = @PhaseID 

				
				UPDATE #table_Phase_Position SET F_RegisterName = B.F_LongName FROM #table_Phase_Position AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
				UPDATE #table_Phase_Position SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
				UPDATE #table_Phase_Position SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
				UPDATE #table_Phase_Position SET F_FederationLongName = C.F_FederationLongName FROM #table_Phase_Position AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
					LEFT JOIN TC_Federation_Des AS C ON B.F_FederationID = C.F_FederationID AND C.F_LanguageCode = @LanguageCode

				UPDATE #table_Phase_Position SET F_Seed = B.F_Seed FROM #table_Phase_Position AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_EventID = @curEventID
				UPDATE #table_Phase_Position SET F_Seed = NULL WHERE F_Seed = 0
				UPDATE #table_Phase_Position SET F_RegisterName = F_RegisterName + '[' + CAST(F_Seed AS NVARCHAR(100)) + ']' WHERE F_Seed IS NOT NULL
				
				UPDATE #table_Phase_Position SET F_PhasePoints = B.F_PhasePoints, F_PhaseRank = B.F_PhaseRank, F_PhaseDisplayPosition = B.F_PhaseDisplayPosition 
					FROM #table_Phase_Position AS A LEFT JOIN TS_Phase_Result AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_RegisterID = B.F_RegisterID
					
				SELECT F_PhaseName AS [Group Name], F_PhasePosition AS Position, F_RegisterName AS [Competitor_Name], F_FederationLongName AS [Federation],
					 [F_PhasePoints] AS [Group Points], [F_PhaseRank] AS [Group Rank], [F_PhaseDisplayPosition] AS [Display Position],
						 [F_RegisterID], [F_PhaseID], [F_SourcePhaseID] 
							FROM #table_Phase_Position
				RETURN

			END
			ELSE
			BEGIN

				INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
					SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
					  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID

				WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
				BEGIN
					SET @NodeLevel = @NodeLevel + 1
					UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

					INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
						SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
							FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel
				END

				--添加Match节点
				INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
					SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
						FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeType = 0
			END
		END
		ELSE
		BEGIN
			IF  @Type = 1
			BEGIN

				SELECT @curEventID = B.F_EventID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

				--添加Match节点
				INSERT INTO #table_Tree( F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
					SELECT  A.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, 1 as F_NodeType, 1 as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
						FROM TS_Match AS A LEFT JOIN TS_Match_Des AS C ON A.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID
			END
		END

	END
	

	CREATE TABLE #table_Competitors (
                                F_SportID				INT,
                                F_DisciplineID			INT,
								F_EventID				INT, 
								F_PhaseID				INT,
								F_PhaseName				NVARCHAR(100),
								F_MatchID				INT,
								F_MatchOrder			INT,
								F_MatchName				NVARCHAR(150),
                                F_CompetitionPosition		INT,
								F_CompetitionPositionDes1	INT,
								F_CompetitionPositionDes2	INT,
								F_RegisterID			INT,
								F_RegisterName			NVARCHAR(100),
								F_StartPhaseID			INT,
								F_StartPhaseName		NVARCHAR(100),
                                F_StartPhasePosition	INT,
                                F_SourcePhaseID			INT,
								F_SourcePhaseName		NVARCHAR(100),
								F_SourcePhaseRank		INT,
								F_SourceMatchPhaseID	INT,
								F_SourceMatchPhaseName	NVARCHAR(100),
								F_SourceMatchID			INT,
								F_SourceMatchOrder		INT,
								F_SourceMatchName		NVARCHAR(100),
								F_SourceMatchRank		INT,
								F_HistoryMatchID		INT,
								F_HistoryMatchPhaseID	INT,
								F_HistoryMatchPhaseName NVARCHAR(100),
								F_HistoryMatchRank		INT,
								F_HistoryLevel			INT,
								F_HistoryMatchName		NVARCHAR(100),
								F_ResultID				INT,
                                F_Rank					INT,
								F_Points				INT,
								F_Service				INT,
								F_IRMID					INT,
								F_CountryLongName	    NVARCHAR(100),
								F_DelegationLongName    NVARCHAR(100),
								F_FederationLongName    NVARCHAR(100),
								F_Seed					INT,
								F_MatchNum				INT,
								F_SouceProgressDes		NVARCHAR(100),
								F_SouceProgressType		INT,
								F_ProgressDes			NVARCHAR(100),
								F_ProgressType			INT
							 )

	INSERT INTO #table_Competitors (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_RegisterID,
					F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
					F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel,
					F_ResultID, F_Rank, F_Points, F_Service, F_IRMID, F_MatchNum, F_SouceProgressDes, F_SouceProgressType, F_ProgressDes, F_ProgressType)
		SELECT  B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, A.F_Order, D.F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, D.F_RegisterID,
					D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
					D.F_HistoryMatchID, D.F_HistoryMatchRank, D.F_HistoryLevel,
					D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID, A.F_MatchNum, E.F_SouceProgressDes, E.F_SouceProgressType, E.F_ProgressDes, E.F_ProgressType
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Match_Des AS C 
				ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID LEFT JOIN
					TS_Match_Result_Des AS E ON D.F_MatchID = E.F_MatchID AND D.F_CompetitionPosition = E.F_CompetitionPosition AND E.F_LanguageCode = @LanguageCode WHERE B.F_NodeType = 1
		
	UPDATE #table_Competitors SET F_PhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_MatchName = LTRIM(RTRIM(A.F_PhaseName)) + ' ' + LTRIM(RTRIM(B.F_MatchLongName)) FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_LanguageCode = @LanguageCode

	SELECT @curEventName = F_EventLongname FROM TS_Event_Des WHERE F_EventID = @CurEventID AND F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_StartPhaseName = @curEventName WHERE F_StartPhaseName IS NULL
	UPDATE #table_Competitors SET F_StartPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode WHERE A.F_StartPhaseID IS NOT NULL
	
	UPDATE #table_Competitors SET F_SourcePhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchName = A.F_SourceMatchPhaseName + ' ' + LTRIM(RTRIM(B.F_MatchLongName)) FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_SourceMatchID = B.F_MatchID WHERE B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_HistoryMatchPhaseID = B.F_PhaseID FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_HistoryMatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_HistoryMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_HistoryMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_HistoryMatchName = A.F_HistoryMatchPhaseName + ' ' + LTRIM(RTRIM(B.F_MatchLongName)) FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_HistoryMatchID = B.F_MatchID WHERE B.F_LanguageCode = @LanguageCode
	
	UPDATE #table_Competitors SET F_RegisterName = B.F_LongName FROM #table_Competitors AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_HistoryMatchName)) + ' Rank ' + CAST(F_HistoryMatchRank AS NVARCHAR(100)) + ' History Level ' + CAST(F_HistoryLevel AS NVARCHAR(100)) WHERE F_RegisterName IS NULL


	UPDATE #table_Competitors SET F_CountryLongName = C.F_CountryLongName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Country_Des AS C ON B.F_NOC = C.F_NOC AND C.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_DelegationLongName = C.F_DelegationLongName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_FederationLongName = C.F_FederationLongName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Federation_Des AS C ON B.F_FederationID = C.F_FederationID AND C.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_Seed = B.F_Seed FROM #table_Competitors AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_EventID = @curEventID
	UPDATE #table_Competitors SET F_Seed = NULL WHERE F_Seed = 0
	UPDATE #table_Competitors SET F_RegisterName = F_RegisterName + '[' + CAST(F_Seed AS NVARCHAR(100)) + ']' WHERE F_Seed IS NOT NULL

	SELECT F_MatchNum AS [M.Num], F_MatchName AS [Match Name], F_CompetitionPositionDes1 AS Position1,F_CompetitionPositionDes2 AS Position2, F_RegisterName AS [Competitor Name],
		   F_CountryLongName AS Country,F_DelegationLongName AS Delegation, F_FederationLongName AS Federation,
		   F_SourcePhaseName, F_SourcePhaseRank, F_SourceMatchName, F_SourceMatchRank, F_StartPhaseName, F_StartPhasePosition, 
		   F_HistoryMatchName, F_HistoryMatchRank, F_HistoryLevel, F_SouceProgressDes,
		   F_Rank, F_Points, F_ProgressDes, F_SouceProgressType, F_ProgressType,
		   F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_CompetitionPosition, F_MatchOrder, F_RegisterID, F_StartPhaseID, F_SourcePhaseID, F_SourceMatchPhaseID,
		   F_SourceMatchID, F_SourceMatchOrder, F_HistoryMatchID
		FROM #table_Competitors ORDER BY F_MatchNum, F_MatchOrder, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_CompetitionPosition

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--EXEC [Proc_GetScheduleMatchCompetitors] 2495,1200,0,'CHN'

--EXEC Proc_GetMatchCompetitors 121,0,0,-1,'ENG'