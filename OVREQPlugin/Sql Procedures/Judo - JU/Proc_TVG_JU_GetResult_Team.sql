IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_JU_GetResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_JU_GetResult_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_TVG_JU_GetResult_Team]
--描    述: TVG团体赛成绩
--创 建 人: 宁顺泽
--日    期: 2011年5月23日 星期1
--修改记录：
/*			
	日期					修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_TVG_JU_GetResult_Team]
	@MatchID						INT,
	@MatchSplitID					INT	=-1
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		TEDE.F_EventLongName,
		TPDE.F_PhaseLongName,
		TCDE.F_CourtShortName,
		MR1.F_DelegationCode AS NOC_A,
		MR2.F_DelegationCode AS NOC_B,
		Convert(NVARCHAR(10),M1.IPP)+
			Convert(NVARCHAR(10),M1.WAZ)+
			Convert(NVARCHAR(10),M1.YUK)+
			CASE when M1.HX<> '' then M1.HX
			else 
				CASE when M1.S=1 then 'S1'
					 when M1.S=2 then 'S2'
					 when M1.S=3 then 'S3'
					 when M1.S=4 then 'S4'
					 else '' end
			end AS Result_Blue,
		M1.IPP AS I_A,
		M1.WAZ AS W_A,
		M1.YUK AS Y_A,
		CASE when M1.HX<> '' then M1.HX
			else 
				CASE when M1.S=1 then 'S1'
					 when M1.S=2 then 'S2'
					 when M1.S=3 then 'S3'
					 when M1.S=4 then 'S4'
					 else '' end
			end AS P_A,
		Convert(NVARCHAR(10),M2.IPP)+
			Convert(NVARCHAR(10),M2.WAZ)+
			Convert(NVARCHAR(10),M2.YUK)+
			CASE when M2.HX<> '' then M2.HX
			else 
				CASE when M2.S=1 then 'S1'
					 when M2.S=2 then 'S2'
					 when M2.S=3 then 'S3'
					 when M2.S=4 then 'S4'
					 else '' end
			end AS Result_White,
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
		CASE when M1.F_ResultID=1 then 'W'
			 else ''
		END AS WinSplit_A,
		CASE when M2.F_ResultID=1 then 'W'
			 else ''
		END AS WinSplit_B,
		convert(nvarchar(10),MR1.WinSets)+
			case when MR1.F_ResultID=1 then ' /W'
				 else '' end
			+N'  :  '
			+convert(nvarchar(10),MR2.WinSets)
			+case when MR2.F_ResultID=1 then ' /W'
				 else '' end  AS TotalScore
		,N'[Image]'+M1.F_DelegationCode AS [Image_Noc_A]
		,N'[Image]'+M2.F_DelegationCode AS [Image_Noc_B]
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
			RD.F_TvLongName,
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
			RD.F_PrintLongName,
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
		ON M.F_MatchID=MS.F_MatchID AND MS.F_MatchSplitStatusID>99 AND (MS.F_MatchSplitID=@MatchSplitID or @MatchSplitID=-1)
	LEFT JOIN
	(
		SELECT 
			MSRA.F_MatchID,
			MSRA.F_MatchSplitID,
			MSRA.F_Points,
			MSRA.F_ResultID,
			RD.F_TvLongName,
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
					WHEN MSRA.F_PointsCharDes3 = N'H' OR MSRA.F_PointsCharDes3 = N'X' THEN N'S' + MSRA.F_PointsCharDes3
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
		WHERE MSRA.F_MatchID=@MatchID AND MSRA.F_CompetitionPosition=1 AND (@MatchSplitID=-1 or MSRA.F_MatchSplitID=@MatchSplitID)
		
	) AS M1
		ON MS.F_MatchID=M1.F_MatchID AND MS.F_MatchSplitID=M1.F_MatchSplitID
	LEFT JOIN 
	(
		SELECT 
			MSRB.F_MatchID,
			MSRB.F_MatchSplitID,
			MSRB.F_Points,
			MSRb.F_ResultID,
			RD.F_TvLongName,
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
					WHEN MSRB.F_PointsCharDes3 = N'H' OR MSRB.F_PointsCharDes3 = N'X' THEN N'S' + MSRB.F_PointsCharDes3
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
		WHERE MSRB.F_MatchID=@MatchID AND MSRB.F_CompetitionPosition=2 AND (@MatchSplitID=-1 or MSRB.F_MatchSplitID=@MatchSplitID)
	) AS M2
		ON MS.F_MatchID=M2.F_MatchID AND MS.F_MatchSplitID=M2.F_MatchSplitID
	WHERE M.F_MatchID=@MatchID

SET NOCOUNT OFF
END

GO

/*
exec Proc_TVG_JU_GetResult_Team 413,1
exec Proc_TVG_JU_GetResult_Team 415
*/