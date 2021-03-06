IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_UpdateAllSplitStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_UpdateAllSplitStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_BD_UpdateAllSplitStatus]
----功		  能：设置比赛的所有局状态
----作		  者：王强
----日		  期: 2011-5-5

CREATE PROCEDURE [dbo].[Proc_BD_UpdateAllSplitStatus] (	
						@MatchID INT,
						@StatusID INT
)	
AS
BEGIN
SET NOCOUNT ON
	
	UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @StatusID WHERE F_MatchID = @MatchID AND F_MatchSplitStatusID != 0
	
	UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 0 WHERE F_MatchID = @MatchID AND F_MatchSplitStatusID != 0
	AND F_MatchSplitID NOT IN 
	( SELECT F_MatchSplitID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND ( F_Points IS NOT NULL OR F_IRMID IS NOT NULL) )
	
	
	
SET NOCOUNT OFF
END




GO

