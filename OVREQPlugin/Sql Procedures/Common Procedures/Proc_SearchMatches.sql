
/****** Object:  StoredProcedure [dbo].[Proc_SearchMatches]    Script Date: 04/25/2011 14:16:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SearchMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SearchMatches]
GO


/****** Object:  StoredProcedure [dbo].[Proc_SearchMatches]    Script Date: 04/25/2011 14:16:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_SearchMatches]
--描    述：根据查询条件查询符合的Match列表 --为赵海军的查找比赛列表用
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月29日
--修改记录：
/*
           2011年04月25日     李燕        增加PhaseID、CourtID参数
*/

CREATE PROCEDURE [dbo].[Proc_SearchMatches](
				 @DisciplineCode	CHAR(2),
				 @EventID			INT,
				 @DateTime			NVARCHAR(50),
				 @VenueID			INT,
				 @PhaseID           INT,
				 @CourtID           INT
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

	DECLARE @LanguageCode AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

	DECLARE @DisciplineID AS INT
	DECLARE @CompetitionType AS INT

    IF @PhaseID = -1
    BEGIN
			IF @EventID = -1
			BEGIN
				SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
				
				INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
					SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
					  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID 
						WHERE A.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID IN (SELECT F_EventID FROM TS_Event WHERE @DisciplineID = F_DisciplineID)) AND A.F_FatherPhaseID = 0

				
			END
			ELSE
			BEGIN
				SELECT @DisciplineID = F_DisciplineID FROM TS_Event WHERE F_EventID = @EventID

				INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
					SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
					  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID 
						WHERE A.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID) AND A.F_FatherPhaseID = 0
			END
     END
     ELSE 
     BEGIN
         SELECT @DisciplineID = B.F_DisciplineID FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID
				
			INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
				SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
				  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID 
					WHERE A.F_PhaseID = @PhaseID

     END

	IF EXISTS (SELECT F_EventID FROM TS_Event WHERE F_DisciplineID = @DisciplineID AND F_CompetitionTypeID != 1)
	BEGIN
		SET @CompetitionType = 2
	END
	ELSE
	BEGIN
		SET @CompetitionType = 1 
	END
	
	DECLARE @NodeLevel AS INT
	SET @NodeLevel = 0
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


	CREATE TABLE #table_Competitors (
                                F_SportID				INT,
                                F_DisciplineID			INT,
								F_EventID				INT, 
								F_EventName				NVARCHAR(100),
								F_PhaseID				INT,
								F_PhaseName				NVARCHAR(100),
								F_MatchID				INT,
								F_MatchOrder			INT,
								F_MatchNum				INT,
								F_VenueID				INT,
								F_CourtID				INT,
								F_MatchDate				DATETIME,
								F_MatchTime				DATETIME,
								F_SessionID				INT,
								F_MatchStatusID         INT,
								F_RoundID				INT,
								F_MatchName				NVARCHAR(150),
                                F_CompetitionPosition   INT,
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
								F_ResultID				INT,
                                F_Rank					INT,
								F_Points				INT,
								F_Service				INT,
								F_IRMID					INT,
								F_SessionName			NVARCHAR(100),
								F_StatusName			NVARCHAR(100),
								F_MatchCode				NVARCHAR(20),
								F_RaceNum				NVARCHAR(20)
							 )
	INSERT INTO #table_Competitors (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_MatchNum, F_VenueID, F_CourtID, F_MatchDate, F_MatchTime, F_SessionID, F_MatchStatusID, F_RoundID, F_CompetitionPosition, F_RegisterID,
					F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
					F_ResultID, F_Rank, F_Points, F_Service, F_IRMID, F_MatchCode, F_RaceNum)
		SELECT  B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, A.F_Order, A.F_MatchNum, A.F_VenueID, A.F_CourtID, A.F_MatchDate, A.F_StartTime, A.F_SessionID, A.F_MatchStatusID, A.F_RoundID, D.F_CompetitionPosition, D.F_RegisterID,
					D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
					D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID, A.F_MatchCode, A.F_RaceNum
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Match_Des AS C 
				ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID WHERE B.F_NodeType = 1
	

	DELETE FROM #table_Competitors WHERE F_MatchStatusID IS NULL
	DELETE FROM #table_Competitors WHERE F_MatchStatusID <= 20

	UPDATE #table_Competitors SET F_MatchDate = '' WHERE F_MatchDate IS NULL
	UPDATE #table_Competitors SET F_VenueID = 0 WHERE F_VenueID IS NULL
	UPDATE #table_Competitors SET F_CourtID = 0 WHERE F_CourtID IS NULL
	UPDATE #table_Competitors SET F_RoundID = 0 WHERE F_RoundID IS NULL

	IF ((@DateTime != ' ALL') AND (@DateTime != ' 全部'))
	BEGIN
		DELETE FROM #table_Competitors WHERE LEFT(CONVERT (NVARCHAR(100), F_MatchDate, 120), 10) <> LTRIM(RTRIM(@DateTime))
	END
	
	IF (@VenueID != -1)
	BEGIN
		DELETE FROM #table_Competitors WHERE F_VenueID != @VenueID
	END
	
	IF(@CourtID != -1)
	BEGIN
	   DELETE FROM #table_Competitors WHERE F_CourtID != @CourtID
	END

	UPDATE #table_Competitors SET F_SessionName = LEFT(CONVERT (NVARCHAR(100), B.F_SessionDate, 120), 10) +' Session '+ CAST(B.F_SessionNumber AS NVARCHAR(100))   FROM #table_Competitors AS A LEFT JOIN TS_Session AS B ON A.F_SessionID = B.F_SessionID
	UPDATE #table_Competitors SET F_StatusName = B.F_StatusLongName FROM #table_Competitors AS A LEFT JOIN TC_Status_Des AS B ON A.F_MatchStatusID = B.F_StatusID AND B.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_EventName = B.F_EventLongName FROM #table_Competitors AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_PhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_MatchName = LTRIM(RTRIM(A.F_PhaseName)) + ' ' + B.F_MatchLongName FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_MatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_StartPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourcePhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
	
	UPDATE #table_Competitors SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchName = A.F_SourceMatchPhaseName + B.F_MatchLongName FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_SourceMatchID = B.F_MatchID AND B.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_RegisterName = B.F_LongName FROM #table_Competitors AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
	UPDATE #table_Competitors SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL


	IF (@CompetitionType = 1)
	BEGIN
			SELECT A.F_StatusName AS Status,A.F_EventName AS [Event], A.F_MatchName AS [Match Name], A.F_MatchCode AS [M.Code], A.F_RegisterName AS Home, B.F_RegisterName AS Away,
				CAST(A.F_Points AS NVARCHAR(10)) + ':' + CAST(B.F_Points AS NVARCHAR(10)) AS [Points], DBO.Fun_GetMatchResultDes(A.F_MatchID) AS [Full Result],LEFT(CONVERT (NVARCHAR(100), A.F_MatchDate, 120), 10) AS [Match Date],
				A.F_SessionName AS [Session], A.F_MatchNum AS [M.N], A.F_MatchID
					FROM #table_Competitors AS A INNER JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = 1 AND B.F_CompetitionPosition = 2
						ORDER BY A.F_EventID, A.F_MatchNum
	END
	ELSE
	BEGIN
		IF (@CompetitionType IN (2, 3) )
		BEGIN
			SELECT DISTINCT F_StatusName AS Status, F_EventName AS [Event], F_MatchName AS [Match Name], F_RaceNum AS [Race Num], F_MatchCode AS [M.Code], F_MatchName AS [Match Name]
				, LEFT(CONVERT (NVARCHAR(100), F_MatchDate, 120), 10) AS [Match Date]
				, F_SessionName AS [Session], F_MatchNum AS [M.N], F_MatchID 
				FROM #table_Competitors ORDER BY F_EventName, F_MatchNum
		END
		ELSE
		BEGIN
			SELECT DISTINCT F_StatusName AS Status, F_EventName AS [Event], F_MatchName AS [Match Name], F_RaceNum AS [Race Num], F_MatchCode AS [M.Code], F_MatchName AS [Match Name]
				, LEFT(CONVERT (NVARCHAR(100), F_MatchDate, 120), 10) AS [Match Date]
				, F_SessionName AS [Session], F_MatchNum AS [M.N], F_MatchID 
				FROM #table_Competitors ORDER BY F_EventName, F_MatchNum
		END
	END



Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


--exec [Proc_SearchMatches]  'te', -1, '2011-08-14', -1, -1, -1