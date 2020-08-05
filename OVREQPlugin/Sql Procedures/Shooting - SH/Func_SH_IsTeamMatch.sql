IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_IsTeamMatch]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_IsTeamMatch]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Function:	Is Team Match
-- Author:		MU XUEFENG
-- Date:		2010/12/22

CREATE FUNCTION [dbo].[Func_SH_IsTeamMatch]
								(
									@MatchID   INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @EventCode CHAR(3)
	DECLARE @PhaseCode CHAR(1)
	DECLARE @UnitCode CHAR(2)
		
	SELECT	@EventCode = C.F_EventCode, 
			@PhaseCode = B.F_PhaseCode, 
			@UnitCode = A.F_MatchCode 
	FROM TS_Match AS A 
	LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID

	--下面从common code 得来
	
	DECLARE @RETURN INT
	SET @RETURN = 0
	
	IF (@EventCode IN( '002', '004', '006' ,'008' ,'010' ,'012' ,'014' ,'102' ,	'104' ,	'106' ,	'108' ,	'110' ))
	BEGIN
		SET @RETURN = 1
	END
	
	RETURN @RETURN

END

GO


-- SELECT DBO.Func_SH_IsTeamMatch(34)
