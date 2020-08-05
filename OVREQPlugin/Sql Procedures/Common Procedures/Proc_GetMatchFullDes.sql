IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchFullDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchFullDes]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











--名    称：[Proc_GetMatchFullDes]
--描    述：得到一个Phase或者Match节点的所有的运动员，此时如果是Phase需要区分Phase是小组赛还是淘汰赛
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月04日

CREATE PROCEDURE [dbo].[Proc_GetMatchFullDes](
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

	DECLARE @NodeLevel INT
	SET @NodeLevel = 0

	IF @Type = -1
	BEGIN
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
				SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
				  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_EventID = @EventID

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
	ELSE
	BEGIN
		IF @Type = 0
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
		ELSE
		BEGIN
			IF  @Type = 1
			BEGIN
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
								F_MatchNum				INT,
								F_MatchCode				NVARCHAR(20),
								F_MatchName				NVARCHAR(150),
                                F_CompetitionPosition   INT,
								F_CompetitionPositionDes1   INT,
								F_CompetitionPositionDes2   INT,
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
								F_PositionDes			NVARCHAR(100),
								F_PositionSourceDes		NVARCHAR(100)
							 )
	INSERT INTO #table_Competitors (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_MatchNum, F_MatchCode, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_RegisterID,
					F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
					F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel,
					F_ResultID, F_Rank, F_Points, F_Service, F_IRMID, F_MatchName)
		SELECT  B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, A.F_Order, A.F_MatchNum, A.F_MatchCode, D.F_CompetitionPosition, D.F_CompetitionPositionDes1, D.F_CompetitionPositionDes2, D.F_RegisterID,
					D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
					D.F_HistoryMatchID, D.F_HistoryMatchRank, D.F_HistoryLevel,
					D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID, C.F_MatchLongName AS F_MatchName
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Match_Des AS C 
				ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID WHERE B.F_NodeType = 1
		
	UPDATE #table_Competitors SET F_PhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	
--	UPDATE #table_Competitors SET F_MatchName = LTRIM(RTRIM(F_PhaseName)) + ' Match' + CAST (F_MatchOrder AS NVARCHAR(100))
	DECLARE @curEventName AS NVARCHAR(100)
	SELECT @curEventName = F_EventLongname FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_StartPhaseName = @curEventName WHERE F_StartPhaseName IS NULL
	UPDATE #table_Competitors SET F_StartPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode WHERE A.F_StartPhaseID IS NOT NULL
	
	UPDATE #table_Competitors SET F_SourcePhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchName = F_SourceMatchPhaseName + B.F_MatchLongName FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_SourceMatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_HistoryMatchPhaseID = B.F_PhaseID FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_HistoryMatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_HistoryMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_HistoryMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_HistoryMatchName = A.F_HistoryMatchPhaseName + ' ' + LTRIM(RTRIM(B.F_MatchLongName)) FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_HistoryMatchID = B.F_MatchID WHERE B.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_RegisterName = B.F_LongName FROM #table_Competitors AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_HistoryMatchName)) + ' Rank ' + CAST(F_HistoryMatchRank AS NVARCHAR(100)) + ' History Level ' + CAST(F_HistoryLevel AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	

	UPDATE #table_Competitors SET F_PositionSourceDes = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_PositionSourceDes IS NULL
	UPDATE #table_Competitors SET F_PositionSourceDes = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_PositionSourceDes IS NULL
	UPDATE #table_Competitors SET F_PositionSourceDes = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_PositionSourceDes IS NULL
	UPDATE #table_Competitors SET F_PositionSourceDes = LTRIM(RTRIM(F_HistoryMatchName)) + ' Rank ' + CAST(F_HistoryMatchRank AS NVARCHAR(100)) + ' History Level ' + CAST(F_HistoryLevel AS NVARCHAR(100)) WHERE F_RegisterName IS NULL

	
	
	UPDATE #table_Competitors SET F_CompetitionPositionDes1 = ISNULL(F_CompetitionPositionDes1, 0), F_CompetitionPositionDes2 = ISNULL(F_CompetitionPositionDes2, 0)
	UPDATE #table_Competitors SET F_PositionDes = 'Pos ' + CAST(ISNULL(F_CompetitionPositionDes1, 0) AS NVARCHAR(100)) WHERE F_CompetitionPositionDes2 = 0
	UPDATE #table_Competitors SET F_PositionDes = 'Pos ' + CAST(ISNULL(F_CompetitionPositionDes2, 0) AS NVARCHAR(100)) + '_' + CAST(ISNULL(F_CompetitionPositionDes1, 0) AS NVARCHAR(100)) WHERE F_CompetitionPositionDes2 != 0
	
	DECLARE @CompetitionType AS INT
	SELECT @CompetitionType = F_CompetitionTypeID FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID
/*
	IF (@CompetitionType = 1)
	BEGIN
		SELECT A.F_MatchNum AS [M.Num], A.F_MatchCode AS [M.Code], A.F_MatchName AS [Match Name], A.F_RegisterName AS Home, B.F_RegisterName AS Away, A.F_Points AS [Home Points], B.F_Points AS [Away Points], A.F_MatchID 
			FROM #table_Competitors AS A INNER JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPositionDes1 = 1 AND B.F_CompetitionPositionDes1 = 2
	END
	ELSE
	BEGIN
		IF (@CompetitionType IN (2, 3) )
		BEGIN
			SELECT DISTINCT F_MatchNum AS [M.Num], F_MatchCode AS [M.Code], F_MatchName AS [Match Name], F_MatchID
				FROM #table_Competitors 
		END
		ELSE
		BEGIN
			SELECT DISTINCT F_MatchNum AS [M.Num], F_MatchCode AS [M.Code], F_MatchName AS [Match Name], F_MatchID 
				FROM #table_Competitors 
		END
	END
	*/

	DECLARE @ColName AS NVARCHAR(max)
	SET @ColName = ''
	SELECT DISTINCT F_PositionDes, F_CompetitionPositionDes2, F_CompetitionPositionDes1 INTO #Temp_Cols FROM #table_Competitors ORDER BY F_CompetitionPositionDes2, F_CompetitionPositionDes1
	SELECT @ColName = @ColName + ', [' + F_PositionDes + ']' FROM #Temp_Cols

	IF LEN(@ColName) < 1
	BEGIN
		SET @ColName = '[No Position]'
	END
	ELSE
	BEGIN
		SET @ColName = RTRIM(LTRIM(RIGHT(@ColName, LEN(@ColName) - 1)))
	END
	
	
	DECLARE @SQL		    NVARCHAR(MAX)
	
	SET @SQL = 'SELECT F_MatchNum AS [M.Num], F_MatchCode AS [M.Code], F_MatchName AS [Match Name],' + @ColName + ', F_MatchID
					FROM (SELECT F_MatchNum, F_MatchCode, F_MatchName, F_MatchID, F_PositionDes, F_RegisterName FROM #table_Competitors) AS A
						PIVOT (MAX(F_RegisterName) FOR F_PositionDes IN (' + @ColName + ') ) AS B'
	EXEC (@Sql)

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec Proc_GetMatchFullDes 36, 0, 0, -1, 'ENG'