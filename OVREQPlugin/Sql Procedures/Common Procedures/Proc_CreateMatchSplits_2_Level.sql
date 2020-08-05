if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_CreateMatchSplits_2_Level]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_CreateMatchSplits_2_Level]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_CreateMatchSplits_2_Level]
----功		  能：
----作		  者：郑金勇 
----日		  期: 2009-04-30 

CREATE PROCEDURE [DBO].[Proc_CreateMatchSplits_2_Level] 
	@MatchID					INT,
	@MatchType					INT,
	@Level_1_SplitNum			INT,
	@Level_2_SplitNum			INT, 
	@CreateType					INT, --1 表示直接删除原有的Split，创建新的Split, 2表示保留原有的Split，直接返回 @Result=-3 告诉用户，已有Split.不做进一步的操作
	@Result 					AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	创建MatchSplits失败，标示没有做任何操作！
					-- @Result=1; 	创建MatchSplits成功！
					-- @Result=-1; 	创建MatchSplits失败，@MatchID无效
					-- @Result=-2; 	创建MatchSplits失败，@Level_1_SplitNum无效、@Level_2_SplitNum 无效
					-- @Result=-3;	创建MatchSplits失败,已有Split，只能删除原有的Split后再创建新的Split

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @Level_1_SplitNum<=0 or @Level_2_SplitNum <0
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF (@CreateType = 2)
	BEGIN
		IF EXISTS(SELECT F_MatchID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
		BEGIN
			SET @Result = -3
			RETURN
		END
	END

	DECLARE @SplitNum AS INT
	DECLARE @TempCount AS INT
	DECLARE @TempCount1 AS INT
	SET @SplitNum = 1 
	SET @TempCount = 1
	SET @TempCount1 = 1
	
	CREATE TABLE #Temp_Result (
							F_CompetitionPosition	INT
							)
	INSERT INTO #Temp_Result (F_CompetitionPosition) VALUES (1)
	INSERT INTO #Temp_Result (F_CompetitionPosition) VALUES (2)

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
		
		DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match SET F_MatchTypeID = @MatchType WHERE F_MatchID = @MatchID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		WHILE (@TempCount <= @Level_1_SplitNum)
		BEGIN

			INSERT INTO TS_Match_Split_Info (F_MatchID,F_MatchSplitID,F_FatherMatchSplitID,F_Order) VALUES (@MatchID,@SplitNum,0,@TempCount)
			select * from TS_Match_Split_Info WHERE F_MatchID = @MatchID
			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

			DECLARE @FatherSplit AS INT
			SET @FatherSplit = @SplitNum
			SET @SplitNum = @SplitNum + 1
			SET @TempCount1 = 1
			WHILE (@TempCount1 <= @Level_2_SplitNum)
			BEGIN
				INSERT INTO TS_Match_Split_Info (F_MatchID,F_MatchSplitID,F_FatherMatchSplitID,F_Order) VALUES (@MatchID,@SplitNum,@FatherSplit,@TempCount1)

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

				SET @SplitNum = @SplitNum + 1
				SET @TempCount1 = @TempCount1 +1
			END
			SET @TempCount = @TempCount +1
		END

		UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 0 WHERE F_MatchID = @MatchID

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Match_Split_Result (F_MatchID,F_MatchSplitID,F_CompetitionPosition)
			SELECT A.F_MatchID, A.F_MatchSplitID, B.F_CompetitionPosition 
				FROM TS_Match_Split_Info AS A, #Temp_Result AS B 
					WHERE A.F_MatchID = @MatchID

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
select * from TS_Match
go

declare @Ret as int
exec [Proc_CreateMatchSplits_2_Level] 31,1,5,3,1,@Ret output
select @Ret
--select * from TS_Match_Split_Info where F_MatchID = 31 Order by F_FatherMatchSplitID,F_MatchSplitID
select * from TS_Match_Split_Result where F_MatchID = 31
go
*/