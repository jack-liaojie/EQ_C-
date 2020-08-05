IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetDrawMatchNum]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetDrawMatchNum]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_GetDrawMatchNum]
								(
									@PhaseID					INT,
									@RegisterID					INT
								)
RETURNS INT
AS
BEGIN

	
	DECLARE @DrawMatchNum AS INT

	SELECT @DrawMatchNum = COUNT(A.F_MatchID) FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
		WHERE A.F_StartPhaseID = @PhaseID AND A.F_RegisterID = @RegisterID AND A.F_ResultID = 3 AND B.F_MatchStatusID = 110


	RETURN @DrawMatchNum

END



