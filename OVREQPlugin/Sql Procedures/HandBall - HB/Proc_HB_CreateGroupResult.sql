

/****** Object:  StoredProcedure [dbo].[Proc_HB_CreateGroupResult]    Script Date: 08/30/2012 08:57:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_CreateGroupResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_CreateGroupResult]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_CreateGroupResult]    Script Date: 08/30/2012 08:57:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_HB_CreateGroupResult]
----��		  �ܣ�����С��Ļ��ֺ�����
----��		  �ߣ������
----��		  ��: 2011-05-27

CREATE PROCEDURE [dbo].[Proc_HB_CreateGroupResult] (	
	@PhaseID			INT
)	
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @EventCode  AS NVARCHAR(10)
	DECLARE @PhaseType	AS INT

	SELECT @PhaseType = A.F_PhaseType, @EventCode = F_EventCode FROM TS_Phase AS A lEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID

	IF (@PhaseType != 2)--��С����������ͳ��С��������
	BEGIN
		RETURN
	END


	DECLARE	@tmpWonMatchPoint	AS INT
	DECLARE	@tmpDrawMatchPoint	AS INT
	DECLARE	@tempLostMatchPoint AS INT

	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID)
	BEGIN
		INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint) VALUES (@PhaseID, 3, 1, 0)
		--RETURN --С�����Ļ��ֹ���δ�����޷�ͳ��С��������
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
								) 
	INSERT INTO #tmp_GroupResult (F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_PhasePoints, F_PhaseRank, F_PhaseDisplayPosition, F_WonMatchNum, F_DrawMatchNum, F_LostMatchNum)
		SELECT F_PhaseID, F_PhaseResultNumber, F_RegisterID, 0 AS F_PhasePoints, 0 AS F_PhaseRank, 0 AS F_PhaseDisplayPosition, 0 AS F_WonMatchNum, 0 AS F_DrawMatchNum, 0 AS F_LostMatchNum
			FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID
	

	UPDATE #tmp_GroupResult SET F_WonMatchNum = DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID), F_DrawMatchNum = DBO.[Fun_GetDrawMatchNum](F_PhaseID, F_RegisterID), F_LostMatchNum = DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID)
	
	UPDATE #tmp_GroupResult SET F_PhasePoints = @tmpWonMatchPoint * F_WonMatchNum + @tmpDrawMatchPoint * F_DrawMatchNum + @tempLostMatchPoint * F_LostMatchNum
	
	UPDATE #tmp_GroupResult SET F_PhaseRank = B.Rank, F_PhaseDisplayPosition = B.DisplayPosition FROM #tmp_GroupResult AS A 
					LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC) AS Rank, ROW_NUMBER() OVER(ORDER BY F_PhasePoints DESC) AS DisplayPosition, * FROM #tmp_GroupResult) AS B
						ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	UPDATE TS_Phase_Result SET F_PhasePoints = A.F_PhasePoints, F_PhaseRank = A.F_PhaseRank, F_PhaseDisplayPosition = A.F_PhaseDisplayPosition 
		FROM #tmp_GroupResult AS A LEFT JOIN TS_Phase_Result AS B 
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber

	RETURN
SET NOCOUNT OFF
END


GO


