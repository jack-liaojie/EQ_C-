IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_HO_GetMatchWonLost]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_HO_GetMatchWonLost]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		张翠霞
-- Create date: 2012/08/30
-- Description:	统计小组排名需要
-- =============================================

CREATE FUNCTION [dbo].[Fun_HO_GetMatchWonLost]
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

	IF @TypeID = 1 --Matches
	BEGIN
	    SELECT @ResultNum = COUNT(X.F_MatchID) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
	    WHERE X.F_PhaseID = @PhaseID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID AND Y.F_ResultID = @ResultID
	END
	ELSE IF (@TypeID = 2) AND (@ResultID = 1) --WonScore
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_Points IS NULL THEN 0 ELSE X.F_Points END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID = @RegisterID
	END
	ELSE IF (@TypeID = 2) AND (@ResultID = 2) --LostScore
	BEGIN
	    SELECT @ResultNum = SUM(CASE WHEN X.F_Points IS NULL THEN 0 ELSE X.F_Points END) FROM TS_Match_Result AS X LEFT JOIN TS_Match AS Y ON X.F_MatchID = Y.F_MatchID
        WHERE Y.F_PhaseID = @PhaseID AND Y.F_MatchStatusID IN (100, 110) AND X.F_RegisterID <> @RegisterID
	END
	ELSE IF @TypeID = 4
	BEGIN
	    SELECT @ResultNum = COUNT(X.F_MatchID) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_MatchID
	    LEFT JOIN TS_Phase AS P ON X.F_PhaseID = P.F_PhaseID
	    WHERE P.F_EventID = @PhaseID AND X.F_MatchStatusID IN (100, 110) AND Y.F_RegisterID = @RegisterID
	END
	
	IF @ResultNum IS NULL
	SET @ResultNum = 0
	RETURN @ResultNum

END

GO


