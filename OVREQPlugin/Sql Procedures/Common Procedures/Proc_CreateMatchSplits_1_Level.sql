IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CreateMatchSplits_1_Level]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CreateMatchSplits_1_Level]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_CreateMatchSplits_1_Level]
--描    述：检查更新Match_Split_Info表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009年04月11日

	
CREATE PROCEDURE [dbo].[Proc_CreateMatchSplits_1_Level](
					@MatchID					INT, --当前比赛的ID
					@MatchType					INT,
					@Level_1_SplitNum			INT,
                    @CreateType					INT, --1 表示直接删除原有的Split，创建新的Split, 2表示保留原有的Split
					@Result 					AS INT OUTPUT
)
	
AS
BEGIN
SET NOCOUNT ON

    SET @Result = 0;  -- @Result=0; 	添加MatchSplit失败，标示没有做任何操作！
					  -- @Result=1; 	添加MatchSplit成功！
                      -- @Result=-1;    添加MatchSplit，该@MatchID无效
                      -- @Result=-2; 	创建MatchSplits失败，@Level_1_SplitNum无效无效
					  -- @Result=-3;	创建MatchSplits失败,已有Split，Split数目相同，只能删除原有的Split后再创建新的Split
                      -- @Result=-4;	创建MatchSplits失败,已有Split，Split数目不同，只能删除原有的Split后再创建新的Split
    
   IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
    BEGIN
		SET @Result = -1
		RETURN
	END

   IF (@Level_1_SplitNum <= 0)
    BEGIN
	    SET @Result = -2
		RETURN
    END

   IF (@CreateType = 2)
    BEGIN
        DECLARE @SplitCount INT
        SELECT @SplitCount = COUNT(*) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		IF (@SplitCount = @Level_1_SplitNum)
		BEGIN
			SET @Result = -3
			RETURN
		END
        ELSE IF (@SplitCount <> @Level_1_SplitNum AND @SplitCount <> 0)
        BEGIN
            SET @Result = -4
			RETURN
		END
    END

    DECLARE @SplitID INT
    DECLARE @FatherSplitID INT

    SET @SplitID = 0
    SET @FatherSplitID = 0
    
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

    WHILE(@SplitID < @Level_1_SplitNum)
    BEGIN
		SET @SplitID = @SplitID + 1
		IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
			BEGIN
				INSERT INTO TS_Match_Split_Info(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order) VALUES(@MatchID, @SplitID, @FatherSplitID, @SplitID)

                IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
			END

        IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1)
		BEGIN
			INSERT INTO TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES(@MatchID, @SplitID, 1)

            IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
		END

        IF @SplitID NOT IN (SELECT F_MatchSplitID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2)
		BEGIN
			INSERT INTO TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES(@MatchID, @SplitID, 2)

            IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
		END

    END

    DECLARE @HomeID INT
    DECLARE @AwayID INT

    SET @HomeID = -1
    SET @AwayID = -1

    SELECT @HomeID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
    SELECT @AwayID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

    UPDATE TS_Match_Split_Result SET F_RegisterID = @HomeID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1

    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END

    UPDATE TS_Match_Split_Result SET F_RegisterID = @AwayID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

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

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

