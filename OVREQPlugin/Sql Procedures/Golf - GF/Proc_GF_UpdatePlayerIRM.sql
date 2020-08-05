IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdatePlayerIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdatePlayerIRM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_UpdatePlayerIRM]
----功		  能：更新一场比赛中运动员的IRM状态
----作		  者： 张翠霞
----日		  期: 2010-10-12

CREATE PROCEDURE [dbo].[Proc_GF_UpdatePlayerIRM] (	
	@MatchID				INT,
	@CompetitionID		    INT,
	@IRM                    NVARCHAR(50),
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID或CompetitionID不存在！ 
    
    DECLARE @IRMID INT
    SELECT @IRMID = F_IRMID FROM TC_IRM WHERE F_IRMCODE = @IRM
                                          
    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID)
    BEGIN
    SET @Result = -1
    RETURN
    END
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
 
      UPDATE TS_Match_Result SET F_IRMID = @IRMID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		UPDATE TS_Match_Result SET F_PointsNumDes1 = NULL, F_Rank = NULL WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionID AND F_IRMID IS NOT NULL

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
        EXEC Proc_GF_UpdateMatchResult @MatchID, 0, @Result OUTPUT

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



