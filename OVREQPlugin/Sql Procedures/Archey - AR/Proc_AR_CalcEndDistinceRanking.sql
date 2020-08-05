IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_CalcEndDistinceRanking]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_CalcEndDistinceRanking]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_AR_CalcEndDistinceRanking]
--描    述：计算每种靶距排名
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年10月20日


CREATE PROCEDURE [dbo].[Proc_AR_CalcEndDistinceRanking](
												@MatchID		    INT,
												@Result 			AS INT OUTPUT
												)
As
Begin
	SET NOCOUNT ON 
	
	SET @Result = -1;  -- @Result=-1; 	失败，表示没有做任何操作！
					   -- @Result=1; 	成功！

	CREATE TABLE #Temp_Ranking
	(
		F_CompetitionPosition	int,
		F_RegisterID			int,
		F_DistinceA				int,
		F_DistinceB				int,
		F_DistinceC				int,
		F_DistinceD				int,
		F_10NumA				int,
		F_10NumB				int,
		F_10NumC				int,
		F_10NumD				int,
		F_XNumA					int,
		F_XNumB					int,
		F_XNumC					int,
		F_XNumD					int,
		F_RankA					NVARCHAR(10),
		F_RankB					NVARCHAR(10),
		F_RankC					NVARCHAR(10),
		F_RankD					NVARCHAR(10),
	)
	INSERT INTO #Temp_Ranking  (F_CompetitionPosition,F_RegisterID,F_DistinceA,F_DistinceB,F_DistinceC,F_DistinceD)
	(SELECT F_CompetitionPosition,F_RegisterID,F_PointsNumDes1,F_PointsNumDes2,F_PointsNumDes3,F_PointsNumDes4
		 FROM TS_Match_Result WHERE F_MatchID=@MatchID)
	
	UPDATE #Temp_Ranking
		 SET F_10NumA =  (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 1
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
		    ,F_XNumA =  (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 1
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0) FROM #Temp_Ranking AS T
	UPDATE #Temp_Ranking
		 SET F_10NumB =  (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 2
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
		    ,F_XNumB =  (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 2
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0) FROM #Temp_Ranking AS T
	UPDATE #Temp_Ranking
		 SET F_10NumC =  (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 3
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
		    ,F_XNumC =  (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 3
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0) FROM #Temp_Ranking AS T
	UPDATE #Temp_Ranking
		 SET F_10NumD =  (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 4
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
		    ,F_XNumD =  (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitPrecision = 4
				AND MSR.F_CompetitionPosition = T.F_CompetitionPosition
				AND MSI.F_MatchSplitType = 0) FROM #Temp_Ranking AS T		
		
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		-- 距离1
		-- 计算排名
			UPDATE TS_Match_Result SET F_PointsCharDes1 =CASE WHEN  F_PointsNumDes1 IS NOT NULL THEN RNK.F_Rnk ELSE '' END
				FROM
				(
					SELECT row_number() OVER 
							(ORDER BY TR.F_DistinceA DESC,TR.F_10NumA DESC, TR.F_XNumA DESC
								--, (CASE WHEN MR.F_IRMID IS NULL THEN 1 ELSE 0 END)  
								) AS F_Rnk, 
							TR.F_CompetitionPosition AS F_Pos
							,TR.F_RankA AS F_RankA							
						FROM #Temp_Ranking AS TR
				) AS RNK
				WHERE F_MatchID = @MatchID AND F_CompetitionPosition = RNK.F_Pos
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			RETURN
		END
		
		-- 距离2
		-- 计算排名
			UPDATE TS_Match_Result SET F_PointsCharDes2 = CASE WHEN  F_PointsNumDes2 IS NOT NULL THEN RNK.F_Rnk ELSE '' END
				FROM
				(
					SELECT row_number() OVER 
							(ORDER BY TR.F_DistinceB DESC,TR.F_10NumB DESC, TR.F_XNumB DESC
								--, (CASE WHEN MR.F_IRMID IS NULL THEN 1 ELSE 0 END)  
								) AS F_Rnk, 
							TR.F_CompetitionPosition AS F_Pos
							,TR.F_RankB AS F_RankB							
						FROM #Temp_Ranking AS TR
				) AS RNK
				WHERE F_MatchID = @MatchID AND F_CompetitionPosition = RNK.F_Pos
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			RETURN
		END
		
		-- 距离3
		-- 计算排名
			UPDATE TS_Match_Result SET F_PointsCharDes3 = CASE WHEN  F_PointsNumDes3 IS NOT NULL THEN RNK.F_Rnk ELSE '' END
				FROM
				(
					SELECT row_number() OVER 
							(ORDER BY TR.F_DistinceC DESC,TR.F_10NumC DESC, TR.F_XNumC DESC
								--, (CASE WHEN MR.F_IRMID IS NULL THEN 1 ELSE 0 END)  
								) AS F_Rnk, 
							TR.F_CompetitionPosition AS F_Pos
							,TR.F_RankC AS F_RankC							
						FROM #Temp_Ranking AS TR
				) AS RNK
				WHERE F_MatchID = @MatchID AND F_CompetitionPosition = RNK.F_Pos
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			RETURN
		END
			
		
		-- 距离4
		-- 计算排名
			UPDATE TS_Match_Result SET F_PointsCharDes4 = CASE WHEN  F_PointsNumDes4 IS NOT NULL THEN RNK.F_Rnk ELSE '' END
				FROM
				(
					SELECT row_number() OVER 
							(ORDER BY TR.F_DistinceD DESC,TR.F_10NumD DESC, TR.F_XNumD DESC
								--, (CASE WHEN MR.F_IRMID IS NULL THEN 1 ELSE 0 END)  
								) AS F_Rnk, 
							TR.F_CompetitionPosition AS F_Pos
							,TR.F_RankD AS F_RankD							
						FROM #Temp_Ranking AS TR
				) AS RNK
				WHERE F_MatchID = @MatchID AND F_CompetitionPosition = RNK.F_Pos
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			RETURN
		END
	
	COMMIT TRANSACTION --成功提交事务
	
	SET @Result = 1

	   
	Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF





GO


/*
DECLARE @Result
EXEC Proc_AR_CalcEndDistinceRanking 1,@Result output
return @Result
*/