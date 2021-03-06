 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_GetMatchPlayerIDFromTS]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_GetMatchPlayerIDFromTS]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--王强：从计时计分字符串获取playerID

CREATE FUNCTION [dbo].[Fun_BD_GetMatchPlayerIDFromTS]
								(
									@MatchID		 INT,
									@MatchSetID      INT,
									@PlayerInfo      NVARCHAR(10)       
								)
RETURNS INT
AS
BEGIN
	DECLARE @RegID INT
	DECLARE @EventType INT
	SELECT @EventType = C.F_PlayerRegTypeID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	--单打
	IF @EventType = 1
	BEGIN
		IF @PlayerInfo = 'A1'
			SELECT @RegID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
		ELSE IF @PlayerInfo = 'B1'
			SELECT @RegID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
		ELSE
			RETURN 0
	END
	ELSE IF @EventType = 2
	BEGIN
		IF @PlayerInfo = 'A1'
			SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 1
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
		ELSE IF @PlayerInfo = 'A2'
			SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 2
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 1
		ELSE IF @PlayerInfo = 'B1'
			SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 1
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
		ELSE IF @PlayerInfo = 'B2'
			SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Result AS A
			LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 2
			WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = 2
		ELSE
			RETURN 0
	END
	ELSE IF @EventType = 3
	BEGIN
		DECLARE @SplitType INT
		SELECT @SplitType = F_MatchSplitType FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSetID
		IF @SplitType IN (1,2)
		BEGIN
			IF @PlayerInfo = 'A1'
				SELECT @RegID = F_RegisterID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1 AND F_MatchSplitID = @MatchSetID
			ELSE IF @PlayerInfo = 'B1'
				SELECT @RegID = F_RegisterID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2 AND F_MatchSplitID = @MatchSetID
			ELSE
				RETURN 0
		END
		ELSE IF @SplitType IN (3,4,5)
		BEGIN
			IF @PlayerInfo = 'A1'
				SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Split_Result AS A 
				LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 1
				WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1 AND F_MatchSplitID = @MatchSetID
			ELSE IF @PlayerInfo = 'A2'
				SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Split_Result AS A 
				LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 2
				WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1 AND F_MatchSplitID = @MatchSetID
			ELSE IF @PlayerInfo = 'B1'
				SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Split_Result AS A 
				LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 1
				WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2 AND F_MatchSplitID = @MatchSetID
			ELSE IF @PlayerInfo = 'B2'
				SELECT @RegID = B.F_MemberRegisterID FROM TS_Match_Split_Result AS A 
				LEFT JOIN TR_Register_Member AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_Order = 2
				WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2 AND F_MatchSplitID = @MatchSetID
			ELSE
				RETURN 0
		END
		ELSE
			RETURN 0
	END
	ELSE
		RETURN 0
	
	RETURN @RegID
	
END


GO

