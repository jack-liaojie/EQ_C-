IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_TeamSummaryByRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_TeamSummaryByRound]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_GF_TeamSummaryByRound]
--描    述: 为C84A报表服务
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2011年03月07日
--修改记录：
/*			
			时间				修改人		修改内容	
			2012年09月13日      吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/



CREATE PROCEDURE [dbo].[Proc_Report_GF_TeamSummaryByRound]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    DECLARE @SexCode AS INT
    
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID, @SexCode = E.F_SexCode
    FROM TS_Match AS M 
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID 
    WHERE M.F_MatchID = @MatchID

	-- 创建临时表, 加入基本字段
	CREATE TABLE #MatchResult
	(
	    F_PhaseID               INT,
	    F_MatchID               INT,
	    F_DelegationID          INT,
	    F_MemberCount           INT,
	    [Round]                 NVARCHAR(100),
	    NOC                     NVARCHAR(10),
	    Delegation              NVARCHAR(20),
	    Name                    NVARCHAR(100),
		[Hole in one]           NVARCHAR(10),
		Albatross               NVARCHAR(10),
		Eagles					NVARCHAR(10),
		Birdies					NVARCHAR(10),
		Pars                    NVARCHAR(10),
		Bogeys                  NVARCHAR(10),
		[Double Bogeys]         NVARCHAR(10),
		Others                  NVARCHAR(10)
	)
	
	
	
	INSERT INTO #MatchResult(F_PhaseID, F_MatchID, F_DelegationID, F_MemberCount, [Round], NOC, Delegation,
	[Hole in one],Albatross,Eagles,Birdies,Pars,Bogeys,[Double Bogeys],Others)
	SELECT distinct P.F_PhaseID, M.F_MatchID, D.F_DelegationID
	, (select count(F_MemberRegisterID) from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode))
	, PD.F_PhaseShortName
	, D.F_DelegationCode
	, DD.F_DelegationLongName
	,(SELECT COUNT(MSR.F_Points)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_Points = 1)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_SplitPoints = -3)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_SplitPoints = -2)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_SplitPoints = -1)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_SplitPoints = 0)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_Points = 1)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_SplitPoints = 2)	
	,(SELECT COUNT(MSR.F_SplitPoints)
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Result AS TMR ON MSR.F_MatchID = TMR.F_MatchID AND MSR.F_CompetitionPosition = TMR.F_CompetitionPosition
	WHERE MSR.F_MatchID = M.F_MatchID AND TMR.F_RegisterID IN (select F_MemberRegisterID from TR_Register_Member where F_RegisterID in (
	select F_RegisterID from TR_Register as r where r.F_DelegationID = D.F_DelegationID and F_RegTypeID = 3 and F_SexCode = @SexCode)) 
	AND MSR.F_SplitPoints > 2)	
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Result AS MR ON M.F_MatchID = MR.F_MatchID
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID	
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID	AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID
	WHERE P.F_EventID = @EventID AND P.F_Order <= @PhaseOrder AND PD.F_LanguageCode = @LanguageCode
	--ORDER BY P.F_Order,R.F_NOC

    UPDATE #MatchResult SET [Hole in one] = '-', Albatross = '-', Eagles = '-', Birdies = '-',
		Pars = '-', Bogeys = '-', [Double Bogeys] = '-', Others = '-'
    WHERE F_MemberCount is null or F_MemberCount = 0

	SELECT * FROM #MatchResult

SET NOCOUNT OFF
END

GO



