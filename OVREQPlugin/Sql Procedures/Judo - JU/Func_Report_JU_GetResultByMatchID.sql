IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_JU_GetResultByMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_JU_GetResultByMatchID]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Func_Report_JU_GetResultByMatchID]
--说    明: 根据 MatchID 获取指定比赛的比赛成绩.
--创 建 人: 邓年彩
--日    期: 2010年10月27日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE FUNCTION [Func_Report_JU_GetResultByMatchID]
(
	@MatchID						INT,
	@IsFinishedShow					INT,	-- 是否在比赛结束后才显示成绩: 0 - 否, 1 - 是
	@LanguageCode					CHAR(3)
)
RETURNS NVARCHAR(100)
AS
BEGIN
	
	DECLARE @ResultVar				NVARCHAR(50)
	
	SELECT 
		@ResultVar = 
			CASE 
				WHEN (@IsFinishedShow = 1 AND M.F_MatchStatusID NOT IN (100, 110))
					OR M1.F_RegisterID = -1 OR M2.F_RegisterID = -1 THEN N''
				ELSE
					CASE DC.F_DecisionCode 
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
							+ ISNULL(N' ' + M.F_MatchComment4, N'')
							+ ISNULL(CHAR(10) + CASE WHEN M.F_MatchComment3 = N'1' THEN N'GS' END, N'')
							+m1.Hantei1+M2.Hantei2
			END
		END
	FROM TS_Match AS M
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, MR.F_RegisterID
				, Points = 
				CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN  MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S'+ CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
				END
				,[Hantei1]=CASE MR.F_PointsCharDes1 WHEN N'1' THEN N'(Hantei)' ELSE '' END
			FROM TS_Match_Result AS MR
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_CompetitionPositionDes1 = 1
		) AS M1
		ON M.F_MatchID = M1.F_MatchID
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_ResultID
				, MR.F_RegisterID
				, Points = 
				CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes1, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				+ CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes3, 0))
				+ CASE 
					WHEN MR.F_PointsCharDes4 = N'H' OR MR.F_PointsCharDes4 = N'X' THEN  MR.F_PointsCharDes4
					WHEN MR.F_PointsNumDes4 > 0 THEN N'S'+  CONVERT(NVARCHAR(10), MR.F_PointsNumDes4)
					ELSE N''
				END
				,[Hantei2]=CASE MR.F_PointsCharDes1 WHEN N'1' THEN N'(Hantei)' ELSE '' END
			FROM TS_Match_Result AS MR
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_CompetitionPositionDes1 = 2
		) AS M2
		ON M.F_MatchID = M2.F_MatchID
	LEFT JOIN TC_Decision AS DC
		On M.F_DecisionID = DC.F_DecisionID
	LEFT JOIN TC_Decision_Des AS DCD
		ON DC.F_DecisionID = DCD.F_DecisionID AND DCD.F_LanguageCode = @LanguageCode
	WHERE M.F_MatchID = @MatchID
	
	RETURN @ResultVar

END

/*

-- Just for test
SELECT dbo.[Func_Report_JU_GetResultByMatchID]

*/