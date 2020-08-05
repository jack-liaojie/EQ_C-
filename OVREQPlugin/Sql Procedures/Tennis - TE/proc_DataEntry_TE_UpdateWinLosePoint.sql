IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_DataEntry_TE_UpdateWinLosePoint]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_DataEntry_TE_UpdateWinLosePoint]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_TE_UpdateWinLosePoint]
----功		  能：团体项目中，更新获胜盘、获胜局的分数
----作		  者：李燕
----日		  期: 2012-08-10
----修 改 记  录： 

CREATE PROCEDURE [dbo].[proc_DataEntry_TE_UpdateWinLosePoint] (	
	@MatchID						INT,
	@Result                         INT OUTPUT   ---- 0, 非团体赛
	                                             ---- 1, 团体赛
)	
AS
BEGIN
SET NOCOUNT ON

    SET  @Result = 0
    
    DECLARE @MatchType   INT
    DECLARE @HomeWinMatch    INT
    DECLARE @HomeLoseMatch   INT
    DECLARE @HomeWinSets     INT
    DECLARE @HomeLoseSets    INT
    DECLARE @HomeWinGames    INT
    DECLARE @HomeLoseGames   INT
    
    SELECT @MatchType = C.F_PlayerRegTypeID
       FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
             LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
         WHERE A.F_MatchID = @MatchID
          
    IF(@MatchType <> 3)
    BEGIN
        RETURN
    END
    
    SELECT @HomeWinMatch = A.F_Points, @HomeLoseMatch = B.F_Points
       FROM TS_Match_Result AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID 
       WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1 AND B.F_CompetitionPosition = 2
          
    
    SELECT @HomeWinSets = Sum(B.F_Points), @HomeLoseSets = Sum(C.F_Points)
       FROM TS_Match_Split_Info AS A 
		   LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
		   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
       WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 3 AND B.F_CompetitionPosition = 1 AND C.F_CompetitionPosition = 2 
	
    SELECT @HomeWinGames = Sum(B.F_Points), @HomeLoseGames = Sum(C.F_Points)
       FROM TS_Match_Split_Info AS A 
		   LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
		   LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
       WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition = 1 AND C.F_CompetitionPosition = 2
     
     UPDATE TS_Match_Result SET F_WinPoints = @HomeWinMatch, F_LosePoints = @HomeLoseMatch
                               , F_WinSets = @HomeWinSets, F_LoseSets = @HomeLoseSets
                               , F_WinSets_1 = @HomeWinGames, F_LoseSets_1 = @HomeLoseGames
            WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
            
     UPDATE TS_Match_Result SET F_WinPoints = @HomeLoseMatch, F_LosePoints = @HomeWinMatch
                               , F_WinSets = @HomeLoseSets, F_LoseSets = @HomeWinSets
                               , F_WinSets_1 = @HomeLoseGames, F_LoseSets_1 = @HomeWinGames
            WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
              
     SET @Result = 1
     RETURN	
SET NOCOUNT OFF
END





GO

--declare @e int 
--exec [proc_DataEntry_TE_UpdateWinLosePoint] 251, @e  output
--select @e

--select * from ts_Match_result where f_matchid = 251