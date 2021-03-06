IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_SetMatchSplitStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_SetMatchSplitStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_BD_SetMatchSplitStatus]
----功		  能：设置比赛的局状态
----作		  者：王强
----日		  期: 2011-5-5

CREATE PROCEDURE [dbo].[Proc_BD_SetMatchSplitStatus] (	
						@MatchID INT,
						@MatchSplitID INT,
						@StatusID INT,
						@Result INT OUTPUT  --  1为成功，-1为未找到MatchID或SplitID, -2，@StatusID错误
)	
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @FatherSplitID INT
	SELECT @FatherSplitID = F_FatherMatchSplitID  FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
	IF @FatherSplitID IS NULL 
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF @StatusID NOT IN (50,110)
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	--如果为盘ID
	IF @FatherSplitID  = 0
	BEGIN
		IF @StatusID = 50
		BEGIN
			--首先将处于50状态下的其他split设置为100
			UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 110 
			WHERE F_MatchID = @MatchID AND F_MatchSplitStatusID = 50 AND F_FatherMatchSplitID != @MatchSplitID
		END
		
		IF @StatusID = 110
		BEGIN
			--如果为100则设置它下面的所有splitID状态为100
			UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 110 
			WHERE F_MatchID = @MatchID AND F_MatchSplitStatusID != 0 AND F_FatherMatchSplitID = @MatchSplitID
		END
		
		--设置状态
		UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @StatusID
		WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
	END
	ELSE
	BEGIN
		IF @StatusID = 50
		BEGIN
			--首先将处于50状态下的其他split设置为100
			UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 110 
			WHERE F_MatchID = @MatchID AND F_MatchSplitStatusID = 50 AND F_MatchSplitID NOT IN (@FatherSplitID, @MatchSplitID)
			
			--设置split及其父split的状态
			UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @StatusID
			WHERE F_MatchID = @MatchID AND F_MatchSplitID IN (@MatchSplitID,@FatherSplitID)
		END
		
		--仅设置该split的status
		IF @StatusID = 110
		BEGIN
			UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @StatusID
			WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
		END
	END
	
	SET @Result = 1
	
SET NOCOUNT OFF
END




GO

