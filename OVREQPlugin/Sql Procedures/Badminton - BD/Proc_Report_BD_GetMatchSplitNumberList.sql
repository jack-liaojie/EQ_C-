IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetMatchSplitNumberList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetMatchSplitNumberList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_BD_GetMatchSplitNumberList]
----功		  能：得到该Match的共比赛了几局
----作		  者：张翠霞
----日		  期: 2010-01-19



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetMatchSplitNumberList] 
                   (	
					@MatchID			INT
                   )	
AS
BEGIN
SET NOCOUNT ON

        CREATE TABLE #Temp_table(
                                   F_Order             INT  
                                )

    DECLARE @PosA INT
    DECLARE @PosB INT
    DECLARE @SplitID INT
    SELECT @PosA = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
    SELECT @PosB = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
    
    INSERT INTO #Temp_table(F_Order)
    SELECT DISTINCT A.F_Order
    FROM TS_Match_Split_Info AS A RIGHT JOIN TS_Match_ActionList AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID ORDER BY A.F_Order

    SELECT * FROM #Temp_table
SET NOCOUNT OFF
END


GO

