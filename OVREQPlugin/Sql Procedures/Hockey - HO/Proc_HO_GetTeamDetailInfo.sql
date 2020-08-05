IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_GetTeamDetailInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_GetTeamDetailInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_HO_GetTeamDetailInfo]
--描    述：得到比赛中队伍的比分
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月27日

CREATE PROCEDURE [dbo].[Proc_HO_GetTeamDetailInfo]
                 @MatchID             INT,   
                 @TeamID              INT,
                 @TeamPos             INT

AS
BEGIN
   SET NOCOUNT ON

       DECLARE @DisciplineID  INT
       SELECT @DisciplineID = C.F_DisciplineID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
              WHERE A.F_MatchID = @MatchID 
              
            CREATE TABLE #table_teaminfo(
                                             F_TeamID           INT,
                                             F_PtsSet1          INT,
                                             F_PtsSet2          INT,
                                             F_PtsExtra1        INT,
                                             F_PtsExtra2        INT,
                                             F_PtsPSO        INT,
                                            )
 
  
      INSERT INTO #table_teaminfo (F_TeamID) VALUES (@TeamID)
      
      UPDATE #table_teaminfo SET F_PtsSet1 = F_Points FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @TeamPos AND B.F_MatchSplitCode = '1'
     
      UPDATE #table_teaminfo SET F_PtsSet2 = F_Points FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @TeamPos AND B.F_MatchSplitCode = '2'
            
      UPDATE #table_teaminfo SET F_PtsExtra1 = F_Points FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @TeamPos AND B.F_MatchSplitCode = '3'
      
      UPDATE #table_teaminfo SET F_PtsExtra2 = F_Points FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @TeamPos AND B.F_MatchSplitCode = '4'
              
              UPDATE #table_teaminfo SET F_PtsPSO = F_Points FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
              WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @TeamPos AND B.F_MatchSplitCode = '51'
    SELECT * FROM #table_teaminfo
   
Set NOCOUNT OFF
End
