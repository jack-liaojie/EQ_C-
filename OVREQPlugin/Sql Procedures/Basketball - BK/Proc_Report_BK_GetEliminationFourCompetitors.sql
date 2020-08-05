IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetEliminationFourCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].Proc_Report_BK_GetEliminationFourCompetitors

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_BK_GetEliminationFourCompetitors]
--描    述：得到淘汰赛对阵表
--参数说明： 
--说    明：
--创 建 人：穆学峰
--日    期：2009年04月21日
-- Proc_Report_BK_GetEliminationFourCompetitors 325,'58to56','chn'
CREATE PROCEDURE [dbo].Proc_Report_BK_GetEliminationFourCompetitors(
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
								F_DelegationID			INT,
								F_DelegationName		NVARCHAR(100),
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
	UPDATE #table_Competitors SET F_DelegationName = C.F_DelegationShortName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID 
			LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode

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
								Team1	 NVARCHAR(50),
								Team2	 NVARCHAR(50),
								Team3	 NVARCHAR(50),
								Team4	 NVARCHAR(50)
							 )

	DECLARE @PHASE AS NVARCHAR(100)
	DECLARE @PLAYER AS NVARCHAR(100)
	DECLARE @TEAM AS NVARCHAR(100)
	DECLARE @ROW AS INT
	SET @ROW = 1
	DECLARE Competitor_CURSOR CURSOR FOR SELECT F_PhaseName, F_RegisterName FROM #table_Competitors  WHERE F_PHASEName = @PhaseName
	OPEN Competitor_CURSOR
	FETCH NEXT FROM Competitor_CURSOR INTO @PHASE, @TEAM
	--ONLY ONE ROW EACH PHASE
	INSERT  INTO #table_report_Competitors(phase) VALUES (@PHASE)

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @ROW = 1 UPDATE #table_report_Competitors SET Team1 = @TEAM
		IF @ROW = 2 UPDATE #table_report_Competitors SET Team2 = @TEAM
		IF @ROW = 3 UPDATE #table_report_Competitors SET Team3 = @TEAM
		IF @ROW = 4 UPDATE #table_report_Competitors SET Team4 = @TEAM
		SET @ROW = @ROW + 1
		FETCH NEXT FROM Competitor_CURSOR INTO @PHASE, @TEAM
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


