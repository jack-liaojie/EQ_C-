IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_GetResult_AllCourt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_GetResult_AllCourt]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_GetResult_AllCourt]
--描    述: SCB 获取所有场馆的比赛成绩.
--创 建 人: 邓年彩
--日    期: 2011年3月31日 星期四
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_SCB_JU_GetResult_AllCourt]
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
		,N'I' AS I
		,N'W' AS W
		,N'Y' As Y
		,N'P' AS P
		,N'Blue' AS [Blue]
		,N'White' AS [White]
		,N'[Image]Card_Blue' AS Image_Blue
		,N'[Image]Card_White' AS Image_White
		,CASE WHEN M1.F_ResultID = 1 THEN 'Win' ELSE '' END AS [W1]
		,CASE WHEN M2.F_ResultID = 1 THEN 'Win' ELSE '' END AS [W2]
		, M1.F_PrintLongName AS [Name_A]
		, M1.F_DelegationCode AS [NOCCode_A]
		, M2.F_PrintLongName AS [Name_B]
		, M2.F_DelegationCode AS [NOCCode_B]
		, M1.[IPP] AS [IPP_A]
		, M1.[WAZ] AS [WAZ_A]
		, M1.[YUK] AS [YUK_A]
		, CASE when ISNULL(M1.HX, '') <> '' then M1.HX
			else 
				CASE when M1.S=1 then 'S1'
					 when M1.S=2 then 'S2'
					 when M1.S=3 then 'S3'
					 when M1.S=4 then 'S4'
					 else '' end
			end AS [S_A]
		, M2.[IPP] AS [IPP_B]
		, M2.[WAZ] AS [WAZ_B]
		, M2.[YUK] AS [YUK_B]
		, CASE when ISNULL(M2.HX,'') <> '' then M2.HX
			else 
				CASE when M2.S=1 then 'S1'
					 when M2.S=2 then 'S2'
					 when M2.S=3 then 'S3'
					 when M2.S=4 then 'S4'
					 else '' end
			end AS [S_B]
		,N'[Image]'+M1.F_DelegationCode AS [Image_Noc_A]
		,N'[Image]'+M2.F_DelegationCode AS [Image_Noc_B]
		,TCDC.F_CourtLongName AS CourtName_CHN
		,TCDE.F_CourtLongName +N'（'+TCDC.F_CourtLongName +N'）' AS CourtName_ENG_CHN
		,TEDC.F_EventLongName AS EVentName_CHN
		,TEDE.F_EventLongName+N'（'+TEDC.F_EventLongName+N'）' AS EventName_ENG_CHN
		,TPDC.F_PhaseLongName AS PhaseName_CHN
		,TPDE.F_PhaseLongName+N'（'+TPDC.F_PhaseLongName+N'）' AS PhaseName_CHN_ENG 
		,TEDE.F_EventLongName+N' - '+TPDE.F_PhaseLongName AS Event_Phase
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
				, ISNULL(MR.F_PointsNumDes1, 0) AS [IPP]
				, ISNULL(MR.F_PointsNumDes2, 0) AS [WAZ]
				, ISNULL(MR.F_PointsNumDes3, 0) AS [YUK]
				, MR.F_PointsNumDes4 AS [S]
				, MR.F_PointsCharDes4 AS [HX]
				, Points = 
				CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN  MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
				END
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			WHERE MR.F_CompetitionPositionDes1 = 1
		) AS M1
		ON M.F_MatchID = M1.F_MatchID
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, RD.F_PrintLongName
				, D.F_DelegationCode
				, ISNULL(MR.F_PointsNumDes1, 0) AS [IPP]
				, ISNULL(MR.F_PointsNumDes2, 0) AS [WAZ]
				, ISNULL(MR.F_PointsNumDes3, 0) AS [YUK]
				, MR.F_PointsNumDes4 AS [S]
				, MR.F_PointsCharDes4 AS [HX]
				, Points = 
				CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN  MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
				END
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
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
GO

/*

-- Just for test
EXEC [Proc_SCB_JU_GetResult_AllCourt] 

*/