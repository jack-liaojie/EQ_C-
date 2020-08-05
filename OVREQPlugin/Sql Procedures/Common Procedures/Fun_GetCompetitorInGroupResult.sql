IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetCompetitorInGroupResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetCompetitorInGroupResult]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DBO].[Fun_GetCompetitorInGroupResult]
								(
									@PhaseID					INT,
									@RegisterID					INT,
									@ResultID					INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @MatchNum	AS INT
	
	SELECT  @MatchNum = COUNT(A.F_MatchID) FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
		WHERE A.F_RegisterID = @RegisterID AND A.F_ResultID = @ResultID AND B.F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_FatherPhaseID = @PhaseID)
	
	RETURN @MatchNum

END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO



--select DBO.Fun_GetCompetitorInGroupResult(F_PhaseID, F_RegisterID, 1) AS Win, 
--					DBO.Fun_GetCompetitorInGroupResult(F_PhaseID, F_RegisterID, 2) AS Lose, 
--					DBO.Fun_GetCompetitorInGroupResult(F_PhaseID, F_RegisterID, 3) AS Draw
--	FROM TS_Phase_Result 