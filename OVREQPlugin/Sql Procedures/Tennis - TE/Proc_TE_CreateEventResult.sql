if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_TE_CreateEventResult]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_TE_CreateEventResult]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_TE_CreateEventResult]
----功		  能：生成网球项目成绩排名
----作		  者：李燕
----日		  期: 2011-02-22
/*
	修改记录
	序号	日期			修改者		修改内容

*/
CREATE PROCEDURE [dbo].[Proc_TE_CreateEventResult] (	
													@EventID			INT
)	
AS
BEGIN
SET NOCOUNT ON

         DECLARE @EventCode       NVARCHAR(10)
         DECLARE @SexCode         INT
         DECLARE @QuarterCode     NVARCHAR(10)
         DECLARE @SemiCode        NVARCHAR(10)
         DECLARE @FinalCode       NVARCHAR(10)
         
         DECLARE @QuarterScore    INT
         DECLARE @SemiScore       INT
         DECLARE @SilverScore     INT
         DECLARE @GoldScore       INT
         
         DECLARE @SingleType      INT
         
         SET @QuarterCode = '3'
         SET @SemiCode = '2'
         SET @FinalCode = '1'
         
         SET @QuarterScore = 10
         SET @SemiScore = 25
         SET @SilverScore = 60
         SET @GoldScore = 100
         
         SET @SingleType = 1
         
         SELECT @EventCode = E.F_EventCode, @SexCode = E.F_SexCode FROM TS_Event AS E WHERE E.F_EventID = @EventID
         
         ---非团体赛，执行公共存储过程
         IF(@EventCode <> '003' AND @EventCode <> '103')
         BEGIN
           EXEC Proc_CreateEventResult_Original @EventID
         END
         ELSE
         BEGIN
              --创建虚拟队伍
              EXEC Proc_TE_CreatTeamForDelegation 'TE', @EventID, @SexCode
              
              CREATE TABLE #tmp_TeamEvent(F_EventID  INT)
              INSERT INTO #tmp_TeamEvent(F_EventID)
                 SELECT E.F_EventID FROM TS_Event AS E
                    WHERE E.F_SexCode = @SexCode AND E.F_EventID <> @EventID  --OR E.F_SexCode = 3    --是否考虑混合双打


              CREATE TABLE #tmp_TeamMedal(
                                     F_RegisterID      INT,
                                     F_DelegationID    INT,
                                     F_Score           INT,
                                     F_SingleScore     INT,
                                     F_Rank            INT)
               
              INSERT INTO #tmp_TeamMedal(F_RegisterID, F_DelegationID, F_Score, F_SingleScore)
                     SELECT I.F_RegisterID, R.F_DelegationID, 0, 0
                       FROM TR_Inscription AS I
                       LEFT JOIN TR_Register AS R ON I.F_RegisterID = R.F_RegisterID
                        WHERE I.F_EventID = @EventID
                           

              CREATE TABLE #tmp_TeamScore(
                                    F_MatchID        INT,
                                    F_RegisterID     INT,
                                    F_DelegationID   INT,
                                    F_EventTypeID    INT )
              
              ---5-8名10分
              INSERT INTO #tmp_TeamScore(F_MatchID,F_RegisterID, F_DelegationID,F_EventTypeID)
                     SELECT M.F_MatchID, R.F_RegisterID, R.F_DelegationID, E.F_PlayerRegTypeID
                      FROM TS_Match  AS M 
                       LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                       LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                       RIGHT JOIN TS_Match_Result AS MR ON M.F_MatchID = MR.F_MatchID 
                       LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
                      WHERE P.F_PhaseCode = @QuarterCode AND MR.F_Rank = 2 AND E.F_EventID IN (SELECT F_EventID FROM #tmp_TeamEvent)
                           
               
               UPDATE A SET A.F_Score = A.F_Score + ISNULL(B.F_Score, 0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @QuarterScore AS F_Score, F_DelegationID FROM #tmp_TeamScore GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID

               UPDATE A SET A.F_SingleScore = A.F_SingleScore + ISNULL(B.F_Score, 0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @QuarterScore AS F_Score, F_DelegationID FROM #tmp_TeamScore WHERE F_EventTypeID = @SingleType GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID


               ----3-4名25分
               DELETE FROM #tmp_TeamScore
               
               INSERT INTO #tmp_TeamScore(F_MatchID,F_RegisterID, F_DelegationID, F_EventTypeID)
                     SELECT M.F_MatchID, R.F_RegisterID, R.F_DelegationID, E.F_PlayerRegTypeID
                      FROM TS_Match  AS M 
                       LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                       LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                       RIGHT JOIN TS_Match_Result AS MR ON M.F_MatchID = MR.F_MatchID 
                       LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
                      WHERE P.F_PhaseCode = @SemiCode AND MR.F_Rank = 2 AND E.F_EventID IN (SELECT F_EventID FROM #tmp_TeamEvent)
               
               UPDATE A SET A.F_Score = A.F_Score + ISNULL(B.F_Score, 0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @SemiScore AS F_Score, F_DelegationID FROM #tmp_TeamScore GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID
                             

               UPDATE A SET A.F_SingleScore = A.F_SingleScore + ISNULL(B.F_Score, 0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @SemiScore AS F_Score, F_DelegationID FROM #tmp_TeamScore WHERE F_EventTypeID = @SingleType GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID

               ----2名60分
               DELETE FROM #tmp_TeamScore
               
             INSERT INTO #tmp_TeamScore(F_MatchID,F_RegisterID, F_DelegationID, F_EventTypeID)
                 SELECT M.F_MatchID, R.F_RegisterID, R.F_DelegationID, E.F_PlayerRegTypeID
                  FROM TS_Match  AS M 
                   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                   LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                   RIGHT JOIN TS_Match_Result AS MR ON M.F_MatchID = MR.F_MatchID 
                   LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
                  WHERE P.F_PhaseCode = @FinalCode AND MR.F_Rank = 2 AND E.F_EventID IN (SELECT F_EventID FROM #tmp_TeamEvent)
                      
               UPDATE A SET A.F_Score = A.F_Score + ISNULL(B.F_Score ,0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @SilverScore AS F_Score, F_DelegationID FROM #tmp_TeamScore GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID
               
               UPDATE A SET A.F_SingleScore = A.F_SingleScore + ISNULL(B.F_Score, 0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @SilverScore AS F_Score, F_DelegationID FROM #tmp_TeamScore WHERE F_EventTypeID = @SingleType GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID
                                        
              ----1名100分
               DELETE FROM #tmp_TeamScore
               
               INSERT INTO #tmp_TeamScore(F_MatchID,F_RegisterID, F_DelegationID, F_EventTypeID)
                 SELECT M.F_MatchID, R.F_RegisterID, R.F_DelegationID, E.F_PlayerRegTypeID
                  FROM TS_Match  AS M 
                   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
                   LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
                   RIGHT JOIN TS_Match_Result AS MR ON M.F_MatchID = MR.F_MatchID 
                   LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
                  WHERE P.F_PhaseCode = @FinalCode AND MR.F_Rank = 1 AND E.F_EventID IN (SELECT F_EventID FROM #tmp_TeamEvent)

               
               UPDATE A SET A.F_Score = A.F_Score + ISNULL(B.F_Score,0) 
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @GoldScore AS F_Score, F_DelegationID FROM #tmp_TeamScore GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID  
           
             
               UPDATE A SET A.F_SingleScore = A.F_SingleScore + ISNULL(B.F_Score, 0)
                      FROM #tmp_TeamMedal AS A LEFT JOIN (SELECT Count(F_DelegationID) * @GoldScore AS F_Score, F_DelegationID FROM #tmp_TeamScore WHERE F_EventTypeID = @SingleType GROUP BY F_DelegationID) AS B
                          ON A.F_DelegationID = B.F_DelegationID

               ---计算排名
               UPDATE #tmp_TeamMedal  SET F_Rank = B.F_Rank
                      FROM #tmp_TeamMedal AS A LEFT JOIN ( SELECT RANK()OVER (ORDER BY F_Score DESC, F_SingleScore DESC) AS F_Rank, F_DelegationID FROM  #tmp_TeamMedal) AS B 
                      ON A.F_DelegationID = B.F_DelegationID
            
            --select * from #tmp_TeamMedal
              SET Implicit_Transactions off
	          BEGIN TRANSACTION --设定事务

  
			  DELETE FROM TS_Event_Result WHERE F_EventID = @EventID
	
			  IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					RETURN
				END
				
			INSERT INTO TS_Event_Result (F_EventID, F_EventResultNumber, F_EventRank, F_RegisterID, F_EventDisplayPosition, F_EventPoints)
			  SELECT @EventID, RANK()OVER(ORDER BY F_Rank, F_DelegationID), F_Rank, F_RegisterID, RANK()OVER(ORDER BY F_Rank, F_DelegationID), F_Score
			     FROM #tmp_TeamMedal
			       WHERE F_Rank IN (1, 2, 3) ORDER BY F_Rank,F_DelegationID
			
			IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					RETURN
				END
			
			--为EventResult中的参赛者指定奖牌

	        UPDATE TS_Event_Result SET F_MedalID = ( CASE F_EventRank WHEN 1 THEN 1 WHEN  2 THEN 2 WHEN  3 THEN 3 ELSE NULL END) WHERE F_EventID = @EventID

			
			COMMIT TRANSACTION --成功提交事务
		               
         END
         

SET NOCOUNT OFF
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO



--exec [Proc_TE_CreateEventResult] 5
