IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdatePlayerHoleNum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdatePlayerHoleNum]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_UpdatePlayerHoleNum]
----功		  能：更新一场比赛的实时成绩
----作		  者： 张翠霞
----日		  期: 2010-10-05

CREATE PROCEDURE [dbo].[Proc_GF_UpdatePlayerHoleNum] (	
	@MatchID				INT,
	@CompetitionID		    INT,
	@Hole					INT,
	@HoleNum				INT,
	@DoRank                 INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID或CompetitionID或Hole不存在！ 
                                  
    DECLARE @MatchSplitID AS INT
    DECLARE @HolePar AS INT
    DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    
    SELECT @MatchSplitID = F_MatchSplitID, @HolePar = CAST(F_MatchSplitComment AS INT) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Hole
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID
            
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID AND F_MatchSplitID = @MatchSplitID)
    BEGIN
    SET @Result = -1
    RETURN
    END
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
 
      UPDATE TS_Match_Split_Result SET F_Points = (CASE @HoleNum WHEN 0 THEN NULL ELSE @HoleNum END), F_SplitPoints = (CASE @HoleNum WHEN 0 THEN NULL ELSE (@HoleNum - @HolePar) END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID AND F_MatchSplitID = @MatchSplitID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		DECLARE @MatchPoints AS INT
		DECLARE @MatchPar AS INT
		SELECT @MatchPoints = SUM(CASE WHEN F_Points IS NULL THEN 0 ELSE F_Points END), @MatchPar = SUM(CASE WHEN F_SplitPoints IS NULL THEN 0 ELSE F_SplitPoints END) FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID
        UPDATE TS_Match_Result SET F_PointsCharDes1 = (CASE WHEN @MatchPoints = 0 THEN NULL ELSE @MatchPoints END), F_PointsCharDes2 = (CASE WHEN @MatchPoints = 0 THEN NULL ELSE @MatchPar END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID
        
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		if @DoRank is not null and @DoRank = 1
			EXEC Proc_GF_UpdateMatchResult @MatchID, 0, @Result OUTPUT
		else 
		    set @Result = 1	

		IF @Result<>1  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN
	
SET NOCOUNT OFF
END

GO



