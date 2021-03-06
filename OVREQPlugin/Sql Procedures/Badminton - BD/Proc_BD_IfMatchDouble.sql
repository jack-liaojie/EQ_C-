IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_IfMatchDouble]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_IfMatchDouble]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_BD_IfMatchDouble]
----功		  能：判断是否为双打比赛
----作		  者：王强
----日		  期: 2012-08-22

CREATE PROCEDURE [dbo].[Proc_BD_IfMatchDouble]
	@MatchID INT,
	@MatchSplitID INT = -1,
	@Result 			     AS INT OUTPUT --1为双打，0不为双打，-1为获取失败
	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @MatchType INT
	DECLARE @MatchSplitType INT
	SELECT @MatchType = A.F_PlayerRegTypeID
	FROM TS_Event AS A
	LEFT JOIN TS_Phase AS B ON B.F_EventID = A.F_EventID
	LEFT JOIN TS_Match AS C ON C.F_PhaseID = B.F_PhaseID
	WHERE F_MatchID = @MatchID
	
	IF @MatchType = 3
		BEGIN
			SELECT @MatchSplitType = F_MatchSplitType FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID
			IF @MatchSplitType > 2
				BEGIN
					SET @Result = 1
					RETURN
				END
			ELSE IF @MatchSplitType >=1 AND @MatchSplitType <=2
				BEGIN
					SET @Result = 0
					RETURN
				END
			ELSE
				BEGIN
					SET @Result = -1
					RETURN
				END
		END
	ELSE IF @MatchType = 2
		BEGIN
			SET @Result = 1
			RETURN
		END
	ELSE IF @MatchType = 1
		BEGIN
			SET @Result = 0
			RETURN
		END
	
	SET @Result = -1
	RETURN
	
SET NOCOUNT OFF
END

GO

