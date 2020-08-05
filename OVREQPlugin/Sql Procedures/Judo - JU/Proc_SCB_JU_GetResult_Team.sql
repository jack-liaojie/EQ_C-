IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_JU_GetResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_JU_GetResult_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_JU_GetResult_Team]
--描    述: 屏幕团体赛成绩
--创 建 人: 宁顺泽
--日    期: 2011年3月2日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_SCB_JU_GetResult_Team]
	@MatchID						INT
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		TEDE.F_EventLongName,
		TPDE.F_PhaseLongName,
		TCDE.F_CourtShortName,
		MR1.TeamName AS NOC_A,
		MR2.TeamName AS NOC_B,
		N'Blue' AS BLue,
		N'[Image]Card_Blue' AS Image_Blue,
		N'White' AS White,
		N'[Image]Card_White' AS Image_White,
		N'I' AS I,
		N'W' AS W,
		N'Y' AS Y,
		N'P' AS P,
		M1.IPP AS I_A,
		M1.WAZ AS W_A,
		M1.YUK AS Y_A,
		M1.Name AS NameBlue,
		M2.Name as NameWhite,
		CASE when M1.HX<> '' then M1.HX
			else 
				CASE when M1.S=1 then 'S1'
					 when M1.S=2 then 'S2'
					 when M1.S=3 then 'S3'
					 when M1.S=4 then 'S4'
					 else '' end
			end AS P_A,
		M2.IPP AS I_B,
		M2.WAZ AS W_B,
		M2.YUK AS Y_B,
		CASE when M2.HX<> '' then M2.HX
			else 
				CASE when M2.S=1 then 'S1'
					 when M2.S=2 then 'S2'
					 when M2.S=3 then 'S3'
					 when M2.S=4 then 'S4'
					 else '' end
			end AS P_B,
		CASE when M1.F_ResultID=1 then 'WINNER'
			 when M1.F_ResultID=2 then ''
		END AS WinSplit_A,
		CASE when M2.F_ResultID=1 then 'WINNER'
			 when M2.F_ResultID=2 then ''
		END AS WinSplit_B,
			convert(nvarchar(10),ISNULL(MR1.WinSets,N'0'))
			+N':'
			+convert(nvarchar(10),ISNULL(MR2.WinSets,N'0'))
			 AS TotalScore
		,N'[Image]'+MR1.F_DelegationCode AS [Image_Noc_A]
		,N'[Image]'+MR2.F_DelegationCode AS [Image_Noc_B]
		,ISNULL(MS.F_Memo,N'') AS Weigh
		,case when MR1.F_ResultID=1 then 'Winner'
			else N'' end AS TeamResultA
		,case when MR2.F_ResultID=1 then 'Winner'
			else N'' end  AS TeamResultB
		,TCDC.F_CourtShortName AS CourtName_CHN
		,TCDE.F_CourtShortName +N'（'+TCDC.F_CourtShortName +N'）' AS CourtName_ENG_CHN
		,TEDC.F_EventLongName AS EVentName_CHN
		,TEDE.F_EventLongName+N'（'+TEDC.F_EventLongName+N'）' AS EventName_ENG_CHN
		,TPDC.F_PhaseLongName AS PhaseName_CHN
		,TPDE.F_PhaseLongName+N'（'+TPDC.F_PhaseLongName+N'）' AS PhaseName_CHN_ENG 
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS TP
		ON M.F_PhaseID=TP.F_PhaseID
	LEFT JOIN TS_Phase_Des AS TPDE
		ON M.F_PhaseID=TPDE.F_PhaseID AND TPDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Phase_Des AS TPDC
		ON M.F_PhaseID=TPDC.F_PhaseID AND TPDC.F_LanguageCode='CHN'
	LEFT JOIN TS_Event AS TE
		ON TP.F_EventID=TE.F_EventID
	LEFT JOIN TS_Event_Des AS TEDE
		ON TE.F_EventID=TEDE.F_EventID AND TEDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Event_Des AS TEDC
		ON TE.F_EventID=TEDC.F_EventID AND TEDC.F_LanguageCode='CHN'
	LEFT JOIN TC_Court_Des AS TCDE
		ON M.F_CourtID=TCDE.F_CourtID AND TCDE.F_LanguageCode='ENG'
	LEFT JOIN TC_Court_Des AS TCDC
		ON M.F_CourtID=TCDC.F_CourtID AND TCDC.F_LanguageCode='CHN'
	LEFT JOIN 
	(
		SELECT 
			MRA.F_MatchID,
			MRA.F_Points,
			ISNULL(MRA.F_WinSets,0) AS WinSets,
			MRA.F_ResultID,
			RD.F_PrintLongName as TeamName,
			D.F_DelegationCode
		FROM TS_Match_Result AS MRA
		LEFT JOIN TR_Register AS R
			ON MRA.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode='ENG'
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE F_MatchID=@MatchID AND F_CompetitionPositionDes1=1
	) AS MR1
		ON M.F_MatchID=MR1.F_MatchID
	LEFT JOIN 
	(
		SELECT 
			MRB.F_MatchID,
			MRB.F_Points,
			ISNULL(MRB.F_WinSets,0) AS WinSets,
			MRB.F_ResultID,
			RD.F_PrintLongName as TeamName,
			D.F_DelegationCode
		FROM TS_Match_Result AS MRB
		LEFT JOIN TR_Register AS R
			ON MRB.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode='ENG'
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE F_MatchID=@MatchID AND F_CompetitionPositionDes1=2
	) AS MR2
		ON M.F_MatchID=MR2.F_MatchID
	LEFT JOIN TS_Match_Split_Info AS MS
		ON M.F_MatchID=MS.F_MatchID 
	LEFT JOIN
	(
		SELECT 
			MSRA.F_MatchID,
			MSRA.F_MatchSplitID,
			MSRA.F_Points,
			MSRA.F_ResultID,
			RD.F_PrintLongName AS Name,
			D.F_DelegationCode,
			MSRA.F_PointsNumDes1 AS [IPP],
			MSRA.F_PointsNumDes2 AS [WAZ],
			MSRA.F_PointsNumDes3 AS [YUK],
			MSRA.F_SplitPointsNumDes3 AS [S],
			MSRA.F_PointsCharDes3 AS [HX],
			ResultA = 
				CONVERT(NVARCHAR(10), ISNULL(MSRA.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRA.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRA.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MSRA.F_PointsCharDes3 = N'H' OR MSRA.F_PointsCharDes3 = N'X' THEN  MSRA.F_PointsCharDes3
					WHEN MSRA.F_SplitPointsNumDes3 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MSRA.F_SplitPointsNumDes3)
					ELSE N''
				END	
		FROM TS_Match_Split_Result AS MSRA
		LEFT JOIN TR_Register AS R
			ON MSRA.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode='ENG'
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE MSRA.F_MatchID=@MatchID AND MSRA.F_CompetitionPosition=1
		
	) AS M1
		ON MS.F_MatchID=M1.F_MatchID AND MS.F_MatchSplitID=M1.F_MatchSplitID
	LEFT JOIN 
	(
		SELECT 
			MSRB.F_MatchID,
			MSRB.F_MatchSplitID,
			MSRB.F_Points,
			MSRb.F_ResultID,
			RD.F_PrintLongName AS Name,
			D.F_DelegationCode,
			MSRB.F_PointsNumDes1 AS [IPP],
			MSRB.F_PointsNumDes2 AS [WAZ],
			MSRB.F_PointsNumDes3 AS [YUK],
			MSRB.F_SplitPointsNumDes3 AS [S],
			MSRB.F_PointsCharDes3 AS [HX],
			ResultB = 
				CONVERT(NVARCHAR(10), ISNULL(MSRB.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRB.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRB.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MSRB.F_PointsCharDes3 = N'H' OR MSRB.F_PointsCharDes3 = N'X' THEN  MSRB.F_PointsCharDes3
					WHEN MSRB.F_SplitPointsNumDes3 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MSRB.F_SplitPointsNumDes3)
					ELSE N''
				END	
		FROM TS_Match_Split_Result AS MSRB
		LEFT JOIN TR_Register AS R
			ON MSRB.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=Rd.F_RegisterID AND RD.F_LanguageCode='ENG'
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE MSRB.F_MatchID=@MatchID AND MSRB.F_CompetitionPosition=2
	) AS M2
		ON MS.F_MatchID=M2.F_MatchID AND MS.F_MatchSplitID=M2.F_MatchSplitID
	WHERE M.F_MatchID=@MatchID

SET NOCOUNT OFF
END

Go
/*
+N'('+convert(nvarchar(10),MR2.F_Points)+N')'

*/