IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetMatchResultsEnds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetMatchResultsEnds]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_Report_AR_GetMatchResultsEnds]
--描    述: 射箭项目,获取某人局信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月11日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetMatchResultsEnds]
	@MatchID				INT,
	@CompetitionPosition	INT,
	@LanguageCode			CHAR(3) = Null
AS
BEGIN
SET NOCOUNT ON
		
	if @LanguageCode = null
	begin
	 set @LanguageCode = 'CHN'
	 END
	 
	 
		SELECT
		  MSI.F_MatchSplitID 
		, MSR.F_Points AS Score
		, MSR.F_SplitPoints AS SetPoints
		, MSR.F_Comment1 AS Num10s
		, MSR.F_Comment2 AS NumXs
		, MSI.F_Order  AS EndIndex
		, MSI.F_MatchSplitCode AS EndCode
		, MR1.F_Points AS Arrow1
		, MR2.F_Points AS Arrow2
		, MR3.F_Points AS Arrow3
		, MR4.F_Points AS Arrow4
		, MR5.F_Points AS Arrow5
		, MR6.F_Points AS Arrow6
		FROM TS_Match_Split_Info AS MSI
		LEFT JOIN TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID= @MatchID 
		LEFT JOIN (SELECT case when B.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(B.F_Points AS VARCHAR) END AS F_Points,A.F_FatherMatchSplitID FROM TS_Match_Split_Info AS A
						LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_MatchID =@MatchID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition =@CompetitionPosition AND A.F_Order =1)
				 AS MR1 ON MR1.F_FatherMatchSplitID = MSI.F_MatchSplitID
		LEFT JOIN (SELECT case when B.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(B.F_Points AS VARCHAR) END AS F_Points,A.F_FatherMatchSplitID FROM TS_Match_Split_Info AS A
						LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_MatchID =@MatchID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition =@CompetitionPosition AND A.F_Order =2)
				 AS MR2 ON MR2.F_FatherMatchSplitID = MSI.F_MatchSplitID 
		LEFT JOIN (SELECT case when B.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(B.F_Points AS VARCHAR) END AS F_Points,A.F_FatherMatchSplitID FROM TS_Match_Split_Info AS A
						LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_MatchID =@MatchID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition =@CompetitionPosition AND A.F_Order =3)
				 AS MR3 ON MR3.F_FatherMatchSplitID = MSI.F_MatchSplitID 
		LEFT JOIN (SELECT case when B.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(B.F_Points AS VARCHAR) END AS F_Points,A.F_FatherMatchSplitID FROM TS_Match_Split_Info AS A
						LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_MatchID =@MatchID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition =@CompetitionPosition AND A.F_Order =4)
				 AS MR4 ON MR4.F_FatherMatchSplitID = MSI.F_MatchSplitID 
		LEFT JOIN (SELECT case when B.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(B.F_Points AS VARCHAR) END AS F_Points,A.F_FatherMatchSplitID FROM TS_Match_Split_Info AS A
						LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_MatchID =@MatchID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition =@CompetitionPosition AND A.F_Order =5)
				 AS MR5 ON MR5.F_FatherMatchSplitID = MSI.F_MatchSplitID 
		LEFT JOIN (SELECT case when B.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(B.F_Points AS VARCHAR) END AS F_Points,A.F_FatherMatchSplitID FROM TS_Match_Split_Info AS A
						LEFT JOIN TS_Match_Split_Result AS B ON A.F_MatchSplitID = B.F_MatchSplitID AND B.F_MatchID =@MatchID
								WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_CompetitionPosition =@CompetitionPosition AND A.F_Order =6)
				 AS MR6 ON MR6.F_FatherMatchSplitID = MSI.F_MatchSplitID  
		WHERE MSI.F_MatchID= @MatchID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0

SET NOCOUNT OFF
END

GO

/*
exec Proc_Report_AR_GetMatchResultsEnds 49,2,'ENG'
*/
