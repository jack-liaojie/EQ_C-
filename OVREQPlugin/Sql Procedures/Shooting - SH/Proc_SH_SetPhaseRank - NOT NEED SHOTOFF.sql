
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_SetPhaseRank]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_SetPhaseRank]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[Proc_SH_SetPhaseRank] (	
	@MatchID					INT
)	

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @IsTeamMatch INT
	SELECT @IsTeamMatch = dbo.Func_SH_IsTeamMatch(@MatchID)
	IF @IsTeamMatch = 1 
	RETURN
	
	

	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @UnitCode  NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			@PhaseCode = Phase_Code, 
			@UnitCode = Match_Code 
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	DECLARE @RANK_NUMBER INT
	SET @RANK_NUMBER = 8
	IF @EventCode = '005' SET @RANK_NUMBER = 6
	IF @EventCode = '007' SET @RANK_NUMBER = 3
	
	-- First:
	CREATE TABLE #TT_RANK(F_MatchID INT, F_RegisterID INT, F_Rank INT)
	INSERT #TT_RANK(F_RegisterID, F_Rank)
	SELECT 	R.F_RegisterID, 
			RANK() OVER (ORDER BY R.F_PhasePoints DESC) AS RK 
			FROM TS_Phase_Result AS R
		LEFT JOIN TC_IRM I ON R.F_IRMID = I.F_IRMID
		WHERE R.F_PhaseID IN (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID) 
			AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR R.F_IRMID IS NULL)
		
	--test 1
	-- SELECT * FROM #TT_RANK
	UPDATE A SET F_PhaseRank = B.F_Rank
	FROM TS_Phase_Result A 
	LEFT JOIN #TT_RANK	AS B ON A.F_RegisterID = B.F_RegisterID
	LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
	WHERE A.F_PhaseID IN (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID) 
		AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR I.F_IRMID IS NULL)

	CREATE TABLE #TQ_MatchID(F_MatchID INT)
	INSERT INTO #TQ_MatchID(F_MatchID)
	SELECT F_MatchID FROM dbo.Func_SH_GetQualificationMatchId(@MatchID)
		
	-- TEST 
	-- SELECT * FROM #TQ_MatchID
	
	UPDATE #TT_RANK SET F_Rank = B.RK
	FROM #TT_RANK AS A
	LEFT JOIN
	(
	SELECT 	R.F_RegisterID, 
			RANK() OVER (ORDER BY R.F_Rank,
						F_RealScore DESC, 
						P.[12] DESC,
						P.[11] DESC,
						P.[10] DESC,
						P.[9] DESC,
						P.[9] DESC,
						P.[7] DESC,
						P.[6] DESC,
						P.[5] DESC,
						P.[4] DESC,
						P.[3] DESC,
						P.[2] DESC,
						P.[1] DESC) 
			AS RK 
			FROM #TT_RANK AS R
			LEFT JOIN (		
			SELECT F_RegisterID,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
		FROM (
				SELECT F_RegisterID, F_CompetitionPosition,F_MatchSplitID,F_ActionDetail1 
				FROM TS_Match_ActionList WHERE F_MatchID IN (SELECT F_MatchID FROM #TQ_MatchID)
			 ) 	AS SourceTable
		PIVOT 
		(
			MAX(F_ActionDetail1) FOR F_MatchSplitID
			IN (
			[1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12]
			)
		) AS PivotTable) AS P 
		ON P.F_RegisterID = R.F_RegisterID
		LEFT JOIN (SELECT F_RegisterID, F_Points, F_RealScore, F_IRMID 
					FROM TS_Match_Result WHERE F_MatchID IN 
							(SELECT F_MatchID FROM #TQ_MatchID) ) AS S ON S.F_RegisterID = R.F_RegisterID
		LEFT JOIN TC_IRM I ON S.F_IRMID = I.F_IRMID
		WHERE (I.F_IRMCODE NOT IN('DNS','DSQ') OR S.F_IRMID IS NULL) ) 
		AS B ON A.F_RegisterID = B.F_RegisterID
		
	
		UPDATE #TT_RANK SET F_Rank = B.RK
		FROM #TT_RANK AS A
		LEFT JOIN
		(SELECT F_RegisterID,RANK() OVER(ORDER BY P.F_Points DESC, 
								P.F_RealScore DESC, 
								P.F_S12 DESC, 
								P.F_S11 DESC, 
								P.F_S10 DESC, 
								P.F_S9 DESC, 
								P.F_S8 DESC, 
								P.F_S7 DESC, 
								P.F_S6 DESC, 
								P.F_S5 DESC, 
								P.F_S4 DESC, 
								P.F_S3 DESC, 
								P.F_S2 DESC, 
								P.F_S1 DESC) AS RK
		 FROM 
		(SELECT * FROM dbo.[Func_SH_GetPhaseResult] (@MatchID)
			) AS P 
			LEFT JOIN TC_IRM I ON P.F_IRMID = I.F_IRMID
			WHERE (I.F_IRMCODE NOT IN('DNS','DSQ') OR P.F_IRMID IS NULL) ) 
			AS B ON A.F_RegisterID = B.F_RegisterID
		
		
	-- TEST 3
	 --SELECT * FROM #TT_RANK		
	
	--Last:
	UPDATE A SET F_PhaseRank = B.F_Rank
	FROM TS_Phase_Result A 
	LEFT JOIN #TT_RANK	AS B ON A.F_RegisterID = B.F_RegisterID
	LEFT JOIN TC_IRM AS I ON I.F_IRMID = A.F_IRMID
	WHERE A.F_PhaseID IN (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID) AND (I.F_IRMCODE NOT IN('DNS','DSQ') OR I.F_IRMID IS NULL)

			
SET NOCOUNT OFF
END


GO


/*

EXEC Proc_SH_SetPhaseRank 63
SELECT F_Rank, F_Points, F_RealScore, * FROM TS_Match_Result WHERE F_MatchID = 3

*/
