IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEliminationCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].Proc_Report_BK_GetEliminationCompetitors

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_BK_GetEliminationCompetitors]
--描    述：得到淘汰赛对阵表
--参数说明： 
--说    明：
--创 建 人：穆学峰
--日    期：2009年04月21日
-- Proc_Report_BK_GetEliminationCompetitors 325,'58to56','chn'
CREATE PROCEDURE [dbo].Proc_Report_BK_GetEliminationCompetitors(
				 @PhaseID			INT,--对应类型的ID，与Type相关
				 @phasename		char(50),
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

   
	BEGIN
		
		DECLARE @PhaseType AS INT
		SELECT @PhaseType = F_PhaseType FROM TS_Phase WHERE F_PhaseID = @PhaseID


		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID


		WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
		BEGIN
			SET @NodeLevel = @NodeLevel + 1
			UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

			INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
				SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
					FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
		END

		--添加Match节点
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
				FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID WHERE B.F_NodeType = 0

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
								F_DisplayPos			INT,
								F_FederationID			INT,
								F_FederationName		NVARCHAR(100),
								F_MatchDate				NVARCHAR(20),
								F_MatchNum				INT,
								F_InscripNum			nvarchar(100)
							 )
	INSERT INTO #table_Competitors (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_CompetitionPosition, F_RegisterID,
					F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
					F_ResultID, F_Rank, F_Points, F_Service, F_IRMID)
		SELECT  B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, A.F_Order, D.F_CompetitionPosition, D.F_RegisterID,
					D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
					D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Match_Des AS C 
				ON C.F_MatchID = A.F_MatchID RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID WHERE B.F_NodeType = 1
		
	UPDATE #table_Competitors SET F_PhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_MatchName = LTRIM(RTRIM(F_PhaseName)) + ' Match' + CAST (F_MatchOrder AS NVARCHAR(100))
	UPDATE #table_Competitors SET F_StartPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourcePhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchName = F_SourceMatchPhaseName + ' Match' + CAST (F_SourceMatchOrder AS NVARCHAR(100))
	UPDATE #table_Competitors SET F_RegisterName = B.F_LongName FROM #table_Competitors AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_RegisterName = '(轮空)' WHERE F_RegisterID = -1
	UPDATE #table_Competitors SET F_FederationName = C.F_FederationShortName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID 
			LEFT JOIN TC_Federation_Des AS C ON B.F_FederationID = C.F_FederationID AND C.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_InscripNum = right(cast(100+B.F_InscriptionNum as nvarchar(100)),2) from #table_Competitors as A 
				left join tr_inscription as B on A.F_RegisterID = B.F_RegisterID and A.F_EventId = B.F_EventID
					 

	SET LANGUAGE N'简体中文'
	DECLARE @matchStatus AS INT
	DECLARE @matchDate AS NVARCHAR(100)
	DECLARE @matchScore AS INT

--	SET @matchStatus = SELECT A.F_StatusID  FROM TS_Match AS A LEFT JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_MatchDate = DATENAME(DAY, A.F_MatchDate) + '(' + substring(DATENAME(WEEKDAY, A.F_MatchDate),3,1) +')' FROM TS_Match AS A RIGHT JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID 

--	DELETE FROM #table_Competitors WHERE F_RegisterName = 'BYE'

	CREATE TABLE #table_report_Competitors (
								[event]	NVARCHAR(100),
								phase	NVARCHAR(50),
								playerNum1 NVARCHAR(50),
								playerNum2 NVARCHAR(50),
								playerNum3 NVARCHAR(50),
								playerNum4 NVARCHAR(50),
								playerNum5 NVARCHAR(50),
								playerNum6 NVARCHAR(50),
								playerNum7 NVARCHAR(50),
								playerNum8 NVARCHAR(50),
								playerNum9 NVARCHAR(50),
								playerNum10 NVARCHAR(50),
								playerNum11 NVARCHAR(50),
								playerNum12 NVARCHAR(50),
								playerNum13 NVARCHAR(50),
								playerNum14 NVARCHAR(50),
								playerNum15 NVARCHAR(50),
								playerNum16 NVARCHAR(50),
								playerNum17 NVARCHAR(50),
								playerNum18 NVARCHAR(50),
								playerNum19 NVARCHAR(50),
								playerNum20 NVARCHAR(50),
								playerNum21 NVARCHAR(50),
								playerNum22 NVARCHAR(50),
								playerNum23 NVARCHAR(50),
								playerNum24 NVARCHAR(50),
								playerNum25 NVARCHAR(50),
								playerNum26 NVARCHAR(50),
								playerNum27 NVARCHAR(50),
								playerNum28 NVARCHAR(50),
								playerNum29 NVARCHAR(50),
								playerNum30 NVARCHAR(50),
								playerNum31 NVARCHAR(50),
								playerNum32 NVARCHAR(50),
								playerNum33 NVARCHAR(50),
								playerNum34 NVARCHAR(50),
								playerNum35 NVARCHAR(50),
								playerNum36 NVARCHAR(50),
								playerNum37 NVARCHAR(50),
								playerNum38 NVARCHAR(50),
								playerNum39 NVARCHAR(50),
								playerNum40 NVARCHAR(50),
								playerNum41 NVARCHAR(50),
								playerNum42 NVARCHAR(50),
								playerNum43 NVARCHAR(50),
								playerNum44 NVARCHAR(50),
								playerNum45 NVARCHAR(50),
								playerNum46 NVARCHAR(50),
								playerNum47 NVARCHAR(50),
								playerNum48 NVARCHAR(50),
								playerNum49 NVARCHAR(50),
								playerNum50 NVARCHAR(50),
								playerNum51 NVARCHAR(50),
								playerNum52 NVARCHAR(50),
								playerNum53 NVARCHAR(50),
								playerNum54 NVARCHAR(50),
								playerNum55 NVARCHAR(50),
								playerNum56 NVARCHAR(50),
								playerNum57 NVARCHAR(50),
								playerNum58 NVARCHAR(50),
								playerNum59 NVARCHAR(50),
								playerNum60 NVARCHAR(50),
								playerNum61 NVARCHAR(50),
								playerNum62 NVARCHAR(50),
								playerNum63 NVARCHAR(50),
								playerNum64 NVARCHAR(50),
								player1 NVARCHAR(50),
								player2 NVARCHAR(50),
								player3 NVARCHAR(50),
								player4 NVARCHAR(50),
								player5 NVARCHAR(50),
								player6 NVARCHAR(50),
								player7 NVARCHAR(50),
								player8 NVARCHAR(50),
								player9 NVARCHAR(50),
								player10 NVARCHAR(50),
								player11 NVARCHAR(50),
								player12 NVARCHAR(50),
								player13 NVARCHAR(50),
								player14 NVARCHAR(50),
								player15 NVARCHAR(50),
								player16 NVARCHAR(50),
								player17 NVARCHAR(50),
								player18 NVARCHAR(50),
								player19 NVARCHAR(50),
								player20 NVARCHAR(50),
								player21 NVARCHAR(50),
								player22 NVARCHAR(50),
								player23 NVARCHAR(50),
								player24 NVARCHAR(50),
								player25 NVARCHAR(50),
								player26 NVARCHAR(50),
								player27 NVARCHAR(50),
								player28 NVARCHAR(50),
								player29 NVARCHAR(50),
								player30 NVARCHAR(50),
								player31 NVARCHAR(50),
								player32 NVARCHAR(50),
								player33 NVARCHAR(50),
								player34 NVARCHAR(50),
								player35 NVARCHAR(50),
								player36 NVARCHAR(50),
								player37 NVARCHAR(50),
								player38 NVARCHAR(50),
								player39 NVARCHAR(50),
								player40 NVARCHAR(50),
								player41 NVARCHAR(50),
								player42 NVARCHAR(50),
								player43 NVARCHAR(50),
								player44 NVARCHAR(50),
								player45 NVARCHAR(50),
								player46 NVARCHAR(50),
								player47 NVARCHAR(50),
								player48 NVARCHAR(50),
								player49 NVARCHAR(50),
								player50 NVARCHAR(50),
								player51 NVARCHAR(50),
								player52 NVARCHAR(50),
								player53 NVARCHAR(50),
								player54 NVARCHAR(50),
								player55 NVARCHAR(50),
								player56 NVARCHAR(50),
								player57 NVARCHAR(50),
								player58 NVARCHAR(50),
								player59 NVARCHAR(50),
								player60 NVARCHAR(50),
								player61 NVARCHAR(50),
								player62 NVARCHAR(50),
								player63 NVARCHAR(50),
								player64 NVARCHAR(50),
								team1	 NVARCHAR(50),
								team2	 NVARCHAR(50),
								team3	 NVARCHAR(50),
								team4	 NVARCHAR(50),
								team5	 NVARCHAR(50),
								team6	 NVARCHAR(50),
								team7	 NVARCHAR(50),
								team8	 NVARCHAR(50),
								team9	 NVARCHAR(50),
								team10	 NVARCHAR(50),
								team11	 NVARCHAR(50),
								team12	 NVARCHAR(50),
								team13	 NVARCHAR(50),
								team14	 NVARCHAR(50),
								team15	 NVARCHAR(50),
								team16	 NVARCHAR(50),
								team17	 NVARCHAR(50),
								team18	 NVARCHAR(50),
								team19	 NVARCHAR(50),
								team20	 NVARCHAR(50),
								team21	 NVARCHAR(50),
								team22	 NVARCHAR(50),
								team23	 NVARCHAR(50),
								team24	 NVARCHAR(50),
								team25	 NVARCHAR(50),
								team26	 NVARCHAR(50),
								team27	 NVARCHAR(50),
								team28	 NVARCHAR(50),
								team29	 NVARCHAR(50),
								team30	 NVARCHAR(50),
								team31	 NVARCHAR(50),
								team32	 NVARCHAR(50),
								team33	 NVARCHAR(50),
								team34	 NVARCHAR(50),
								team35	 NVARCHAR(50),
								team36	 NVARCHAR(50),
								team37	 NVARCHAR(50),
								team38	 NVARCHAR(50),
								team39	 NVARCHAR(50),
								team40	 NVARCHAR(50),
								team41	 NVARCHAR(50),
								team42	 NVARCHAR(50),
								team43	 NVARCHAR(50),
								team44	 NVARCHAR(50),
								team45	 NVARCHAR(50),
								team46	 NVARCHAR(50),
								team47	 NVARCHAR(50),
								team48	 NVARCHAR(50),
								team49	 NVARCHAR(50),
								team50	 NVARCHAR(50),
								team51	 NVARCHAR(50),
								team52	 NVARCHAR(50),
								team53	 NVARCHAR(50),
								team54	 NVARCHAR(50),
								team55	 NVARCHAR(50),
								team56	 NVARCHAR(50),
								team57	 NVARCHAR(50),
								team58	 NVARCHAR(50),
								team59	 NVARCHAR(50),
								team60	 NVARCHAR(50),
								team61	 NVARCHAR(50),
								team62	 NVARCHAR(50),
								team63	 NVARCHAR(50),
								team64	 NVARCHAR(50)
							 )

	DECLARE @PHASE AS NVARCHAR(100)
	DECLARE @PLAYER AS NVARCHAR(100)
	DECLARE @TEAM AS NVARCHAR(100)
	DECLARE @InscriNum AS NVARCHAR(100)
	DECLARE @ROW AS INT
	SET @ROW = 1
	DECLARE Competitor_CURSOR CURSOR FOR SELECT F_PhaseName, F_RegisterName, F_FederationName, F_InscripNum FROM #table_Competitors  WHERE F_PHASEName = @PhaseName
	OPEN Competitor_CURSOR
	FETCH NEXT FROM Competitor_CURSOR INTO @PHASE, @PLAYER, @TEAM, @InscriNum

	--ONLY ONE ROW EACH PHASE
	INSERT  INTO #table_report_Competitors(phase) VALUES (@PHASE)

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ROW = 1 UPDATE #table_report_Competitors SET player1 = @PLAYER, team1 = @TEAM, playerNum1 = @InscriNum
		IF @ROW = 2 UPDATE #table_report_Competitors SET player2 = @PLAYER, team2 = @TEAM, playerNum2 = @InscriNum
		IF @ROW = 3 UPDATE #table_report_Competitors SET player3 = @PLAYER, team3 = @TEAM, playerNum3 = @InscriNum
		IF @ROW = 4 UPDATE #table_report_Competitors SET player4 = @PLAYER, team4 = @TEAM, playerNum4 = @InscriNum
		IF @ROW = 5 UPDATE #table_report_Competitors SET player5 = @PLAYER, team5 = @TEAM, playerNum5 = @InscriNum
		IF @ROW = 6 UPDATE #table_report_Competitors SET player6 = @PLAYER, team6 = @TEAM, playerNum6 = @InscriNum
		IF @ROW = 7 UPDATE #table_report_Competitors SET player7 = @PLAYER, team7 = @TEAM, playerNum7 = @InscriNum
		IF @ROW = 8 UPDATE #table_report_Competitors SET player8 = @PLAYER, team8 = @TEAM, playerNum8 = @InscriNum
		IF @ROW = 9 UPDATE #table_report_Competitors SET player9 = @PLAYER, team9 = @TEAM, playerNum9 = @InscriNum
		IF @ROW = 10 UPDATE #table_report_Competitors SET player10 = @PLAYER, team10 = @TEAM, playerNum10 = @InscriNum
		IF @ROW = 11 UPDATE #table_report_Competitors SET player11 = @PLAYER, team11 = @TEAM, playerNum11 = @InscriNum
		IF @ROW = 12 UPDATE #table_report_Competitors SET player12 = @PLAYER, team12 = @TEAM, playerNum12 = @InscriNum
		IF @ROW = 13 UPDATE #table_report_Competitors SET player13 = @PLAYER, team13 = @TEAM, playerNum13 = @InscriNum
		IF @ROW = 14 UPDATE #table_report_Competitors SET player14 = @PLAYER, team14 = @TEAM, playerNum14 = @InscriNum
		IF @ROW = 15 UPDATE #table_report_Competitors SET player15 = @PLAYER, team15 = @TEAM, playerNum15 = @InscriNum
		IF @ROW = 16 UPDATE #table_report_Competitors SET player16 = @PLAYER, team16 = @TEAM, playerNum16 = @InscriNum
		IF @ROW = 17 UPDATE #table_report_Competitors SET player17 = @PLAYER, team17 = @TEAM, playerNum17 = @InscriNum
		IF @ROW = 18 UPDATE #table_report_Competitors SET player18 = @PLAYER, team18 = @TEAM, playerNum18 = @InscriNum
		IF @ROW = 19 UPDATE #table_report_Competitors SET player19 = @PLAYER, team19 = @TEAM, playerNum19 = @InscriNum
		IF @ROW = 20 UPDATE #table_report_Competitors SET player20 = @PLAYER, team20 = @TEAM, playerNum20 = @InscriNum
		IF @ROW = 21 UPDATE #table_report_Competitors SET player21 = @PLAYER, team21 = @TEAM, playerNum21 = @InscriNum
		IF @ROW = 22 UPDATE #table_report_Competitors SET player22 = @PLAYER, team22 = @TEAM, playerNum22 = @InscriNum
		IF @ROW = 23 UPDATE #table_report_Competitors SET player23 = @PLAYER, team23 = @TEAM, playerNum23 = @InscriNum
		IF @ROW = 24 UPDATE #table_report_Competitors SET player24 = @PLAYER, team24 = @TEAM, playerNum24 = @InscriNum
		IF @ROW = 25 UPDATE #table_report_Competitors SET player25 = @PLAYER, team25 = @TEAM, playerNum25 = @InscriNum
		IF @ROW = 26 UPDATE #table_report_Competitors SET player26 = @PLAYER, team26 = @TEAM, playerNum26 = @InscriNum
		IF @ROW = 27 UPDATE #table_report_Competitors SET player27 = @PLAYER, team27 = @TEAM, playerNum27 = @InscriNum
		IF @ROW = 28 UPDATE #table_report_Competitors SET player28 = @PLAYER, team28 = @TEAM, playerNum28 = @InscriNum
		IF @ROW = 29 UPDATE #table_report_Competitors SET player29 = @PLAYER, team29 = @TEAM, playerNum29 = @InscriNum
		IF @ROW = 30 UPDATE #table_report_Competitors SET player30 = @PLAYER, team30 = @TEAM, playerNum30 = @InscriNum
		IF @ROW = 31 UPDATE #table_report_Competitors SET player31 = @PLAYER, team31 = @TEAM, playerNum31 = @InscriNum
		IF @ROW = 32 UPDATE #table_report_Competitors SET player32 = @PLAYER, team32 = @TEAM, playerNum32 = @InscriNum
		IF @ROW = 33 UPDATE #table_report_Competitors SET player33 = @PLAYER, team33 = @TEAM, playerNum33 = @InscriNum
		IF @ROW = 34 UPDATE #table_report_Competitors SET player34 = @PLAYER, team34 = @TEAM, playerNum34 = @InscriNum
		IF @ROW = 35 UPDATE #table_report_Competitors SET player35 = @PLAYER, team35 = @TEAM, playerNum35 = @InscriNum
		IF @ROW = 36 UPDATE #table_report_Competitors SET player36 = @PLAYER, team36 = @TEAM, playerNum36 = @InscriNum
		IF @ROW = 37 UPDATE #table_report_Competitors SET player37 = @PLAYER, team37 = @TEAM, playerNum37 = @InscriNum
		IF @ROW = 38 UPDATE #table_report_Competitors SET player38 = @PLAYER, team38 = @TEAM, playerNum38 = @InscriNum
		IF @ROW = 39 UPDATE #table_report_Competitors SET player39 = @PLAYER, team39 = @TEAM, playerNum39 = @InscriNum
		IF @ROW = 40 UPDATE #table_report_Competitors SET player40 = @PLAYER, team40 = @TEAM, playerNum40 = @InscriNum
		IF @ROW = 41 UPDATE #table_report_Competitors SET player41 = @PLAYER, team41 = @TEAM, playerNum41 = @InscriNum
		IF @ROW = 42 UPDATE #table_report_Competitors SET player42 = @PLAYER, team42 = @TEAM, playerNum42 = @InscriNum
		IF @ROW = 43 UPDATE #table_report_Competitors SET player43 = @PLAYER, team43 = @TEAM, playerNum43 = @InscriNum
		IF @ROW = 44 UPDATE #table_report_Competitors SET player44 = @PLAYER, team44 = @TEAM, playerNum44 = @InscriNum
		IF @ROW = 45 UPDATE #table_report_Competitors SET player45 = @PLAYER, team45 = @TEAM, playerNum45 = @InscriNum
		IF @ROW = 46 UPDATE #table_report_Competitors SET player46 = @PLAYER, team46 = @TEAM, playerNum46 = @InscriNum
		IF @ROW = 47 UPDATE #table_report_Competitors SET player47 = @PLAYER, team47 = @TEAM, playerNum47 = @InscriNum
		IF @ROW = 48 UPDATE #table_report_Competitors SET player48 = @PLAYER, team48 = @TEAM, playerNum48 = @InscriNum
		IF @ROW = 49 UPDATE #table_report_Competitors SET player49 = @PLAYER, team49 = @TEAM, playerNum49 = @InscriNum
		IF @ROW = 50 UPDATE #table_report_Competitors SET player50 = @PLAYER, team50 = @TEAM, playerNum50 = @InscriNum
		IF @ROW = 51 UPDATE #table_report_Competitors SET player51 = @PLAYER, team51 = @TEAM, playerNum51 = @InscriNum
		IF @ROW = 52 UPDATE #table_report_Competitors SET player52 = @PLAYER, team52 = @TEAM, playerNum52 = @InscriNum
		IF @ROW = 53 UPDATE #table_report_Competitors SET player53 = @PLAYER, team53 = @TEAM, playerNum53 = @InscriNum
		IF @ROW = 54 UPDATE #table_report_Competitors SET player54 = @PLAYER, team54 = @TEAM, playerNum54 = @InscriNum
		IF @ROW = 55 UPDATE #table_report_Competitors SET player55 = @PLAYER, team55 = @TEAM, playerNum55 = @InscriNum
		IF @ROW = 56 UPDATE #table_report_Competitors SET player56 = @PLAYER, team56 = @TEAM, playerNum56 = @InscriNum
		IF @ROW = 57 UPDATE #table_report_Competitors SET player57 = @PLAYER, team57 = @TEAM, playerNum57 = @InscriNum
		IF @ROW = 58 UPDATE #table_report_Competitors SET player58 = @PLAYER, team58 = @TEAM, playerNum58 = @InscriNum
		IF @ROW = 59 UPDATE #table_report_Competitors SET player59 = @PLAYER, team59 = @TEAM, playerNum59 = @InscriNum
		IF @ROW = 60 UPDATE #table_report_Competitors SET player60 = @PLAYER, team60 = @TEAM, playerNum60 = @InscriNum
		IF @ROW = 61 UPDATE #table_report_Competitors SET player61 = @PLAYER, team61 = @TEAM, playerNum61 = @InscriNum
		IF @ROW = 62 UPDATE #table_report_Competitors SET player62 = @PLAYER, team62 = @TEAM, playerNum62 = @InscriNum
		IF @ROW = 63 UPDATE #table_report_Competitors SET player63 = @PLAYER, team63 = @TEAM, playerNum63 = @InscriNum
		IF @ROW = 64 UPDATE #table_report_Competitors SET player64 = @PLAYER, team64 = @TEAM, playerNum64 = @InscriNum
		SET @ROW = @ROW + 1
		FETCH NEXT FROM Competitor_CURSOR INTO @PHASE, @PLAYER, @TEAM, @InscriNum
	END
	CLOSE Competitor_CURSOR
	DEALLOCATE Competitor_CURSOR



	--根据phaseid得EventName
	declare @EventName as NVARCHAR(100)
	select @EventName = B.F_EventLongName from ts_phase as A inner join ts_event_des as B On A.F_EventID=B.F_EventID
	where A.F_PhaseID=@PhaseID

	Update #table_report_Competitors set [event]=@EventName

	select * from #table_report_Competitors

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF









GO


