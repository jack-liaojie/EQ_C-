IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_CumulativeCourseStatistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_CumulativeCourseStatistics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_GF_CumulativeCourseStatistics]
--描    述: 为C84B报表服务
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2010年10月06日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_GF_CumulativeCourseStatistics]
	@MatchID				INT
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
	    Hole                    INT,
	    [Length]                NVARCHAR(100),
		Par                     INT,
		Average                 DECIMAL(18,4),
		[Rank]					INT,
		[Hole in one]		    INT,
		Albatross               INT,
		Eagles                  INT,
		Birdies                 INT,
		Pars                    INT,
		Bogeys                  INT,
		[Double Bogeys]         INT,
		Others                  INT,
		F_HoleNum               INT,
		F_PlayerNum             INT
	)
	
	INSERT INTO #MatchResult(Hole, [Length], Par, [Hole in one], Albatross, Eagles, Birdies, Pars, Bogeys, [Double Bogeys], Others, F_HoleNum, F_PlayerNum)
	SELECT MSI.F_Order, MSI.F_MatchSplitComment1, MSI.F_MatchSplitComment
	,(SELECT COUNT(MSR.F_Points)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_Points = 1 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints = -3 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints = -2 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints = -1 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints = 0 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints = 1 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints = 2 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSR.F_SplitPoints > 2 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT SUM(CASE WHEN MSR.F_Points IS NULL THEN 0 ELSE MSR.F_Points END)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	,(SELECT COUNT(F_Points)
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Match_Split_Info AS MSI1 ON M.F_MatchID = MSI1.F_MatchID
	LEFT JOIN TS_Match_Split_Result AS MSR ON MSI1.F_MatchID = MSR.F_MatchID AND MSI1.F_MatchSplitID = MSR.F_MatchSplitID
	WHERE M.F_Order = 1 AND MSI1.F_Order = MSI.F_Order AND P.F_Order <= @PhaseOrder)
	
	FROM TS_Match_Split_Info AS MSI
	WHERE MSI.F_MatchID = @MatchID ORDER BY MSI.F_Order
	
	UPDATE #MatchResult SET Average = CAST(F_HoleNum AS DECIMAL(18, 4)) / CAST(F_PlayerNum AS DECIMAL(18, 4)) WHERE F_PlayerNum <> 0
    UPDATE #MatchResult SET [Rank] = B.RankPts
		FROM #MatchResult AS A 
		LEFT JOIN (SELECT RANK() OVER(ORDER BY (CASE WHEN Average IS NULL THEN 1 ELSE 0 END), Average) AS RankPts
		, * FROM #MatchResult)
		AS B ON A.Hole = B.Hole
		
	SELECT * FROM #MatchResult

SET NOCOUNT OFF
END

GO



