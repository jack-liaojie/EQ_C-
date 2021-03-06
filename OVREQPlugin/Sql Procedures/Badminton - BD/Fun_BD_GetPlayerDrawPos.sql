IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BD_GetPlayerDrawPos]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BD_GetPlayerDrawPos]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		王强
-- Create date: 2011/3/16
-- Description:	获取运动员的最初签位
-- =============================================

CREATE FUNCTION [dbo].[Fun_BD_GetPlayerDrawPos]
								(
									@MatchID INT,
									@Composition INT
								)
RETURNS INT
AS
BEGIN

    DECLARE @RegisterID INT
    SELECT @RegisterID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = @Composition
    IF @RegisterID IS NULL OR @RegisterID <= 0
		RETURN NULL
	
	DECLARE @EventID INT
	SELECT @EventID = A.F_EventID FROM TS_Event AS A
	LEFT JOIN TS_Phase AS B ON B.F_EventID = A.F_EventID
	LEFT JOIN TS_Match AS C ON C.F_PhaseID = B.F_PhaseID
	WHERE C.F_MatchID = @MatchID
	
	DECLARE @Pos INT
	SELECT @Pos = A.F_StartPhasePosition 
	FROM TS_Match_Result AS A
	LEFT JOIN TS_Match AS B ON B.F_MatchID = A.F_MatchID
	LEFT JOIN TS_Phase AS C ON C.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS D ON D.F_EventID = C.F_EventID
	WHERE F_RegisterID = @RegisterID AND F_StartPhasePosition IS NOT NULL AND D.F_EventID = @EventID
	
	RETURN @Pos
END

GO

