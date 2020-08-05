IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_SetCurrentSplitIndicator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_SetCurrentSplitIndicator]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_BD_SetCurrentSplitIndicator]
----功		  能：设置当前比赛标志
----作		  者：王强
----日		  期: 2011-05-04

CREATE PROCEDURE [dbo].[Proc_BD_SetCurrentSplitIndicator]
		@MatchID     INT, 
		@MatchSplitID INT,  --局ID，如果是盘ID，则设置为第一局,0为取消所有局的状态,-1为设置为最后一局
		@Flag   INT, --局标志  2为正在比赛，3为已经结束但建议为正在比赛，1为比赛未开始，建议为正在比赛
		@Result INT OUTPUT-- -1：match或split不存在，-2:flag参数错误， 1成功,-3其他错误
		
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SetID INT 
	DECLARE @GameID INT
	DECLARE @FatherSplitID INT
	
	IF @Flag NOT IN (1,2,3)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	IF @MatchSplitID = 0
	BEGIN
		UPDATE TS_Match_Split_Info SET F_MatchSplitComment = NULL WHERE F_MatchID = @MatchID AND F_MatchSplitComment IS NOT NULL
		SET @Result = 1
		RETURN
	END
	
	
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	IF @MatchType IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF @MatchSplitID = -1
	BEGIN
	
		IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
		BEGIN
			SET @Result = -1
			RETURN
		END
		
		SELECT @GameID = MAX(F_MatchSplitID) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND (F_MatchSplitStatusID IS NOT NULL AND F_MatchSplitStatusID != 0 )
		--如果为空，说明比赛未开始，@SetID为1
		IF @GameID IS NULL
			BEGIN
				SET @GameID = 1
			END
			
		--递归调用
		EXEC Proc_BD_SetCurrentSplitIndicator @MatchID, @GameID, 3, @Result OUTPUT
		RETURN
		
	END
	
	IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	
	
	
	IF @MatchType = 1
		BEGIN
			
			--先清空带状态的comment
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = NULL 
			WHERE F_MatchID = @MatchID AND F_MatchSplitComment IS NOT NULL
			
			--设置状态
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = CONVERT( NVARCHAR(4), @Flag)
			WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID	
		END
	ELSE IF @MatchType = 3
		BEGIN
			
	
			
			SET @GameID = @MatchSplitID
			SELECT @SetID = F_FatherMatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
			
			--若为盘ID，则取第一局的splitID
			IF @SetID = 0
			BEGIN
				SELECT @GameID = F_MatchSplitID FROM TS_Match_Split_Info 
				WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @MatchSplitID AND F_Order = 1
				
				SET @SetID = @MatchSplitID
			END
			
			--先清空带状态的comment
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = NULL 
			WHERE F_MatchID = @MatchID AND F_MatchSplitComment IS NOT NULL
			
			--设置状态
			UPDATE TS_Match_Split_Info SET F_MatchSplitComment = CONVERT( NVARCHAR(4), @Flag)
			WHERE F_MatchID = @MatchID AND F_MatchSplitID IN ( @SetID, @GameID)
		END
	ELSE
		BEGIN
			SET @Result = -3
			RETURN
		END
	
	SET @Result = 1
	
SET NOCOUNT OFF
END


GO


