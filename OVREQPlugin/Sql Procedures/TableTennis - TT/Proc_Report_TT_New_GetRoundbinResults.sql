IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_New_GetRoundbinResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_New_GetRoundbinResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_TT_New_GetRoundbinResults]
----功		  能：获取循环赛小组成绩
----作		  者：王强
----日		  期: 2011-07-27

CREATE PROCEDURE [dbo].[Proc_Report_TT_New_GetRoundbinResults]
				@EventID INT,
				@LanguageCode NVARCHAR(10),
				@ScheduleOnly INT
AS
BEGIN
	SET LANGUAGE us_english
	CREATE TABLE #TMP_TABLE1
	(
		PhaseID INT,
		[Pos] INT,
		RegisterID INT,
		RegisterName NVARCHAR(200),
		NOC NVARCHAR(30),
		PhaseName NVARCHAR(100),
		[Rank] INT,
		TeamSize INT,
		EventType INT,
		WinSets INT,
		RegColName1 NVARCHAR(100),
		RegColName2 NVARCHAR(100),
		RegColName3 NVARCHAR(100),
		RegColName4 NVARCHAR(100),
		RegColName5 NVARCHAR(100),
		RegColName6 NVARCHAR(100),
		NOC1 NVARCHAR(30),
		NOC2 NVARCHAR(30),
		NOC3 NVARCHAR(30),
		NOC4 NVARCHAR(30),
		NOC5 NVARCHAR(30),
		NOC6 NVARCHAR(30),
		ScoreDes11 NVARCHAR(100),
		ScoreDes12 NVARCHAR(100),
		ScoreDes21 NVARCHAR(100),
		ScoreDes22 NVARCHAR(100),
		ScoreDes31 NVARCHAR(100),
		ScoreDes32 NVARCHAR(100),
		ScoreDes41 NVARCHAR(100),
		ScoreDes42 NVARCHAR(100),
		ScoreDes51 NVARCHAR(100),
		ScoreDes52 NVARCHAR(100),
		ScoreDes61 NVARCHAR(100),
		ScoreDes62 NVARCHAR(100)
	)

	DECLARE @PhaseID INT
	DECLARE @PhasePos INT
	DECLARE @RegisterID INT
	DECLARE @TempMatchID INT
	DECLARE @TempPos INT
	DECLARE @TempRegID INT
	DECLARE phaseCursor CURSOR FOR SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseIsPool = 1 AND F_PhaseHasPools != 1 ORDER BY F_Order
	OPEN phaseCursor
	FETCH NEXT FROM phaseCursor INTO @PhaseID
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		DECLARE RegCursor CURSOR FOR SELECT F_RegisterID, F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID ORDER BY F_PhasePosition
		OPEN RegCursor
		FETCH NEXT FROM RegCursor INTO @RegisterID,@PhasePos
		WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT INTO #TMP_TABLE1 (PhaseID,[Pos],RegisterID) VALUES(@PhaseID,@PhasePos,@RegisterID)
			DECLARE MatchCursor CURSOR FOR 
			SELECT A.F_MatchID,A.F_RegisterID, C.F_PhasePosition FROM TS_Match_Result AS A
			LEFT JOIN TS_Match_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_CompetitionPositionDes1 != A.F_CompetitionPositionDes1
			LEFT JOIN TS_Phase_Position AS C ON C.F_PhaseID = @PhaseID AND C.F_RegisterID = B.F_RegisterID
			WHERE A.F_RegisterID = @RegisterID AND A.F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID)
			ORDER BY C.F_PhasePosition
			
			OPEN MatchCursor
			FETCH NEXT FROM MatchCursor INTO @TempMatchID, @TempRegID, @TempPos
			
			WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @TempPos = 1
					UPDATE #TMP_TABLE1 SET ScoreDes11 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 1, @TempRegID, @ScheduleOnly),
										  ScoreDes12 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 2, @TempRegID, @ScheduleOnly)
						   WHERE PhaseID = @PhaseID AND [Pos] = @PhasePos
				ELSE IF @TempPos = 2
					UPDATE #TMP_TABLE1 SET ScoreDes21 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 1, @TempRegID, @ScheduleOnly),
										  ScoreDes22 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 2, @TempRegID, @ScheduleOnly)
						   WHERE PhaseID = @PhaseID AND [Pos] = @PhasePos
				ELSE IF @TempPos = 3
					UPDATE #TMP_TABLE1 SET ScoreDes31 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 1, @TempRegID, @ScheduleOnly),
										  ScoreDes32 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 2, @TempRegID, @ScheduleOnly)
						   WHERE PhaseID = @PhaseID AND [Pos] = @PhasePos
				ELSE IF @TempPos = 4
					UPDATE #TMP_TABLE1 SET ScoreDes41 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 1, @TempRegID, @ScheduleOnly),
										  ScoreDes42 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 2, @TempRegID, @ScheduleOnly)
						   WHERE PhaseID = @PhaseID AND [Pos] = @PhasePos
				ELSE IF @TempPos = 5
					UPDATE #TMP_TABLE1 SET ScoreDes51 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 1, @TempRegID, @ScheduleOnly),
										  ScoreDes52 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 2, @TempRegID, @ScheduleOnly)
						   WHERE PhaseID = @PhaseID AND [Pos] = @PhasePos
				ELSE IF @TempPos = 6
					UPDATE #TMP_TABLE1 SET ScoreDes61 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 1, @TempRegID, @ScheduleOnly),
										  ScoreDes62 = dbo.[Fun_BDTT_New_GetMatchResultDes](@TempMatchID, 2, @TempRegID, @ScheduleOnly)
						   WHERE PhaseID = @PhaseID AND [Pos] = @PhasePos
						   
				FETCH NEXT FROM MatchCursor INTO @TempMatchID, @TempRegID, @TempPos
			END
			
			CLOSE MatchCursor
			DEALLOCATE MatchCursor
			
			
			--第二层 
			FETCH NEXT FROM RegCursor INTO @RegisterID,@PhasePos
		END
		
		CLOSE RegCursor
		DEALLOCATE RegCursor
		
		
		UPDATE #TMP_TABLE1 SET TeamSize = @PhasePos WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET RegColName1 = 
		(
			SELECT B.F_PrintShortName FROM #TMP_TABLE1 AS A 
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
			WHERE A.Pos = 1 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET RegColName2 = 
		(
			SELECT B.F_PrintShortName FROM #TMP_TABLE1 AS A 
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
			WHERE A.Pos = 2 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET RegColName3 = 
		(
			SELECT B.F_PrintShortName FROM #TMP_TABLE1 AS A 
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
			WHERE A.Pos = 3 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET RegColName4 = 
		(
			SELECT B.F_PrintShortName FROM #TMP_TABLE1 AS A 
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
			WHERE A.Pos = 4 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET RegColName5 = 
		(
			SELECT B.F_PrintShortName FROM #TMP_TABLE1 AS A 
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
			WHERE A.Pos = 5 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET RegColName6 = 
		(
			SELECT B.F_PrintShortName FROM #TMP_TABLE1 AS A 
			LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
			WHERE A.Pos = 6 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET NOC1 = 
		(
			SELECT dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID) FROM #TMP_TABLE1 AS A 
			WHERE A.Pos = 1 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET NOC2 = 
		(
			SELECT dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID) FROM #TMP_TABLE1 AS A 
			WHERE A.Pos = 2 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET NOC3 = 
		(
			SELECT dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID) FROM #TMP_TABLE1 AS A 
			WHERE A.Pos = 3 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET NOC4 = 
		(
			SELECT dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID) FROM #TMP_TABLE1 AS A 
			WHERE A.Pos = 4 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET NOC5 = 
		(
			SELECT dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID) FROM #TMP_TABLE1 AS A 
			WHERE A.Pos = 5 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		
		UPDATE #TMP_TABLE1 SET NOC6 = 
		(
			SELECT dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID) FROM #TMP_TABLE1 AS A 
			WHERE A.Pos = 6 AND A.PhaseID = @PhaseID
		) WHERE PhaseID = @PhaseID
		--第一层
		FETCH NEXT FROM phaseCursor INTO @PhaseID
		
	END

	CLOSE phaseCursor
	DEALLOCATE phaseCursor

	UPDATE #TMP_TABLE1 SET PhaseName = B.F_PhaseShortName,[Rank] = C.F_PhaseRank,
				WinSets = (SELECT COUNT(X.F_WinSets) FROM TS_Match_Result AS X 
							LEFT JOIN TS_Match AS Y ON Y.F_MatchID = X.F_MatchID
							WHERE X.F_RegisterID = A.RegisterID AND Y.F_PhaseID = A.PhaseID AND X.F_ResultID = 1 )
	FROM #TMP_TABLE1 AS A
	LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.PhaseID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Phase_Result AS C ON C.F_PhaseID = A.PhaseID AND C.F_RegisterID = A.RegisterID

	UPDATE #TMP_TABLE1 SET RegisterName = B.F_PrintShortName,NOC = dbo.Fun_BDTT_GetPlayerNOCName(A.RegisterID)
	FROM #TMP_TABLE1 AS A
	LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.RegisterID AND B.F_LanguageCode = @LanguageCode
	

	UPDATE #TMP_TABLE1 SET EventType =
	(
		SELECT F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
	)
	SELECT * FROM #TMP_TABLE1

SET NOCOUNT OFF
END


GO


--exec Proc_TVG_BDTT_GetContestInfo 70

