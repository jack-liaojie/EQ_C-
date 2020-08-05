IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_CalEventResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_CalEventResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_CalEventResult]
----功		  能：一个项目的最后一场比赛结束后，计算小项的最终排名
----作		  者： 张翠霞
----日		  期: 2010-10-12

CREATE PROCEDURE [dbo].[Proc_GF_CalEventResult] (	
	@MatchID				INT,
	@Result                 AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

    SET @Result=0;     -- @Result = 0; 更新失败，标示没有做任何操作！
					   -- @Result = 1; 更新成功！
                       -- @Result = -1; 更新失败，该MatchID不存在或比赛没有结束！ 
              

    IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
    BEGIN
        SET @Result = -1
        RETURN
    END
    
    DECLARE @PhaseOrder AS INT
    DECLARE @EventID AS INT
    SELECT @PhaseOrder = P.F_Order, @EventID = P.F_EventID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE M.F_MatchID = @MatchID
    
    IF EXISTS(SELECT F_MatchStatusID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID WHERE C.F_EventID = @EventID AND A.F_MatchStatusID NOT IN (100, 110))
    BEGIN
        SET @Result = -1
        RETURN
    END
    
    IF @PhaseOrder <> 4
    BEGIN
        SET @Result = -1
        RETURN
    END
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
        EXEC Proc_GF_CreateSingleEventResult @MatchID, @Result OUTPUT
		
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		EXEC Proc_GF_CreateTeamEventResult @MatchID, @Result OUTPUT
		
		IF @@error<>0  --事务失败返回  
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



