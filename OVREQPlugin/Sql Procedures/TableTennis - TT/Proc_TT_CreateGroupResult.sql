IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TT_CreateGroupResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TT_CreateGroupResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_TT_CreateGroupResult]
----功		  能：计算小组的积分和排名
----作		  者：张翠霞
----日		  期: 2010-7-8
----修改：死循环情况 2010-8-24

CREATE PROCEDURE [dbo].[Proc_TT_CreateGroupResult] (	
	@PhaseID			INT
)	
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @Result INT = 0
    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					  -- @Result = 1; 更新成功！
					  
					  
	--IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
 --   BEGIN
 --   SET @Result = -1
 --   RETURN
 --   END
    
 --   DECLARE @StatusID AS INT
 --   SELECT @StatusID = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
    
 --   IF @StatusID NOT IN(100, 110)
 --   BEGIN
 --   SET @Result = -1
 --   RETURN
 --   END
	
	--DECLARE @PhaseType	AS INT
 --   DECLARE @PhaseID    AS INT
	--SELECT @PhaseType = B.F_PhaseType, @PhaseID = A.F_PhaseID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

	--IF (@PhaseType != 2 OR @PhaseType IS NULL)--非小组赛，不能统计小组赛积分
	--BEGIN
	--    SET @Result = 0
	--	RETURN
	--END
	
	--不是小组赛
	IF NOT EXISTS ( SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID AND F_PhaseHasPools = 0 AND F_PhaseIsPool = 1)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	--Phase下面不存在unofficial和official的比赛
	IF NOT EXISTS ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchStatusID IN (100,110) )
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
		INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint) VALUES (@PhaseID, 1, 0, 0)
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	END
	ELSE
	BEGIN
	    UPDATE TS_Phase_MatchPoint SET F_WonMatchPoint = 1, F_DrawMatchPoint = 0, F_LostMatchPoint = 0 WHERE F_PhaseID = @PhaseID
	    
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
									[F_NOC]                     NVARCHAR(10),
									[F_PhaseResultNumber]		[int],
									[F_RegisterID]				[int],
									[F_PhasePoints]				[int],
									[F_PhaseRank]				[int],
									[F_PhaseDisplayPosition]	[int],
									[F_TiesWon]				    [int],
									[F_TiesLost]			    [int],
									[F_MatchesWon]              [int],
									[F_MatchesLost]             [int],
									[F_MatchDif]                [int],
									[F_GamesWon]                [int],
									[F_GamesLost]               [int],
									[F_GamesDif]                [int],
									[F_PointsWon]               [int],
									[F_PointsLost]              [int],
									[F_PointsDif]               [int],
									[F_RankPts]                 [int],
									[F_RankMatches]             [int],
									[F_RankGames]               [int],
									[F_RankPoints]              [int]
								) 
								
	CREATE TABLE #tmp_Table(
	                                F_RegisterID               int,
	                                F_OppRegisterID            int,
	                                F_NOC                      NVARCHAR(10),
	                                F_Rank                     int,
	                                F_DisplayPos               int,
	                                F_Pos                      int                            
	                        )
	                        
	INSERT INTO #tmp_GroupResult (F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_NOC)
	SELECT A.F_PhaseID, A.F_PhaseResultNumber, A.F_RegisterID, C.F_DelegationCode
	FROM TS_Phase_Result AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
	LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
	WHERE A.F_PhaseID = @PhaseID	

	UPDATE #tmp_GroupResult SET F_TiesWon = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 1, 1), F_TiesLost = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 1, 2)
	, F_MatchesWon = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 2, 1), F_MatchesLost = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 2, 2)
	, F_GamesWon = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 3, 1), F_GamesLost = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 3, 2)
	, F_PointsWon = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 4, 1), F_PointsLost = [dbo].[Fun_BD_GetMatchWonLost](F_PhaseID, F_RegisterID, 4, 2)
	
	UPDATE #tmp_GroupResult SET F_PhasePoints = @tmpWonMatchPoint * F_TiesWon + @tempLostMatchPoint * F_TiesLost, 
		F_MatchDif = F_MatchesWon - F_MatchesLost, F_GamesDif = F_GamesWon - F_GamesLost, F_PointsDif = F_PointsWon - F_PointsLost

    UPDATE #tmp_GroupResult SET F_RankPts = B.RankPts, F_RankMatches = B.RankMatches, F_RankGames = B.RankGames
	, F_RankPoints = B.RankPoints, F_PhaseRank = B.RankPoints, F_PhaseDisplayPosition = B.RankTotal
	FROM #tmp_GroupResult AS A 
	LEFT JOIN (SELECT RANK() OVER(ORDER BY F_PhasePoints DESC) AS RankPts
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_MatchDif DESC) AS RankMatches
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_MatchDif DESC, F_GamesDif DESC) AS RankGames
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_MatchDif DESC, F_GamesDif DESC, F_PointsDif DESC) AS RankPoints
	, RANK() OVER(ORDER BY F_PhasePoints DESC, F_MatchDif DESC, F_GamesDif DESC, F_PointsDif DESC, F_NOC) AS RankTotal, * FROM #tmp_GroupResult)
	AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhaseResultNumber = B.F_PhaseResultNumber
	
	DECLARE @DisplayPos AS INT
	DECLARE @SameCount AS INT
	
	WHILE EXISTS(SELECT DisposCount FROM (SELECT COUNT(F_RankPts) AS DisposCount, F_RankPts FROM #tmp_GroupResult GROUP BY F_RankPts) AS B WHERE B.DisposCount = 2 AND B.F_RankPts > 0)
	BEGIN
		    
	    SELECT TOP 1 @DisplayPos = F_RankPts FROM (SELECT F_RankPts, COUNT(F_RankPts) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankPts) AS B WHERE B.DisposCount = 2 AND B.F_RankPts > 0

	    DELETE FROM #tmp_Table
	        INSERT INTO #tmp_Table(F_RegisterID, F_NOC, F_Pos)
	          SELECT F_RegisterID, F_NOC, F_PhaseResultNumber FROM #tmp_GroupResult WHERE F_RankPts = @DisplayPos
	             
        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
          LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
        UPDATE #tmp_Table SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
		  FROM #tmp_Table AS A 
		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_NOC, F_Pos) AS DisplayPos, * FROM #tmp_Table)
		      AS B ON A.F_Pos = B.F_Pos

        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankPts = B.F_DisplayPos + @DisplayPos - 1, A.F_RankMatches = NULL, A.F_RankGames = NULL, A.F_RankPoints = NULL FROM #tmp_GroupResult AS A
          INNER JOIN #tmp_Table AS B ON A.F_PhaseResultNumber = B.F_Pos
	END
	
	WHILE EXISTS(SELECT DisposCount FROM (SELECT COUNT(F_RankMatches) AS DisposCount, F_RankMatches FROM #tmp_GroupResult GROUP BY F_RankMatches) AS B WHERE B.DisposCount = 2 AND B.F_RankMatches > 0)
	BEGIN
		    
	    SELECT TOP 1 @DisplayPos = F_RankMatches FROM (SELECT F_RankMatches, COUNT(F_RankMatches) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankMatches) AS B WHERE B.DisposCount = 2 AND B.F_RankMatches > 0

	    DELETE FROM #tmp_Table
	        INSERT INTO #tmp_Table(F_RegisterID, F_NOC, F_Pos)
	          SELECT F_RegisterID, F_NOC, F_PhaseResultNumber FROM #tmp_GroupResult WHERE F_RankMatches = @DisplayPos
	             
        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
          LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
        UPDATE #tmp_Table SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
		  FROM #tmp_Table AS A 
		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_NOC, F_Pos) AS DisplayPos, * FROM #tmp_Table)
		      AS B ON A.F_Pos = B.F_Pos

        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankMatches = B.F_DisplayPos + @DisplayPos - 1, A.F_RankGames = NULL, A.F_RankPoints = NULL FROM #tmp_GroupResult AS A
          INNER JOIN #tmp_Table AS B ON A.F_PhaseResultNumber = B.F_Pos
	END
	
	WHILE EXISTS(SELECT DisposCount FROM (SELECT COUNT(F_RankGames) AS DisposCount, F_RankGames FROM #tmp_GroupResult GROUP BY F_RankGames) AS B WHERE B.DisposCount = 2 AND B.F_RankGames > 0)
	BEGIN
		    
	    SELECT TOP 1 @DisplayPos = F_RankGames FROM (SELECT F_RankGames, COUNT(F_RankGames) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankGames) AS B WHERE B.DisposCount = 2 AND B.F_RankGames > 0

	    DELETE FROM #tmp_Table
	        INSERT INTO #tmp_Table(F_RegisterID, F_NOC, F_Pos)
	          SELECT F_RegisterID, F_NOC, F_PhaseResultNumber FROM #tmp_GroupResult WHERE F_RankGames = @DisplayPos
	             
        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
          LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
        UPDATE #tmp_Table SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
		  FROM #tmp_Table AS A 
		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_NOC, F_Pos) AS DisplayPos, * FROM #tmp_Table)
		      AS B ON A.F_Pos = B.F_Pos

        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankGames = B.F_DisplayPos + @DisplayPos - 1, A.F_RankPoints = NULL FROM #tmp_GroupResult AS A
          INNER JOIN #tmp_Table AS B ON A.F_PhaseResultNumber = B.F_Pos
	END
	
	WHILE EXISTS(SELECT DisposCount FROM (SELECT COUNT(F_RankPoints) AS DisposCount, F_RankPoints FROM #tmp_GroupResult GROUP BY F_RankPoints) AS B WHERE B.DisposCount = 2 AND B.F_RankPoints > 0)
	BEGIN
		    
	    SELECT TOP 1 @DisplayPos = F_RankPoints FROM (SELECT F_RankPoints, COUNT(F_RankPoints) AS DisposCount FROM #tmp_GroupResult GROUP BY F_RankPoints) AS B WHERE B.DisposCount = 2 AND B.F_RankPoints > 0

	    DELETE FROM #tmp_Table
	        INSERT INTO #tmp_Table(F_RegisterID, F_NOC, F_Pos)
	          SELECT F_RegisterID, F_NOC, F_PhaseResultNumber FROM #tmp_GroupResult WHERE F_RankPoints = @DisplayPos
	             
        UPDATE A SET A.F_OppRegisterID = B.F_RegisterID FROM #tmp_Table AS A LEFT JOIN #tmp_Table AS B ON A.F_RegisterID <> B.F_RegisterID
        
        UPDATE A SET A.F_DisplayPos = B.F_Rank FROM #tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_RegisterID = B.F_RegisterID
          LEFT JOIN TS_Match_Result AS C ON A.F_OppRegisterID  = C.F_RegisterID WHERE B.F_MatchID = C.F_MatchID
        
        UPDATE #tmp_Table SET F_Rank = B.FRank, F_DisplayPos = B.DisplayPos
		  FROM #tmp_Table AS A 
		    LEFT JOIN (SELECT RANK() OVER(ORDER BY F_DisplayPos) AS FRank, DENSE_RANK() OVER(ORDER BY F_DisplayPos, F_NOC, F_Pos) AS DisplayPos, * FROM #tmp_Table)
		      AS B ON A.F_Pos = B.F_Pos

        UPDATE A SET A.F_PhaseRank = B.F_Rank + @DisplayPos - 1, A.F_PhaseDisplayPosition = B.F_DisplayPos + @DisplayPos - 1, A.F_RankPoints = B.F_DisplayPos + @DisplayPos - 1 FROM #tmp_GroupResult AS A
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

