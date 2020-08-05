

/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchResult]    Script Date: 08/30/2012 08:38:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetMatchResult]
GO


/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchResult]    Script Date: 08/30/2012 08:38:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_HB_GetMatchResult]
----功		  能：获取一场比赛的结果
---				0:1 HT
---				2:1 FT(0:1 HT)
---				2:1 AET(1:1 FT, 0:0 HT)
---				4:2 PSO(2:2 AET, 2:2 FT, 1:2 HT)
---				3:2 PSO(1:1 FT, 1:0 HT)
----作		  者：杨佳鹏 
----日		  期: 2011-02-16 
---2011-5-20 杨佳鹏 结果显示样式根据上述样例修改
CREATE PROCEDURE [dbo].[Proc_HB_GetMatchResult]
	@MatchID			INT,
	@Result				NVARCHAR(MAX) OUTPUT
AS
BEGIN
	
SET NOCOUNT ON
	
    DECLARE @STATUS_RUNNING AS INT
    DECLARE @STATUS_FINISHED AS INT
	
    SET @STATUS_RUNNING =50
    SET @STATUS_FINISHED=110
	SET @Result = ''
	create table #tmpSplitScores
	(
		GoalsA int,
		GoalsB Int,
		Game_No int,
		Game_Status int,
		SUMGoalA NVARCHAR(100),
		SUMGoalB NVARCHAR(100),
	)
	 
	insert into #tmpSplitScores(Game_No,GoalsA,GoalsB,Game_Status)
	(
		SELECT 
		CASE TMSI.F_MatchSplitCode 
			WHEN '1' THEN 0
			WHEN '2' THEN 1
			WHEN '3' THEN 2
			WHEN '4' THEN 3
			WHEN '51'THEN 4
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

	update A 
	SET SUMGoalA = (SELECT SUM(GoalsA) FROM #tmpSplitScores AS B WHERE B.Game_No<=A.Game_No)
	,SUMGoalB =(SELECT SUM(GoalsB) FROM #tmpSplitScores AS C WHERE C.Game_No<=A.Game_No)
	FROM #tmpSplitScores AS A


	IF NOT EXISTS(SELECT * FROM #tmpSplitScores )
	BEGIN
	 	RETURN --@Result
	END
	IF NOT EXISTS(SELECT * FROM #tmpSplitScores WHERE Game_No IN(1,2,3,4) )
	BEGIN
		 SELECT @Result = SUMGoalA +':'+SUMGoalB +' HT' FROM #tmpSplitScores WHERE Game_No = 0
		 RETURN --@Result
	END
	
	IF NOT EXISTS(SELECT * FROM #tmpSplitScores WHERE Game_No IN(2,3,4) )
	BEGIN
		 SELECT @Result =' FT('+ SUMGoalA +':'+SUMGoalB+' HT)' FROM #tmpSplitScores WHERE Game_No = 0 
		 SELECT @Result =SUMGoalA +':'+SUMGoalB + @Result FROM #tmpSplitScores WHERE Game_No = 1 
		
		 RETURN --@Result
	END
-----------------------------------------------------------------------------------------
	IF EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(2))
		AND NOT EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(3))
		AND NOT EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(4))
	BEGIN
		 SELECT @Result =', '+SUMGoalA +':'+SUMGoalB+' HT)' FROM #tmpSplitScores WHERE Game_No = 0 
		 SELECT @Result =' ('+SUMGoalA +':'+SUMGoalB + ' FT'+@Result FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @Result = SUMGoalA +':'+SUMGoalB +@Result FROM #tmpSplitScores WHERE Game_No = 2
		 RETURN --@Result
	END
	ELSE IF  EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(2))
		AND EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(3))
		AND NOT EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(4))
	BEGIN
	
		SELECT @Result =', '+SUMGoalA +':'+SUMGoalB+' HT)' FROM #tmpSplitScores WHERE Game_No = 0 
		SELECT @Result ='('+SUMGoalA +':'+SUMGoalB +' FT'+ @Result FROM #tmpSplitScores WHERE Game_No = 1 
		
		IF (SELECT Game_Status FROM #tmpSplitScores WHERE Game_No = 3)<>2
		BEGIN
			
			 SELECT @Result = SUMGoalA +':'+SUMGoalB +' '+@Result FROM #tmpSplitScores WHERE Game_No = 3
			 RETURN --@Result
		END
		ELSE
		BEGIN
			SELECT @Result = SUMGoalA +':'+SUMGoalB +' AET'+@Result FROM #tmpSplitScores WHERE Game_No = 3
			 RETURN --@Result
		END
		 
	END
	ELSE IF  NOT EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(2))
		AND NOT EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(3))
		AND EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(4))
	BEGIN
		---				1:1 (1:0) 3:2 PSO
		 SELECT @Result =', '+SUMGoalA +':'+SUMGoalB+' HT)' FROM #tmpSplitScores WHERE Game_No = 0 
		 SELECT @Result ='('+SUMGoalA +':'+SUMGoalB + ' FT'+@Result FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @Result =SUMGoalA +':'+SUMGoalB+' PSO'+@Result  FROM #tmpSplitScores WHERE Game_No = 4
		 RETURN --@Result
	END
	ELSE IF   EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(2))
		AND  EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(3))
		AND EXISTS (SELECT * FROM #tmpSplitScores WHERE Game_No IN(4))
	BEGIN
		---				2:2 AET (2:2, 1:2) 4:2 PSO
		 SELECT @Result =', '+SUMGoalA +':'+SUMGoalB+' HT)' FROM #tmpSplitScores WHERE Game_No = 0 
		 SELECT @Result =', '+SUMGoalA +':'+SUMGoalB +' FT' +@Result FROM #tmpSplitScores WHERE Game_No = 1 
		 SELECT @Result = '('+SUMGoalA +':'+SUMGoalB +' AET'+@Result FROM #tmpSplitScores WHERE Game_No = 3
		 SELECT @Result =SUMGoalA +':'+SUMGoalB+' PSO'+ @Result  FROM #tmpSplitScores WHERE Game_No = 4
		 RETURN --@Result
	END
----------------------------------------------------------------------------------------
	 RETURN --@Result
SET NOCOUNT OFF
END
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


