
/****** Object:  StoredProcedure [dbo].[Proc_HB_UpdatePlayerStat]    Script Date: 08/30/2012 08:45:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_UpdatePlayerStat]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_UpdatePlayerStat]
GO



/****** Object:  StoredProcedure [dbo].[Proc_HB_UpdatePlayerStat]    Script Date: 08/30/2012 08:45:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_HB_UpdatePlayerStat]
----功		  能：更新队员的技术统计值
----作		  者：李燕 
----日		  期: 2010-03-09 

CREATE PROCEDURE [dbo].[Proc_HB_UpdatePlayerStat]
    @MatchID                INT,
    @MatchSplitID           INT,
    @TeamPos        		INT,
	@RegisterID    		    INT,
	@StatCode     		    NVARCHAR(20),
	@StatValue		        NVARCHAR(50),
	@Result 			    AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	修改失败，标示没有做任何操作！
					  -- @Result>=1; 	修改成功！
					  -- @Result=-1; 	修改失败, @StatID无效	

    DECLARE @DisciplineID   INT
    SELECT @DisciplineID = E.F_DisciplineID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
			 LEFT JOIN TS_Event AS E On P.F_EventID = E.F_EventID 
		WHERE M.F_MatchID = @MatchID
		
    
    DECLARE @StatID INT

	IF NOT EXISTS(SELECT F_StatisticID FROM TD_Statistic WHERE F_StatisticCode = @StatCode AND F_DisciplineID = @DisciplineID)
	BEGIN
		SET @Result = -1
		RETURN
	END
    ELSE
    BEGIN
        SELECT @StatID =  F_StatisticID FROM TD_Statistic WHERE F_StatisticCode = @StatCode AND F_DisciplineID = @DisciplineID
    END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
       
         IF NOT EXISTS (SELECT F_StatisticValue FROM TS_Match_Statistic 
                         WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @TeamPos AND F_RegisterID = @RegisterID AND F_StatisticID = @StatID)
		 BEGIN
			  INSERT INTO TS_Match_Statistic (F_MatchID, F_MatchSplitID, F_CompetitionPosition, F_RegisterID, F_StatisticID, F_StatisticValue)
				VALUES (@MatchID, @MatchSplitID, @TeamPos, @RegisterID, @StatID, @StatValue)
			
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			UPDATE TS_Match_Statistic SET F_StatisticValue = @StatValue 
                        WHERE F_MatchID = @MatchID AND F_MatchSplitID= @MatchSplitID AND F_CompetitionPosition = @TeamPos AND F_RegisterID = @RegisterID AND F_StatisticID = @StatID 
	   
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
         END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END


GO


