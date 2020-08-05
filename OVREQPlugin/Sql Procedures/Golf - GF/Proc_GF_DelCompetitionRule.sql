IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_DelCompetitionRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_DelCompetitionRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_DelCompetitionRule]
----功		  能：删除一个项目的一个竞赛规则
----作		  者：张翠霞
----日		  期: 2010-09-27

CREATE PROCEDURE [dbo].[Proc_GF_DelCompetitionRule] (	
	@CompetitionRuleID					INT,
	@Result								INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result=0;  -- @Result=0; 	删除竞赛规则失败，标示没有做任何操作！
					-- @Result=1; 	删除竞赛规则成功！
					-- @Result=-1; 	删除竞赛规则失败，该CompetitionRuleID无效
					-- @Result=-2; 	删除竞赛规则失败，该竞赛规则已经有比赛在用,不允许删除.
					
	
	IF NOT EXISTS(SELECT F_CompetitionRuleID FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
		DELETE FROM TD_CompetitionRule_Des WHERE F_CompetitionRuleID = @CompetitionRuleID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		DELETE FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
	COMMIT TRANSACTION
	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END






GO


