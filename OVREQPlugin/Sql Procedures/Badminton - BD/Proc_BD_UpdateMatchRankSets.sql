IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_UpdateMatchRankSets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_UpdateMatchRankSets]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_BD_UpdateMatchRankSets]
--描    述：更新比赛胜分胜局
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月06日

CREATE  PROCEDURE [dbo].[Proc_BD_UpdateMatchRankSets](
				 @MatchID		    INT,--当前比赛的ID
                 @Result 			AS INT OUTPUT
)
	
AS
BEGIN
	
SET NOCOUNT ON
    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					  -- @Result = 1; 更新成功！
                      -- @Result = -1; 更新失败，该MatchID不存在！ 
    UPDATE TS_Match_Result SET F_Rank = F_ResultID WHERE F_MatchID = @MatchID

    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
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

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
 
      UPDATE TS_Match_Result SET F_WinSets = F_Points WHERE F_MatchID = @MatchID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LoseSets = (SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1) WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LoseSets = (SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2) WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


        DECLARE @WSets_1 INT
        DECLARE @WSets_2 INT
        DECLARE @LSets_1 INT
        DECLARE @LSets_2 INT
        DECLARE @WPoints INT
        DECLARE @LPoints INT

---创建MatchSplit Tree
     CREATE TABLE #table_Tree (
								F_MatchID				INT,
								F_MatchSplitID			INT,
								F_FatherMatchSplitID	INT,
                                F_NodeLeveL             INT
							  )

    DECLARE @NodeLevel INT
    SET @NodeLevel = 0

    INSERT INTO #table_Tree(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID,F_NodeLeveL)
	    SELECT F_MatchID, F_MatchSplitID, F_FatherMatchSplitID,0
		     FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0

	WHILE EXISTS ( SELECT F_MatchID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	BEGIN
		SET @NodeLevel = @NodeLevel + 1
		 UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

		INSERT INTO #table_Tree(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_NodeLeveL)
			SELECT A.F_MatchID, A.F_MatchSplitID, A.F_FatherMatchSplitID, 0
			FROM TS_Match_Split_Info AS A INNER JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID AND B.F_NodeLevel = @NodeLevel
	END
   
   SELECT @WSets_1 = SUM (CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END) 
              FROM TS_Match_Split_Result AS A 
                   INNER JOIN #table_Tree AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_NodeLeveL = 1
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1

   SELECT @LSets_1 = SUM (CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END) 
              FROM TS_Match_Split_Result AS A 
                   INNER JOIN #table_Tree AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_NodeLeveL = 1
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2

   SELECT @WSets_2 = SUM (CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END) 
              FROM TS_Match_Split_Result AS A 
                   INNER JOIN #table_Tree AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_NodeLeveL = 2 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1

   SELECT @LSets_2 = SUM (CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END) 
              FROM TS_Match_Split_Result AS A 
                   INNER JOIN #table_Tree AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_NodeLeveL = 2 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2


   SELECT @WPoints = SUM (CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END) 
              FROM TS_Match_Split_Result AS A 
                   INNER JOIN #table_Tree AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_NodeLeveL = 3 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1

   SELECT @LPoints = SUM (CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END) 
              FROM TS_Match_Split_Result AS A 
                   INNER JOIN #table_Tree AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_NodeLeveL = 3 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2


  ---更新MatchSplit ---Sets1
    UPDATE TS_Match_Result SET F_WinSets_1 = @WSets_1 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
 
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LoseSets_1 = @LSets_1 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_WinSets_1 = @LSets_1 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
      
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LoseSets_1 = @WSets_1 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
   
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

  ----更新Sets2
     UPDATE TS_Match_Result SET F_WinSets_2 = @WSets_2 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
 
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LoseSets_2 = @LSets_2 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_WinSets_2 = @LSets_2 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
      
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LoseSets_2 = @WSets_2 WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
   
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

 ----更新Points--GamePoints
     UPDATE TS_Match_Result SET F_WinPoints = @WPoints WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
 
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LosePoints = @LPoints WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
        
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_WinPoints = @LPoints WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
      
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        UPDATE TS_Match_Result SET F_LosePoints = @WPoints WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
   
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	



GO

