IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCourtMatchList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCourtMatchList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_GetCourtMatchList]
--描    述：得到一个Phase或者Match节点的所有的运动员，此时如果是Phase需要区分Phase是小组赛还是淘汰赛
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年09月24日

CREATE PROCEDURE [dbo].[Proc_GetCourtMatchList](
												@CourtID		INT
)
As
Begin
SET NOCOUNT ON 

	DECLARE @LanguageCode  AS CHAR(3)
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1

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
								F_FederationLongName    NVARCHAR(100),
								F_Seed					INT,
								F_MatchNum				INT,
								F_EventName				NVARCHAR(100),
								F_MatchCode				NVARCHAR(20),
								F_MatchStatusID			INT,
								F_StatusLongName		NVARCHAR(50),
								F_NOC					NVARCHAR(100),
								F_RoundID				INT,
								F_RoundLongName			NVARCHAR(100)
							 )

	IF @CourtID = -1
    BEGIN
		INSERT INTO #table_Competitors (F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_CompetitionPosition, F_RegisterID,
						F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
						F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel,
						F_ResultID, F_Rank, F_Points, F_Service, F_IRMID, F_MatchNum, F_MatchCode, F_MatchStatusID, F_RoundID)
			SELECT E.F_EventID, E.F_PhaseID, A.F_MatchID, A.F_Order, D.F_CompetitionPosition, D.F_RegisterID,
						D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
						D.F_HistoryMatchID, D.F_HistoryMatchRank, D.F_HistoryLevel,
						D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID, A.F_MatchNum, A.F_MatchCode, A.F_MatchStatusID, A.F_RoundID
				FROM TS_Match AS A LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode 
					RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID LEFT JOIN TS_Phase AS E ON A.F_PhaseID = E.F_PhaseID
	END
	BEGIN
		INSERT INTO #table_Competitors (F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_CompetitionPosition, F_RegisterID,
						F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank,
						F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel,
						F_ResultID, F_Rank, F_Points, F_Service, F_IRMID, F_MatchNum, F_MatchCode, F_MatchStatusID, F_RoundID)
			SELECT E.F_EventID, E.F_PhaseID, A.F_MatchID, A.F_Order, D.F_CompetitionPosition, D.F_RegisterID,
						D.F_StartPhaseID, D.F_StartPhasePosition, D.F_SourcePhaseID, D.F_SourcePhaseRank, D.F_SourceMatchID, D.F_SourceMatchRank,
						D.F_HistoryMatchID, D.F_HistoryMatchRank, D.F_HistoryLevel,
						D.F_ResultID, D.F_Rank, D.F_Points, D.F_Service, D.F_IRMID, A.F_MatchNum, A.F_MatchCode, A.F_MatchStatusID, A.F_RoundID
				FROM TS_Match AS A LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode 
					RIGHT JOIN TS_Match_Result AS D ON A.F_MatchID = D.F_MatchID LEFT JOIN TS_Phase AS E ON A.F_PhaseID = E.F_PhaseID
						WHERE A.F_CourtID = @CourtID
	END

		
	UPDATE #table_Competitors SET F_PhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_MatchName = LTRIM(RTRIM(A.F_PhaseName)) + ' ' + LTRIM(RTRIM(B.F_MatchLongName)) FROM #table_Competitors AS A LEFT JOIN TS_Match_Des AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_StartPhaseName = B.F_PhaseLongName FROM #table_Competitors AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
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
	UPDATE #table_Competitors SET F_NOC = C.F_DelegationLongName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID WHERE C.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_FederationLongName = C.F_FederationLongName FROM #table_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Federation_Des AS C ON B.F_FederationID = C.F_FederationID AND C.F_LanguageCode = @LanguageCode

	UPDATE #table_Competitors SET F_Seed = B.F_Seed FROM #table_Competitors AS A LEFT JOIN TR_Inscription AS B ON A.F_RegisterID = B.F_RegisterID WHERE A.F_EventID = B.F_EventID
	UPDATE #table_Competitors SET F_Seed = NULL WHERE F_Seed = 0
	UPDATE #table_Competitors SET F_RegisterName = F_RegisterName + '[' + CAST(F_Seed AS NVARCHAR(100)) + ']' WHERE F_Seed IS NOT NULL

--	SELECT F_MatchNum AS [M.Num], F_MatchName AS [Match Name], F_CompetitionPosition AS [Position], F_RegisterName AS [Competitor Name],F_FederationLongName AS Federation,
--		   F_SourcePhaseName, F_SourcePhaseRank, F_SourceMatchName, F_SourceMatchRank, F_StartPhaseName, F_StartPhasePosition, 
--		   F_HistoryMatchName, F_HistoryMatchRank, F_HistoryLevel,
--		   F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_RegisterID, F_StartPhaseID, F_SourcePhaseID, F_SourceMatchPhaseID,
--		   F_SourceMatchID, F_SourceMatchOrder, F_HistoryMatchID
--		FROM #table_Competitors
	UPDATE #table_Competitors SET F_EventName = F_EventLongName FROM #table_Competitors AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_StatusLongName = B.F_StatusLongName FROM #table_Competitors AS A LEFT JOIN TC_Status_Des AS B ON A.F_MatchStatusID = B.F_StatusID AND B.F_LanguageCode = @LanguageCode
	UPDATE #table_Competitors SET F_RoundLongName = B.F_RoundLongName FROM #table_Competitors AS A LEFT JOIN TS_Round_Des AS B ON A.F_RoundID = B.F_RoundID AND B.F_LanguageCode = @LanguageCode

	SELECT A.F_EventName AS [级别], A.F_PhaseName AS [阶段],  A.F_RoundLongName AS [比赛名称], A.F_MatchCode AS [场次号], A.F_NOC AS [红方], A.F_RegisterName AS [红方姓名], B.F_RegisterName AS [蓝方姓名], B.F_NOC AS [蓝方], A.F_StatusLongName AS [比赛状态], A.F_Points AS [Home Points], B.F_Points AS [Away Points], A.F_MatchNum AS [M.Num], A.F_MatchID 
		FROM #table_Competitors AS A INNER JOIN #table_Competitors AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = 1 AND B.F_CompetitionPosition = 2
			ORDER BY (CASE WHEN A.F_MatchCode IS NULL THEN 1 ELSE 0 END),  A.F_MatchCode

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

