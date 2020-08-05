if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelCompetitionPosition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelCompetitionPosition]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[proc_DelCompetitionPosition]
----功		  能：删除一个比赛者位置
----作		  者：郑金勇 
----日		  期: 2009-11-11 

CREATE PROCEDURE [dbo].[proc_DelCompetitionPosition] 
	@MatchID						INT,
	@CompetitionPosition			INT,
	@Result 						AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除一个比赛者位置失败，标示没有做任何操作！
					-- @Result=1; 	删除一个比赛者位置成功！
					-- @Result=-1; 	删除一个比赛者位置失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition)
	BEGIN
		SET @Result = -1
		RETURN
	END
	 
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Phase_Model_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
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
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
/*
exec proc_DelCompetitionPosition 1075, 4, 1
*/