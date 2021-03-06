IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_GetMatchWonLost]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_GetMatchWonLost]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		张翠霞
-- Create date: 2010/7/8
-- Description:	统计小组排名需要
-- =============================================

CREATE FUNCTION [dbo].[Fun_BD_GetMatchWonLost]
								(
									@PhaseID					INT,
									@RegisterID					INT,
									@TypeID                     INT,
									@ResultID                   INT	
								)
RETURNS INT
AS
BEGIN

    DECLARE @ResultNum AS INT
    SET @ResultNum = 0

	IF @TypeID = 1 AND @ResultID = 0--total Ties
	BEGIN
		SELECT @ResultNum = COUNT(X.F_MatchID) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
	    WHERE X.F_PhaseID = @PhaseID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	END
	ELSE IF @TypeID = 1 --Ties
	BEGIN
	    SELECT @ResultNum = COUNT(X.F_MatchID) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
	    WHERE X.F_PhaseID = @PhaseID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID AND Y.F_ResultID = @ResultID
	END
	ELSE IF (@TypeID = 2) AND (@ResultID = 1) --WonMatches
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_WinSets IS NULL THEN 0 ELSE X.F_WinSets END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 2) AND (@ResultID = 2) --LostMatches
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_LoseSets IS NULL THEN 0 ELSE X.F_LoseSets END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 3) AND (@ResultID = 1) --WonGames
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_WinSets_1 IS NULL THEN 0 ELSE X.F_WinSets_1 END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 3) AND (@ResultID = 2) --LostGames
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_LoseSets_1 IS NULL THEN 0 ELSE X.F_LoseSets_1 END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 4) AND (@ResultID = 1) --WonPoints
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_WinSets_2 IS NULL THEN 0 ELSE X.F_WinSets_2 END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 4) AND (@ResultID = 2) --LostPoints
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_LoseSets_2 IS NULL THEN 0 ELSE X.F_LoseSets_2 END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID	    
	END
	
	IF @ResultNum IS NULL
	SET @ResultNum = 0
	RETURN @ResultNum

END





GO

