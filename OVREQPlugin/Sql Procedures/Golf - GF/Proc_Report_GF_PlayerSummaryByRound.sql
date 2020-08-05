IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_PlayerSummaryByRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_PlayerSummaryByRound]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_GF_PlayerSummaryByRound]
--描    述: 为C84A报表服务
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2011年03月07日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_GF_PlayerSummaryByRound]
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
	    F_MatchID               INT,
	    F_F_CompetitionPosition INT,
	    F_DelegationID          INT,
	    F_MemberOrder           INT,
	    F_RegisterID            INT,
	    [Round]                 NVARCHAR(100),
	    NOC                     NVARCHAR(10),
	    Name                    NVARCHAR(100),
		[Hole in one]           INT,
		Albatross               INT,
		Eagles					INT,
		Birdies					INT,
		Pars                    INT,
		Bogeys                  INT,
		[Double Bogeys]         INT,
		Others                  INT
	)
	
	INSERT INTO #MatchResult(F_PhaseID, F_MatchID, F_F_CompetitionPosition, F_DelegationID, F_MemberOrder, F_RegisterID, [Round], NOC, Name, [Hole in one], Albatross, Eagles, Birdies, Pars, Bogeys, [Double Bogeys], Others)
	SELECT P.F_PhaseID, M.F_MatchID, MR.F_CompetitionPosition, D.F_DelegationID
	, (select F_Order from TR_Register_Member where F_MemberRegisterID = R.F_RegisterID)
	, R.F_RegisterID, ('R' + cast(P.F_Order as NVARCHAR(2))) AS [Round] --PD.F_PhaseShortName
	, R.F_NOC 
	, RD.F_PrintLongName
	,(SELECT COUNT(MSR.F_Points)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_Points = 1)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints = -3)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints = -2)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints = -1)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints = 0)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints = 1)
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints = 2)
	,(SELECT COUNT(MSR.F_SplitPoints)	
	FROM TS_Match_Split_Result AS MSR
	WHERE M.F_PhaseID = P.F_PhaseID AND M.F_Order = 1 
	AND MSR.F_MatchID = M.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition 
	AND MSR.F_SplitPoints > 2)

	FROM TS_Match AS M
	LEFT JOIN TS_Match_Result AS MR ON M.F_MatchID = MR.F_MatchID
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID	
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID	AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID
	WHERE P.F_EventID = @EventID AND P.F_Order <= @PhaseOrder AND PD.F_LanguageCode = @LanguageCode
	ORDER BY P.F_Order,R.F_NOC

    UPDATE #MatchResult SET Name = '*' + name 
    WHERE F_MemberOrder is not null
    
	SELECT * FROM #MatchResult ORDER BY [Round],NOC,F_MemberOrder

SET NOCOUNT OFF
END

GO



