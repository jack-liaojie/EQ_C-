IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetContestResult_MatchInfo_Individual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetContestResult_MatchInfo_Individual]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetContestResult_MatchInfo_Individual]
--描    述: C71 Contest Result 获取 MatchInfo 信息.
--创 建 人: 邓年彩
--日    期: 2010年11月6日 星期六
--修改记录：
/*			
	日期					修改人		修改内容
	2011年3月30号			宁顺泽		添加裁判判罚Hantei
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetContestResult_MatchInfo_Individual]
	@MatchID						INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SELECT M.F_MatchComment3 AS [GoldenScore]
		, M.F_MatchComment4 AS [ContestTime]
		, CASE 
			WHEN M1.F_ResultID = 1 THEN M1.F_PrintLongName
			WHEN M2.F_ResultID = 1 THEN M2.F_PrintLongName
		END AS [Name_Winner]
		, CASE 
			WHEN M1.F_ResultID = 1 THEN M1.F_DelegationCode
			WHEN M2.F_ResultID = 1 THEN M2.F_DelegationCode
		END AS [NOCCode_Winner]
		, CASE 
			WHEN M1.F_ResultID = 2 THEN M1.F_PrintLongName
			WHEN M2.F_ResultID = 2 THEN M2.F_PrintLongName
		END AS [Name_Loser]
		, CASE 
			WHEN M1.F_ResultID = 2 THEN M1.F_DelegationCode
			WHEN M2.F_ResultID = 2 THEN M2.F_DelegationCode
		END AS [NOCCode_Loser]
		, M1.F_PrintLongName AS [Name_A]
		, M1.F_DelegationCode AS [NOCCode_A]
		, M2.F_PrintLongName AS [Name_B]
		, M2.F_DelegationCode AS [NOCCode_B]
		, M1.[IPP] AS [IPP_A]
		, M1.[WAZ] AS [WAZ_A]
		, M1.[YUK] AS [YUK_A]
		, M1.[S] AS [S_A]
		,[S_A1]=case when M1.S=1 then '1' else '0' end
		,[S_A2]=case when M1.S=2 then '1' else '0' end
		,[S_A3]=case when M1.S=3 then '1' else '0' end
		,[S_A4]=case when M1.HX<>'' then ''
						else 
							case when M1.S=4 then '1'   else '0' end
					end
		, M1.[HX] AS [HX_A]
		, M2.[IPP] AS [IPP_B]
		, M2.[WAZ] AS [WAZ_B]
		, M2.[YUK] AS [YUK_B]
		, M2.[S] AS [S_B]
		,[S_B1]=case when M2.S=1 then '1' else '0' end
		,[S_B2]=case when M2.S=2 then '1' else '0' end
		,[S_B3]=case when M2.S=3 then '1' else '0' end
		,[S_B4]=case when M2.HX<> '' then ''  
						else
							case when M2.S=4 then '1' else '0' end
					end
		, M2.[HX] AS [HX_B]
		, [Result] = CASE DC.F_DecisionCode 
			WHEN N'KIK' THEN DCD.F_DecisionLongName
			WHEN N'FUS' THEN DCD.F_DecisionLongName
			ELSE CASE
					WHEN M1.F_ResultID = 1 THEN M1.Points
					WHEN M2.F_ResultID = 1 THEN M2.Points
				END
				+ N' / '
				+ CASE
					WHEN M1.F_ResultID = 2 THEN M1.Points
					WHEN M2.F_ResultID = 2 THEN M2.Points
				END
				+ CASE 
					WHEN LTRIM(RTRIM(M.F_MatchComment5)) <> N'' THEN N' (' + M.F_MatchComment5 + N')'
					ELSE N''
				END
				+M1.HanteiA+M2.HanteiB
			
		END
		,ResultLeft=CASE
					WHEN M1.F_ResultID = 1 THEN M1.Score
					WHEN M2.F_ResultID = 1 THEN M2.Score
				END
		,PLeft=CASE
					WHEN M1.F_ResultID = 1 THEN M1.p
					WHEN M2.F_ResultID = 1 THEN M2.P
				END
		,ResultRight=CASE
					WHEN M1.F_ResultID = 2 THEN M1.Score
					WHEN M2.F_ResultID = 2 THEN M2.Score
				END
		,Pright=CASE
					WHEN M1.F_ResultID = 2 THEN M1.p
					WHEN M2.F_ResultID = 2 THEN M2.P
				END
		,PCenter=CASE DC.F_DecisionCode 
			WHEN N'KIK' THEN DCD.F_DecisionLongName
			WHEN N'FUS' THEN DCD.F_DecisionLongName
			else N''
			end
		,Hantei=M1.HanteiA+M2.HanteiB
		,IJK=CASE 
					WHEN LTRIM(RTRIM(M.F_MatchComment5)) <> N'' THEN N' (' + M.F_MatchComment5 + N')'
					ELSE N''
				END
	FROM TS_Match AS M
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, RD.F_PrintLongName
				, D.F_DelegationCode
				, MR.F_PointsNumDes1 AS [IPP]
				, MR.F_PointsNumDes2 AS [WAZ]
				, MR.F_PointsNumDes3 AS [YUK]
				, MR.F_PointsNumDes4 AS [S]
				, MR.F_PointsCharDes4 AS [HX]
				, Points = 
				CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S'+  CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
				END
				,Score=CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				,p=CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN  MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S'+ CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
					end
				,[HanteiA] = CASE MR.F_PointsCharDes1 WHEN N'1' THEN N'(Hantei)' ELSE '' END	
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_CompetitionPositionDes1 = 1
		) AS M1
		ON M.F_MatchID = M1.F_MatchID
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, RD.F_PrintLongName
				, D.F_DelegationCode
				, MR.F_PointsNumDes1 AS [IPP]
				, MR.F_PointsNumDes2 AS [WAZ]
				, MR.F_PointsNumDes3 AS [YUK]
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
				,Score=CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				,p=CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN  MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S' + CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
					end
				,[HanteiB] = CASE MR.F_PointsCharDes1 WHEN N'1' THEN N'(Hantei)' ELSE '' END
			FROM TS_Match_Result AS MR
			LEFT JOIN TR_Register AS R
				ON MR.F_RegisterID = R.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD
				ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D
				ON R.F_DelegationID = D.F_DelegationID
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_CompetitionPositionDes1 = 2
		) AS M2
		ON M.F_MatchID = M2.F_MatchID
	LEFT JOIN TC_Decision AS DC
		On M.F_DecisionID = DC.F_DecisionID
	LEFT JOIN TC_Decision_Des AS DCD
		ON DC.F_DecisionID = DCD.F_DecisionID AND DCD.F_LanguageCode = @LanguageCode
	WHERE M.F_MatchID = @MatchID

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetContestResult_MatchInfo_Individual] 

*/