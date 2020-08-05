IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetPhaseResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetPhaseResults]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











--名    称：[Proc_GetPhaseResults]
--描    述：得到一个Event或者Phase或者Match节点的成绩表述
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月22日

CREATE PROCEDURE [dbo].[Proc_GetPhaseResults](
				 @EventID			INT,
				 @PhaseID			INT,
                 @MatchID           INT,
				 @Type				INT,--注释:  -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase, 1表示Match
                 @LanguageCode  char(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #table_Event_Result(
									[Event Name] [NVARCHAR] (100),
									[Event Rank] [int],
									[Competitor Name] [NVARCHAR] (100),
									[Delegation] [NVARCHAR] (100),
									[Medal] [NVARCHAR] (100),
									[Medal Date] [NVARCHAR] (100),
									[Result Date] [NVARCHAR] (100),
									[Event Display Position] [int],
									[Event Points] [int],
									[F_SourcePhaseName] [NVARCHAR] (100),
									[F_SourcePhaseRank] [int],
									[F_SourceMatchName] [NVARCHAR] (100),
									[F_SourceMatchRank] [int],
									[F_SourcePhaseID] [int],
									[F_SourceMatchID] [int],
									[F_EventResultNumber] [int],
									[F_EventID] [int],
									[F_RegisterID] [int]
								)

	CREATE TABLE #table_Phase_Result(
									[F_PhaseName] [NVARCHAR] (100),
									[F_PhaseID] [int],
									[F_PhaseResultNumber] [int],
									[F_PhaseRank] [int],
									[F_RegisterID] [int],
									[F_PhasePosition] [int],
									[F_RegisterName] [NVARCHAR] (100),
									[F_DelegationLongName] [NVARCHAR] (100),
									[F_PhasePoints] [int],
									[F_PhaseDisplayPosition] [int],
									[F_SourcePhaseID] [int],
									[F_SourcePhaseName] [NVARCHAR] (100),
									[F_SourcePhaseRank] [int],
									[F_SourceMatchID] [int],
									[F_SourceMatchName] [NVARCHAR] (100),
									[F_SourceMatchRank] [int],
									[F_IRMID] [int],
									[F_IRMCODE] [NVARCHAR] (20)
								)
 
	IF @Type = -1
	BEGIN
		INSERT INTO #table_Event_Result([Event Name], [Event Rank], [Competitor Name], [Delegation],
				[Medal], [Medal Date], [Result Date], [Event Display Position], [Event Points],
				[F_SourcePhaseName], [F_SourcePhaseRank], [F_SourceMatchName], [F_SourceMatchRank], [F_SourcePhaseID], [F_SourceMatchID], 
				F_EventResultNumber, F_EventID, F_RegisterID)
			SELECT  E.F_EventLongName AS [Event Name], A.F_EventRank AS [Event Rank], C.F_LongName AS [Competitor Name], D.F_DelegationLongName AS [Federation],
				F.F_MedalLongName AS [Medal]
				, CAST(DATEPART(YEAR, A.F_MedalCreateDate) AS NVARCHAR(50)) +'-'+ CAST(DATEPART(MONTH, A.F_MedalCreateDate) AS NVARCHAR(50)) + '-' + CAST(DATEPART(DAY, A.F_MedalCreateDate) AS NVARCHAR(50)) + ' ' + CAST(DATEPART(HOUR, A.F_MedalCreateDate) AS NVARCHAR(50)) +':'+ CAST(DATEPART(MINUTE, A.F_MedalCreateDate) AS NVARCHAR(50)) AS [Medal Date]
				, CAST(DATEPART(YEAR, A.F_ResultCreateDate) AS NVARCHAR(50)) +'-'+ CAST(DATEPART(MONTH, A.F_ResultCreateDate) AS NVARCHAR(50)) + '-' + CAST(DATEPART(DAY, A.F_ResultCreateDate) AS NVARCHAR(50)) + ' ' + CAST(DATEPART(HOUR, A.F_ResultCreateDate) AS NVARCHAR(50)) +':'+ CAST(DATEPART(MINUTE, A.F_ResultCreateDate) AS NVARCHAR(50)) AS [Result Date]
				, A.F_EventDisplayPosition AS [Event Display Position], A.F_EventPoints AS [Event Points],
				G.[F_PhaseLongName] AS [F_SourcePhaseName], A.[F_SourcePhaseRank], H.F_MatchLongName AS [F_SourceMatchName], A.[F_SourceMatchRank], A.[F_SourcePhaseID], A.[F_SourceMatchID], 
				A.F_EventResultNumber, A.F_EventID, A.F_RegisterID
					FROM TS_Event_Result AS A LEFT JOIN  TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
					LEFT JOIN TR_Register_Des AS C ON A.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode 
					LEFT JOIN TC_Delegation_Des AS D ON B.F_DelegationID = D.F_DelegationID AND D.F_LanguageCode = @LanguageCode 
					LEFT JOIN TS_Event_Des AS E ON A.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_Medal_Des AS F ON A.F_MedalID = F.F_MedalID AND F.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Phase_Des AS G	ON A.F_SourcePhaseID = G.F_PhaseID AND G.F_LanguageCode = @LanguageCode 
					LEFT JOIN TS_Match_Des AS H	ON A.F_SourceMatchID = H.F_MatchID AND H.F_LanguageCode = @LanguageCode
						WHERE A.F_EventID = @EventID

			UPDATE #table_Event_Result SET [Competitor Name] = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE [Competitor Name] IS NULL
			UPDATE #table_Event_Result SET [Competitor Name] = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE [Competitor Name] IS NULL

			SELECT * FROM #table_Event_Result ORDER BY 
				CASE WHEN [Event Rank] IS NULL THEN 1 ELSE 0 END, [Event Rank], CASE WHEN [Event Display Position] IS NULL THEN 1 ELSE 0 END, 
				 [Event Display Position]

		RETURN
	END

	
	IF @Type = 0
	BEGIN
		
		DECLARE @EventCode  AS NVARCHAR(10)
		DECLARE @PhaseType	AS INT

		SELECT @PhaseType = A.F_PhaseType, @EventCode = F_EventCode FROM TS_Phase AS A lEFT JOIN TS_Event AS B 
			ON A.F_EventID = B.F_EventID 
				WHERE A.F_PhaseID = @PhaseID


		IF @PhaseType =2 --小组循环赛
		BEGIN

			INSERT INTO #table_Phase_Result ([F_PhaseName], F_PhaseID, F_PhaseResultNumber, [F_PhasePosition], [F_RegisterID],
					[F_PhasePoints], [F_PhaseRank], [F_PhaseDisplayPosition], [F_SourcePhaseID], [F_SourcePhaseName], [F_SourcePhaseRank],
					[F_SourceMatchID], [F_SourceMatchName], [F_SourceMatchRank], [F_IRMID], [F_IRMCODE])

					SELECT B.F_PhaseLongName AS [F_PhaseName], A.F_PhaseID, A.F_PhaseResultNumber, A.F_PhaseResultNumber AS F_PhasePosition, A.[F_RegisterID],
							 A.[F_PhasePoints],A.[F_PhaseRank],A.[F_PhaseDisplayPosition],A.[F_SourcePhaseID],C.F_PhaseLongName AS [F_SourcePhaseName],
								A.[F_SourcePhaseRank], A.[F_SourceMatchID], D.F_MatchLongName AS F_SourceMatchName, A.[F_SourceMatchRank], A.[F_IRMID], E.[F_IRMCODE] 
						FROM TS_Phase_Result AS A LEFT JOIN TS_Phase_Des AS B 
						ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Phase_Des AS C 
							ON A.F_SourcePhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TS_Match_Des AS D
								ON A.F_SourceMatchID=D.F_MatchID AND D.F_LanguageCode = @LanguageCode LEFT JOIN TC_IRM AS E
									ON A.F_IRMID = E.F_IRMID WHERE A.F_PhaseID = @PhaseID 

							
			UPDATE #table_Phase_Result SET F_RegisterName = B.F_LongName FROM #table_Phase_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
			UPDATE #table_Phase_Result SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
			UPDATE #table_Phase_Result SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
			UPDATE #table_Phase_Result SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL

			UPDATE #table_Phase_Result SET F_DelegationLongName = C.F_DelegationLongName FROM #table_Phase_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode

			IF @EventCode = 'TS006' OR @EventCode = 'TS105'--网球团体赛
			BEGIN
					SELECT F_PhaseName AS [Group Name], F_PhasePosition AS Position, F_RegisterName AS [Competitor_Name], F_DelegationLongName AS [Delegation],
							[F_PhasePoints] AS [Group Points], [F_PhaseRank] AS [Group Rank], [F_PhaseDisplayPosition] AS [Display Position],
							DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) AS [F_WinMatchNum], DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID) AS [F_LoseMatchNum],
							DBO.[Fun_TS_GetWinMatchNum](F_PhaseID, F_RegisterID) AS [获胜场数], CAST(DBO.[Fun_TS_GetWinSetPercentage](F_PhaseID, F_RegisterID) AS NVARCHAR(50)) AS [获胜盘数百分比],
							CAST(DBO.[Fun_TS_GetWinGamePercentage](F_PhaseID, F_RegisterID) AS NVARCHAR(50)) AS [获胜局数百分比], CAST(DBO.[Fun_TS_GetWinPointsPercentage](F_PhaseID, F_RegisterID) AS NVARCHAR(50)) AS [获胜分数百分比],
							[F_RegisterID], [F_PhaseID], [F_SourcePhaseID] 
								FROM #table_Phase_Result --ORDER BY CASE WHEN [F_PhaseRank] IS NULL THEN 1 ELSE 0 END, CASE WHEN [F_PhaseDisplayPosition] IS NULL THEN 1 ELSE 0 END, [F_PhaseRank], [F_PhaseDisplayPosition]

					RETURN
			END

			IF @EventCode = 'VB002' OR @EventCode = 'VB101'	--排球
			BEGIN
					SELECT F_PhaseName AS [Group Name], F_PhasePosition AS Position, F_RegisterName AS [Competitor_Name], F_DelegationLongName AS [Delegation],
						 [F_PhasePoints] AS [Group Points], [F_PhaseRank] AS [Group Rank], [F_PhaseDisplayPosition] AS [Display Position],
						 DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) AS [F_WinMatchNum], DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID) AS [F_LoseMatchNum],
						 DBO.[Fun_VO_ComputeZ](F_PhaseID, F_RegisterID) AS [Z值], DBO.[Fun_VO_ComputeC](F_PhaseID, F_RegisterID) AS [C值],	 
						 [F_RegisterID], [F_PhaseID], [F_SourcePhaseID] 
								FROM #table_Phase_Result --ORDER BY CASE WHEN [F_PhaseRank] IS NULL THEN 1 ELSE 0 END, CASE WHEN [F_PhaseDisplayPosition] IS NULL THEN 1 ELSE 0 END, [F_PhaseRank], [F_PhaseDisplayPosition]

					RETURN
			END

			IF @EventCode = 'BV001' OR @EventCode = 'BV101'	--沙滩排球
			BEGIN
					SELECT F_PhaseName AS [Group Name], F_PhasePosition AS Position, F_RegisterName AS [Competitor_Name], F_DelegationLongName AS [Delegation],
						 [F_PhasePoints] AS [Group Points], [F_PhaseRank] AS [Group Rank], [F_PhaseDisplayPosition] AS [Display Position],
						 DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) AS [F_WinMatchNum], DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID) AS [F_LoseMatchNum],
						 DBO.[Fun_VO_ComputeZ](F_PhaseID, F_RegisterID) AS [Z值], DBO.[Fun_VO_ComputeC](F_PhaseID, F_RegisterID) AS [C值],	 
						 [F_RegisterID], [F_PhaseID], [F_SourcePhaseID] 
								FROM #table_Phase_Result --ORDER BY CASE WHEN [F_PhaseRank] IS NULL THEN 1 ELSE 0 END, CASE WHEN [F_PhaseDisplayPosition] IS NULL THEN 1 ELSE 0 END, [F_PhaseRank], [F_PhaseDisplayPosition]

					RETURN
			END

			IF @EventCode = 'HO002' OR @EventCode = 'HO101'	--曲棍球
			BEGIN
					SELECT F_PhaseName AS [Group Name], F_PhasePosition AS Position, F_RegisterName AS [Competitor_Name], F_DelegationLongName AS [Delegation],
						[F_PhasePoints] AS [Group Points], [F_PhaseRank] AS [Group Rank], [F_PhaseDisplayPosition] AS [Display Position],
						DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) AS [F_WinMatchNum], DBO.[Fun_GetDrawMatchNum](F_PhaseID, F_RegisterID) AS [F_DrawMatchNum], DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID) AS [F_LoseMatchNum],
						DBO.[Fun_HO_GetWinGoalNum](F_PhaseID, F_RegisterID) AS [F_WinGoalNum], DBO.[Fun_HO_GetLoseGoalNum](F_PhaseID, F_RegisterID) AS [F_LoseGoalNum], 
						( DBO.[Fun_HO_GetWinGoalNum](F_PhaseID, F_RegisterID) - DBO.[Fun_HO_GetLoseGoalNum](F_PhaseID, F_RegisterID) ) AS [F_AbsoluteGoalNum],
						[F_RegisterID], [F_PhaseID], [F_SourcePhaseID] 
							FROM #table_Phase_Result --ORDER BY CASE WHEN [F_PhaseRank] IS NULL THEN 1 ELSE 0 END, CASE WHEN [F_PhaseDisplayPosition] IS NULL THEN 1 ELSE 0 END, [F_PhaseRank], [F_PhaseDisplayPosition]

					RETURN
			END

			--没有特定的指定小组赛积分规则，因此不必要特殊整理
			SELECT F_PhaseName AS [Group Name], F_PhasePosition AS Position, F_RegisterName AS [Competitor_Name], F_DelegationLongName AS [Delegation],
				[F_PhasePoints] AS [Group Points], [F_PhaseRank] AS [Group Rank], [F_PhaseDisplayPosition] AS [Display Position], F_IRMCODE AS [IRM],
				DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) AS [F_WinMatchNum], DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID) AS [F_LoseMatchNum],
				[F_RegisterID], [F_PhaseID], [F_SourcePhaseID], F_PhaseResultNumber 
					FROM #table_Phase_Result --ORDER BY CASE WHEN [F_PhaseRank] IS NULL THEN 1 ELSE 0 END, CASE WHEN [F_PhaseDisplayPosition] IS NULL THEN 1 ELSE 0 END, [F_PhaseRank], [F_PhaseDisplayPosition]

			RETURN
		END
		ELSE--除小组赛之外还是要展现各个Phase的成绩
		BEGIN
			INSERT INTO #table_Phase_Result ([F_PhaseName], F_PhaseID, F_PhaseResultNumber, [F_PhasePosition], [F_RegisterID],
					[F_PhasePoints], [F_PhaseRank], [F_PhaseDisplayPosition], [F_SourcePhaseID], [F_SourcePhaseName], [F_SourcePhaseRank],
					[F_SourceMatchID], [F_SourceMatchName], [F_SourceMatchRank], [F_IRMID], [F_IRMCODE])

					SELECT B.F_PhaseLongName AS [F_PhaseName], A.F_PhaseID, A.F_PhaseResultNumber, E.F_PhasePosition AS F_PhasePosition, A.[F_RegisterID],
							 A.[F_PhasePoints],A.[F_PhaseRank],A.[F_PhaseDisplayPosition],A.[F_SourcePhaseID],C.F_PhaseLongName AS [F_SourcePhaseName],
								A.[F_SourcePhaseRank], A.[F_SourceMatchID], D.F_MatchLongName AS F_SourceMatchName, A.[F_SourceMatchRank], A.[F_IRMID], F.[F_IRMCODE]
					 FROM TS_Phase_Result AS A LEFT JOIN TS_Phase_Des AS B 
						ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Phase_Des AS C 
							ON A.F_SourcePhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode LEFT JOIN TS_Match_Des AS D
								ON A.F_SourceMatchID=D.F_MatchID AND D.F_LanguageCode = @LanguageCode LEFT JOIN TS_Phase_Position AS E
									ON A.F_PhaseID = E.F_PhaseID AND A.F_RegisterID = E.F_RegisterID LEFT JOIN TC_IRM AS F ON A.F_IRMID = F.F_IRMID WHERE A.F_PhaseID = @PhaseID 

				
			UPDATE #table_Phase_Result SET F_RegisterName = B.F_LongName FROM #table_Phase_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode
			UPDATE #table_Phase_Result SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
			UPDATE #table_Phase_Result SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL
			UPDATE #table_Phase_Result SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL

			UPDATE #table_Phase_Result SET F_DelegationLongName = C.F_DelegationLongName FROM #table_Phase_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
				LEFT JOIN TC_Delegation_Des AS C ON B.F_DelegationID = C.F_DelegationID AND C.F_LanguageCode = @LanguageCode

			SELECT F_PhaseName AS [Phase Name], [F_PhaseRank] AS [Phase Rank], F_RegisterName AS [Competitor Name], F_DelegationLongName AS [Delegation], F_PhasePosition AS [Draw Number],
				[F_PhasePoints] AS [Group Points], [F_PhaseDisplayPosition] AS [Display Position], F_IRMCODE AS [IRM],
				F_SourcePhaseName, [F_SourcePhaseRank], [F_SourceMatchName], [F_SourceMatchRank], [F_PhaseResultNumber], [F_SourcePhaseID], [F_SourceMatchID]
				[F_RegisterID], [F_PhaseID]
					FROM #table_Phase_Result --ORDER BY CASE WHEN [F_PhaseRank] IS NULL THEN 1 ELSE 0 END, CASE WHEN [F_PhaseDisplayPosition] IS NULL THEN 1 ELSE 0 END, [F_PhaseRank], [F_PhaseDisplayPosition]
			RETURN
		END

	END

	SELECT top 0 * FROM TS_Phase_Result
	RETURN

Set NOCOUNT OFF
End	
GO
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--exec Proc_GetPhaseResults 135,8,0,0, 'ENG'