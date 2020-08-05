IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_CreateMatchSplits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_CreateMatchSplits]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_AR_CreateMatchSplits]
----功		  能：
----作		  者：吴定昉, 郑金勇
----日		  期: 2010-03-22 

CREATE PROCEDURE [dbo].[Proc_AR_CreateMatchSplits] 
	@MatchID			           INT,
	@EndCount				       INT,--回合数目
	@ArrowCount			           INT,--每一回合的箭数
	@Distince			           INT,--靶距，
	@CreateType					   INT, --1 表示直接删除原有的Split，创建新的Split, 2表示保留原有的Split，直接返回 @Result=-3 告诉用户，已有Split.不做进一步的操作
	@Result 			           AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
 	DECLARE @Order		    NVARCHAR(50)

	SET @Result=0;		-- @Result=0; 	创建MatchSplits失败，标示没有做任何操作！
						-- @Result=1; 	创建MatchSplits成功，返回！
						-- @Result=-1; 	创建MatchSplits失败，@MatchID无效
						-- @Result=-3;	创建MatchSplits失败,已有Split，只能删除原有的Split后再创建新的Split

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
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

		DECLARE @SplitNum AS INT
		DECLARE @EndCode	AS INT
		DECLARE @ArrowCode	AS INT
		DECLARE @TempDistinceNum AS INT
		SET @TempDistinceNum = 1
		SET @SplitNum = 1 
		SET @EndCode = 1
		SET @ArrowCode = 1
	
	WHILE (@TempDistinceNum <= @Distince)
	BEGIN

		DECLARE @TempCount AS INT 
		SET @TempCount = 1
		WHILE (@TempCount <= @EndCount)
		BEGIN
			INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitCode, F_MatchSplitType, F_MatchSplitStatusID,F_MatchSplitPrecision) 
				VALUES (@MatchID, @SplitNum, 0, @TempCount, @EndCode, 0, 0,@TempDistinceNum)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

			
			DECLARE @FatherSplit AS INT
			DECLARE @TempCount1 AS INT
			SET @FatherSplit = @SplitNum
			SET @SplitNum = @SplitNum + 1
			SET @TempCount1 = 1
			WHILE (@TempCount1 <= @ArrowCount)
			BEGIN
				INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitCode, F_MatchSplitType, F_MatchSplitStatusID)
					VALUES (@MatchID, @SplitNum, @FatherSplit, @TempCount1, @ArrowCode, 1, 0)

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

				SET @SplitNum = @SplitNum + 1
				SET @TempCount1 = @TempCount1 + 1
				SET @ArrowCode = @ArrowCode + 1
			END

			SET @TempCount = @TempCount +1
			SET @EndCode = @EndCode + 1
		END
			SET @TempDistinceNum = @TempDistinceNum + 1
	END

		INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition)
			SELECT A.F_MatchID, A.F_MatchSplitID, B.F_CompetitionPosition FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Result AS B
				ON A.F_MatchID = B.F_MatchID WHERE A.F_MatchID = @MatchID AND B.F_CompetitionPosition IS NOT NULL

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

/*
DECLARE @Result int
EXEC Proc_AR_CreateMatchSplits 36,5,3,1,2, @Result output
SELECT	@Result as N'@Result'
*/

