IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchSplitResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchSplitResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchSplitResults]
----功		  能：得到一场比赛的各盘各局的详细成绩信息,网球项目,实例化需要计算网球成绩的类
----作		  者：郑金勇 
----日		  期: 2010-09-25
----修 改 记  录： 
/*
                  李燕    2011-2-12     增加抢七小比分的存储
                  李燕    2011-6-27     为了团体比赛，增加SubMatchCode参数
*/

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchSplitResults] (	
	@MatchID					INT,
	@SubMatchCode               INT  --- -1:个人赛
)	
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #Temp_Results(	F_Level				INT, --0表示Match，1表示Set，2表示Game
								F_Status			INT,
								F_SetNum			INT,
								F_GameNum			INT,
								F_Position			INT,
								F_Server			INT,
								F_Points			INT,
								F_Rank				INT,
								F_TBPoint           INT)
	
	IF(@SubMatchCode = -1)
	BEGIN							
		INSERT INTO #Temp_Results (F_Level, F_Status, F_Position, F_Server, F_Points, F_Rank)
			SELECT 0 AS F_Level, B.F_MatchStatusID, A.F_CompetitionPosition AS F_Position, 0 AS F_Server, A.F_Points, A.F_Rank
				FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE A.F_MatchID = @MatchID
				
		INSERT INTO #Temp_Results (F_Level, F_Status, F_SetNum, F_Position, F_Server, F_Points, F_Rank, F_TBPoint)
			SELECT 1 AS F_Level, B.F_MatchSplitStatusID ,B.F_MatchSplitCode AS F_SetNum, A.F_CompetitionPosition AS F_Position, 0 AS F_Server, A.F_Points, A.F_Rank, A.F_SplitPoints
				FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitType = 1
		
		INSERT INTO #Temp_Results (F_Level, F_Status, F_SetNum, F_GameNum, F_Position, F_Server, F_Points, F_Rank)
			SELECT 2 AS F_Level, B.F_MatchSplitStatusID, C.F_MatchSplitCode AS F_SetNum, B.F_MatchSplitCode AS F_GameNum, A.F_CompetitionPosition  AS F_Position, A.F_Service AS F_Server, A.F_Points, A.F_Rank
				FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					LEFT JOIN TS_Match_Split_Info AS C ON B.F_FatherMatchSplitID = C.F_MatchSplitID AND C.F_MatchID = B.F_MatchID 
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_MatchSplitType = 1
	END
	ELSE
	BEGIN  ----团体比赛
	  INSERT INTO #Temp_Results (F_Level, F_Status, F_Position, F_Server, F_Points, F_Rank)
			SELECT 0 AS F_Level, B.F_MatchSplitStatusID, A.F_CompetitionPosition AS F_Position, 0 AS F_Server, A.F_Points, A.F_Rank
				FROM TS_Match_Split_Result AS A 
				  LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
		     WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SubMatchCode AND B.F_MatchSplitType = 3
				
		INSERT INTO #Temp_Results (F_Level, F_Status, F_SetNum, F_Position, F_Server, F_Points, F_Rank, F_TBPoint)
			SELECT 1 AS F_Level, B.F_MatchSplitStatusID ,B.F_MatchSplitCode AS F_SetNum, A.F_CompetitionPosition AS F_Position, 0 AS F_Server, A.F_Points, A.F_Rank, A.F_SplitPoints
				FROM TS_Match_Split_Result AS A 
				   LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
				   LEFT JOIN TS_Match_Split_Info AS C ON B.F_MatchID = C.F_MatchID AND B.F_FatherMatchSplitID = C.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND C.F_MatchSplitCode = @SubMatchCode AND C.F_MatchSplitType = 3 AND B.F_MatchSplitType = 1
		
		INSERT INTO #Temp_Results (F_Level, F_Status, F_SetNum, F_GameNum, F_Position, F_Server, F_Points, F_Rank)
			SELECT 2 AS F_Level, B.F_MatchSplitStatusID, C.F_MatchSplitCode AS F_SetNum, B.F_MatchSplitCode AS F_GameNum, A.F_CompetitionPosition  AS F_Position, A.F_Service AS F_Server, A.F_Points, A.F_Rank
				FROM TS_Match_Split_Result AS A 
				    LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					LEFT JOIN TS_Match_Split_Info AS C ON B.F_FatherMatchSplitID = C.F_MatchSplitID AND C.F_MatchID = B.F_MatchID 
					LEFT JOIN TS_Match_Split_Info AS D ON C.F_MatchID = D.F_MatchID AND C.F_FatherMatchSplitID = D.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND D.F_MatchSplitCode = @SubMatchCode AND D.F_MatchSplitType = 3 AND B.F_MatchSplitType = 2 AND C.F_MatchSplitType = 1
	END
	SELECT * FROM #Temp_Results ORDER BY F_Level, F_SetNum, F_GameNum
	
SET NOCOUNT OFF
END






GO

--EXEC [Proc_TE_GetMatchSplitResults] 1,1
