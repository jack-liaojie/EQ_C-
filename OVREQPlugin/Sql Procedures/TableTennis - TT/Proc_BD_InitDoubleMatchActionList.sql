IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_InitDoubleMatchActionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_InitDoubleMatchActionList]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_BD_InitDoubleMatchActionList]
----功		  能：初始化双打分数历程
----作		  者：王强
----日		  期: 2011-03-12 

CREATE PROCEDURE [dbo].[Proc_BD_InitDoubleMatchActionList]
    @MatchID        INT,
    @MatchSplitID   INT,
    @Composition    INT,
    @RegisterIDA1   INT,
    @RegisterIDB1   INT,
	@Result 		AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @MaxScore INT
	DECLARE @Res INT
	SELECT @MaxScore = MAX(F_ActionDetail1) FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
	IF @MaxScore IS NULL OR @MaxScore = 0
		BEGIN
			DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
			IF @Composition = 1
				BEGIN
					exec dbo.proc_BD_AddAction 2, @MatchID, @MatchSplitID, @RegisterIDB1, 0, 0, 0, @Res OUTPUT
					exec dbo.proc_BD_AddAction @Composition, @MatchID, @MatchSplitID, @RegisterIDA1, 0, 0, 0, @Res OUTPUT
				END
			ELSE
				BEGIN
					exec dbo.proc_BD_AddAction 1, @MatchID, @MatchSplitID, @RegisterIDA1, 0, 0, 0, @Res OUTPUT
					exec dbo.proc_BD_AddAction @Composition, @MatchID, @MatchSplitID, @RegisterIDB1, 0, 0, 0, @Res OUTPUT
				END	
			SET @Result = 1
			RETURN
		END
	
	SET @Result = 0
SET NOCOUNT OFF
END

GO

