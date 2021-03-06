IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetSetHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetSetHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









----存储过程名称：[Proc_Report_TE_GetSetHistory]
----功		  能：得到一场比赛的，一盘的得分历程
----作		  者：郑金勇 
----日		  期: 2009-08-12
----修 改 记  录：
/*
                  李燕    2011-2-17  修改该Set的最后得分
                  李燕    2011-6-8   修改没有Rank的Game的得分
                  李燕    2011-8-11  修改抢十局的球权
*/

CREATE PROCEDURE [dbo].[Proc_Report_TE_GetSetHistory] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

           CREATE TABLE #tmp_SetHistory(
                                         F_Set               NVARCHAR(50),
                                         F_AGames            NVARCHAR(50),
                                         F_BGames            NVARCHAR(50),
                                         F_ATBPoint          NVARCHAR(50),
                                         F_BTBPoint          NVARCHAR(50),
                                         F_SerPos            INT,
                                         F_ARank             INT,
                                         F_BRank             INT,
                                         F_SetID             INT,
                                         F_GameID            INT,
                                         F_GameCode          NVARCHAR(10)
                                         )
            INSERT INTO #tmp_SetHistory(F_Set, F_SetID, F_GameID, F_GameCode, F_ATBPoint, F_BTBPoint)
                SELECT '局' + MSRF.F_MatchSplitCode, MSRF.F_MatchSplitID, MSR.F_MatchSplitID, MSR.F_MatchSplitCode, '-1', '-1'
                   FROM TS_Match_Split_INFO AS MSR LEFT JOIN TS_Match_Split_Info AS MSRF ON MSR.F_FatherMatchSplitID = MSRF.F_MatchSplitID AND MSR.F_MatchID = MSRF.F_MatchID 
                   WHERE MSR.F_MatchSplitType = 2 AND MSR.F_MatchID = @MatchID

           
           UPDATE #tmp_SetHistory SET F_AGames = ISNULL(B.F_Games, 0) 
                 FROM #tmp_SetHistory AS A 
                    LEFT JOIN (SELECT TS.F_SetID, TS.F_GameID, COUNT(TMSR.F_MatchSplitID) AS F_Games
                               FROM #tmp_SetHistory AS TS 
                                   LEFT JOIN TS_Match_Split_Info AS MSI ON TS.F_SetID = MSI.F_FatherMatchSplitID 
                                   LEFT JOIN TS_Match_Split_Result AS TMSR ON MSI.F_MatchSplitID = TMSR.F_MatchSplitID AND MSI.F_MatchID = TMSR.F_MatchID AND TMSR.F_CompetitionPosition = 1 
                                  WHERE MSI.F_MatchSplitType = 2 AND  TMSR.F_Rank = 1 AND MSI.F_MatchID = @MatchID AND CAST(MSI.F_MatchSplitCode AS INT) <= CAST(TS.F_GameCode AS INT) ---AND MSI.F_MatchSplitStatusID = 110 
                                     GROUP BY TS.F_SetID, TS.F_GameID) AS B ON A.F_SetID =B.F_SetID AND  A.F_GameID = B.F_GameID

            UPDATE #tmp_SetHistory SET F_BGames = ISNULL(B.F_Games, 0) 
                 FROM #tmp_SetHistory AS A 
                    LEFT JOIN (SELECT TS.F_SetID, TS.F_GameID, COUNT(TMSR.F_MatchSplitID) AS F_Games
                               FROM #tmp_SetHistory AS TS 
                                   LEFT JOIN TS_Match_Split_Info AS MSI ON TS.F_SetID = MSI.F_FatherMatchSplitID  
                                   LEFT JOIN TS_Match_Split_Result AS TMSR ON MSI.F_MatchSplitID = TMSR.F_MatchSplitID  AND MSI.F_MatchID = TMSR.F_MatchID AND TMSR.F_CompetitionPosition = 2  
                                  WHERE MSI.F_MatchSplitType = 2 AND  TMSR.F_Rank = 1 AND MSI.F_MatchID = @MatchID AND CAST(MSI.F_MatchSplitCode AS INT) <= CAST(TS.F_GameCode AS INT) --- AND MSI.F_MatchSplitStatusID = 110
                                      GROUP BY TS.F_SetID, TS.F_GameID) AS B ON A.F_SetID =B.F_SetID AND A.F_GameID = B.F_GameID
                                      
                         
          
          ---抢十局
           UPDATE #tmp_SetHistory SET F_AGames = MSR1.F_Points, F_BGames = MSR2.F_Points
                FROM  #tmp_SetHistory AS A 
                    LEFT JOIN TS_Match_Split_Info AS MSI ON A.F_SetID = MSI.F_MatchSplitID
                    LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
                    LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
                 WHERE MSI.F_MatchID = @MatchID  AND MSI.F_MatchSplitComment1 = 1 AND MSI.F_MatchSplitComment2 = 1
                         
                  
           UPDATE #tmp_SetHistory SET F_SerPos = CASE WHEN B.F_Service = 1 THEN 1 ELSE CASE WHEN C.F_Service = 1 THEN 2 ELSE 3 END END,
                                      F_ARank = B.F_Rank, F_BRank = C.F_Rank     
                   FROM #tmp_SetHistory AS A 
                        LEFT JOIN TS_Match_Split_Result AS B ON A.F_GameID = B.F_MatchSplitID AND B.F_CompetitionPosition = 1
                        LEFT JOIN TS_Match_Split_Result AS C ON A.F_GameID = C.F_MatchSplitID AND C.F_CompetitionPosition = 2  
                   WHERE B.F_MatchID = @MatchID AND C.F_MatchID = @MatchID  
                   
                   
         ---抢十局的球权
           UPDATE #tmp_SetHistory SET F_SerPos = 3
                FROM  #tmp_SetHistory AS A 
                    LEFT JOIN TS_Match_Split_Info AS MSI ON A.F_SetID = MSI.F_MatchSplitID
                 WHERE MSI.F_MatchID = @MatchID  AND MSI.F_MatchSplitComment1 = 1 AND MSI.F_MatchSplitComment2 = 1                      
  
           UPDATE #tmp_SetHistory SET F_ATBPoint = B.F_SplitPoints, F_BTBPoint = C.F_SplitPoints
               FROM #tmp_SetHistory AS A 
                     LEFT JOIN TS_Match_Split_Info AS MSI ON A.F_SetID = MSI.F_MatchSplitID
                     LEFT JOIN TS_Match_Split_Result AS B ON MSI.F_MatchSplitID= B.F_MatchSplitID AND MSI.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
                     LEFT JOIN TS_Match_Split_Result AS C ON MSI.F_MatchSplitID = C.F_MatchSplitID AND MSI.F_MatchID = C.F_MatchID AND C.F_CompetitionPosition = 2
                  WHERE A.F_GameCode = '13' AND MSI.F_MatchSplitComment1 = 1 AND MSI.F_MatchID = @MatchID
                
           DELETE FROM #tmp_SetHistory WHERE (F_ARank = F_BRank) OR (F_ARank IS NULL AND F_BRank IS NULL)
          
     UPDATE #tmp_SetHistory SET F_AGames = F_AGames + (CASE WHEN F_ATBPoint = '-1' THEN '' ELSE '(' + F_ATBPoint + ')' END) WHERE F_ARank = 2
     UPDATE #tmp_SetHistory SET F_BGames = F_BGames + (CASE WHEN F_BTBPoint = '-1' THEN '' ELSE '(' + F_BTBPoint + ')' END) WHERE F_BRank = 2
      
     UPDATE #tmp_SetHistory SET F_AGames = (CASE WHEN F_SerPos = 1 THEN '*' ELSE '' END)  + F_AGames WHERE F_ATBPoint = '-1'
     UPDATE #tmp_SetHistory SET F_BGames = (CASE WHEN F_SerPos = 2 THEN '*' ELSE '' END)  + F_BGames WHERE F_BTBPoint = '-1'
     
     UPDATE #tmp_SetHistory SET F_AGames = RTRIM(F_AGames), F_BGames = RTRIM(F_BGames)
     
     SELECT F_Set,  F_AGames, F_BGames FROM  #tmp_SetHistory ORDER BY F_SetID, CAST( F_GameCode AS INT)
SET NOCOUNT OFF
END 





