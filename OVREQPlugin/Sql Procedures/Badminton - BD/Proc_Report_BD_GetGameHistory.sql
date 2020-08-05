
/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetGameHistory]    Script Date: 05/03/2011 08:56:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetGameHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetGameHistory]
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetGameHistory]    Script Date: 05/03/2011 08:56:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_BD_GetGameHistory]
----功		  能：得到一场比赛的，一局的得分历程
----作		  者：李燕
----日		  期: 2011-03-13
----修 改 记  录：
/*
                 2011-5-3   李燕     修改比分为21:0的情况
*/

CREATE PROCEDURE [dbo].[Proc_Report_BD_GetGameHistory] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

----得到比赛分为几个Split，几个SplitNum
           CREATE TABLE #tmp_GetGameNum(
                                        F_MatchID            INT,
                                         F_MatchSplitID       INT,
                                         F_FatherSplitID      INT,
                                         F_MatchSplitNum      INT,
                                         F_MatchSplitType     INT,
                                         F_SplitStartTime     NVARCHAR(10),
                                         F_SplitEndTime       NVARCHAR(10),
                                         F_SpendTime          NVARCHAR(10),
                                         F_SplitOrder         INT,
                                         F_RegA1ID            INT,
                                         F_RegA2ID            INT,
                                         F_RegB1ID            INT,
                                         F_RegB2ID            INT,
                                         F_RegA1Name          NVARCHAR(100),
                                         F_RegA2Name          NVARCHAR(100),
                                         F_RegB1Name          NVARCHAR(100),
                                         F_RegB2Name          NVARCHAR(100),
                                         F_UMShortName        NVARCHAR(100),
                                         F_SVGShortName       NVARCHAR(100),
                                         F_UMNOC              NVARCHAR(10),
                                         F_SVGNOC             NVARCHAR(10),
                                         F_MinActionOrder     INT,
                                         F_MaxActionOrder     INT,
                                         F_ScoreDes1          NVARCHAR(20),
                                         F_ScoreDes2          NVARCHAR(20),
                                         F_ScoreDes3          NVARCHAR(20)
                                         )
           INSERT INTO #tmp_GetGameNum
                EXEC Proc_Report_BD_GetGameNum @MatchID, @LanguageCode
          
           
           CREATE TABLE #tmp_GameHistory(
                                          F_MatchID          INT,
                                          F_MatchSplitID     INT,
                                          F_FatherSplitID    INT,
                                          F_MatchSplitNum    INT,
                                          F_MatchSplitType   INT,
                                          F_A1RegID          INT,
                                          F_A2RegID          INT,
                                          F_B1RegID          INT,
                                          F_B2RegID          INT,
                                          F_A1Score          NVARCHAR(10),
                                          F_A2Score          NVARCHAR(10),
                                          F_B1Score          NVARCHAR(10),
                                          F_B2Score          NVARCHAR(10),
                                          F_CompetitionPosition  INT,
                                          F_RegisterID           INT,
                                          F_ActionOrder          INT,
                                          F_Score                INT,
                                          F_MaxOrder             INT,
                                         )
             INSERT INTO #tmp_GameHistory(F_MatchID, F_MatchSplitID, F_RegisterID, F_ActionOrder, F_Score, F_CompetitionPosition)
                  SELECT F_MatchID, F_MatchSplitID, F_RegisterID, F_ActionOrder, F_ActionDetail1, F_CompetitionPosition
                    FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
           
              
             UPDATE #tmp_GameHistory SET F_FatherSplitID = B.F_FatherSplitID, F_MatchSplitNum = B.F_MatchSplitNum
                                        ,F_MatchSplitType = B.F_MatchSplitType, F_A1RegID = B.F_RegA1ID, F_A2RegID = B.F_RegA2ID 
                                        ,F_B1RegID = B.F_RegB1ID, F_B2RegID = B.F_RegB2ID  
                      FROM #tmp_GameHistory AS A LEFT JOIN #tmp_GetGameNum AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
                              AND A.F_ActionOrder BETWEEN B.F_MinActionOrder AND B.F_MaxActionOrder
                  
             UPDATE #tmp_GameHistory SET F_A1Score = F_Score WHERE F_A1RegID = F_RegisterID  
             UPDATE #tmp_GameHistory SET F_A2Score = F_Score WHERE F_A2RegID = F_RegisterID  
             UPDATE #tmp_GameHistory SET F_B1Score = F_Score WHERE F_B1RegID = F_RegisterID  
             UPDATE #tmp_GameHistory SET F_B2Score = F_Score WHERE F_B2RegID = F_RegisterID      
             
             
             ---比分0与0的显示, S与R的显示 
			 INSERT INTO #tmp_GameHistory (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_A1RegID, F_A2RegID, F_B1RegID, F_B2RegID, F_ActionOrder, F_RegisterID, F_Score)
				  SELECT B.F_MatchID, B.F_MatchSplitID, B.F_FatherSplitID, B.F_MatchSplitNum, F_A1RegID, F_A2RegID, F_B1RegID, F_B2RegID,  -1, F_RegisterID, F_Score
					FROM  #tmp_GameHistory AS B 
					WHERE B.F_ActionOrder = 1 AND B.F_Score = 0 
                    
			 UPDATE #tmp_GameHistory SET F_A1Score = 'R' WHERE F_A1RegID = F_RegisterID  AND F_ActionOrder = -1
			 UPDATE #tmp_GameHistory SET F_A2Score = 'R' WHERE F_A2RegID = F_RegisterID  AND F_ActionOrder = -1
			 UPDATE #tmp_GameHistory SET F_B1Score = 'R' WHERE F_B1RegID = F_RegisterID  AND F_ActionOrder = -1
			 UPDATE #tmp_GameHistory SET F_B2Score = 'R' WHERE F_B2RegID = F_RegisterID  AND F_ActionOrder = -1
             
			 UPDATE A SET A.F_RegisterID = B.F_RegisterID 
				 FROM #tmp_GameHistory AS A LEFT JOIN #tmp_GameHistory AS B ON A.F_MatchSplitID = B.F_MatchSplitID 
					WHERE A.F_ActionOrder = -1 AND  B.F_ActionOrder = 2 AND B.F_Score = 0 
            
			 UPDATE #tmp_GameHistory SET F_A1Score = 'S' WHERE F_A1RegID = F_RegisterID  AND F_ActionOrder = -1
			 UPDATE #tmp_GameHistory SET F_A2Score = 'S' WHERE F_A2RegID = F_RegisterID  AND F_ActionOrder = -1
			 UPDATE #tmp_GameHistory SET F_B1Score = 'S' WHERE F_B1RegID = F_RegisterID  AND F_ActionOrder = -1
			 UPDATE #tmp_GameHistory SET F_B2Score = 'S' WHERE F_B2RegID = F_RegisterID  AND F_ActionOrder = -1 
			  
			  UPDATE A SET F_A1Score = B.F_Score FROM #tmp_GameHistory AS A LEFT JOIN #tmp_GameHistory AS B ON A.F_MatchSplitID = B.F_MatchSplitID
			     WHERE A.F_A1RegID = B.F_RegisterID AND A.F_ActionOrder = 1 AND B.F_ActionOrder = 2
			  
			  UPDATE A SET F_A2Score = B.F_Score FROM #tmp_GameHistory AS A LEFT JOIN #tmp_GameHistory AS B ON A.F_MatchSplitID = B.F_MatchSplitID
			     WHERE A.F_A2RegID = B.F_RegisterID AND A.F_ActionOrder = 1 AND B.F_ActionOrder = 2
			     
			 UPDATE A SET F_B1Score = B.F_Score FROM #tmp_GameHistory AS A LEFT JOIN #tmp_GameHistory AS B ON A.F_MatchSplitID = B.F_MatchSplitID
			     WHERE A.F_B1RegID = B.F_RegisterID AND A.F_ActionOrder = 1 AND B.F_ActionOrder = 2
			     
			 UPDATE A SET F_B2Score = B.F_Score FROM #tmp_GameHistory AS A LEFT JOIN #tmp_GameHistory AS B ON A.F_MatchSplitID = B.F_MatchSplitID
			     WHERE A.F_B2RegID = B.F_RegisterID AND A.F_ActionOrder = 1 AND B.F_ActionOrder = 2
			  
	         DELETE #tmp_GameHistory WHERE F_ActionOrder = 2 AND F_Score = 0   
             
             ---最终比分的双方都显示  
             UPDATE #tmp_GameHistory SET F_MaxOrder = B.F_Order
                       FROM #tmp_GameHistory AS A LEFT JOIN (SELECT F_MatchSplitID, MAX(F_ActionOrder) AS F_Order FROM #tmp_GameHistory GROUP BY F_MatchSplitID) AS B
                         ON A.F_MatchSplitID = B.F_MatchSplitID
                          
             
             UPDATE T SET T.F_A1Score = Y.F_A1Score
				, T.F_A2Score = Y.F_A2Score
				, T.F_B1Score = Y.F_B1Score
				, T.F_B2Score = Y.F_B2Score
             FROM #tmp_GameHistory AS T
             INNER JOIN
             (
				 SELECT F_MatchSplitID
					, CASE WHEN F_A1Score >= F_A2Score THEN F_A1Score ELSE NULL END AS F_A1Score
					, CASE WHEN F_A2Score > F_A1Score THEN F_A2Score ELSE NULL END AS F_A2Score
					, CASE WHEN F_B1Score >= F_B2Score THEN F_B1Score ELSE NULL END AS F_B1Score
					, CASE WHEN F_B2Score > F_B1Score THEN F_B2Score ELSE NULL END AS F_B2Score
				 FROM
				 (
					 SELECT F_MatchSplitID
						, MAX(CONVERT(INT, ISNULL(F_A1Score, -1))) AS F_A1Score
						, MAX(CONVERT(INT, ISNULL(F_A2Score, -1))) AS F_A2Score
						, MAX(CONVERT(INT, ISNULL(F_B1Score, -1))) AS F_B1Score
						, MAX(CONVERT(INT, ISNULL(F_B2Score, -1))) AS F_B2Score
					 FROM #tmp_GameHistory
					 WHERE F_ActionOrder <> -1
					 GROUP BY F_MatchSplitID
				 ) AS X
			) AS Y
				ON T.F_MatchSplitID = Y.F_MatchSplitID
			WHERE T.F_ActionOrder = T.F_MaxOrder 
			  
           ---不够36个球，补齐36个球
   --         DECLARE One_Cursor CURSOR FOR 
			--SELECT F_ FROM #tmp_ActionList 

			--OPEN One_Cursor
			--FETCH NEXT FROM One_Cursor INTO @FatherSplitID, @MatchSplitID, @ActionNum, @MinActionOrder, @MaxActionOrder
			           
			--WHILE @@FETCH_STATUS = 0
			--BEGIN
			--   IF(@ActionNum <= 36)
			--   BEGIN
			--        INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_MinActionOrder,F_MaxActionOrder)
			--         VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @MatchSplitNum, @MinActionOrder,@MaxActionOrder)
			         
			--         SET @MatchSplitNum = @MatchSplitNum + 1
			--   END
			--   ELSE 
			--   BEGIN
			--      INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_MinActionOrder,F_MaxActionOrder)
			--         VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @MatchSplitNum, @MinActionOrder,@MidActionOrder)
			         
			--         SET @MatchSplitNum = @MatchSplitNum + 1
			         
			--     INSERT INTO #tmp_GetGameNum (F_MatchID, F_MatchSplitID, F_FatherSplitID, F_MatchSplitNum, F_MinActionOrder,F_MaxActionOrder)
			--         VALUES(@MatchID, @MatchSplitID, @FatherSplitID, @MatchSplitNum, @MidActionOrder+1, @MaxActionOrder)
			         
			--         SET @MatchSplitNum = @MatchSplitNum + 1
			--   END
			--   FETCH NEXT FROM One_Cursor INTO @FatherSplitID, @MatchSplitID, @ActionNum, @MinActionOrder, @MaxActionOrder
			--END
           
           
           SELECT * FROM #tmp_GameHistory  Order By F_MatchSplitID, F_ActionOrder
           
SET NOCOUNT OFF
END 







GO


