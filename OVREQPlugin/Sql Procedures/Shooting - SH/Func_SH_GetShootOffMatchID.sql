IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetShootOffMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetShootOffMatchID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Func_SH_GetShootOffMatchID]
								(
									@MatchID   INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @return INT
	DECLARE @PhaseID INT
	
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode NVARCHAR(10)
	
	SELECT @EventCode = EVENT_CODE, 
			@PhaseCode = PHASE_CODE 
	FROM dbo.[Func_SH_GetEventCommonCodeInfo](@MatchID)	
	
	SELECT @PhaseID = F_PhaseID FROM TS_Match
	WHERE F_MatchId = @Matchid
	
	SELECT @return = A.F_MatchID FROM TS_Match A
	LEFT JOIN TS_Phase B ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event C ON B.F_EventID = C.F_EventID
	WHERE B.F_PhaseCode = @PhaseCode AND C.F_EventCode = @EventCode AND A.F_MatchCode = '50'
		AND B.F_PhaseID = @PhaseID
	
	RETURN @return

END

GO


-- SELECT DBO.Func_SH_GetShootOffMatchID(5)
