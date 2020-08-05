IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_HO_GetTeamStatistic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_HO_GetTeamStatistic]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		张翠霞
-- Create date: 2012/09/06
-- Description:	统计队伍的单项技术统计
-- =============================================

CREATE FUNCTION [dbo].[Fun_Report_HO_GetTeamStatistic]
								(
									@EventID					INT,
									@RegisterID					INT,
									@Par1                       INT,
									@Par2                       INT	
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    SET @ResultNum = 0

	IF @Par1 = 1 --主队
	BEGIN
	    IF @Par2 = 1
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_WinPoints IS NULL THEN 0 ELSE Y.F_WinPoints END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 2
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_LosePoints IS NULL THEN 0 ELSE Y.F_LosePoints END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 3
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_WinSets IS NULL THEN 0 ELSE Y.F_WinSets END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 4
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_DrawSets IS NULL THEN 0 ELSE Y.F_DrawSets END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 5
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_LoseSets IS NULL THEN 0 ELSE Y.F_LoseSets END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 6
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_WinSets_1 IS NULL THEN 0 ELSE Y.F_WinSets_1 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 7
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_LoseSets_1 IS NULL THEN 0 ELSE Y.F_LoseSets_1 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 8
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_WinSets_2 IS NULL THEN 0 ELSE Y.F_WinSets_2 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 9
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_LoseSets_2 IS NULL THEN 0 ELSE Y.F_LoseSets_2 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	END
	ELSE IF (@Par1 = 2) --客队
	BEGIN
	    IF @Par2 = 1
	    BEGIN
			SELECT @ResultNum = SUM(CAST (Y.F_PointsCharDes1 AS INT)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 2
	    BEGIN
			SELECT @ResultNum = SUM(CAST (Y.F_PointsCharDes2 AS INT)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 3
	    BEGIN
			SELECT @ResultNum = SUM(CAST (Y.F_PointsCharDes3 AS INT)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 4
	    BEGIN
			SELECT @ResultNum = SUM(CAST (Y.F_PointsCharDes4 AS INT)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 5
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_PointsNumDes1 IS NULL THEN 0 ELSE Y.F_PointsNumDes1 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 6
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_PointsNumDes2 IS NULL THEN 0 ELSE Y.F_PointsNumDes2 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 7
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_PointsNumDes3 IS NULL THEN 0 ELSE Y.F_PointsNumDes3 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 8
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_PointsNumDes4 IS NULL THEN 0 ELSE Y.F_PointsNumDes4 END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	    ELSE IF @Par2 = 9
	    BEGIN
			SELECT @ResultNum = SUM(CASE WHEN Y.F_StartTimeNumDes IS NULL THEN 0 ELSE Y.F_StartTimeNumDes END) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
			LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
			WHERE P.F_EventID = @EventID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	    END
	END
	
	IF @ResultNum IS NULL
	SET @ResultNum = 0
	RETURN @ResultNum

END

GO


