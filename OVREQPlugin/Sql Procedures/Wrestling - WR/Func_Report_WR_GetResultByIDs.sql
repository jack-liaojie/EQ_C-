IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_Report_WR_GetResultByIDs]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_Report_WR_GetResultByIDs]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Func_Report_WR_GetResultByIDs]
--说    明: .
--创 建 人: 宁顺泽
--日    期: 2011年11月27日 星期五
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE FUNCTION [Func_Report_WR_GetResultByIDs]
(
	@MatchID						INT,
	@Compos							int,--1红方  2---蓝方
	@SplitID						int,--1第一句分数 2--第二局分  3--第三局分  4--总分  5--名次分
	@IsFinishedShow					int
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
				ELSE 
					case 
						when @Compos=1 then 
							case 
								when @SplitID=1 then M1.PointsSplit1
								when @SplitID=2 then m1.PointsSplit2
								when @SplitID=3 then M1.PointsSplit3
								when @SplitID=4 then m1.Points
								when @SplitID=5 then m1.ClassPts
								else N''
							end
						when @Compos=2 then 
							case 
								when @SplitID=1 then M2.PointsSplit1
								when @SplitID=2 then m2.PointsSplit2
								when @SplitID=3 then M2.PointsSplit3
								when @SplitID=4 then m2.Points
								when @SplitID=5 then m2.ClassPts
								else N''
							end
						else N''
					end
		END
	FROM TS_Match AS M
	LEFT JOIN 
		(
			SELECT MR.F_MatchID
				 ,MR.F_RegisterID
				,Points = CONVERT(NVARCHAR(10), ISNULL(MR.F_Points, 0))
				,ClassPts=CONVERT(NVARCHAR(10), ISNULL(MR.F_PointsNumDes2, 0))
				,PointsSplit1=CONVERT(NVARCHAR(10), ISNULL(MSR1.F_Points,0)+isnull(MSR1.F_PointsNumDes3, 0))
				,PointsSplit2=CONVERT(NVARCHAR(10), ISNULL(MSR2.F_Points,0)+isnull(MSR2.F_PointsNumDes3, 0))
				,PointsSplit3=case when isnull(MSI3.F_MatchSplitStatusID,0)<100 then N'' else CONVERT(NVARCHAR(10), ISNULL(MSR3.F_Points,0)+isnull(MSR3.F_PointsNumDes3, 0)) end
			FROM TS_Match_Result AS MR
			LEFT JOIN TS_Match_Split_Info aS MSI1
				ON MR.F_MatchID=MSI1.F_MatchID and MSI1.F_MatchSplitID=1
			LEFT JOIN TS_Match_Split_Info aS MSI2
				ON MR.F_MatchID=MSI2.F_MatchID and MSI2.F_MatchSplitID=2
			LEFT JOIN TS_Match_Split_Info aS MSI3
				ON MR.F_MatchID=MSI3.F_MatchID and MSI3.F_MatchSplitID=3
			LEFT JOIN TS_Match_Split_Result AS MSR1
				On MR.F_MatchID=MSR1.F_MatchID and MSR1.F_CompetitionPosition=MR.F_CompetitionPosition and MSR1.F_MatchSplitID=1
			LEFT JOIN TS_Match_Split_Result AS MSR2
				On MR.F_MatchID=MSR2.F_MatchID and MSR2.F_CompetitionPosition=MR.F_CompetitionPosition and MSR2.F_MatchSplitID=2
			LEFT JOIN TS_Match_Split_Result AS MSR3
				On MR.F_MatchID=MSR3.F_MatchID and MSR3.F_CompetitionPosition=MR.F_CompetitionPosition and MSR3.F_MatchSplitID=3				
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
				,PointsSplit1=CONVERT(NVARCHAR(10), ISNULL(MSR1.F_Points,0)+isnull(MSR1.F_PointsNumDes3, 0))
				,PointsSplit2=CONVERT(NVARCHAR(10), ISNULL(MSR2.F_Points,0)+isnull(MSR2.F_PointsNumDes3, 0))
				,PointsSplit3=case when isnull(MSI3.F_MatchSplitStatusID,0)<100 then N'' else CONVERT(NVARCHAR(10), ISNULL(MSR3.F_Points,0)+isnull(MSR3.F_PointsNumDes3, 0)) end
			FROM TS_Match_Result AS MR
			LEFT JOIN TS_Match_Split_Info aS MSI1
				ON MR.F_MatchID=MSI1.F_MatchID and MSI1.F_MatchSplitID=1
			LEFT JOIN TS_Match_Split_Info aS MSI2
				ON MR.F_MatchID=MSI2.F_MatchID and MSI2.F_MatchSplitID=2
			LEFT JOIN TS_Match_Split_Info aS MSI3
				ON MR.F_MatchID=MSI3.F_MatchID and MSI3.F_MatchSplitID=3
			LEFT JOIN TS_Match_Split_Result AS MSR1
				On MR.F_MatchID=MSR1.F_MatchID and MSR1.F_CompetitionPosition=MR.F_CompetitionPosition and MSR1.F_MatchSplitID=1
			LEFT JOIN TS_Match_Split_Result AS MSR2
				On MR.F_MatchID=MSR2.F_MatchID and MSR2.F_CompetitionPosition=MR.F_CompetitionPosition and MSR2.F_MatchSplitID=2
			LEFT JOIN TS_Match_Split_Result AS MSR3
				On MR.F_MatchID=MSR3.F_MatchID and MSR3.F_CompetitionPosition=MR.F_CompetitionPosition and MSR3.F_MatchSplitID=3
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