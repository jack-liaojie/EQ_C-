if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_AddCompetitionPosition]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_AddCompetitionPosition]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[proc_AddCompetitionPosition]
----功		  能：添加一个比赛者位置
----作		  者：郑金勇 
----日		  期: 2009-11-11 

CREATE PROCEDURE [dbo].[proc_AddCompetitionPosition] 
	@MatchID						INT,
	@Result 						AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加一个比赛者位置失败，标示没有做任何操作！
					-- @Result=1; 	添加一个比赛者位置成功！
					-- @Result=-1; 	添加一个比赛者位置失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @CompetitionPosition AS INT
	SELECT @CompetitionPosition = (CASE WHEN MAX(F_CompetitionPosition) IS NULL THEN 0 ELSE MAX(F_CompetitionPosition) END) + 1 FROM TS_Match_Result WHERE F_MatchID = @MatchID

	DECLARE @CompetitionPositionDes1 AS INT
	SELECT @CompetitionPositionDes1 = (CASE WHEN MAX(F_CompetitionPositionDes1) IS NULL THEN 0 ELSE MAX(F_CompetitionPositionDes1) END) + 1 FROM TS_Match_Result WHERE F_MatchID = @MatchID

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Match_Result (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1) VALUES (@MatchID, @CompetitionPosition, @CompetitionPositionDes1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_CompetitionPosition)
			SELECT F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, @CompetitionPosition AS F_CompetitionPosition
				FROM TS_Match_Split_info WHERE F_MatchID = @MatchID

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

--exec proc_AddCompetitionPosition 750, 1
--select * from TS_Match_Result where F_MatchID = 1075
--select * from TS_Match_Result where F_MatchID = 750
--
--select * from TS_Match_Split_Result where F_MatchID = 1075
--select * from TS_Match_Split_Result where F_MatchID = 750