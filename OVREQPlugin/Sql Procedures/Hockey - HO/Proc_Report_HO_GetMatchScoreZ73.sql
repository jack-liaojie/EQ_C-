IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetMatchScoreZ73]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetMatchScoreZ73]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_HO_GetMatchScoreZ73]
----功		  能：得到当前Match的基础信息
----作		  者：张翠霞
----日		  期: 2012-09-05 

CREATE PROCEDURE [dbo].[Proc_Report_HO_GetMatchScoreZ73]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #TableScore(
                                        F_MatchID             INT,
                                        F_HHalf               INT,
                                        F_VHalf               INT,
                                        F_HFull               INT,
                                        F_VFull               INT,
                                        F_HExtra1             INT,
                                        F_VExtra1             INT,
                                        F_HExtra2             INT,
                                        F_VExtra2             INT,
                                        F_HPso                INT,
                                        F_VPso                INT,
                                        F_HHalfScore          INT,
                                        F_VHalfScore          INT,
                                        F_HFullScore          INT,
                                        F_VFullScore          INT,
                                        F_HExtraScore         INT,
                                        F_VExtraScore         INT,
                                        F_HPsoScore           INT,
                                        F_VPsoScore           INT                                  
                                 )
                                 
    CREATE TABLE #table_Match(
                                    F_SetName    NVARCHAR(20),
                                    F_Score      NVARCHAR(20)
                             )
                             
    INSERT INTO #TableScore(F_MatchID, F_HHalf, F_VHalf, F_HFull, F_VFull, F_HExtra1, F_VExtra1, F_HExtra2, F_VExtra2, F_HPso, F_VPso)
        SELECT M.F_MatchID
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 1)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 1)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 2)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 2)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 3)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 3)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 4)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 4)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 1 AND MSI.F_Order = 5)
        ,(SELECT MSR.F_Points FROM TS_Match_Split_Result AS MSR LEFT JOIN TS_Match_Split_Info AS MSI ON MSR.F_MatchID = MSI.F_MatchID AND MSR.F_MatchSplitID = MSI.F_MatchSplitID
          WHERE MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = 2 AND MSI.F_Order = 5)
        FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
        
        UPDATE #TableScore SET F_HHalfScore = F_HHalf, F_VHalfScore = F_VHalf, F_HFullScore = F_HHalf + F_HFull, F_VFullScore = F_VHalf + F_VFull
                              ,F_HExtraScore = F_HHalf + F_HFull + F_HExtra1 + F_HExtra2, F_VExtraScore = F_VHalf + F_VFull + F_VExtra1 + F_VExtra2
                              ,F_HPsoScore = F_HHalf + F_HFull + F_HExtra1 + F_HExtra2 + F_HPso, F_VPsoScore = F_VHalf + F_VFull + F_VExtra1 + F_VExtra2 + F_VPso

    INSERT INTO #table_Match(F_SetName, F_Score)
    SELECT (CASE WHEN @LanguageCode = 'CHN' THEN '全场比赛时间' ELSE 'Full Time' END)
    , CAST (F_HFullScore AS NVARCHAR(5)) + ' - ' + CAST (F_VFullScore AS NVARCHAR(5))
    FROM #TableScore
    
    INSERT INTO #table_Match(F_SetName, F_Score)
    SELECT (CASE WHEN @LanguageCode = 'CHN' THEN '中场休息' ELSE 'Halftime' END)
    , CAST (F_HHalf AS NVARCHAR(5)) + ' - ' + CAST (F_VHalf AS NVARCHAR(5))
    FROM #TableScore
    
    INSERT INTO #table_Match(F_SetName, F_Score)
    SELECT (CASE WHEN @LanguageCode = 'CHN' THEN '加时时间' ELSE 'Extra Time' END)
    , CAST (F_HExtraScore AS NVARCHAR(5)) + ' - ' + CAST (F_VExtraScore AS NVARCHAR(5))
    FROM #TableScore WHERE F_HExtraScore IS NOT NULL AND F_VExtraScore IS NOT NULL
    
    INSERT INTO #table_Match(F_SetName, F_Score)
    SELECT (CASE WHEN @LanguageCode = 'CHN' THEN '点球' ELSE 'Penalty Strokes' END)
    , CAST (F_HPso AS NVARCHAR(5)) + ' - ' + CAST (F_VPso AS NVARCHAR(5))
    FROM #TableScore WHERE F_HPso IS NOT NULL AND F_VPso IS NOT NULL

    SELECT * FROM #table_Match

Set NOCOUNT OFF
End

GO

/*EXEC Proc_Report_HO_GetMatchScoreZ73 18, 'CHN'*/

