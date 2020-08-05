
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_SetMatchRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_SetMatchRank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Proc_SH_SetMatchRank] (	
	@MatchID					INT
)	

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @IsTeamMatch INT
	SELECT @IsTeamMatch = dbo.Func_SH_IsTeamMatch(@MatchID)
	IF @IsTeamMatch = 1 
	RETURN
	
	-- temp put here
	DELETE  FROM TS_Phase_Result
	WHERE F_RegisterID is null

	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @UnitCode  NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			@PhaseCode = Phase_Code, 
			@UnitCode = Match_Code 
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	IF @UnitCode = '50'
	BEGIN
		EXEC Proc_SH_SetShootOffRank @MatchID
		RETURN
	END
	
	
	DECLARE @WHO_NEED_SHOTOFF_RANK INT
	DECLARE @SHOTOFF_COUNT INT
	DECLARE @HAS_SHOTOFF INT
	DECLARE @SHOT_GROUP INT
	DECLARE @RANK_NUMBER INT
	SET @RANK_NUMBER = 8

	CREATE TABLE #TSHOT_GROUP(F_Rank INT, F_Count INT)
	CREATE TABLE #TT_RANK(F_MatchID INT, F_RegisterID INT, F_Points INT, F_Rank INT)

	DECLARE @ShootOffMatchID INT
	SELECT @ShootOffMatchID = DBO.Func_SH_GetShootOffMatchID(@MatchID)
	

	--25M STANDARD, ONLY ONE PHASE, IF SHOOT OFF IN FIRST THREE THEN SHOOTOFF 
	-- SAME AS FINAL, COUNT BACK AS QUALIFICAITON
	IF @EventCode IN ( '007' )
	BEGIN
	
			SET @RANK_NUMBER = 3
			--First, Rank by F_Points
			INSERT #TT_RANK(F_MatchID, F_RegisterID, F_Points, F_Rank)
			SELECT F_MatchID, 
					R.F_RegisterID, 
					R.F_Points,
					RANK() OVER (ORDER BY R.F_Points DESC) AS RK 
					FROM TS_Match_Result AS R
				LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
				
			INSERT INTO #TSHOT_GROUP(F_Rank, F_Count)	
			SELECT F_Rank, COUNT(*)
			FROM #TT_RANK
			WHERE F_Rank <= @RANK_NUMBER
			GROUP BY F_Rank
			HAVING COUNT(*) >= 2

			SELECT @SHOT_GROUP = COUNT(*) FROM #TSHOT_GROUP										
			SELECT @HAS_SHOTOFF = COUNT(*) FROM TS_Match_Result
			WHERE F_MatchID = @ShootOffMatchID AND F_RegisterID IS NOT NULL 
			
	
			-- 2 COUNTBACK, FROM QUALIFICAION
			UPDATE #TT_RANK SET F_Rank = B.RK
			FROM #TT_RANK AS A
			LEFT JOIN
			(SELECT *,RANK() OVER(ORDER BY P.Points DESC, 
									P.RealScore DESC, 
									P.S12 DESC, P.S11 DESC, P.S10 DESC, P.S9 DESC, P.S8 DESC, P.S7 DESC, P.S6 DESC, 
									P.S5 DESC, P.S4 DESC, P.S3 DESC, P.S2 DESC, P.S1 DESC) AS RK
			 FROM 
			(SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@MatchID)
				) AS P 
				LEFT JOIN TC_IRM I ON P.IRMID = I.F_IRMID
				WHERE (I.F_IRMCODE NOT IN('DNS','DSQ') OR P.IRMID IS NULL) ) 
				AS B ON A.F_RegisterID = B.REG_ID
			WHERE A.F_Rank > @RANK_NUMBER

							
			IF @HAS_SHOTOFF > 0
			BEGIN
				IF @SHOT_GROUP > 1
				BEGIN
				UPDATE #TT_RANK SET F_Rank = A.F_Rank + B.RK - 1
				FROM #TT_RANK AS A
				RIGHT JOIN (SELECT T.F_RegisterID,  RANK() OVER(PARTITION BY T.F_Rank ORDER BY R.F_Rank) AS RK 
							FROM #TT_RANK AS T
							LEFT JOIN TS_Match_Result AS R ON T.F_RegisterID = R.F_RegisterID
							LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
							WHERE R.F_MatchID = @ShootOffMatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
							)	
							AS B ON A.F_RegisterID = B.F_RegisterID
				END
				ELSE
				BEGIN
				
					UPDATE #TT_RANK SET F_Rank = A.F_Rank + B.RK - 1
					FROM #TT_RANK AS A
					RIGHT JOIN (SELECT T.F_RegisterID,  RANK() OVER(ORDER BY R.F_Rank) AS RK 
								FROM #TT_RANK AS T
								LEFT JOIN TS_Match_Result AS R ON T.F_RegisterID = R.F_RegisterID
								LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
								WHERE R.F_MatchID = @ShootOffMatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
								)	
								AS B ON A.F_RegisterID = B.F_RegisterID
				
				END
			END
		
	END



	--50M PRONSE WOMEN, BACKCOUT, A,9
	ELSE IF @EventCode = '109'
	BEGIN
			INSERT INTO #TT_RANK(F_MatchID, F_RegisterID, F_Rank)
			SELECT F_MatchID, 
					R.F_RegisterID, 
					RANK() OVER (ORDER BY R.F_Points DESC,
								F_RealScore DESC, 
								P.[12] DESC,
								P.[11] DESC,
								P.[10] DESC,
								P.[9] DESC,
								P.[8] DESC,
								P.[7] DESC,
								P.[6] DESC,
								P.[5] DESC,
								P.[4] DESC,
								P.[3] DESC,
								P.[2] DESC,
								P.[1] DESC) 
					AS RK 
					FROM TS_Match_Result AS R
					LEFT JOIN (		
					SELECT F_RegisterID,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
				FROM (
						SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 
						FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
					 ) 	AS SourceTable
				PIVOT 
				(
					MAX(F_ActionDetail1) FOR F_MatchSplitID
					IN (
					[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
					)
				) AS PivotTable) AS P 
				ON P.F_RegisterID = R.F_RegisterID
				LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL) 
	
	END
	


	--25M RP
	ELSE IF @EventCode = '005' 
	BEGIN
	
		IF  @PhaseCode = '1'
		BEGIN
			SET @RANK_NUMBER = 6
			
			INSERT #TT_RANK(F_MatchID, F_RegisterID, F_Points, F_Rank)
			SELECT F_MatchID, 
					R.F_RegisterID, 
					R.F_Points,
					RANK() OVER (ORDER BY R.F_Points DESC) AS RK 
					FROM TS_Match_Result AS R
				--LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID 
				--AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
				
			--test 1
			--SELECT * FROM #TT_RANK
			UPDATE TS_Match_Result SET F_Rank = B.F_Rank
			FROM TS_Match_Result A 
			LEFT JOIN #TT_RANK	AS B ON A.F_MatchID = B.F_MatchID AND A.F_RegisterID = B.F_RegisterID
			--LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
			WHERE A.F_MatchID = @MatchID 
			--AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR I.F_IRMID IS NULL)


			--Second
			--<=8
			IF @ShootOffMatchID IS NOT NULL
			BEGIN
				UPDATE #TT_RANK SET F_Rank = A.F_Rank + B.RK - 1
				FROM #TT_RANK AS A
				RIGHT JOIN (SELECT T.F_RegisterID,  RANK() OVER(ORDER BY R.F_Rank) AS RK 
							FROM #TT_RANK AS T
							LEFT JOIN TS_Match_Result AS R ON T.F_RegisterID = R.F_RegisterID
							LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
							WHERE R.F_MatchID = @ShootOffMatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
							)	
							AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_Rank <= @RANK_NUMBER	AND A.F_Rank = 	@WHO_NEED_SHOTOFF_RANK		
			END
		END
		
		
		IF @PhaseCode = '9'
		BEGIN
				SET @RANK_NUMBER = 6

				--First, Rank by F_Points
				INSERT #TT_RANK(F_MatchID, F_RegisterID, F_Points, F_Rank)
				SELECT F_MatchID, 
						R.F_RegisterID, 
						R.F_Points,
						RANK() OVER (ORDER BY R.F_Points DESC) AS RK 
						FROM TS_Match_Result AS R
					LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
					WHERE R.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
					

				UPDATE TS_Match_Result SET F_Rank = B.F_Rank
				FROM TS_Match_Result A 
				LEFT JOIN #TT_RANK	AS B ON A.F_MatchID = B.F_MatchID AND A.F_RegisterID = B.F_RegisterID
				LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
				WHERE A.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR I.F_IRMID IS NULL)
					
					
				--select @WHO_NEED_SHOTOFF_RANK = F_Rank
				--from TS_Match_Result
				--where F_MatchID = @MatchID AND F_Rank <= @RANK_NUMBER
				--group by F_Rank
				--having COUNT(*) >= 2
			
				--SELECT @SHOTOFF_COUNT = COUNT(*) FROM TS_Match_Result
				--WHERE F_MatchID = @ShootOffMatchID AND F_RegisterID IS NOT NULL 
				
				--IF @SHOTOFF_COUNT > 0
				--BEGIN
				--	UPDATE #TT_RANK SET F_Rank = A.F_Rank + B.RK - 1
				--	FROM #TT_RANK AS A
				--	RIGHT JOIN (SELECT T.F_RegisterID,  RANK() OVER(ORDER BY R.F_Rank) AS RK 
				--				FROM #TT_RANK AS T
				--				LEFT JOIN TS_Match_Result AS R ON T.F_RegisterID = R.F_RegisterID
				--				LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				--				WHERE R.F_MatchID = @ShootOffMatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
				--				)	
				--				AS B ON A.F_RegisterID = B.F_RegisterID
				--	WHERE  A.F_Rank = @WHO_NEED_SHOTOFF_RANK
				--END

			UPDATE #TT_RANK SET F_Rank = B.RK
			FROM #TT_RANK AS A
			LEFT JOIN
			(SELECT *,RANK() OVER(ORDER BY P.Points DESC, 
									P.RealScore DESC, 
									P.S12 DESC, P.S11 DESC, P.S10 DESC, P.S9 DESC, P.S8 DESC, P.S7 DESC, P.S6 DESC, 
									P.S5 DESC, P.S4 DESC, P.S3 DESC, P.S2 DESC, P.S1 DESC) AS RK
			 FROM 
			(SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@MatchID)
				) AS P 
				LEFT JOIN TC_IRM I ON P.IRMID = I.F_IRMID
				WHERE (I.F_IRMCODE NOT IN('DNS','DSQ') OR P.IRMID IS NULL) ) 
				AS B ON A.F_RegisterID = B.REG_ID
--			WHERE A.F_Rank < @WHO_NEED_SHOTOFF_RANK OR (A.F_Rank >= @SHOTOFF_COUNT + @WHO_NEED_SHOTOFF_RANK)
			
		END

	END


	-- OTHER EVENTS
	ELSE
	BEGIN
		IF  @PhaseCode IN ('A','9') 	--Backcount
		BEGIN
			INSERT INTO #TT_RANK(F_MatchID, F_RegisterID, F_Rank)
			SELECT F_MatchID, 
					R.F_RegisterID, 
					RANK() OVER (ORDER BY R.F_Points DESC,
								F_RealScore DESC, 
								P.[12] DESC,
								P.[11] DESC,
								P.[10] DESC,
								P.[9] DESC,
								P.[8] DESC,
								P.[7] DESC,
								P.[6] DESC,
								P.[5] DESC,
								P.[4] DESC,
								P.[3] DESC,
								P.[2] DESC,
								P.[1] DESC) 
					AS RK 
					FROM TS_Match_Result AS R
					LEFT JOIN (		
					SELECT F_RegisterID,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
				FROM (
						SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 
						FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
					 ) 	AS SourceTable
				PIVOT 
				(
					MAX(F_ActionDetail1) FOR F_MatchSplitID
					IN (
					[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
					)
				) AS PivotTable) AS P 
				ON P.F_RegisterID = R.F_RegisterID
				LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL) 
		END

		IF @PhaseCode = '9'
		BEGIN
			UPDATE #TT_RANK SET F_Rank = B.RK
			FROM #TT_RANK AS A
			LEFT JOIN
			(SELECT *,RANK() OVER(ORDER BY P.Points DESC, 
									P.RealScore DESC, 
									P.S12 DESC, P.S11 DESC, P.S10 DESC, P.S9 DESC, P.S8 DESC, P.S7 DESC, P.S6 DESC, 
									P.S5 DESC, P.S4 DESC, P.S3 DESC, P.S2 DESC, P.S1 DESC) AS RK
			 FROM 
			(SELECT * FROM dbo.[Func_SH_GetMatchQualifiedlResult] (@MatchID)
				) AS P 
				LEFT JOIN TC_IRM I ON P.IRMID = I.F_IRMID
				WHERE (I.F_IRMCODE NOT IN('DNS','DSQ') OR P.IRMID IS NULL) ) 
				AS B ON A.F_RegisterID = B.REG_ID
		
		END
		
		IF @PhaseCode = '1'
		BEGIN
				
			SET @RANK_NUMBER = 3
			--First, Rank by F_Points
			INSERT #TT_RANK(F_MatchID, F_RegisterID, F_Points, F_Rank)
			SELECT F_MatchID, 
					R.F_RegisterID, 
					R.F_Points,
					RANK() OVER (ORDER BY R.F_Points DESC) AS RK 
					FROM TS_Match_Result AS R
--				LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID  
				--AND (I.F_IRMCODE NOT IN('DSQ') OR R.F_IRMID IS NULL)
				
			INSERT INTO #TSHOT_GROUP(F_Rank, F_Count)	
			SELECT F_Rank, COUNT(*)
			FROM #TT_RANK
			WHERE F_Rank <= @RANK_NUMBER
			GROUP BY F_Rank
			HAVING COUNT(*) >= 2

			SELECT @SHOT_GROUP = COUNT(*) FROM #TSHOT_GROUP										
			SELECT @HAS_SHOTOFF = COUNT(*) FROM TS_Match_Result
			WHERE F_MatchID = @ShootOffMatchID AND F_RegisterID IS NOT NULL 
			
	
			-- 2 COUNTBACK
			UPDATE #TT_RANK SET F_Rank = B.RK
			FROM #TT_RANK AS A
			LEFT JOIN
			(
			SELECT F_MatchID, 
					R.F_RegisterID, 
					RANK() OVER (ORDER BY R.F_Points DESC,
								F_RealScore DESC, 
								P.[20] DESC,
								P.[19] DESC,
								P.[18] DESC,
								P.[17] DESC,
								P.[16] DESC,
								P.[15] DESC,
								P.[14] DESC,
								P.[13] DESC,
								P.[12] DESC,
								P.[11] DESC,
								P.[10] DESC,
								P.[9] DESC,
								P.[8] DESC,
								P.[7] DESC,
								P.[6] DESC,
								P.[5] DESC,
								P.[4] DESC,
								P.[3] DESC,
								P.[2] DESC,
								P.[1] DESC) 
					AS RK 
					FROM TS_Match_Result AS R
					LEFT JOIN (		
					SELECT F_RegisterID,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20]
				FROM (
						SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 
						FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
					 ) 	AS SourceTable
				PIVOT 
				(
					MAX(F_ActionDetail1) FOR F_MatchSplitID
					IN (
					[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20]
					)
				) AS PivotTable) AS P 
				ON P.F_RegisterID = R.F_RegisterID
			--	LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
				WHERE R.F_MatchID = @MatchID 
				--AND (I.F_IRMCODE NOT IN('DSQ') OR R.F_IRMID IS NULL) 
				) 
				AS B ON A.F_RegisterID = B.F_RegisterID
				WHERE A.F_Rank > @RANK_NUMBER

							
			IF @HAS_SHOTOFF > 0
			BEGIN
				IF @SHOT_GROUP > 1
				BEGIN
				UPDATE #TT_RANK SET F_Rank = A.F_Rank + B.RK - 1
				FROM #TT_RANK AS A
				RIGHT JOIN (SELECT T.F_RegisterID,  RANK() OVER(PARTITION BY T.F_Rank ORDER BY R.F_Rank) AS RK 
							FROM #TT_RANK AS T
							LEFT JOIN TS_Match_Result AS R ON T.F_RegisterID = R.F_RegisterID
							--LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
							WHERE R.F_MatchID = @ShootOffMatchID 
							--AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
							)	
							AS B ON A.F_RegisterID = B.F_RegisterID
				END
				ELSE
				BEGIN
				
					UPDATE #TT_RANK SET F_Rank = A.F_Rank + B.RK - 1
					FROM #TT_RANK AS A
					RIGHT JOIN (SELECT T.F_RegisterID,  RANK() OVER(ORDER BY R.F_Rank) AS RK 
								FROM #TT_RANK AS T
								LEFT JOIN TS_Match_Result AS R ON T.F_RegisterID = R.F_RegisterID
								--LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
								WHERE R.F_MatchID = @ShootOffMatchID 
								--AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
								)	
								AS B ON A.F_RegisterID = B.F_RegisterID
				
				END
			END

				----3 RANK IS NULL
				--UPDATE #TT_RANK SET F_Rank = B.RK
				--FROM #TT_RANK AS A
				--LEFT JOIN
				--(
				--SELECT *, RANK() 
				--OVER(ORDER BY F_Points DESC, 
				--F_QResult DESC,
				--F_QRealScore DESC,
				--F_Q12 DESC,
				--F_Q11 DESC,
				--F_Q10 DESC,
				--F_Q9 DESC,
				--F_Q8 DESC,
				--F_Q7 DESC,
				--F_Q6 DESC,
				--F_Q5 DESC,
				--F_Q4 DESC,
				--F_Q3 DESC,
				--F_Q2 DESC,
				--F_Q1 DESC
				--	) AS RK
				-- FROM dbo.Func_SH_GetFinalResult(@MatchID)
				-- )
				--	AS B ON A.F_RegisterID = B.F_RegisterID
				--WHERE A.F_Rank IS NULL

		END
		
	END
	
	--SELECT * FROM #TT_RANK	
		
	--Last
	IF @PhaseCode = '1'
	BEGIN
		UPDATE TS_Match_Result SET F_Rank = B.F_Rank
		FROM TS_Match_Result A 
		LEFT JOIN #TT_RANK	AS B ON A.F_MatchID = B.F_MatchID AND A.F_RegisterID = B.F_RegisterID
--		LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
		WHERE A.F_MatchID = @MatchID
		-- AND (I.F_IRMCODE NOT IN('DSQ') OR I.F_IRMID IS NULL)
	END
	ELSE
	BEGIN
		UPDATE TS_Match_Result SET F_Rank = B.F_Rank
		FROM TS_Match_Result A 
		LEFT JOIN #TT_RANK	AS B ON A.F_MatchID = B.F_MatchID AND A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
		WHERE A.F_MatchID = @MatchID AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR I.F_IRMID IS NULL)
	END	
			
SET NOCOUNT OFF
END


GO


/*

EXEC Proc_SH_SetMatchRank 50
SELECT F_Rank, F_Points, F_RealScore, * FROM TS_Match_Result WHERE F_MatchID = 3

*/
