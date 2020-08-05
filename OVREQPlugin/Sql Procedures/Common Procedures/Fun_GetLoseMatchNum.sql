IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetLoseMatchNum]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetLoseMatchNum]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_GetLoseMatchNum]
								(
									@PhaseID					INT,
									@RegisterID					INT
								)
RETURNS INT
AS
BEGIN

	
	DECLARE @LoseMatchNum AS INT

	SELECT @LoseMatchNum = COUNT(A.F_MatchID) FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
		WHERE A.F_StartPhaseID = @PhaseID AND A.F_RegisterID = @RegisterID AND A.F_ResultID = 2 AND B.F_MatchStatusID = 110


	RETURN @LoseMatchNum

END



