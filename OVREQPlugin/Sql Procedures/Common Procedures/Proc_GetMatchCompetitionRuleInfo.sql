IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchCompetitionRuleInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchCompetitionRuleInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_GetMatchCompetitionRuleInfo]
----功		  能：得到Match的竞赛规则
----作		  者：郑金勇 
----日		  期: 2011-01-17

CREATE PROCEDURE [dbo].[Proc_GetMatchCompetitionRuleInfo]
	@NodeType				INT,
	@EventID				INT,
	@PhaseID				INT,
	@MatchID				INT	
AS
BEGIN
	
SET NOCOUNT ON

	
	IF @NodeType = 1 --Match
	BEGIN
		SELECT F_CompetitionRuleID FROM TS_Match WHERE F_MatchID = @MatchID
		RETURN
	END
	ELSE
	BEGIN
		SELECT NULL AS F_CompetitionRuleID
		RETURN
	END
	
	RETURN

SET NOCOUNT OFF
END

GO

