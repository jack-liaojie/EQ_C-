IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_TotalSummaryByRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_TotalSummaryByRound]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_GF_TotalSummaryByRound]
--描    述: 为C84A报表服务
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2011年03月07日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_GF_TotalSummaryByRound]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
	    F_PhaseID               INT,
	    [Round]                 NVARCHAR(100),
		[Hole in one]           INT,
		Albatross               INT,
		Eagles					INT,
		Birdies					INT,
		Pars                    INT,
		Bogeys                  INT,
		[Double Bogeys]         INT,
		Others                  INT
	)
	
	INSERT INTO #MatchResult(F_PhaseID, [Round], [Hole in one], Albatross, Eagles, Birdies, Pars, Bogeys, [Double Bogeys], Others)
	SELECT P.F_PhaseID, PD.F_PhaseShortName
	,(SELECT COUNT(MSR.F_Points)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_Points = 1)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints = -3)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints = -2)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints = -1)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints = 0)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints = 1)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints = 2)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Split_Result AS MSR ON M.F_MatchID = MSR.F_MatchID
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 AND MSR.F_SplitPoints > 2)
	
	FROM TS_Phase AS P
	LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID
	WHERE P.F_EventID = @EventID AND P.F_Order <= @PhaseOrder AND PD.F_LanguageCode = @LanguageCode
	ORDER BY P.F_Order

	SELECT * FROM #MatchResult

SET NOCOUNT OFF
END

GO



