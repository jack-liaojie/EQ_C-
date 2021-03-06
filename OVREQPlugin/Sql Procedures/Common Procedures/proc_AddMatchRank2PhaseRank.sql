if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddMatchRank2PhaseRank]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddMatchRank2PhaseRank]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_AddMatchRank2PhaseRank
----功		  能：添加一个Match编排描述信息，主要是说明该场比赛的Rank为n的在Phase中的排名Rank为m
----作		  者：郑金勇 
----日		  期: 2009-04-10

CREATE PROCEDURE proc_AddMatchRank2PhaseRank 
	@MatchID			INT,
	@MatchRank			INT,
	@PhaseID			INT,
	@PhaseRank			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加失败，标示没有做任何操作！
					-- @Result>=1; 	添加成功！
					-- @Result=-1; 	添加失败，@MatchID、@PhaseID无效
					-- @Result=-2; 	添加失败，一场比赛的同一名次在指定Phase中的排名应该是唯一的，不允许重复添加

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS(SELECT F_MatchID FROM TS_MatchRank2PhaseRank WHERE F_MatchID = @MatchID AND F_MatchRank = @MatchRank AND F_PhaseID = @PhaseID)
	BEGIN
		SET @Result = -1
		RETURN
	END

--	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
--	BEGIN
--		SET @Result = -1
--		RETURN
--	END

	INSERT INTO TS_MatchRank2PhaseRank (F_MatchID, F_MatchRank, F_PhaseID, F_PhaseRank)
		VALUES (@MatchID, @MatchRank, @PhaseID, @PhaseRank)

	IF @@error<>0
	BEGIN 
		SET @Result=0
		RETURN
	END

	SET @Result=1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF 
GO

