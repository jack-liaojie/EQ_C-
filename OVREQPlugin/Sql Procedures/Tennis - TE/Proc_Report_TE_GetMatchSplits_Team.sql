IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchSplits_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchSplits_Team]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_TE_GetMatchSplits_Team]
----功		  能：得到一场比赛的详细成绩信息,网球项目
----作		  者：郑金勇 
----日		  期: 2009-08-12

CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMatchSplits_Team] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON


	SELECT A.F_MatchID, A.F_MatchSplitID
		, CASE @LanguageCode WHEN 'ENG' THEN N'Match '+CAST(A.F_MatchSplitCode AS NVARCHAR(10))
			WHEN 'CHN' THEN N'比赛 '+CAST(A.F_MatchSplitCode AS NVARCHAR(10)) 
			ELSE N'Match '+CAST(A.F_MatchSplitCode AS NVARCHAR(10)) END  AS F_MathcSplitName
		FROM TS_Match_Split_Info AS A 
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0

SET NOCOUNT OFF
END
GO



--EXEC Proc_Report_TE_GetMatchSplits_Team 284, 'ENG'
--EXEC Proc_Report_TE_GetMatchSplits_Team 284, 'CHN'

