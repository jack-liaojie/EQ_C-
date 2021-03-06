IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BK_CreateGroupResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BK_CreateGroupResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_BK_CreateGroupResult]
----功		  能：计算小组的积分和排名
----作		  者：李燕 
----日		  期: 2010-6-7

CREATE PROCEDURE [dbo].[Proc_BK_CreateGroupResult] (	
	@MatchID			INT

)	
AS
BEGIN
SET NOCOUNT ON
	

	DECLARE @PhaseType	AS INT
    DECLARE @PhaseID    AS INT
	SELECT @PhaseType = B.F_PhaseType, @PhaseID = A.F_PhaseID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID


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

	END
	ELSE
	BEGIN
	    UPDATE TS_Phase_MatchPoint SET F_WonMatchPoint = 2, F_DrawMatchPoint = 1, F_LostMatchPoint = 0 WHERE F_PhaseID = @PhaseID
	   
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
									[F_NOC]                     NVARCHAR(10),
									[F_RegisterID]				[int],
									[F_PhasePoints]				[int],
									[F_PhaseRank]				[int],
									[F_PhaseDisplayPosition]	[int],
 									[F_WonMatchNum]				[int],
									[F_DrawMatchNum]			[int],
									[F_LostMatchNum]			[int],
								    [F_RankPts]                 [int],
									[F_RankMatches]             [int],
									[F_RankPos]                 [int],
								) 
	INSERT INTO #tmp_GroupResult (F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_PhasePoints, F_PhaseRank, F_PhaseDisplayPosition, F_WonMatchNum, F_DrawMatchNum, F_LostMatchNum, F_NOC)
		SELECT A.F_PhaseID, A.F_PhaseResultNumber, A.F_RegisterID, 0 AS F_PhasePoints, 0 AS F_PhaseRank, 0 AS F_PhaseDisplayPosition, 0 AS F_WonMatchNum, 0 AS F_DrawMatchNum, 0 AS F_LostMatchNum, C.F_DelegationCode
			FROM TS_Phase_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
	           LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
	        WHERE F_PhaseID = @PhaseID
	

	UPDATE #tmp_GroupResult SET F_WonMatchNum = DBO.[Fun_GetWinMatchNum](F_PhaseID, F_RegisterID), F_DrawMatchNum = DBO.[Fun_WP_GetDrawMatchNum](F_PhaseID, F_RegisterID), F_LostMatchNum = DBO.[Fun_GetLoseMatchNum](F_PhaseID, F_RegisterID)
	
	

	UPDATE #tmp_GroupResult SET F_PhasePoints = @tmpWonMatchPoint * F_WonMatchNum + @tmpDrawMatchPoint * F_DrawMatchNum + @tempLostMatchPoint * F_LostMatchNum
	
----根据积分，胜场数，得分进行排名
	 UPDATE #tmp_GroupResult SET F_RankPts = B.RankPts, F_PhaseRank = B.RankPts,
	  F_PhaseDisplayPosition = B.RankTotal
		FROM #tmp_GroupResult AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC) AS RankPts
		, RANK() OVER(ORDER BY F_PhasePoints DESC,  F_NOC) AS RankTotal, * FROM #tmp_GroupResult)
		AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	
--	CREATE TABLE #tmp_Table(
--	                                F_RegisterID               int,
--	                                F_OppRegisterID            int,
--	                                F_NOC                      NVARCHAR(10),
--	                                F_Rank                     int,
--	                                F_DisplayPos               int                             
--	                        )
	                        
--	DECLARE @DisplayPos AS INT
--	DECLARE @SameCount AS INT
	
-------当有两支队伍的名次相同，则按胜负关系判定	
--	WHILE EXISTS(SELECT DisposCount FROM (SELECT COUNT(F_RankPos) AS DisposCount, F_RankPos FROM #tmp_GroupResult GROUP BY F_RankPos) AS B WHERE B.DisposCount = 2 AND B.F_RankPos > 0)
--	BEGIN
		    
--	    SELECT TOP 1 @DisplayPos = F_RankPos FROM (SELECT F_RankPos, COUNT(F_RankPos) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankPos) AS B WHERE B.DisposCount = 2 AND B.F_RankPos > 0

--	    DELETE FROM #tmp_Table
--	    INSERT INTO #tmp_Table(F_RegisterID, F_NOC)
--	          SELECT F_RegisterID, F_NOC FROM #tmp_GroupResult WHERE F_RankPos = @DisplayPos

--        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
--        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
--          LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
--        UPDATE #tmp_Table SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
--		  FROM #tmp_Table AS A 
--		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_NOC) AS DisplayPos, * FROM #tmp_Table)
--		      AS B ON A.F_RegisterID = B.F_RegisterID

--        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankPos = B.F_DisplayPos + @DisplayPos - 1  FROM #tmp_GroupResult AS A
--          INNER JOIN #tmp_Table AS B ON A.F_RegisterID = B.F_RegisterID
--	END

	
	UPDATE TS_Phase_Result SET F_PhasePoints = A.F_PhasePoints, F_PhaseRank = A.F_PhaseRank, F_PhaseDisplayPosition = A.F_PhaseDisplayPosition 
		FROM #tmp_GroupResult AS A LEFT JOIN TS_Phase_Result AS B 
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber


SET NOCOUNT OFF
END
GO
