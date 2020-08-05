IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_IsMatchConfiged]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_IsMatchConfiged]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_IsMatchConfiged]
----功		  能：判断一场比赛是已经指定竞赛规则，以及判断一场比赛的Splits是否根据指定的竞赛规则进行创建
----作		  者：郑金勇 
----日		  期: 2010-09-20

CREATE PROCEDURE [dbo].[Proc_IsMatchConfiged] (	
	@MatchID					INT,
	@Result						INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result=0; 	当场比赛竞赛规则没有指定、也没有创建MatchSplit！
					-- @Result=1; 	当场比赛竞赛规则已经指定、也没有创建MatchSplit！
					-- @Result=-1; 	判断当场比赛是否配置好失败，该@MatchID无效
	
	
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF NOT EXISTS (SELECT F_MatchID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID AND F_CompetitionRuleID IS NULL)
	BEGIN
		SET @Result = 0
		RETURN
	END
	
	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END






GO


