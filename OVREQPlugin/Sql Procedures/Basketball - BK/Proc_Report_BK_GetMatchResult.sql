IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_BK_GetMatchResult]
----功		  能：获取一场比赛的结果
----作		  者：杨佳鹏 
----日		  期: 2011-06-08 
CREATE PROCEDURE [dbo].[Proc_Report_BK_GetMatchResult]
	@MatchID			INT,
	@1A				NVARCHAR(100) OUTPUT,
	@1B				NVARCHAR(100) OUTPUT,
	@1T				NVARCHAR(100) OUTPUT,
	@2A				NVARCHAR(100) OUTPUT,
	@2B				NVARCHAR(100) OUTPUT,
	@2T				NVARCHAR(100) OUTPUT,
	@3A				NVARCHAR(100) OUTPUT,
	@3B				NVARCHAR(100) OUTPUT,
	@3T				NVARCHAR(100) OUTPUT,
	@4A				NVARCHAR(100) OUTPUT,
	@4B				NVARCHAR(100) OUTPUT,
	@4T				NVARCHAR(100) OUTPUT,
	@EA				NVARCHAR(100) OUTPUT,
	@EB				NVARCHAR(100) OUTPUT,
	@ET			        NVARCHAR(100) OUTPUT
AS
BEGIN
	
SET NOCOUNT ON
	
    DECLARE @STATUS_RUNNING AS INT
    DECLARE @STATUS_FINISHED AS INT
	
    SET @STATUS_RUNNING =50
    SET @STATUS_FINISHED=110
	create table #tmpSplitScores
	(
		GoalsA NVARCHAR(10),
		GoalsB NVARCHAR(10),
		Game_No int,
		Game_Status int,
	)
	 
	insert into #tmpSplitScores(Game_No,GoalsA,GoalsB,Game_Status)
	(
		SELECT 
		CASE TMSI.F_MatchSplitCode 
			WHEN '1' THEN 1
			WHEN '2' THEN 2
			WHEN '3' THEN 3
			WHEN '4' THEN 4
			WHEN '5' THEN 5
		END,
		CASE WHEN TMSR1.F_Points IS NULL THEN 0 ELSE TMSR1.F_Points END,
		CASE WHEN TMSR2.F_Points IS NULL THEN 0 ELSE TMSR2.F_Points END,
		(CASE TMSI.F_MatchSplitStatusID
		WHEN @STATUS_RUNNING THEN 1 
		WHEN @STATUS_FINISHED THEN 2
		ELSE 0 END)
		FROM 
		 TS_Match_Split_Info AS TMSI 
		 LEFT JOIN TS_Match_Split_Result  AS TMSR1 ON TMSI.F_MatchID = TMSR1.F_MatchID AND TMSI.F_MatchSplitID = TMSR1.F_MatchSplitID AND TMSR1.F_CompetitionPosition = 1
		 LEFT JOIN TS_Match_Split_Result  AS TMSR2 ON TMSI.F_MatchID = TMSR2.F_MatchID AND TMSI.F_MatchSplitID = TMSR2.F_MatchSplitID AND TMSR2.F_CompetitionPosition = 2
		WHERE TMSI.F_MatchID = @MatchID AND TMSI.F_MatchSplitStatusID IS NOT NULL
	)


	IF NOT EXISTS(SELECT * FROM #tmpSplitScores )
	BEGIN
	 	RETURN 
	END
	IF NOT EXISTS(SELECT * FROM #tmpSplitScores WHERE Game_No IN(2,3,4,5) )
	BEGIN
		 SELECT @1A = GoalsA FROM #tmpSplitScores WHERE Game_No = 1
		 SELECT @1B = GoalsB FROM #tmpSplitScores WHERE Game_No = 1
		 SELECT @1T = GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 1
		 RETURN 
	END
	
	IF NOT EXISTS(SELECT * FROM #tmpSplitScores WHERE Game_No IN(3,4,5) )
	BEGIN
		 SELECT @1A = GoalsA FROM #tmpSplitScores WHERE Game_No = 1
		 SELECT @1B = GoalsB FROM #tmpSplitScores WHERE Game_No = 1	
		 SELECT @1T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @2A = GoalsA FROM #tmpSplitScores WHERE Game_No = 2
		 SELECT @2B = GoalsB FROM #tmpSplitScores WHERE Game_No = 2	
		 SELECT @2T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 2 		
		 RETURN
	END
	
	IF NOT EXISTS(SELECT * FROM #tmpSplitScores WHERE Game_No IN(4,5) )
	BEGIN
		 SELECT @1A = GoalsA FROM #tmpSplitScores WHERE Game_No = 1
		 SELECT @1B = GoalsB FROM #tmpSplitScores WHERE Game_No = 1	
		 SELECT @1T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @2A = GoalsA FROM #tmpSplitScores WHERE Game_No = 2
		 SELECT @2B = GoalsB FROM #tmpSplitScores WHERE Game_No = 2	
		 SELECT @2T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 2 
		 SELECT @3A = GoalsA FROM #tmpSplitScores WHERE Game_No = 3
		 SELECT @3B = GoalsB FROM #tmpSplitScores WHERE Game_No = 3	
		 SELECT @3T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 3 		
		 RETURN
	END

	IF NOT EXISTS(SELECT * FROM #tmpSplitScores WHERE Game_No IN(5) )
	BEGIN
		 SELECT @1A = GoalsA FROM #tmpSplitScores WHERE Game_No = 1
		 SELECT @1B = GoalsB FROM #tmpSplitScores WHERE Game_No = 1	
		 SELECT @1T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @2A = GoalsA FROM #tmpSplitScores WHERE Game_No = 2
		 SELECT @2B = GoalsB FROM #tmpSplitScores WHERE Game_No = 2	
		 SELECT @2T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 2 
		 SELECT @3A = GoalsA FROM #tmpSplitScores WHERE Game_No = 3
		 SELECT @3B = GoalsB FROM #tmpSplitScores WHERE Game_No = 3	
		 SELECT @3T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 3 		
		 SELECT @4A = GoalsA FROM #tmpSplitScores WHERE Game_No = 4
		 SELECT @4B = GoalsB FROM #tmpSplitScores WHERE Game_No = 4	
		 SELECT @4T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 4 		
		 RETURN
	END
	ELSE
	BEGIN
		 SELECT @1A = GoalsA FROM #tmpSplitScores WHERE Game_No = 1
		 SELECT @1B = GoalsB FROM #tmpSplitScores WHERE Game_No = 1	
		 SELECT @1T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @2A = GoalsA FROM #tmpSplitScores WHERE Game_No = 2
		 SELECT @2B = GoalsB FROM #tmpSplitScores WHERE Game_No = 2	
		 SELECT @2T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 2 
		 SELECT @3A = GoalsA FROM #tmpSplitScores WHERE Game_No = 3
		 SELECT @3B = GoalsB FROM #tmpSplitScores WHERE Game_No = 3	
		 SELECT @3T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 3 		
		 SELECT @4A = GoalsA FROM #tmpSplitScores WHERE Game_No = 4
		 SELECT @4B = GoalsB FROM #tmpSplitScores WHERE Game_No = 4	
		 SELECT @4T =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 4 		
		 SELECT @EA = GoalsA FROM #tmpSplitScores WHERE Game_No = 5
		 SELECT @EB = GoalsB FROM #tmpSplitScores WHERE Game_No = 5	
		 SELECT @ET =GoalsA +':'+GoalsB FROM #tmpSplitScores WHERE Game_No = 5 		
		 RETURN
	END
	
	
	 RETURN 
SET NOCOUNT OFF
END
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
GO
--declare @ee NVARCHAR(100)
--exec [Proc_Report_BK_GetMatchResult] 31 ,@ee out 
--select @ee
