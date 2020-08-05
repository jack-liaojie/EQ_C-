IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEliminationFourTimeOrScore]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetEliminationFourTimeOrScore]
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

CREATE PROCEDURE [dbo].[Proc_Report_BK_GetEliminationFourTimeOrScore](
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
                                F_MatchName1			NVARCHAR(100),
                                F_MatchName2			NVARCHAR(100),
                                F_MatchName3			NVARCHAR(100),
                                F_MatchName4			NVARCHAR(100),
								F_Home1					NVARCHAR(100), 
								F_Home2					NVARCHAR(100), 
								F_Home3					NVARCHAR(100), 
								F_Home4					NVARCHAR(100), 
								F_Away1					NVARCHAR(100),
								F_Away2					NVARCHAR(100),
								F_Away3					NVARCHAR(100),
								F_Away4					NVARCHAR(100),
								F_HomePoint1				INT,
								F_HomePoint2				INT,
								F_HomePoint3				INT,
								F_HomePoint4				INT,
								F_AwayPoint1				INT,
								F_AwayPoint2				INT,
								F_AwayPoint3				INT,
								F_AwayPoint4				INT,
								F_MatchDate1			DATETIME,
								F_MatchDate2			DATETIME,
								F_MatchDate3			DATETIME,
								F_MatchDate4			DATETIME,
								F_MatchTime1			DATETIME,
								F_MatchTime2			DATETIME,
								F_MatchTime3			DATETIME,
								F_MatchTime4			DATETIME,
								F_SessionType1			NVARCHAR(20),
								F_SessionType2			NVARCHAR(20),
								F_SessionType3			NVARCHAR(20),
								F_SessionType4			NVARCHAR(20),
								F_Score1					NVARCHAR(100),
								F_Score2					NVARCHAR(100),
								F_Score3					NVARCHAR(100),
								F_Score4					NVARCHAR(100),
								F_TeamScore1				NVARCHAR(100),
								F_TeamScore2				NVARCHAR(100),
								F_TeamScore3				NVARCHAR(100),
								F_TeamScore4				NVARCHAR(100),
								F_OrderInSession1			NVARCHAR(100),
								F_OrderInSession2			NVARCHAR(100),
								F_OrderInSession3			NVARCHAR(100),
								F_OrderInSession4			NVARCHAR(100),
								F_Court1			NVARCHAR(100),
								F_Court2			NVARCHAR(100),
								F_Court3			NVARCHAR(100),
								F_Court4			NVARCHAR(100)
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


