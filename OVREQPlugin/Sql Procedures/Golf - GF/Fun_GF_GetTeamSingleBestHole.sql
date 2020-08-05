IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetTeamSingleBestHole]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetTeamSingleBestHole]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		张翠霞
-- Create date: 2010/10/13
-- Description:	当最后一轮比赛结束后，出现名次相同的运动员，计算小排名
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetTeamSingleBestHole]
								(
								    @EventID                    INT,
									@TeamID					    INT,
									@PhaseOrder                 INT,
									@Hole                       INT, --第几个洞的信息
									@Type                       INT  --1:Hole 2:Par
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    DECLARE @MatchID AS INT
    DECLARE @SplitID AS INT
    SET @ResultNum = 0
    
    SELECT TOP 1 @MatchID = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = @PhaseOrder AND P.F_EventID = @EventID
    
    SELECT TOP 1 @SplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Hole
    
	IF @Type = 1 --Hole Number
	BEGIN
	    SELECT @ResultNum = MIN(MSR.F_Points) FROM TS_Match_Result AS MR LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
	    LEFT JOIN TR_Register_Member AS RM ON MR.F_RegisterID = RM.F_MemberRegisterID
	    WHERE MR.F_MatchID = @MatchID AND RM.F_RegisterID = @TeamID AND F_MatchSplitID = @SplitID
	END
	ELSE IF @Type = 2 --Par
	BEGIN
	    SELECT @ResultNum = MIN(MSR.F_SplitPoints) FROM TS_Match_Result AS MR LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
	    LEFT JOIN TR_Register_Member AS RM ON MR.F_RegisterID = RM.F_MemberRegisterID
	    WHERE MR.F_MatchID = @MatchID AND RM.F_RegisterID = @TeamID AND F_MatchSplitID = @SplitID
	END

	RETURN @ResultNum

END



GO


