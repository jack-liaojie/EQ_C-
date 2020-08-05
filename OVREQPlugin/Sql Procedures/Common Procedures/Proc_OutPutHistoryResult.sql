IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_OutPutHistoryResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_OutPutHistoryResult]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











--名    称：[Proc_OutPutHistoryResult]
--描    述：输出历史战绩
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年05月18日

CREATE PROCEDURE [dbo].[Proc_OutPutHistoryResult](
				 @EventID			INT,
				 @PhaseID			INT,
				 @RegisterID		INT,
                 @LanguageCode		char(3),
				 @Type				INT ---1表示Event，0表示Phase
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #tem_Table(
							F_EventID						INT,
							F_PhaseID						INT,
							F_FatherPhaseID					INT,
							F_FullPhaseName					NVARCHAR(500),
							ItemType						INT,
							ItemLevel						INT,
							F_MatchID						INT,
							F_RegisterID					INT,
							F_CompetitionPosition			INT,
							F_ResultID						INT,
							F_Points						INT,
							F_WinPoints						INT,
							F_LosePoints					INT,
							F_WinSets						INT,
							F_LoseSets						INT,
							F_WinSets_1						INT,
							F_LoseSets_1					INT,
							F_WinSets_2						INT,
							F_LoseSets_2					INT,
							F_OtherRegisterID				INT,
							F_OtherCompetitionPosition		INT,
							F_OtherResultID					INT,
							F_OtherPoints					INT,
							F_OtherWinPoints				INT,
							F_OtherLosePoints				INT,
							F_OtherWinSets					INT,
							F_OtherLoseSets					INT,
							F_OtherWinSets_1				INT,
							F_OtherLoseSets_1				INT,
							F_OtherWinSets_2				INT,
							F_OtherLoseSets_2				INT,
							)
	
	DECLARE @CurLevel	AS INT
	SET @CurLevel = 0

	IF (@Type = -1)  --该运动员在该项目下的所有比赛战绩
	BEGIN
		INSERT INTO #tem_Table (F_EventID, F_PhaseID, F_FatherPhaseID, ItemType, ItemLevel, F_FullPhaseName)
			SELECT A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 AS ItemType, 0 AS ItemLevel, B.F_PhaseLongName AS F_FullPhaseName 
				FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode 
					WHERE A.F_EventID = @EventID AND F_FatherPhaseID = 0
	END
	ELSE 
	BEGIN
		IF (@Type = 0)		--该运动员在该赛事阶段下得所有比赛战绩
		BEGIN
			INSERT INTO #tem_Table (F_EventID, F_PhaseID, F_FatherPhaseID, ItemType, ItemLevel, F_FullPhaseName)
				SELECT A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 AS ItemType, 0 AS ItemLevel, B.F_PhaseLongName AS F_FullPhaseName 
					FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode 
						WHERE A.F_EventID = @EventID AND A.F_PhaseID = @PhaseID
		END
	END

	WHILE EXiSTS (SELECT F_PhaseID FROM #tem_Table WHERE ItemLevel = 0)
	BEGIN
		SET @CurLevel = @CurLevel + 1 
		UPDATE #tem_Table SET ItemLevel = @CurLevel WHERE ItemLevel = 0

		INSERT INTO #tem_Table (F_EventID, F_PhaseID, F_FatherPhaseID, ItemType, ItemLevel, F_FullPhaseName)
			SELECT A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 AS ItemType, 0 AS ItemLevel, B.F_FullPhaseName +'\'+ C.F_PhaseLongName AS F_FullPhaseName
				FROM TS_Phase AS A LEFT JOIN #tem_Table AS B ON A.F_FatherPhaseID = B.F_PhaseID 
					LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode 
						WHERE B.ItemLevel = @CurLevel
	END


	INSERT INTO #tem_Table (F_EventID, F_PhaseID, F_MatchID, F_RegisterID, F_CompetitionPosition, F_ResultID, F_Points, F_WinPoints, F_LosePoints, F_WinSets, F_LoseSets, F_WinSets_1, F_LoseSets_1, F_WinSets_2, F_LoseSets_2, ItemType, F_FullPhaseName)
		SELECT B.F_EventID, A.F_PhaseID, A.F_MatchID, C.F_RegisterID, C.F_CompetitionPosition, C.F_ResultID, C.F_Points, C.F_WinPoints, C.F_LosePoints, C.F_WinSets, C.F_LoseSets, C.F_WinSets_1, C.F_LoseSets_1, C.F_WinSets_2, C.F_LoseSets_2, 1 AS ItemType, B.F_FullPhaseName 
			FROM TS_Match AS A RIGHT JOIN #tem_Table AS B ON A.F_PhaseID = B.F_PhaseID
				LEFT JOIN TS_Match_Result AS C ON A.F_MatchID = C.F_MatchID WHERE C.F_RegisterID = @RegisterID

	UPDATE #tem_Table SET F_OtherRegisterID = B.F_RegisterID, F_OtherCompetitionPosition = (3 - A.F_CompetitionPosition), F_OtherResultID = B.F_ResultID, F_OtherPoints = B.F_Points, F_OtherWinPoints = B.F_WinPoints,
		 F_OtherWinSets = B.F_WinSets, F_OtherLosePoints = B.F_LosePoints, F_OtherLoseSets = B.F_LoseSets, F_OtherWinSets_1 = B.F_WinSets_1, F_OtherLoseSets_1 = B.F_LoseSets_1, F_OtherWinSets_2 = B.F_WinSets_2, F_OtherLoseSets_2 = B.F_LoseSets_2 
			FROM #tem_Table AS A LEFT JOIN TS_Match_Result AS B 
				ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = (3 - A.F_CompetitionPosition)

	SELECT D.F_EventLongName AS [项目],A.F_FullPhaseName AS[轮次],F.F_MatchNum AS [M.N], B.F_LongName AS [主队], C.F_LongName AS [客队], [dbo].[Fun_GetMatchResultByRegisterID](A.F_MatchID, A.F_RegisterID) AS [详细比分], 
		G.F_ResultLongName AS [主],H.F_ResultLongName AS [客],
		F_WinPoints, F_LosePoints, F_WinSets, F_LoseSets, F_WinSets_1, F_LoseSets_1, F_WinSets_2, F_LoseSets_2, 
		F_Points, F_OtherPoints, F_OtherWinPoints, F_OtherLosePoints, F_OtherWinSets, F_OtherLoseSets, F_OtherWinSets_1, F_OtherLoseSets_1, F_OtherWinSets_2, F_OtherLoseSets_2
		FROM #tem_Table AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register_Des AS C ON A.F_OtherRegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TS_Event_Des AS D ON A.F_EventID = D.F_EventID AND D.F_LanguageCode = @LanguageCode 
			LEFT JOIN TS_Match AS F ON A.F_MatchID = F.F_MatchID
			LEFT JOIN TC_Result_Des AS G ON A.F_ResultID = G.F_ResultID AND G.F_LanguageCode = @LanguageCode LEFT JOIN TC_Result_Des AS H ON A.F_OtherResultID = H.F_ResultID AND H.F_LanguageCode = @LanguageCode
				WHERE A.ItemType = 1 
	RETURN

Set NOCOUNT OFF
End	
GO
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--EXEC [Proc_OutPutHistoryResult] 13,2,2,'CHN',0
--EXEC [Proc_OutPutHistoryResult] 13,2,2,'CHN',-1

--EXEC [Proc_OutPutHistoryResult] 13,2,11,'CHN',0
--EXEC [Proc_OutPutHistoryResult] 13,2,11,'CHN',-1