IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BDTT_TEST_ClearMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BDTT_TEST_ClearMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_BDTT_TEST_ClearMatchResult]
----功		  能: 测试模式下，清空比赛成绩
----作		  者：王强
----日		  期: 2012-08-22

CREATE PROCEDURE [dbo].[Proc_BDTT_TEST_ClearMatchResult]
	  @MatchID INT
AS
BEGIN
	
SET NOCOUNT ON

	UPDATE TS_Match_Result SET F_Points = NULL,F_Rank = NULL, F_ResultID = NULL, F_WinPoints= NULL,
			F_WinSets = NULL, F_WinSets_1 = NULL, F_WinSets_2 = NULL, F_LosePoints = NULL, F_LoseSets = NULL,
			F_LoseSets_1 = NULL, F_LoseSets_2 = NULL
	WHERE F_MatchID = @MatchID
	
	UPDATE TS_Match_Split_Result SET F_Points = NULL, F_Rank = NULL, F_ResultID = NULL WHERE F_MatchID = @MatchID
	
SET NOCOUNT OFF
END

GO

