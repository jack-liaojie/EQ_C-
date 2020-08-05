IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetTeamSingleHole]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetTeamSingleHole]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		吴定昉
-- Create date: 2011/07/08
-- Description:	当最后一轮比赛结束后，出现名次相同的运动员，计算小排名
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetTeamSingleHole]
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
    DECLARE @SexCode AS INT
    SET @ResultNum = 0
    
    SELECT TOP 1 @MatchID = M.F_MatchID, @SexCode = E.F_SexCode FROM TS_Match AS M 
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE M.F_Order = 1 AND P.F_Order = @PhaseOrder AND P.F_EventID = @EventID
    
    SELECT TOP 1 @SplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @Hole
       
	IF @Type = 1 --Hole Number
	BEGIN
	    IF @SexCode = 1 
			SELECT @ResultNum = SUM(T.F_Points) FROM (
			SELECT TOP 3 MSR.F_Points FROM TS_Match_Result AS MR 
			LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
			LEFT JOIN TR_Register_Member AS RM ON MR.F_RegisterID = RM.F_MemberRegisterID
			WHERE MR.F_MatchID = @MatchID AND RM.F_RegisterID = @TeamID AND F_MatchSplitID = @SplitID
			AND RM.F_MemberRegisterID in (select top 3 F_RegisterID from TS_Match_Result where F_MatchID = @MatchID and F_RegisterID in 
			(select F_MemberRegisterID from TR_Register_Member where f_registerid = @TeamID) order by F_PointsCharDes1,F_PointsCharDes2)
			ORDER BY MSR.F_Points) AS T
	    ELSE IF @SexCode = 2 
			SELECT @ResultNum = SUM(T.F_Points) FROM (
			SELECT TOP 2 MSR.F_Points FROM TS_Match_Result AS MR 
			LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
			LEFT JOIN TR_Register_Member AS RM ON MR.F_RegisterID = RM.F_MemberRegisterID
			WHERE MR.F_MatchID = @MatchID AND RM.F_RegisterID = @TeamID AND F_MatchSplitID = @SplitID
			AND RM.F_MemberRegisterID in (select top 2 F_RegisterID from TS_Match_Result where F_MatchID = @MatchID and F_RegisterID in 
			(select F_MemberRegisterID from TR_Register_Member where f_registerid = @TeamID) order by F_PointsCharDes1,F_PointsCharDes2)
			ORDER BY MSR.F_Points) AS T
	END
	ELSE IF @Type = 2 --Par
	BEGIN
	    IF @SexCode = 1 
			SELECT @ResultNum = SUM(T.F_SplitPoints) FROM (
			SELECT TOP 3 MSR.F_SplitPoints FROM TS_Match_Result AS MR 
			LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
			LEFT JOIN TR_Register_Member AS RM ON MR.F_RegisterID = RM.F_MemberRegisterID
			WHERE MR.F_MatchID = @MatchID AND RM.F_RegisterID = @TeamID AND F_MatchSplitID = @SplitID
			AND RM.F_MemberRegisterID in (select top 3 F_RegisterID from TS_Match_Result where F_MatchID = @MatchID and F_RegisterID in 
			(select F_MemberRegisterID from TR_Register_Member where f_registerid = @TeamID) order by F_PointsCharDes1,F_PointsCharDes2)
			ORDER BY MSR.F_SplitPoints) AS T
	    ELSE IF @SexCode = 2 
			SELECT @ResultNum = SUM(T.F_SplitPoints) FROM (
			SELECT TOP 2 MSR.F_SplitPoints FROM TS_Match_Result AS MR 
			LEFT JOIN TS_Match_Split_Result AS MSR ON MR.F_MatchID = MSR.F_MatchID AND MR.F_CompetitionPosition = MSR.F_CompetitionPosition
			LEFT JOIN TR_Register_Member AS RM ON MR.F_RegisterID = RM.F_MemberRegisterID
			WHERE MR.F_MatchID = @MatchID AND RM.F_RegisterID = @TeamID AND F_MatchSplitID = @SplitID
			AND RM.F_MemberRegisterID in (select top 2 F_RegisterID from TS_Match_Result where F_MatchID = @MatchID and F_RegisterID in 
			(select F_MemberRegisterID from TR_Register_Member where f_registerid = @TeamID) order by F_PointsCharDes1,F_PointsCharDes2)
			ORDER BY MSR.F_SplitPoints ) AS T	    
	END

	RETURN @ResultNum

END



GO


