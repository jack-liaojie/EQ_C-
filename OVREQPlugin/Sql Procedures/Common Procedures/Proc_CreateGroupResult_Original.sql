if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_CreateGroupResult_Original]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_CreateGroupResult_Original]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_CreateGroupResult_Original]
----功		  能：计算小组的积分和排名
----作		  者：郑金勇 
----日		  期: 2009-04-22

CREATE PROCEDURE [dbo].[Proc_CreateGroupResult_Original] (	
	@PhaseID			INT
)	
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @EventCode  AS NVARCHAR(10)
	DECLARE @PhaseType	AS INT

	SELECT @PhaseType = A.F_PhaseType, @EventCode = F_EventCode FROM TS_Phase AS A lEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID

	IF (@PhaseType != 2)--非小组赛，不能统计小组赛积分
	BEGIN
		RETURN
	END


	DECLARE	@tmpWonMatchPoint	AS INT
	DECLARE	@tmpDrawMatchPoint	AS INT
	DECLARE	@tempLostMatchPoint AS INT

	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID)
	BEGIN
		INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint) VALUES (@PhaseID, 2, 1, 0)
		--RETURN --小组赛的积分规则未定，无法统计小组赛积分
	END

	SELECT @tmpWonMatchPoint = F_WonMatchPoint, @tmpDrawMatchPoint = F_DrawMatchPoint, @tempLostMatchPoint = F_LostMatchPoint
		FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID

	DELETE FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_PhaseResultNumber NOT IN (SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID)

	INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber)
		SELECT F_PhaseID, F_PhasePosition AS F_PhaseResultNumber FROM TS_Phase_Position 
			WHERE F_PhaseID = @PhaseID AND F_PhasePosition NOT IN (SELECT F_PhaseResultNumber FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID)

	UPDATE TS_Phase_Result SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Result AS A LEFT
		JOIN TS_Phase_Position AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhasePosition WHERE B.F_RegisterID IS NOT NULL

	CREATE TABLE #tmp_GroupResult(
									[F_PhaseID]					[int],
									[F_PhaseResultNumber]		[int],
									[F_RegisterID]				[int],
									[F_PhasePoints]				[int],
									[F_PhaseRank]				[int],
									[F_PhaseDisplayPosition]	[int],
									[F_WonMatchNum]				[int],
									[F_DrawMatchNum]			[int],
									[F_LostMatchNum]			[int],
									[F_Z_Des]					[NVARCHAR] (50),
									[F_C_Des]					[NVARCHAR] (50),
									[F_Z_1]						[INT],
									[F_Z_2]						[DECIMAL] (10,5),
									[F_C_1]						[INT],
									[F_C_2]						[DECIMAL] (10,5),
								) 
	INSERT INTO #tmp_GroupResult (F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_PhasePoints, F_PhaseRank, F_PhaseDisplayPosition, F_WonMatchNum, F_DrawMatchNum, F_LostMatchNum)
		SELECT F_PhaseID, F_PhaseResultNumber, F_RegisterID, 0 AS F_PhasePoints, 0 AS F_PhaseRank, 0 AS F_PhaseDisplayPosition, 0 AS F_WonMatchNum, 0 AS F_DrawMatchNum, 0 AS F_LostMatchNum
			FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID
	

	UPDATE #tmp_GroupResult SET F_WonMatchNum = DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID), F_DrawMatchNum = DBO.[Fun_GetDrawMatchNum](F_PhaseID, F_RegisterID), F_LostMatchNum = DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID)
	
	UPDATE #tmp_GroupResult SET F_PhasePoints = @tmpWonMatchPoint * F_WonMatchNum + @tmpDrawMatchPoint * F_DrawMatchNum + @tempLostMatchPoint * F_LostMatchNum
	
	DECLARE @OperateMark AS INT
	SET @OperateMark = 0
	IF @EventCode = 'TS006' OR @EventCode = 'TS105'--网球团体赛
	BEGIN
			UPDATE #tmp_GroupResult SET F_PhaseRank = B.[Rank], F_PhaseDisplayPosition = B.DisplayPosition FROM #tmp_GroupResult AS A 
				LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC, DBO.[Fun_TS_GetWinMatchNum](F_PhaseID, F_RegisterID) DESC, DBO.[Fun_TS_GetWinSetPercentage](F_PhaseID, F_RegisterID)DESC, DBO.[Fun_TS_GetWinGamePercentage](F_PhaseID, F_RegisterID)DESC, DBO.[Fun_TS_GetWinPointsPercentage](F_PhaseID, F_RegisterID) DESC) AS [Rank], 
							ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC, DBO.[Fun_TS_GetWinMatchNum](F_PhaseID, F_RegisterID) DESC, DBO.[Fun_TS_GetWinSetPercentage](F_PhaseID, F_RegisterID)DESC, DBO.[Fun_TS_GetWinGamePercentage](F_PhaseID, F_RegisterID)DESC, DBO.[Fun_TS_GetWinPointsPercentage](F_PhaseID, F_RegisterID) DESC) AS DisplayPosition, 
								* FROM #tmp_GroupResult) AS B
									ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
			SET @OperateMark = 1
	END

	IF @EventCode = 'VB002' OR @EventCode = 'VB101'	--排球
	BEGIN

			UPDATE #tmp_GroupResult SET [F_Z_Des] = DBO.[Fun_VO_ComputeZ](F_PhaseID, F_RegisterID), [F_C_Des] = DBO.[Fun_VO_ComputeC](F_PhaseID, F_RegisterID)
			UPDATE #tmp_GroupResult SET [F_Z_1] = 0, [F_C_1] = 0
			UPDATE #tmp_GroupResult SET [F_Z_1] = 1 WHERE [F_Z_Des] = 'MAX'
			UPDATE #tmp_GroupResult SET [F_C_1] = 1 WHERE [F_C_Des] = 'MAX'
			UPDATE #tmp_GroupResult SET [F_Z_2] = CAST(F_Z_Des AS DECIMAL(10, 5)) WHERE [F_Z_Des] != 'MAX'
			UPDATE #tmp_GroupResult SET [F_C_2] = CAST(F_C_Des AS DECIMAL(10, 5)) WHERE [F_Z_Des] != 'MAX'

			UPDATE #tmp_GroupResult SET F_PhaseRank = B.[Rank], F_PhaseDisplayPosition = B.DisplayPosition FROM #tmp_GroupResult AS A 
				LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC, [F_Z_1] DESC, [F_Z_2] DESC, [F_C_1] DESC, [F_C_2] DESC) AS [Rank], 
							ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC, [F_Z_1] DESC, [F_Z_2] DESC, [F_C_1] DESC, [F_C_2] DESC) AS DisplayPosition, 
								* FROM #tmp_GroupResult) AS B
									ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
			SET @OperateMark = 1
	END


	IF @EventCode = 'BV001' OR @EventCode = 'BV101'	--沙滩排球
	BEGIN

			UPDATE #tmp_GroupResult SET [F_Z_Des] = DBO.[Fun_VO_ComputeZ](F_PhaseID, F_RegisterID), [F_C_Des] = DBO.[Fun_VO_ComputeC](F_PhaseID, F_RegisterID)
			UPDATE #tmp_GroupResult SET [F_Z_1] = 0, [F_C_1] = 0
			UPDATE #tmp_GroupResult SET [F_Z_1] = 1 WHERE [F_Z_Des] = 'MAX'
			UPDATE #tmp_GroupResult SET [F_C_1] = 1 WHERE [F_C_Des] = 'MAX'
			UPDATE #tmp_GroupResult SET [F_Z_2] = CAST(F_Z_Des AS DECIMAL(10, 5)) WHERE [F_Z_Des] != 'MAX'
			UPDATE #tmp_GroupResult SET [F_C_2] = CAST(F_C_Des AS DECIMAL(10, 5)) WHERE [F_Z_Des] != 'MAX'

			UPDATE #tmp_GroupResult SET F_PhaseRank = B.[Rank], F_PhaseDisplayPosition = B.DisplayPosition FROM #tmp_GroupResult AS A 
				LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC, [F_Z_1] DESC, [F_Z_2] DESC, [F_C_1] DESC, [F_C_2] DESC) AS [Rank], 
							ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC, [F_Z_1] DESC, [F_Z_2] DESC, [F_C_1] DESC, [F_C_2] DESC) AS DisplayPosition, 
								* FROM #tmp_GroupResult) AS B
									ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
			SET @OperateMark = 1
	END


	IF @EventCode = 'HO002' OR @EventCode = 'HO101'	--曲棍球
	BEGIN

			UPDATE #tmp_GroupResult SET F_PhaseRank = B.[Rank], F_PhaseDisplayPosition = B.DisplayPosition FROM #tmp_GroupResult AS A 
				LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC, DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) DESC, (DBO.[Fun_HO_GetWinGoalNum](F_PhaseID, F_RegisterID) - DBO.[Fun_HO_GetLoseGoalNum](F_PhaseID, F_RegisterID) ) DESC, DBO.[Fun_HO_GetWinGoalNum](F_PhaseID, F_RegisterID) DESC) AS [Rank], 
							ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC, DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID) DESC, (DBO.[Fun_HO_GetWinGoalNum](F_PhaseID, F_RegisterID) - DBO.[Fun_HO_GetLoseGoalNum](F_PhaseID, F_RegisterID) ) DESC, DBO.[Fun_HO_GetWinGoalNum](F_PhaseID, F_RegisterID) DESC) AS DisplayPosition, 
								* FROM #tmp_GroupResult) AS B
									ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
			SET @OperateMark = 1
	END

	IF @OperateMark = 0 
	BEGIN
		UPDATE #tmp_GroupResult SET F_PhaseRank = B.Rank, F_PhaseDisplayPosition = B.DisplayPosition FROM #tmp_GroupResult AS A 
					LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC) AS Rank, ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC) AS DisplayPosition, * FROM #tmp_GroupResult) AS B
						ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	END
	
	UPDATE TS_Phase_Result SET F_PhasePoints = A.F_PhasePoints, F_PhaseRank = A.F_PhaseRank, F_PhaseDisplayPosition = A.F_PhaseDisplayPosition 
		FROM #tmp_GroupResult AS A LEFT JOIN TS_Phase_Result AS B 
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber

	RETURN
SET NOCOUNT OFF
END



GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--exec [Proc_CreateGroupResult] 2