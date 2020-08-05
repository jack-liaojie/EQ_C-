IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchSplitsTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchSplitsTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchSplitsTime]
----功		  能：得到一场比赛的各局的比赛耗时时间!
----作		  者：郑金勇 
----日		  期: 2010-10-18

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchSplitsTime] (	
	@MatchID					INT,
	@SubMatchCode               INT  --- -1：个人赛
)	
AS
BEGIN
SET NOCOUNT ON

   IF(@SubMatchCode = -1)
   BEGIN
   
		SELECT 0 AS F_SetNum
			, (ISNULL(F_SpendTime, 0) / 86400) AS F_Day
			, ((ISNULL(F_SpendTime, 0) % 86400) / 3600) AS F_Hour
			, (((ISNULL(F_SpendTime, 0) % 86400) % 3600) / 60) AS F_Minute
			, (((ISNULL(F_SpendTime, 0) % 86400) %3600) % 60) AS F_Sec
			, F_SpendTime 
		FROM TS_Match WHERE F_MatchID = @MatchID
		UNION
		SELECT F_MatchSplitCode AS F_SetNum
			, (ISNULL(F_SpendTime, 0) / 86400) AS F_Day
			, ((ISNULL(F_SpendTime, 0) % 86400) / 3600) AS F_Hour
			, (((ISNULL(F_SpendTime, 0) % 86400) %3600) / 60) AS F_Minute
			, (((ISNULL(F_SpendTime, 0) % 86400) %3600)% 60) AS F_Sec
			, F_SpendTime 
		FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
		
	END
	ELSE
	BEGIN
		SELECT 0 AS F_SetNum
			, (ISNULL(F_SpendTime, 0) / 86400) AS F_Day
			, ((ISNULL(F_SpendTime, 0) % 86400) / 3600) AS F_Hour
			, (((ISNULL(F_SpendTime, 0) % 86400) % 3600) / 60) AS F_Minute
			, (((ISNULL(F_SpendTime, 0) % 86400) %3600) % 60) AS F_Sec
			, F_SpendTime 
		FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SubMatchCode
		UNION
		SELECT F_MatchSplitCode AS F_SetNum
			, (ISNULL(F_SpendTime, 0) / 86400) AS F_Day
			, ((ISNULL(F_SpendTime, 0) % 86400) / 3600) AS F_Hour
			, (((ISNULL(F_SpendTime, 0) % 86400) %3600) / 60) AS F_Minute
			, (((ISNULL(F_SpendTime, 0) % 86400) %3600)% 60) AS F_Sec
			, F_SpendTime 
		FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @SubMatchCode
		
	END
	
SET NOCOUNT OFF
END






GO

 --EXEC Proc_TE_GetMatchSplitsTime 1
