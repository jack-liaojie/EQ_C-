IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GF_GetRegisterLastMuHoleInfo]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GF_GetRegisterLastMuHoleInfo]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		吴定昉
-- Create date: 2011/07/07
-- Description:	统计最后几杆的成绩
-- =============================================

CREATE FUNCTION [dbo].[Fun_GF_GetRegisterLastMuHoleInfo]
								(
								    @EventID                    INT,
									@RegisterID					INT,
									@PhaseOrder                 INT,
									@Type                       INT,	--1：杆数 2：Par								
									@HoleCount                  INT
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    DECLARE @MatchID AS INT
    SET @ResultNum = 0
    DECLARE @TotalHoleNum AS INT
    SET @TotalHoleNum = 0
   
    SELECT TOP 1 @MatchID = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE M.F_Order = 1 AND P.F_Order = @PhaseOrder AND P.F_EventID = @EventID

    SELECT @TotalHoleNum = MAX(F_MatchSplitID) FROM TS_Match_Split_Result
    
	IF @Type = 1 --Hole Number
	BEGIN
		SELECT @ResultNum = SUM(CAST(MSR.F_Points AS INT)) FROM TS_Match_Split_Result AS MSR
		LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition
		WHERE MR.F_MatchID = @MatchID    
		AND MR.F_RegisterID = @RegisterID
		AND MSR.F_MatchSplitID > @TotalHoleNum - @HoleCount
    END 
	ELSE IF @Type = 2 --Par
	BEGIN
		SELECT @ResultNum = SUM(CAST(MSR.F_SplitPoints AS INT)) FROM TS_Match_Split_Result AS MSR
		LEFT JOIN TS_Match_Result AS MR ON MSR.F_MatchID = MR.F_MatchID AND MSR.F_CompetitionPosition = MR.F_CompetitionPosition
		WHERE MR.F_MatchID = @MatchID    
		AND MR.F_RegisterID = @RegisterID
		AND MSR.F_MatchSplitID > @TotalHoleNum - @HoleCount
	END	
    
	RETURN @ResultNum

END


GO


