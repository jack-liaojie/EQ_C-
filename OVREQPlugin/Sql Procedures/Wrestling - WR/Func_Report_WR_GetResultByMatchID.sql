IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_WR_GetResultByMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_WR_GetResultByMatchID]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Func_Report_WR_GetResultByMatchID]
--说    明: 根据 MatchID 获取指定团体比赛的比赛成绩.
--创 建 人: 宁顺泽
--日    期: 2011年1月7日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE FUNCTION [Func_Report_WR_GetResultByMatchID]
(
	@MatchID						INT,
	@IsFinishedShow					INT,	-- 是否在比赛结束后才显示成绩: 0 - 否, 1 - 是
	@LanguageCode					CHAR(3)
)
RETURNS NVARCHAR(100)
AS
BEGIN
	
	DECLARE @ResultVar				NVARCHAR(30)
	
	SELECT 
		@ResultVar = 
		CASE 
				WHEN (@IsFinishedShow = 1 AND M.F_MatchStatusID NOT IN (100, 110))
					OR M1.F_RegisterID = -1 OR M2.F_RegisterID = -1 THEN N''
				ELSE M1.Points+N':'+M2.Points+N'('+M1.ClassPts+N':'+M2.ClassPts+N')'
		END
	FROM TS_Match AS M
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				 ,MR.F_RegisterID
				,Points = CONVERT(NVARCHAR(10), ISNULL(MR.F_Points, 0))
				,ClassPts=CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))	
			FROM TS_Match_Result AS MR
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_CompetitionPositionDes1 = 1
		) AS M1
		ON M.F_MatchID = M1.F_MatchID
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				, MR.F_RegisterID
				,Points = CONVERT(NVARCHAR(10), ISNULL(MR.F_Points, 0))
				,ClassPts=CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))	
			FROM TS_Match_Result AS MR
			WHERE MR.F_MatchID = @MatchID
				AND MR.F_CompetitionPositionDes1 = 2
		) AS M2
		ON M.F_MatchID = M2.F_MatchID
	WHERE M.F_MatchID = @MatchID
	
	RETURN @ResultVar

END

/*

-- Just for test
SELECT dbo.[Func_Report_JU_GetResultByMatchID]

*/