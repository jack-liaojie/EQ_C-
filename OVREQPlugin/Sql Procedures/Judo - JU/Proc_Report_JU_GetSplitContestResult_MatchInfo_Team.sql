IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetSplitContestResult_MatchInfo_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetSplitContestResult_MatchInfo_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetSplitContestResult_MatchInfo_Team]
--描    述: 报表团体赛结果
--创 建 人: 宁顺泽
--日    期: 2011年1月7日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/

CREATE PROCEDURE [dbo].[Proc_Report_JU_GetSplitContestResult_MatchInfo_Team]
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		MS.F_MatchSplitComment1 AS [GoldenScore]
		,MS.F_MatchSplitComment2 AS [ContestTime]
		,CASE 
			WHEN M1.F_ResultID=1 THEN M1.F_PrintLongName+N' /W'
			WHEN M1.F_ResultID=2 THEN M1.F_PrintLongName
		END AS [PlayerNameA]
		,CASE
			WHEN M2.F_ResultID=1 THEN M2.F_PrintLongName+N' /W'
			WHEN M2.F_ResultID=2 THEN M2.F_PrintLongName
		END AS [PlayerNameB]
		,M1.F_Points AS PointsA
		,M2.F_Points AS PointsB
		,M1.F_MatchSplitID
		,M1.F_DelegationCode AS [CCodeA]
		,M2.F_DelegationCode AS [CCodeB]
		,M1.F_PrintLongName AS [Name_A]
		,M2.F_PrintLongName AS [Name_B]
		,M1.IPP AS [IPP_A]
		,M1.WAZ AS [WAZ_A]
		,M1.YUK AS [YUk_A]
		,M1.[S] AS [S_A]
		,[S_A1]=case when M1.S=1 then '1' else '0' end
		,[S_A2]=case when M1.S=2 then '1' else '0' end
		,[S_A3]=case when M1.S=3 then '1' else '0' end
		,[S_A4]=case when M1.HX<>'' then ''
						else 
							case when M1.S=4 then '1'   else '0' end
					end
		,M1.[HX] AS [HX_A]
		,M2.IPP AS [IPP_B]
		,M2.WAZ AS [WAZ_B]
		,M2.YUK AS [YUk_B]
		,M2.S AS [S_B]
		,[S_B1]=case when M2.S=1 then '1' else '0' end
		,[S_B2]=case when M2.S=2 then '1' else '0' end
		,[S_B3]=case when M2.S=3 then '1' else '0' end
		,[S_B4]=case when M2.HX<> '' then ''  
						else
							case when M2.S=4 then '1' else '0' end
					end
		,M2.HX AS [HX_B]
		, [Result] = 
				CASE DC.F_DecisionCode
					WHEN N'KIK' THEN DCD.F_DecisionLongName
					WHEN N'FUS' THEN DCD.F_DecisionLongName
					ELSE
						M1.ResultA+N'/'+M2.ResultB+
						CASE 
							WHEN LTRIM(RTRIM(MS.F_MatchSplitComment3)) <> N'' THEN N' (' + Ms.F_MatchSplitComment3 + N')'
							ELSE N''
						END+
						M1.HanteiA+M2.HanteiB
				END
		,M1.LeftPoints as points_Left
		,M1.LeftP as PLeft
		,M2.RightPoints as Points_right
		,M2.RightP as Pright
		,CASE WHEN LTRIM(RTRIM(MS.F_MatchSplitComment3)) <> N'' THEN N' (' + Ms.F_MatchSplitComment3 + N')' ELSE N'' END as IJK_technique
		,Hantei=M1.HanteiA+M2.HanteiB	
		,IRMCode=CASE DC.F_DecisionCode
					WHEN N'KIK' THEN DCD.F_DecisionLongName
					WHEN N'FUS' THEN DCD.F_DecisionLongName
					else N'' end
	FROM TS_Match_Split_Info AS MS
	LEFT JOIN
	(
		SELECT 
			MSRA.F_MatchID,
			MSRA.F_MatchSplitID,
			MSRA.F_Points,
			MSRA.F_ResultID,
			RD.F_PrintLongName,
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
					WHEN MSRA.F_SplitPointsNumDes3 > 0 THEN N'S'+ CONVERT(NVARCHAR(10), MSRA.F_SplitPointsNumDes3)
					ELSE N''
				END
			,[HanteiA] = CASE MSRA.F_PointsCharDes1 WHEN N'1' THEN N'(Hantei)' ELSE '' END	
			,LeftPoints= CONVERT(NVARCHAR(10), ISNULL(MSRA.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRA.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRA.F_PointsNumDes3, 0))
			,LeftP=CASE 
					WHEN MSRA.F_PointsCharDes3 = N'H' OR MSRA.F_PointsCharDes3 = N'X' THEN  MSRA.F_PointsCharDes3
					WHEN MSRA.F_SplitPointsNumDes3 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MSRA.F_SplitPointsNumDes3)
					ELSE N''
				END
		FROM TS_Match_Split_Result AS MSRA
		LEFT JOIN TR_Register AS R
			ON MSRA.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=RD.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
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
			RD.F_PrintLongName,
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
					WHEN MSRB.F_PointsCharDes3 = N'H' OR MSRB.F_PointsCharDes3 = N'X' THEN MSRB.F_PointsCharDes3
					WHEN MSRB.F_SplitPointsNumDes3 > 0 THEN N'S'+CONVERT(NVARCHAR(10), MSRB.F_SplitPointsNumDes3)
					ELSE N''
				END	
			,[HanteiB] = CASE MSRB.F_PointsCharDes1 WHEN N'1' THEN N'(Hantei)' ELSE '' END
			,RightPoints=
				CONVERT(NVARCHAR(10), ISNULL(MSRB.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRB.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MSRB.F_PointsNumDes3, 0))
			,RightP=CASE 
					WHEN MSRB.F_PointsCharDes3 = N'H' OR MSRB.F_PointsCharDes3 = N'X' THEN MSRB.F_PointsCharDes3
					WHEN MSRB.F_SplitPointsNumDes3 > 0 THEN N'S'+CONVERT(NVARCHAR(10), MSRB.F_SplitPointsNumDes3)
					ELSE N''
				END	
		FROM TS_Match_Split_Result AS MSRB
		LEFT JOIN TR_Register AS R
			ON MSRB.F_RegisterID=R.F_RegisterID
		LEFT JOIN TR_Register_Des AS RD
			ON R.F_RegisterID=Rd.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
		LEFT JOIN TC_Delegation AS D
			ON R.F_DelegationID=D.F_DelegationID
		WHERE MSRB.F_MatchID=@MatchID AND MSRB.F_CompetitionPosition=2
	) AS M2
		ON MS.F_MatchID=M2.F_MatchID AND MS.F_MatchSplitID=M2.F_MatchSplitID
	LEFT JOIN TC_Decision AS DC
		ON MS.F_DecisionID=DC.F_DecisionID
	LEFT JOIN TC_Decision_Des AS DCD
		ON DC.F_DecisionID=DCD.F_DecisionID AND DCD.F_LanguageCode=@LanguageCode
	WHERE MS.F_MatchID=@MatchID AND MS.F_MatchSplitStatusID in (100,110)

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetSplitContestResult_MatchInfo_Team] 45 ,'ENG'

*/
GO