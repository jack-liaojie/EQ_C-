IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_GetResult_Team_AllCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_GetResult_Team_AllCourt]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_GetResult_Team_AllCourt]
--描    述: 柔道项目.
--创 建 人: 宁顺泽
--日    期: 2011年6月26日 星期日
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_GetResult_Team_AllCourt]
	@SessionID						INT
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID			INT	
	SELECT @DisciplineID = F_DisciplineID FROM TS_Session WHERE F_SessionID = @SessionID
	
	SELECT 
		TEDE.F_EventLongName AS [Event_ENG]
		,TPDE.F_PhaseLongName AS [Phase_ENG]
		,RIGHT(TCDE.F_CourtShortName,1) AS [Court_ENG]
		,N'Blue' AS [Blue]
		,N'White' AS [White]
		,N'[Image]Card_Blue' AS Image_Blue
		,N'[Image]Card_White' AS Image_White
		,CASE WHEN M1.F_ResultID = 1 THEN 'Win' ELSE '' END AS [W1]
		,CASE WHEN M2.F_ResultID = 1 THEN 'Win' ELSE '' END AS [W2]
		
		,N'[Image]'+M1.F_DelegationCode AS [Image_Noc_A]
		,N'[Image]'+M2.F_DelegationCode AS [Image_Noc_B]
		,M1.TeamName AS TeamNameblue
		,M2.TeamName AS TeamNameWhite
		,M1.Winsets AS winsetBlue
		,M2.Winsets AS winSetWhite
		,TCDC.F_CourtShortName AS CourtName_CHN
		,TCDE.F_CourtShortName +N'（'+TCDC.F_CourtShortName +N'）' AS CourtName_ENG_CHN
		,TEDC.F_EventLongName AS EVentName_CHN
		,TEDE.F_EventLongName+N'（'+TEDC.F_EventLongName+N'）' AS EventName_ENG_CHN
		,TPDC.F_PhaseLongName AS PhaseName_CHN
		,TPDE.F_PhaseLongName+N'（'+TPDC.F_PhaseLongName+N'）' AS PhaseName_CHN_ENG 
		,TEDE.F_EventLongName+N' - '+TPDE.F_PhaseLongName as Event_Phase
	FROM TC_Court AS C
	INNER JOIN
		(
			SELECT DISTINCT M.F_CourtID
			FROM TS_Match AS M
			INNER JOIN TS_Phase AS P
				ON M.F_PhaseID = P.F_PhaseID
			INNER JOIN TS_Event AS E
				ON P.F_EventID = E.F_EventID
			WHERE E.F_DisciplineID = @DisciplineID
				AND M.F_SessionID = @SessionID
		) AS EC
		ON C.F_CourtID = EC.F_CourtID
	INNER JOIN TS_Match AS M
		ON M.F_MatchID = dbo.[Func_SCB_JU_GetSessionCourtCurrentMatchID](@SessionID, C.F_CourtID)
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, RD.F_PrintLongName
				, D.F_DelegationCode 
				,DD.F_DelegationLongName AS TeamName
				,ISNULL(MR.F_WinSets,0) as Winsets
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS DD 
				ON DD.F_LanguageCode=N'ENG' AND DD.F_DelegationID=D.F_DelegationID
			WHERE MR.F_CompetitionPositionDes1 = 1
		) AS M1
		ON M.F_MatchID = M1.F_MatchID
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, RD.F_PrintLongName
				, D.F_DelegationCode
				,DD.F_DelegationLongName aS TeamName
				,ISNULL(MR.F_WinSets,0) AS Winsets
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS DD 
				ON DD.F_LanguageCode=N'ENG' AND DD.F_DelegationID=D.F_DelegationID
			WHERE MR.F_CompetitionPositionDes1 = 2
		) AS M2
		ON M.F_MatchID = M2.F_MatchID
	LEFT JOIN TC_Decision AS DC
		On M.F_DecisionID = DC.F_DecisionID
	LEFT JOIN TC_Decision_Des AS DCD
		ON DC.F_DecisionID = DCD.F_DecisionID AND DCD.F_LanguageCode = 'ENG'
	INNER JOIN TS_Phase AS TP
		ON M.F_PhaseID=TP.F_PhaseID
	LEFT JOIN TS_Phase_Des AS TPDE
		ON M.F_PhaseID=TPDE.F_PhaseID AND TPDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Phase_Des AS TPDC
		ON M.F_PhaseID=TPDC.F_PhaseID AND TPDC.F_LanguageCode='CHN'
	INNER JOIN TS_Event AS TE
		ON TP.F_EventID=TE.F_EventID
	LEFT JOIN TS_Event_Des AS TEDE
		ON TE.F_EventID=TEDE.F_EventID AND TEDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Event_Des AS TEDC
		ON TE.F_EventID=TEDC.F_EventID AND TEDC.F_LanguageCode='CHN'
	LEFT JOIN TC_Court_Des AS TCDE
		ON M.F_CourtID=TCDE.F_CourtID AND TCDE.F_LanguageCode='ENG'
	LEFT JOIN TC_Court_Des AS TCDC
		ON M.F_CourtID=TCDC.F_CourtID AND TCDC.F_LanguageCode='CHN'
	ORDER BY C.F_CourtCode


SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDataEntryTitle] 

*/