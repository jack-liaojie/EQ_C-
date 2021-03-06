IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BDTT_TEST_SetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BDTT_TEST_SetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_BDTT_TEST_SetMatchResult]
----功		  能: 测试模式下，设置比赛成绩
----作		  者：王强
----日		  期: 2012-08-22

CREATE PROCEDURE [dbo].[Proc_BDTT_TEST_SetMatchResult]
	  @MatchID INT,
	  @Type  INT, -- 1  MatchScore  2 SetScore  3 GameScore
	  @SetOrder INT, --  Type为2,3时，设置哪个
	  @GameOrder INT,
	  @ScoreA INT,
	  @ScoreB INT,
	  @Winner INT-- 1 为 A胜  2为 B胜  0为胜负未分
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @MatchType INT
	SELECT @MatchType = C.F_PlayerRegTypeID FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	
	IF @MatchType IN (1,2)
	BEGIN
		SET @Type = @Type - 1 --如果比赛类型为非团体，则提升Type级别
		SET @SetOrder = @GameOrder
	END
	
	IF @Type = 1
	BEGIN
		UPDATE TS_Match_Result SET F_Points = @ScoreA,
			F_Rank = CASE @Winner WHEN 1 THEN 1 ELSE 2 END,
			F_ResultID = CASE @Winner WHEN 1 THEN 1 ELSE 2 END
		WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
		
		UPDATE TS_Match_Result SET F_Points = @ScoreB,
			F_Rank = CASE @Winner WHEN 2 THEN 1 ELSE 2 END,
			F_ResultID = CASE @Winner WHEN 2 THEN 1 ELSE 2 END
		WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	END
	ELSE IF @Type IN (2,3)
	BEGIN
		
		DECLARE @SplitID INT 
		
		IF @Type = 2
		BEGIN
			SELECT @SplitID = F_MatchSplitID FROM TS_Match_Split_Info 
			WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_Order = @SetOrder
		END
		ELSE IF @Type = 3
		BEGIN
			SET @SplitID = dbo.Fun_TT_GetMatchSplitIDFromOrder(@MatchID, @SetOrder,@GameOrder )
		END
		ELSE 
			RETURN
		
		UPDATE TS_Match_Split_Result SET F_Points = @ScoreA,
				F_Rank = CASE @Winner WHEN 1 THEN 1 ELSE 2 END,
			    F_ResultID = CASE @Winner WHEN 1 THEN 1 ELSE 2 END
		WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SplitID AND F_CompetitionPosition = 1
		
		UPDATE TS_Match_Split_Result SET F_Points = @ScoreB,
				F_Rank = CASE @Winner WHEN 2 THEN 1 ELSE 2 END,
			    F_ResultID = CASE @Winner WHEN 2 THEN 1 ELSE 2 END
		WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SplitID AND F_CompetitionPosition = 2
	END

SET NOCOUNT OFF
END

GO

