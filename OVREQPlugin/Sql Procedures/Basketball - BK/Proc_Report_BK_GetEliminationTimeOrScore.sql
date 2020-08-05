IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEliminationTimeOrScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetEliminationTimeOrScore]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






-- select * from ts_phase where f_phaseid = 79
-- select * from ts_event
-- select * from ts_match where f_matchnum=31
-- Proc_Report_te_GetEliminationTimeOrScore 391,'32to16','CHN'
-- select * from ts_match_split_info


--创 建 人：穆学峰
--日    期：2009年04月27日

CREATE PROCEDURE [dbo].[Proc_Report_BK_GetEliminationTimeOrScore](
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
								F_MatchNum				INT,
								F_MatchOrder			INT,
								F_MatchName				NVARCHAR(150),
								F_MatchStatusID			INT,
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
								F_MatchDate				DATETIME,
								F_MatchTime				DATETIME,
								F_SessionTypeID			INT,
								F_SessionTypeDes		NVARCHAR(100),
								F_OrderInSession		NVARCHAR(100),
								F_CourtName				NVARCHAR(100)
							 )
	INSERT INTO #table_Competitors (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_MatchNum, F_MatchOrder, F_MatchStatusID, F_CompetitionPosition, F_RegisterID,
					F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
					F_ResultID, F_Rank, F_Points, F_Service, F_IRMID, F_MatchDate, F_MatchTime, F_SessionTypeID, F_OrderInSession)
		SELECT  B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, A.F_MatchNum, A.F_Order, A.F_MatchStatusID, D.F_CompetitionPosition, D.F_RegisterID,
					D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
					D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID, A.F_MatchDate, A.F_StartTime, E.F_SessionTypeID, A.F_OrderInSession
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TS_Match_Des AS C 
				ON C.F_MatchID = A.F_MatchID RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID LEFT JOIN ts_session AS E
				ON E.F_SessionID = A.F_SessionID 
				WHERE B.F_NodeType = 1
		
	UPDATE #table_Competitors SET F_PhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_MatchName = LTRIM(RTRIM(F_PhaseName))
	UPDATE #table_Competitors SET F_StartPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourcePhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #table_Competitors AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
	UPDATE #table_Competitors SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SourceMatchName = F_SourceMatchPhaseName + ' Match' + CAST (F_SourceMatchOrder AS NVARCHAR(100))
	UPDATE #table_Competitors SET F_RegisterName = B.F_LongName FROM #table_Competitors AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_RegisterName = ' ' WHERE F_RegisterID = -1
	UPDATE #table_Competitors SET F_FederationName = C.F_FederationShortName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID 
			LEFT JOIN TC_Federation_Des AS C ON B.F_FederationID = C.F_FederationID AND C.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_SessionTypeDes = B.F_SessionTypeShortName From tc_sessionType_des AS B RIGHT JOIN #table_Competitors as A ON A.F_SessionTypeID = B.F_SessionTypeID and B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_CourtName = c.F_CourtShortName from #table_Competitors as A left join ts_match as B on A.F_MatchID = B.F_MatchID left join tc_court_des as c on c.F_courtID = B.F_courtID

--	DELETE FROM #table_Competitors WHERE F_RegisterName = 'BYE'

	CREATE TABLE #table_Match_Competitors (
                                F_MatchNum				INT,
                                F_MatchName				NVARCHAR(100),
								F_HomeID				NVARCHAR(100), 
								F_AwayID				NVARCHAR(100), 				
								F_Home					NVARCHAR(100), 
								F_Away					NVARCHAR(100),
								F_HomePoint				INT,
								F_AwayPoint				INT,
								F_MatchID				INT,
								F_MatchStatusID			INT,
								F_MatchDate				DATETIME,
								F_MatchTime				DATETIME,
								F_SessionType			NVARCHAR(20),
								F_Score					NVARCHAR(100),
								F_OrderInSession		NVARCHAR(20),
								F_CourtName					NVARCHAR(20),
								F_EventID				INT,
								F_IrmName					NVARCHAR(20)
			)

	INSERT INTO #table_Match_Competitors(F_MatchNum, F_MatchName, F_HomeID, F_AwayID, F_Home, F_Away, F_HomePoint, F_AwayPoint, F_MatchID, F_MatchStatusID, 
				F_MatchDate, F_MatchTime, F_SessionType, F_OrderInSession, F_CourtName, F_EventID)
	SELECT A.F_MatchNum, A.F_MatchName, A.F_RegisterID, B.F_RegisterID, A.F_RegisterName AS Home, B.F_RegisterName AS Away, 
			A.F_Points AS [Home Points], B.F_Points AS [Away Points], A.F_MatchID, A.F_MatchStatusID, A.F_MatchDate, 
			A.F_MatchTime, A.F_SessionTypeDes, A.F_OrderInSession, A.F_CourtName, A.F_EventID
		FROM #table_Competitors AS A INNER JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID 
			AND A.F_CompetitionPosition = 1 AND B.F_CompetitionPosition = 2 WHERE A.F_MatchName=@PhaseName

	update #table_Match_Competitors set F_IrmName = dbo.fun_getMatchIRM(F_MatchID, '', '', 'CHN')

	SET LANGUAGE N'简体中文'
	--应该得到每一局的比分，而不是总比分
	--局比分的格式 (21:13 9:21 21:12)
	--时间的格式(12晚三(3)) 12号晚上 场地(三) 第3场比赛

--	select * from #table_Match_Competitors

	DECLARE @HomeID AS NVARCHAR(100)
	DECLARE @AwayID AS NVARCHAR(100)
	DECLARE @MatchID AS NVARCHAR(100)
	DECLARE @ROW AS INT
	DECLARE Competitor_CURSOR CURSOR FOR SELECT F_MatchID, F_HomeID, F_AwayID FROM #table_Match_Competitors
	OPEN Competitor_CURSOR
	FETCH NEXT FROM Competitor_CURSOR INTO @MatchID, @HomeID, @AwayID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- sub cursor
		declare @Score as INT
		declare @ScoreA as INT
		declare @ScoreB as INT
		declare @ScoreSet as NVARCHAR(20)
		declare @ScoreSum as NVARCHAR(100)
		set @ScoreSum = ''
		SET @ROW = 1
		SET @ScoreA = 0
		SET @ScoreB = 0
		declare score_cursor CURSOR FOR 
			select B.F_Points from ts_match_Split_info as A left join ts_match_Split_result as B on A.F_MatchSplitID = B.F_MatchSplitID and A.F_MatchID = B.F_MatchID
			where A.F_MatchID=@MatchID and A.F_FatherMatchSplitID=0 Order by A.F_MatchSplitID, B.F_CompetitionPosition

		open score_cursor
		fetch next from score_cursor into @Score
		WHILE @@FETCH_STATUS = 0
		begin
			if @Score is Null set @Score=0 --null as 0
			if @ROW%2=0
				set @ScoreB = @Score
			else
				set @ScoreA = @Score
	
			if(@ScoreA=0 and @ScoreB=0)
				set @ScoreSet = ''
			else
				set @ScoreSet = cast(@ScoreA as nvarchar(5)) + ':' + cast(@ScoreB as nvarchar(5))
				
			if @ROW%2=0
				set @ScoreSum = @ScoreSum + ' ' + @ScoreSet

			SET @ROW = @ROW + 1
			fetch next from score_cursor into @Score
		end
		close score_cursor
		deallocate score_cursor

		update #table_Match_Competitors set F_Score = ltrim(rtrim(@ScoreSum)) where F_MatchID = @MatchID
		--

		FETCH NEXT FROM Competitor_CURSOR INTO  @MatchID, @HomeID, @AwayID
	END
	CLOSE Competitor_CURSOR
	DEALLOCATE Competitor_CURSOR
	
--	select * from #table_Match_Competitors

	CREATE TABLE #report_table (
                                F_MatchNum1				INT,
                                F_MatchNum2				INT,
                                F_MatchNum3				INT,
                                F_MatchNum4				INT,
                                F_MatchNum5				INT,
                                F_MatchNum6				INT,
                                F_MatchNum7				INT,
                                F_MatchNum8				INT,
                                F_MatchNum9				INT,
                                F_MatchNum10			INT,
                                F_MatchNum11			INT,
                                F_MatchNum12			INT,
                                F_MatchNum13			INT,
                                F_MatchNum14			INT,
                                F_MatchNum15			INT,
                                F_MatchNum16			INT,
                                F_MatchNum17			INT,
                                F_MatchNum18			INT,
                                F_MatchNum19			INT,
                                F_MatchNum20			INT,
                                F_MatchNum21			INT,
                                F_MatchNum22			INT,
                                F_MatchNum23			INT,
                                F_MatchNum24			INT,
                                F_MatchNum25			INT,
                                F_MatchNum26			INT,
                                F_MatchNum27			INT,
                                F_MatchNum28			INT,
                                F_MatchNum29			INT,
                                F_MatchNum30			INT,
                                F_MatchNum31			INT,
                                F_MatchNum32			INT,
                                F_MatchName1			NVARCHAR(100),
                                F_MatchName2			NVARCHAR(100),
                                F_MatchName3			NVARCHAR(100),
                                F_MatchName4			NVARCHAR(100),
                                F_MatchName5			NVARCHAR(100),
                                F_MatchName6			NVARCHAR(100),
                                F_MatchName7			NVARCHAR(100),
                                F_MatchName8			NVARCHAR(100),
                                F_MatchName9			NVARCHAR(100),
                                F_MatchName10			NVARCHAR(100),
                                F_MatchName11			NVARCHAR(100),
                                F_MatchName12			NVARCHAR(100),
                                F_MatchName13			NVARCHAR(100),
                                F_MatchName14			NVARCHAR(100),
                                F_MatchName15			NVARCHAR(100),
                                F_MatchName16			NVARCHAR(100),
                                F_MatchName17			NVARCHAR(100),
                                F_MatchName18			NVARCHAR(100),
                                F_MatchName19			NVARCHAR(100),
                                F_MatchName20			NVARCHAR(100),
                                F_MatchName21			NVARCHAR(100),
                                F_MatchName22			NVARCHAR(100),
                                F_MatchName23			NVARCHAR(100),
                                F_MatchName24			NVARCHAR(100),
                                F_MatchName25			NVARCHAR(100),
                                F_MatchName26			NVARCHAR(100),
                                F_MatchName27			NVARCHAR(100),
                                F_MatchName28			NVARCHAR(100),
                                F_MatchName29			NVARCHAR(100),
                                F_MatchName30			NVARCHAR(100),
                                F_MatchName31			NVARCHAR(100),
                                F_MatchName32			NVARCHAR(100),
								F_Home1					NVARCHAR(100), 
								F_Home2					NVARCHAR(100), 
								F_Home3					NVARCHAR(100), 
								F_Home4					NVARCHAR(100), 
								F_Home5					NVARCHAR(100), 
								F_Home6					NVARCHAR(100), 
								F_Home7					NVARCHAR(100), 
								F_Home8					NVARCHAR(100), 
								F_Home9					NVARCHAR(100), 
								F_Home10				NVARCHAR(100), 
								F_Home11				NVARCHAR(100), 
								F_Home12				NVARCHAR(100), 
								F_Home13				NVARCHAR(100), 
								F_Home14				NVARCHAR(100), 
								F_Home15				NVARCHAR(100), 
								F_Home16				NVARCHAR(100), 
								F_Home17				NVARCHAR(100), 
								F_Home18				NVARCHAR(100), 
								F_Home19				NVARCHAR(100), 
								F_Home20				NVARCHAR(100), 
								F_Home21				NVARCHAR(100), 
								F_Home22				NVARCHAR(100), 
								F_Home23				NVARCHAR(100), 
								F_Home24				NVARCHAR(100), 
								F_Home25				NVARCHAR(100), 
								F_Home26				NVARCHAR(100), 
								F_Home27				NVARCHAR(100), 
								F_Home28				NVARCHAR(100), 
								F_Home29				NVARCHAR(100), 
								F_Home30				NVARCHAR(100), 
								F_Home31				NVARCHAR(100), 
								F_Home32				NVARCHAR(100), 
								F_Away1					NVARCHAR(100),
								F_Away2					NVARCHAR(100),
								F_Away3					NVARCHAR(100),
								F_Away4					NVARCHAR(100),
								F_Away5					NVARCHAR(100),
								F_Away6					NVARCHAR(100),
								F_Away7					NVARCHAR(100),
								F_Away8					NVARCHAR(100),
								F_Away9					NVARCHAR(100),
								F_Away10				NVARCHAR(100),
								F_Away11				NVARCHAR(100),
								F_Away12				NVARCHAR(100),
								F_Away13				NVARCHAR(100),
								F_Away14				NVARCHAR(100),
								F_Away15				NVARCHAR(100),
								F_Away16				NVARCHAR(100),
								F_Away17				NVARCHAR(100),
								F_Away18				NVARCHAR(100),
								F_Away19				NVARCHAR(100),
								F_Away20				NVARCHAR(100),
								F_Away21				NVARCHAR(100),
								F_Away22				NVARCHAR(100),
								F_Away23				NVARCHAR(100),
								F_Away24				NVARCHAR(100),
								F_Away25				NVARCHAR(100),
								F_Away26				NVARCHAR(100),
								F_Away27				NVARCHAR(100),
								F_Away28				NVARCHAR(100),
								F_Away29				NVARCHAR(100),
								F_Away30				NVARCHAR(100),
								F_Away31				NVARCHAR(100),
								F_Away32				NVARCHAR(100),
								F_HomePoint1				INT,
								F_HomePoint2				INT,
								F_HomePoint3				INT,
								F_HomePoint4				INT,
								F_HomePoint5				INT,
								F_HomePoint6				INT,
								F_HomePoint7				INT,
								F_HomePoint8				INT,
								F_HomePoint9				INT,
								F_HomePoint10				INT,
								F_HomePoint11				INT,
								F_HomePoint12				INT,
								F_HomePoint13				INT,
								F_HomePoint14				INT,
								F_HomePoint15				INT,
								F_HomePoint16				INT,
								F_HomePoint17				INT,
								F_HomePoint18				INT,
								F_HomePoint19				INT,
								F_HomePoint20				INT,
								F_HomePoint21				INT,
								F_HomePoint22				INT,
								F_HomePoint23				INT,
								F_HomePoint24				INT,
								F_HomePoint25				INT,
								F_HomePoint26				INT,
								F_HomePoint27				INT,
								F_HomePoint28				INT,
								F_HomePoint29				INT,
								F_HomePoint30				INT,
								F_HomePoint31				INT,
								F_HomePoint32				INT,
								F_AwayPoint1				INT,
								F_AwayPoint2				INT,
								F_AwayPoint3				INT,
								F_AwayPoint4				INT,
								F_AwayPoint5				INT,
								F_AwayPoint6				INT,
								F_AwayPoint7				INT,
								F_AwayPoint8				INT,
								F_AwayPoint9				INT,
								F_AwayPoint10				INT,
								F_AwayPoint11				INT,
								F_AwayPoint12				INT,
								F_AwayPoint13				INT,
								F_AwayPoint14				INT,
								F_AwayPoint15				INT,
								F_AwayPoint16				INT,
								F_AwayPoint17				INT,
								F_AwayPoint18				INT,
								F_AwayPoint19				INT,
								F_AwayPoint20				INT,
								F_AwayPoint21				INT,
								F_AwayPoint22				INT,
								F_AwayPoint23				INT,
								F_AwayPoint24				INT,
								F_AwayPoint25				INT,
								F_AwayPoint26				INT,
								F_AwayPoint27				INT,
								F_AwayPoint28				INT,
								F_AwayPoint29				INT,
								F_AwayPoint30				INT,
								F_AwayPoint31				INT,
								F_AwayPoint32				INT,
								F_MatchDate1			DATETIME,
								F_MatchDate2			DATETIME,
								F_MatchDate3			DATETIME,
								F_MatchDate4			DATETIME,
								F_MatchDate5			DATETIME,
								F_MatchDate6			DATETIME,
								F_MatchDate7			DATETIME,
								F_MatchDate8			DATETIME,
								F_MatchDate9			DATETIME,
								F_MatchDate10			DATETIME,
								F_MatchDate11			DATETIME,
								F_MatchDate12			DATETIME,
								F_MatchDate13			DATETIME,
								F_MatchDate14			DATETIME,
								F_MatchDate15			DATETIME,
								F_MatchDate16			DATETIME,
								F_MatchDate17			DATETIME,
								F_MatchDate18			DATETIME,
								F_MatchDate19			DATETIME,
								F_MatchDate20			DATETIME,
								F_MatchDate21			DATETIME,
								F_MatchDate22			DATETIME,
								F_MatchDate23			DATETIME,
								F_MatchDate24			DATETIME,
								F_MatchDate25			DATETIME,
								F_MatchDate26			DATETIME,
								F_MatchDate27			DATETIME,
								F_MatchDate28			DATETIME,
								F_MatchDate29			DATETIME,
								F_MatchDate30			DATETIME,
								F_MatchDate31			DATETIME,
								F_MatchDate32			DATETIME,
								F_MatchTime1			DATETIME,
								F_MatchTime2			DATETIME,
								F_MatchTime3			DATETIME,
								F_MatchTime4			DATETIME,
								F_MatchTime5			DATETIME,
								F_MatchTime6			DATETIME,
								F_MatchTime7			DATETIME,
								F_MatchTime8			DATETIME,
								F_MatchTime9			DATETIME,
								F_MatchTime10			DATETIME,
								F_MatchTime11			DATETIME,
								F_MatchTime12			DATETIME,
								F_MatchTime13			DATETIME,
								F_MatchTime14			DATETIME,
								F_MatchTime15			DATETIME,
								F_MatchTime16			DATETIME,
								F_MatchTime17			DATETIME,
								F_MatchTime18			DATETIME,
								F_MatchTime19			DATETIME,
								F_MatchTime20			DATETIME,
								F_MatchTime21			DATETIME,
								F_MatchTime22			DATETIME,
								F_MatchTime23			DATETIME,
								F_MatchTime24			DATETIME,
								F_MatchTime25			DATETIME,
								F_MatchTime26			DATETIME,
								F_MatchTime27			DATETIME,
								F_MatchTime28			DATETIME,
								F_MatchTime29			DATETIME,
								F_MatchTime30			DATETIME,
								F_MatchTime31			DATETIME,
								F_MatchTime32			DATETIME,
								F_SessionType1			NVARCHAR(20),
								F_SessionType2			NVARCHAR(20),
								F_SessionType3			NVARCHAR(20),
								F_SessionType4			NVARCHAR(20),
								F_SessionType5			NVARCHAR(20),
								F_SessionType6			NVARCHAR(20),
								F_SessionType7			NVARCHAR(20),
								F_SessionType8			NVARCHAR(20),
								F_SessionType9			NVARCHAR(20),
								F_SessionType10			NVARCHAR(20),
								F_SessionType11			NVARCHAR(20),
								F_SessionType12			NVARCHAR(20),
								F_SessionType13			NVARCHAR(20),
								F_SessionType14			NVARCHAR(20),
								F_SessionType15			NVARCHAR(20),
								F_SessionType16			NVARCHAR(20),
								F_SessionType17			NVARCHAR(20),
								F_SessionType18			NVARCHAR(20),
								F_SessionType19			NVARCHAR(20),
								F_SessionType20			NVARCHAR(20),
								F_SessionType21			NVARCHAR(20),
								F_SessionType22			NVARCHAR(20),
								F_SessionType23			NVARCHAR(20),
								F_SessionType24			NVARCHAR(20),
								F_SessionType25			NVARCHAR(20),
								F_SessionType26			NVARCHAR(20),
								F_SessionType27			NVARCHAR(20),
								F_SessionType28			NVARCHAR(20),
								F_SessionType29			NVARCHAR(20),
								F_SessionType30			NVARCHAR(20),
								F_SessionType31			NVARCHAR(20),
								F_SessionType32			NVARCHAR(20),
								F_Score1					NVARCHAR(100),
								F_Score2					NVARCHAR(100),
								F_Score3					NVARCHAR(100),
								F_Score4					NVARCHAR(100),
								F_Score5					NVARCHAR(100),
								F_Score6					NVARCHAR(100),
								F_Score7					NVARCHAR(100),
								F_Score8					NVARCHAR(100),
								F_Score9					NVARCHAR(100),
								F_Score10					NVARCHAR(100),
								F_Score11					NVARCHAR(100),
								F_Score12					NVARCHAR(100),
								F_Score13					NVARCHAR(100),
								F_Score14					NVARCHAR(100),
								F_Score15					NVARCHAR(100),
								F_Score16					NVARCHAR(100),
								F_Score17					NVARCHAR(100),
								F_Score18					NVARCHAR(100),
								F_Score19					NVARCHAR(100),
								F_Score20					NVARCHAR(100),
								F_Score21					NVARCHAR(100),
								F_Score22					NVARCHAR(100),
								F_Score23					NVARCHAR(100),
								F_Score24					NVARCHAR(100),
								F_Score25					NVARCHAR(100),
								F_Score26					NVARCHAR(100),
								F_Score27					NVARCHAR(100),
								F_Score28					NVARCHAR(100),
								F_Score29					NVARCHAR(100),
								F_Score30					NVARCHAR(100),
								F_Score31					NVARCHAR(100),
								F_Score32					NVARCHAR(100),
								F_TeamScore1				NVARCHAR(100),
								F_TeamScore2				NVARCHAR(100),
								F_TeamScore3				NVARCHAR(100),
								F_TeamScore4				NVARCHAR(100),
								F_TeamScore5				NVARCHAR(100),
								F_TeamScore6				NVARCHAR(100),
								F_TeamScore7				NVARCHAR(100),
								F_TeamScore8				NVARCHAR(100),
								F_TeamScore9				NVARCHAR(100),
								F_TeamScore10				NVARCHAR(100),
								F_TeamScore11				NVARCHAR(100),
								F_TeamScore12				NVARCHAR(100),
								F_TeamScore13				NVARCHAR(100),
								F_TeamScore14				NVARCHAR(100),
								F_TeamScore15				NVARCHAR(100),
								F_TeamScore16				NVARCHAR(100),
								F_TeamScore17				NVARCHAR(100),
								F_TeamScore18				NVARCHAR(100),
								F_TeamScore19				NVARCHAR(100),
								F_TeamScore20				NVARCHAR(100),
								F_TeamScore21				NVARCHAR(100),
								F_TeamScore22				NVARCHAR(100),
								F_TeamScore23				NVARCHAR(100),
								F_TeamScore24				NVARCHAR(100),
								F_TeamScore25				NVARCHAR(100),
								F_TeamScore26				NVARCHAR(100),
								F_TeamScore27				NVARCHAR(100),
								F_TeamScore28				NVARCHAR(100),
								F_TeamScore29				NVARCHAR(100),
								F_TeamScore30				NVARCHAR(100),
								F_TeamScore31				NVARCHAR(100),
								F_TeamScore32				NVARCHAR(100),
								F_OrderInSession1			NVARCHAR(100),
								F_OrderInSession2			NVARCHAR(100),
								F_OrderInSession3			NVARCHAR(100),
								F_OrderInSession4			NVARCHAR(100),
								F_OrderInSession5			NVARCHAR(100),
								F_OrderInSession6			NVARCHAR(100),
								F_OrderInSession7			NVARCHAR(100),
								F_OrderInSession8			NVARCHAR(100),
								F_OrderInSession9			NVARCHAR(100),
								F_OrderInSession10			NVARCHAR(100),
								F_OrderInSession11			NVARCHAR(100),
								F_OrderInSession12			NVARCHAR(100),
								F_OrderInSession13			NVARCHAR(100),
								F_OrderInSession14			NVARCHAR(100),
								F_OrderInSession15			NVARCHAR(100),
								F_OrderInSession16			NVARCHAR(100),
								F_OrderInSession17			NVARCHAR(100),
								F_OrderInSession18			NVARCHAR(100),
								F_OrderInSession19			NVARCHAR(100),
								F_OrderInSession20			NVARCHAR(100),
								F_OrderInSession21			NVARCHAR(100),
								F_OrderInSession22			NVARCHAR(100),
								F_OrderInSession23			NVARCHAR(100),
								F_OrderInSession24			NVARCHAR(100),
								F_OrderInSession25			NVARCHAR(100),
								F_OrderInSession26			NVARCHAR(100),
								F_OrderInSession27			NVARCHAR(100),
								F_OrderInSession28			NVARCHAR(100),
								F_OrderInSession29			NVARCHAR(100),
								F_OrderInSession30			NVARCHAR(100),
								F_OrderInSession31			NVARCHAR(100),
								F_OrderInSession32			NVARCHAR(100),
								F_Court1			NVARCHAR(100),
								F_Court2			NVARCHAR(100),
								F_Court3			NVARCHAR(100),
								F_Court4			NVARCHAR(100),
								F_Court5			NVARCHAR(100),
								F_Court6			NVARCHAR(100),
								F_Court7			NVARCHAR(100),
								F_Court8			NVARCHAR(100),
								F_Court9			NVARCHAR(100),
								F_Court10			NVARCHAR(100),
								F_Court11			NVARCHAR(100),
								F_Court12			NVARCHAR(100),
								F_Court13			NVARCHAR(100),
								F_Court14			NVARCHAR(100),
								F_Court15			NVARCHAR(100),
								F_Court16			NVARCHAR(100),
								F_Court17			NVARCHAR(100),
								F_Court18			NVARCHAR(100),
								F_Court19			NVARCHAR(100),
								F_Court20			NVARCHAR(100),
								F_Court21			NVARCHAR(100),
								F_Court22			NVARCHAR(100),
								F_Court23			NVARCHAR(100),
								F_Court24			NVARCHAR(100),
								F_Court25			NVARCHAR(100),
								F_Court26			NVARCHAR(100),
								F_Court27			NVARCHAR(100),
								F_Court28			NVARCHAR(100),
								F_Court29			NVARCHAR(100),
								F_Court30			NVARCHAR(100),
								F_Court31			NVARCHAR(100),
								F_Court32			NVARCHAR(100)
							)
	DECLARE @matchnum AS NVARCHAR(100)
	DECLARE @homename AS NVARCHAR(100)
	DECLARE @awayname AS NVARCHAR(100)
	DECLARE @homepoint AS INT
	DECLARE @awaypoint AS INT
	DECLARE @Matchdate AS DATETIME
	DECLARE @Matchtime AS DATETIME
	DECLARE @sessionType AS NVARCHAR(100)
	DECLARE @matchscore AS NVARCHAR(100)
	DECLARE @orderInSession AS NVARCHAR(100)
	DECLARE @FieldName AS NVARCHAR(100)
	DECLARE @TeamScore AS NVARCHAR(100)
	DECLARE @IRMName AS NVARCHAR(100)
	declare @eventid as int
	
--	select * from #table_Match_Competitors

	SET @ROW = 1
	DECLARE REPORT_CURSOR CURSOR FOR SELECT F_MatchNum, F_Home, F_Away, F_HomePoint, F_AwayPoint, F_MatchDate, F_MatchTime, F_SessionType, F_Score, F_OrderInSession, F_CourtName, F_EventID, F_IrmName FROM #table_Match_Competitors
	OPEN REPORT_CURSOR
	FETCH NEXT FROM REPORT_CURSOR INTO @matchnum, @homename, @awayname, @homepoint, @awaypoint, @Matchdate, @Matchtime, @sessionType, @matchscore, @orderInsession, @FieldName, @eventid, @IRMName
	
	--ONLY ONE ROW EACH PHASE
	INSERT  INTO #report_table(F_MatchNum1) VALUES ('')

	WHILE @@FETCH_STATUS = 0
	BEGIN
		declare @RegType int
		select @RegType = F_PlayerRegTypeID from ts_event where F_EventID = @eventid

		if(@RegType=3) set @matchscore = CAST(@homepoint as nvarchar(10)) + ':' + CAST(@awaypoint as nvarchar(10))

		IF (@homepoint is not null AND @awaypoint is not null)
			set @TeamScore = CAST(@homepoint as nvarchar(10)) + ':' + CAST(@awaypoint as nvarchar(10))
		else
			set @TeamScore = ''

		if(@IRMName <>'') set @matchscore = @irmName

		IF @ROW = 1 UPDATE #report_table SET F_MatchNum1 = @matchnum, F_Home1 = @homename, F_Away1 = @awayname, F_HomePoint1 = @homepoint, F_AwayPoint1 = @awaypoint, F_MatchDate1 = @Matchdate, F_MatchTime1 = @Matchtime, F_SessionType1 = @sessionType, F_Score1 = @matchscore, F_OrderInsession1 = @orderInSession, F_Court1 = @FieldName, F_TeamScore1 = @TeamScore
		IF @ROW = 2 UPDATE #report_table SET F_MatchNum2 = @matchnum, F_Home2 = @homename, F_Away2 = @awayname, F_HomePoint2 = @homepoint, F_AwayPoint2 = @awaypoint, F_MatchDate2 = @Matchdate, F_MatchTime2 = @Matchtime, F_SessionType2 = @sessionType, F_Score2 = @matchscore, F_OrderInsession2 = @orderInSession, F_Court2 = @FieldName, F_TeamScore2 = @TeamScore
		IF @ROW = 3 UPDATE #report_table SET F_MatchNum3 = @matchnum, F_Home3 = @homename, F_Away3 = @awayname, F_HomePoint3 = @homepoint, F_AwayPoint3 = @awaypoint, F_MatchDate3 = @Matchdate, F_MatchTime3 = @Matchtime, F_SessionType3 = @sessionType, F_Score3 = @matchscore, F_OrderInsession3 = @orderInSession, F_Court3 = @FieldName, F_TeamScore3 = @TeamScore
		IF @ROW = 4 UPDATE #report_table SET F_MatchNum4 = @matchnum, F_Home4 = @homename, F_Away4 = @awayname, F_HomePoint4 = @homepoint, F_AwayPoint4 = @awaypoint, F_MatchDate4 = @Matchdate, F_MatchTime4 = @Matchtime, F_SessionType4 = @sessionType, F_Score4 = @matchscore, F_OrderInsession4 = @orderInSession, F_Court4 = @FieldName, F_TeamScore4 = @TeamScore
		IF @ROW = 5 UPDATE #report_table SET F_MatchNum5 = @matchnum, F_Home5 = @homename, F_Away5 = @awayname, F_HomePoint5 = @homepoint, F_AwayPoint5 = @awaypoint, F_MatchDate5 = @Matchdate, F_MatchTime5 = @Matchtime, F_SessionType5 = @sessionType, F_Score5 = @matchscore, F_OrderInsession5 = @orderInSession, F_Court5 = @FieldName, F_TeamScore5 = @TeamScore
		IF @ROW = 6 UPDATE #report_table SET F_MatchNum6 = @matchnum, F_Home6 = @homename, F_Away6 = @awayname, F_HomePoint6 = @homepoint, F_AwayPoint6 = @awaypoint, F_MatchDate6 = @Matchdate, F_MatchTime6 = @Matchtime, F_SessionType6 = @sessionType, F_Score6 = @matchscore, F_OrderInsession6 = @orderInSession, F_Court6 = @FieldName, F_TeamScore6 = @TeamScore
		IF @ROW = 7 UPDATE #report_table SET F_MatchNum7 = @matchnum, F_Home7 = @homename, F_Away7 = @awayname, F_HomePoint7 = @homepoint, F_AwayPoint7 = @awaypoint, F_MatchDate7 = @Matchdate, F_MatchTime7 = @Matchtime, F_SessionType7 = @sessionType, F_Score7 = @matchscore, F_OrderInsession7 = @orderInSession, F_Court7 = @FieldName, F_TeamScore7 = @TeamScore
		IF @ROW = 8 UPDATE #report_table SET F_MatchNum8 = @matchnum, F_Home8 = @homename, F_Away8 = @awayname, F_HomePoint8 = @homepoint, F_AwayPoint8 = @awaypoint, F_MatchDate8 = @Matchdate, F_MatchTime8 = @Matchtime, F_SessionType8 = @sessionType, F_Score8 = @matchscore, F_OrderInsession8 = @orderInSession, F_Court8 = @FieldName, F_TeamScore8 = @TeamScore
		IF @ROW = 9 UPDATE #report_table SET F_MatchNum9 = @matchnum, F_Home9 = @homename, F_Away9 = @awayname, F_HomePoint9 = @homepoint, F_AwayPoint9 = @awaypoint, F_MatchDate9 = @Matchdate, F_MatchTime9 = @Matchtime, F_SessionType9 = @sessionType, F_Score9 = @matchscore, F_OrderInsession9 = @orderInSession, F_Court9 = @FieldName, F_TeamScore9 = @TeamScore
		IF @ROW = 10 UPDATE #report_table SET F_MatchNum10 = @matchnum, F_Home10 = @homename, F_Away10 = @awayname, F_HomePoint10 = @homepoint, F_AwayPoint10 = @awaypoint, F_MatchDate10 = @Matchdate, F_MatchTime10 = @Matchtime, F_SessionType10 = @sessionType, F_Score10 = @matchscore, F_OrderInsession10 = @orderInSession, F_Court10 = @FieldName, F_TeamScore10 = @TeamScore
		IF @ROW = 11 UPDATE #report_table SET F_MatchNum11 = @matchnum, F_Home11 = @homename, F_Away11 = @awayname, F_HomePoint11 = @homepoint, F_AwayPoint11 = @awaypoint, F_MatchDate11 = @Matchdate, F_MatchTime11 = @Matchtime, F_SessionType11 = @sessionType, F_Score11 = @matchscore, F_OrderInsession11 = @orderInSession, F_Court11 = @FieldName, F_TeamScore11 = @TeamScore
		IF @ROW = 12 UPDATE #report_table SET F_MatchNum12 = @matchnum, F_Home12 = @homename, F_Away12 = @awayname, F_HomePoint12 = @homepoint, F_AwayPoint12 = @awaypoint, F_MatchDate12 = @Matchdate, F_MatchTime12 = @Matchtime, F_SessionType12 = @sessionType, F_Score12 = @matchscore, F_OrderInsession12 = @orderInSession, F_Court12 = @FieldName, F_TeamScore12 = @TeamScore
		IF @ROW = 13 UPDATE #report_table SET F_MatchNum13 = @matchnum, F_Home13 = @homename, F_Away13 = @awayname, F_HomePoint13 = @homepoint, F_AwayPoint13 = @awaypoint, F_MatchDate13 = @Matchdate, F_MatchTime13 = @Matchtime, F_SessionType13 = @sessionType, F_Score13 = @matchscore, F_OrderInsession13 = @orderInSession, F_Court13 = @FieldName, F_TeamScore13 = @TeamScore
		IF @ROW = 14 UPDATE #report_table SET F_MatchNum14 = @matchnum, F_Home14 = @homename, F_Away14 = @awayname, F_HomePoint14 = @homepoint, F_AwayPoint14 = @awaypoint, F_MatchDate14 = @Matchdate, F_MatchTime14 = @Matchtime, F_SessionType14 = @sessionType, F_Score14 = @matchscore, F_OrderInsession14 = @orderInSession, F_Court14 = @FieldName, F_TeamScore14 = @TeamScore
		IF @ROW = 15 UPDATE #report_table SET F_MatchNum15 = @matchnum, F_Home15 = @homename, F_Away15 = @awayname, F_HomePoint15 = @homepoint, F_AwayPoint15 = @awaypoint, F_MatchDate15 = @Matchdate, F_MatchTime15 = @Matchtime, F_SessionType15 = @sessionType, F_Score15 = @matchscore, F_OrderInsession15 = @orderInSession, F_Court15 = @FieldName, F_TeamScore15 = @TeamScore
		IF @ROW = 16 UPDATE #report_table SET F_MatchNum16 = @matchnum, F_Home16 = @homename, F_Away16 = @awayname, F_HomePoint16 = @homepoint, F_AwayPoint16 = @awaypoint, F_MatchDate16 = @Matchdate, F_MatchTime16 = @Matchtime, F_SessionType16 = @sessionType, F_Score16 = @matchscore, F_OrderInsession16 = @orderInSession, F_Court16 = @FieldName, F_TeamScore16 = @TeamScore
		IF @ROW = 17 UPDATE #report_table SET F_MatchNum17 = @matchnum, F_Home17 = @homename, F_Away17 = @awayname, F_HomePoint17 = @homepoint, F_AwayPoint17 = @awaypoint, F_MatchDate17 = @Matchdate, F_MatchTime17 = @Matchtime, F_SessionType17 = @sessionType, F_Score17 = @matchscore, F_OrderInsession17 = @orderInSession, F_Court17 = @FieldName, F_TeamScore17 = @TeamScore
		IF @ROW = 18 UPDATE #report_table SET F_MatchNum18 = @matchnum, F_Home18 = @homename, F_Away18 = @awayname, F_HomePoint18 = @homepoint, F_AwayPoint18 = @awaypoint, F_MatchDate18 = @Matchdate, F_MatchTime18 = @Matchtime, F_SessionType18 = @sessionType, F_Score18 = @matchscore, F_OrderInsession18 = @orderInSession, F_Court18 = @FieldName, F_TeamScore18 = @TeamScore
		IF @ROW = 19 UPDATE #report_table SET F_MatchNum19 = @matchnum, F_Home19 = @homename, F_Away19 = @awayname, F_HomePoint19 = @homepoint, F_AwayPoint19 = @awaypoint, F_MatchDate19 = @Matchdate, F_MatchTime19 = @Matchtime, F_SessionType19 = @sessionType, F_Score19 = @matchscore, F_OrderInsession19 = @orderInSession, F_Court19 = @FieldName, F_TeamScore19 = @TeamScore
		IF @ROW = 20 UPDATE #report_table SET F_MatchNum20 = @matchnum, F_Home20 = @homename, F_Away20 = @awayname, F_HomePoint20 = @homepoint, F_AwayPoint20 = @awaypoint, F_MatchDate20 = @Matchdate, F_MatchTime20 = @Matchtime, F_SessionType20 = @sessionType, F_Score20 = @matchscore, F_OrderInsession20 = @orderInSession, F_Court20 = @FieldName, F_TeamScore20 = @TeamScore
		IF @ROW = 21 UPDATE #report_table SET F_MatchNum21 = @matchnum, F_Home21 = @homename, F_Away21 = @awayname, F_HomePoint21 = @homepoint, F_AwayPoint21 = @awaypoint, F_MatchDate21 = @Matchdate, F_MatchTime21 = @Matchtime, F_SessionType21 = @sessionType, F_Score21 = @matchscore, F_OrderInsession21 = @orderInSession, F_Court21 = @FieldName, F_TeamScore21 = @TeamScore
		IF @ROW = 22 UPDATE #report_table SET F_MatchNum22 = @matchnum, F_Home22 = @homename, F_Away22 = @awayname, F_HomePoint22 = @homepoint, F_AwayPoint22 = @awaypoint, F_MatchDate22 = @Matchdate, F_MatchTime22 = @Matchtime, F_SessionType22 = @sessionType, F_Score22 = @matchscore, F_OrderInsession22 = @orderInSession, F_Court22 = @FieldName, F_TeamScore22 = @TeamScore
		IF @ROW = 23 UPDATE #report_table SET F_MatchNum23 = @matchnum, F_Home23 = @homename, F_Away23 = @awayname, F_HomePoint23 = @homepoint, F_AwayPoint23 = @awaypoint, F_MatchDate23 = @Matchdate, F_MatchTime23 = @Matchtime, F_SessionType23 = @sessionType, F_Score23 = @matchscore, F_OrderInsession23 = @orderInSession, F_Court23 = @FieldName, F_TeamScore23 = @TeamScore
		IF @ROW = 24 UPDATE #report_table SET F_MatchNum24 = @matchnum, F_Home24 = @homename, F_Away24 = @awayname, F_HomePoint24 = @homepoint, F_AwayPoint24 = @awaypoint, F_MatchDate24 = @Matchdate, F_MatchTime24 = @Matchtime, F_SessionType24 = @sessionType, F_Score24 = @matchscore, F_OrderInsession24 = @orderInSession, F_Court24 = @FieldName, F_TeamScore24 = @TeamScore
		IF @ROW = 25 UPDATE #report_table SET F_MatchNum25 = @matchnum, F_Home25 = @homename, F_Away25 = @awayname, F_HomePoint25 = @homepoint, F_AwayPoint25 = @awaypoint, F_MatchDate25 = @Matchdate, F_MatchTime25 = @Matchtime, F_SessionType25 = @sessionType, F_Score25 = @matchscore, F_OrderInsession25 = @orderInSession, F_Court25 = @FieldName, F_TeamScore25 = @TeamScore
		IF @ROW = 26 UPDATE #report_table SET F_MatchNum26 = @matchnum, F_Home26 = @homename, F_Away26 = @awayname, F_HomePoint26 = @homepoint, F_AwayPoint26 = @awaypoint, F_MatchDate26 = @Matchdate, F_MatchTime26 = @Matchtime, F_SessionType26 = @sessionType, F_Score26 = @matchscore, F_OrderInsession26 = @orderInSession, F_Court26 = @FieldName, F_TeamScore26 = @TeamScore
		IF @ROW = 27 UPDATE #report_table SET F_MatchNum27 = @matchnum, F_Home27 = @homename, F_Away27 = @awayname, F_HomePoint27 = @homepoint, F_AwayPoint27 = @awaypoint, F_MatchDate27 = @Matchdate, F_MatchTime27 = @Matchtime, F_SessionType27 = @sessionType, F_Score27 = @matchscore, F_OrderInsession27 = @orderInSession, F_Court27 = @FieldName, F_TeamScore27 = @TeamScore
		IF @ROW = 28 UPDATE #report_table SET F_MatchNum28 = @matchnum, F_Home28 = @homename, F_Away28 = @awayname, F_HomePoint28 = @homepoint, F_AwayPoint28 = @awaypoint, F_MatchDate28 = @Matchdate, F_MatchTime28 = @Matchtime, F_SessionType28 = @sessionType, F_Score28 = @matchscore, F_OrderInsession28 = @orderInSession, F_Court28 = @FieldName, F_TeamScore28 = @TeamScore
		IF @ROW = 29 UPDATE #report_table SET F_MatchNum29 = @matchnum, F_Home29 = @homename, F_Away29 = @awayname, F_HomePoint29 = @homepoint, F_AwayPoint29 = @awaypoint, F_MatchDate29 = @Matchdate, F_MatchTime29 = @Matchtime, F_SessionType29 = @sessionType, F_Score29 = @matchscore, F_OrderInsession29 = @orderInSession, F_Court29 = @FieldName, F_TeamScore29 = @TeamScore
		IF @ROW = 30 UPDATE #report_table SET F_MatchNum30 = @matchnum, F_Home30 = @homename, F_Away30 = @awayname, F_HomePoint30 = @homepoint, F_AwayPoint30 = @awaypoint, F_MatchDate30 = @Matchdate, F_MatchTime30 = @Matchtime, F_SessionType30 = @sessionType, F_Score30 = @matchscore, F_OrderInsession30 = @orderInSession, F_Court30 = @FieldName, F_TeamScore30 = @TeamScore
		IF @ROW = 31 UPDATE #report_table SET F_MatchNum31 = @matchnum, F_Home31 = @homename, F_Away31 = @awayname, F_HomePoint31 = @homepoint, F_AwayPoint31 = @awaypoint, F_MatchDate31 = @Matchdate, F_MatchTime31 = @Matchtime, F_SessionType31 = @sessionType, F_Score31 = @matchscore, F_OrderInsession31 = @orderInSession, F_Court31 = @FieldName, F_TeamScore31 = @TeamScore
		IF @ROW = 32 UPDATE #report_table SET F_MatchNum32 = @matchnum, F_Home32 = @homename, F_Away32 = @awayname, F_HomePoint32 = @homepoint, F_AwayPoint32 = @awaypoint, F_MatchDate32 = @Matchdate, F_MatchTime32 = @Matchtime, F_SessionType32 = @sessionType, F_Score32 = @matchscore, F_OrderInsession32 = @orderInSession, F_Court32 = @FieldName, F_TeamScore32 = @TeamScore
		FETCH NEXT FROM REPORT_CURSOR INTO @matchnum, @homename, @awayname, @homepoint, @awaypoint, @Matchdate, @Matchtime, @sessionType, @matchscore, @orderInSession, @FieldName, @eventid, @IRMName
		SET @ROW = @ROW+1
	END
	CLOSE REPORT_CURSOR
	DEALLOCATE REPORT_CURSOR

select * from #report_table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF







--970,1181














GO


