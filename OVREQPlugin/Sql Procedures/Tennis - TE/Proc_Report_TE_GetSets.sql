IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetSets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetSets]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_Report_TE_GetSets]
----功		  能：得到一场比赛的，一盘的得分历程
----作		  者：郑金勇 
----日		  期: 2009-08-12

CREATE PROCEDURE [dbo].[Proc_Report_TE_GetSets] (	
	@MatchID					INT
)	
AS
BEGIN
SET NOCOUNT ON

	SELECT '局' + CAST(F_MatchSplitCode AS NVARCHAR(MAX)) AS F_Set FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_MatchSplitStatusID IN (50, 110)
			
SET NOCOUNT OFF
END








