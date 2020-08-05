IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_CreateGroupResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_CreateGroupResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_HO_CreateGroupResult]
----功		  能：计算小组的积分和排名
----作		  者：张翠霞
----日		  期: 2012-08-30


CREATE PROCEDURE [dbo].[Proc_HO_CreateGroupResult] (	
	@MatchID			INT
)	
AS
BEGIN
SET NOCOUNT ON

   DECLARE @Result AS INT
   SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					  -- @Result = 1; 更新成功！
					  
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
    BEGIN
    SET @Result = -1
    RETURN
    END
    
    DECLARE @StatusID AS INT
    SELECT @StatusID = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
    
    IF @StatusID NOT IN(100, 110)
    BEGIN
    SET @Result = -1
    RETURN
    END
	
	DECLARE @PhaseType	AS INT
    DECLARE @PhaseID    AS INT
	SELECT @PhaseType = B.F_PhaseType, @PhaseID = A.F_PhaseID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

	IF (@PhaseType != 2 OR @PhaseType IS NULL)--非小组赛，不能统计小组赛积分
	BEGIN
	    SET @Result = 0
		RETURN
	END

	DECLARE	@tmpWonMatchPoint	AS INT
	DECLARE	@tmpDrawMatchPoint	AS INT
	DECLARE	@tempLostMatchPoint AS INT
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID)
	BEGIN
		INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint) VALUES (@PhaseID, 3, 1, 0)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END
	ELSE
	BEGIN
	    UPDATE TS_Phase_MatchPoint SET F_WonMatchPoint = 3, F_DrawMatchPoint = 1, F_LostMatchPoint = 0 WHERE F_PhaseID = @PhaseID
	    
	    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END

	SELECT @tmpWonMatchPoint = F_WonMatchPoint, @tmpDrawMatchPoint = F_DrawMatchPoint, @tempLostMatchPoint = F_LostMatchPoint
	FROM TS_Phase_MatchPoint WHERE F_PhaseID = @PhaseID

	DELETE FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_PhaseResultNumber NOT IN (SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID)
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber)
	SELECT F_PhaseID, F_PhasePosition AS F_PhaseResultNumber FROM TS_Phase_Position 
	WHERE F_PhaseID = @PhaseID AND F_PhasePosition NOT IN (SELECT F_PhaseResultNumber FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID)
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	UPDATE TS_Phase_Result SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Result AS A
	LEFT JOIN TS_Phase_Position AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhasePosition WHERE B.F_RegisterID IS NOT NULL
	
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	CREATE TABLE #tmp_GroupResult(
									[F_PhaseID]					[int],
									[F_DelegationCode]          NVARCHAR(100),
									[F_PhaseResultNumber]		[int],
									[F_RegisterID]				[int],
									[F_PhasePoints]				[int],
									[F_PhaseRank]				[int],
									[F_PhaseDisplayPosition]	[int],
									[F_MatchesWon]				[int],
									[F_MatchesDraw]				[int],
									[F_MatchesLost]			    [int],
									[F_ScoresWon]               [int],
									[F_ScoresLost]              [int],	
									[F_ScoresDif]	            [int],							
									[F_RankPts]                 [int],
									[F_RankScoreDif]            [int],
									[F_RankScoresWon]           [int],
								) 
								
	CREATE TABLE #tmp_Table(
	                                F_RegisterID               int,
	                                F_OppRegisterID            int,
	                                [F_DelegationCode]          NVARCHAR(100),
	                                F_Rank                     int,
	                                F_DisplayPos               int,
	                                F_Pos                      int                            
	                        )
	                        
	INSERT INTO #tmp_GroupResult (F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_DelegationCode)
	SELECT A.F_PhaseID, A.F_PhaseResultNumber, A.F_RegisterID, C.F_DelegationCode
	FROM TS_Phase_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
	LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
	WHERE A.F_PhaseID = @PhaseID	

	UPDATE #tmp_GroupResult SET F_MatchesWon = [dbo].[Fun_HO_GetMatchWonLost](F_PhaseID, F_RegisterID, 1, 1)
	, F_MatchesLost = [dbo].[Fun_HO_GetMatchWonLost](F_PhaseID, F_RegisterID, 1, 2)
	, F_MatchesDraw = [dbo].[Fun_HO_GetMatchWonLost](F_PhaseID, F_RegisterID, 1, 3)
	, F_ScoresWon = [dbo].[Fun_HO_GetMatchWonLost](F_PhaseID, F_RegisterID, 2, 1)
	, F_ScoresLost = [dbo].[Fun_HO_GetMatchWonLost](F_PhaseID, F_RegisterID, 2, 2)
	
	UPDATE #tmp_GroupResult SET F_PhasePoints = @tmpWonMatchPoint * F_MatchesWon +@tmpDrawMatchPoint * F_MatchesDraw + @tempLostMatchPoint * F_MatchesLost

    UPDATE #tmp_GroupResult SET F_RankPts = B.RankPts, F_RankScoreDif = b.RankScoreDif, F_RankScoresWon = B.RankScoreWon, F_PhaseRank = B.RankScoreWon, F_PhaseDisplayPosition = B.RankTotal
	FROM #tmp_GroupResult AS A 
	LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC) AS RankPts
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_ScoresDif DESC) AS RankScoreDif
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_ScoresWon DESC) AS RankScoreWon
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_ScoresWon DESC, F_DelegationCode) AS RankTotal, * FROM #tmp_GroupResult)
	AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	
	DECLARE @DisplayPos AS INT
	DECLARE @SameCount AS INT
	
	WHILE EXISTS(SELECT DisposCount FROM (SELECT COUNT(F_RankScoresWon) AS DisposCount, F_RankScoresWon FROM #tmp_GroupResult GROUP BY F_RankScoresWon) AS B WHERE B.DisposCount = 2 AND B.F_RankScoresWon > 0)
	BEGIN
		    
	    SELECT TOP 1 @DisplayPos = F_RankScoresWon FROM (SELECT F_RankScoresWon, COUNT(F_RankScoresWon) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankScoresWon) AS B WHERE B.DisposCount = 2 AND B.F_RankScoresWon > 0

	    DELETE FROM #tmp_Table
	        INSERT INTO #tmp_Table(F_RegisterID, F_DelegationCode, F_Pos)
	          SELECT F_RegisterID, F_DelegationCode, F_PhaseResultNumber FROM #tmp_GroupResult WHERE F_RankScoresWon = @DisplayPos
	             
        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
          LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
        UPDATE #tmp_Table SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
		  FROM #tmp_Table AS A 
		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_DelegationCode, F_Pos) AS DisplayPos, * FROM #tmp_Table)
		      AS B ON A.F_Pos = B.F_Pos

        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankScoresWon = B.F_DisplayPos + @DisplayPos - 1 FROM #tmp_GroupResult AS A
          INNER JOIN #tmp_Table AS B ON A.F_PhaseResultNumber = B.F_Pos
	END
	
	UPDATE TS_Phase_Result SET F_PhasePoints = A.F_PhasePoints, F_PhaseRank = A.F_PhaseRank, F_PhaseDisplayPosition = A.F_PhaseDisplayPosition 
		FROM #tmp_GroupResult AS A LEFT JOIN TS_Phase_Result AS B 
			ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
			
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END



GO


