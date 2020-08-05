IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_info_BD_GetByeMatchesIDs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_info_BD_GetByeMatchesIDs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_info_BD_GetByeMatchesIDs]
----功		  能：获取轮空的比赛ID，分多种情况
----作		  者：王强
----日		  期: 2011-01-18

CREATE PROCEDURE [dbo].[Proc_info_BD_GetByeMatchesIDs]
		@MatchID  INT, --Phase内的一场比赛
		@Type     INT, -- 1代表不获取已经发送过的Bye Match, 2代表获取Phase内部所有bye Matches
		@Result   INT OUTPUT -- >0代表已经发送的轮空比赛的数目，部分发送
							 -- -1代表Phase下没有轮空的比赛
							 -- -2代表所有轮空比赛消息都未发送
							 -- -3代表所有轮空比赛消息都已发送
							 
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @PhaseID IS NULL
		RETURN
	
	DECLARE @ByeCount INT = 0
	DECLARE @ByeSentCount INT = 0
	
	SELECT @ByeCount = COUNT(DISTINCT(F_MatchID)) FROM TS_Match_Result AS A
	WHERE F_RegisterID = -1 AND A.F_MatchID
	IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID )
	
	IF @ByeCount = 0
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SELECT @ByeSentCount = COUNT(DISTINCT(F_MatchID)) FROM TS_Match_Result AS A
	WHERE F_RegisterID = -1 AND A.F_MatchID
	IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchComment1 = 'Y' )
	
	IF @ByeSentCount = 0
		SET @Result = -2   --所有轮空比赛都未发送
	ELSE IF @ByeSentCount = @ByeCount
		SET @Result = -3   --所有轮空比赛都已发送
	ELSE      
		SET @Result = @ByeSentCount  --轮空比赛部分发送
	
	IF @Type = 1
	BEGIN
		SELECT DISTINCT(F_MatchID) FROM TS_Match_Result AS A
		WHERE F_RegisterID = -1 AND A.F_MatchID
		IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND ( F_MatchComment1 IS NULL OR F_MatchComment1 != 'Y'))
	END
	ELSE IF @Type = 2
	BEGIN
		SELECT DISTINCT(F_MatchID) FROM TS_Match_Result AS A
		WHERE F_RegisterID = -1 AND A.F_MatchID
		IN ( SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID )
	END

SET NOCOUNT OFF
END


GO


