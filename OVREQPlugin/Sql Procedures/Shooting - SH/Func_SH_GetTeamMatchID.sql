IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetTeamMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetTeamMatchID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Function:	get the team's matchId, according to qualifitcation's matchid
-- Author:		MU XUEFENG
-- Date:		2010/12/31

CREATE FUNCTION [dbo].[Func_SH_GetTeamMatchID]
								(
									@MatchID   INT--qualifitcation's matchid
								)
RETURNS INT
AS
BEGIN

	DECLARE @EventCode CHAR(3)
	DECLARE @PhaseCode CHAR(1)
	DECLARE @UnitCode CHAR(2)
	DECLARE @SexCode NVARCHAR(10)
	DECLARE @EventInfo NVARCHAR(10)
	DECLARE @RegType NVARCHAR(10)
		
	SELECT	@EventCode = C.F_EventCode, 
			@PhaseCode = B.F_PhaseCode, 
			@UnitCode = A.F_MatchCode,
			@EventInfo = c.F_EventInfo 
	FROM TS_Match AS A 
	LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
	WHERE A.F_MatchID = @MatchID

	DECLARE @GG NVARCHAR(10)
	
	IF @EventInfo = '10AR' AND @SexCode = '1' AND @RegType = '1' SET @GG = '3'
	IF @EventInfo = '10AP' AND @SexCode = '1' AND @RegType = '1' SET @GG = '3'
	IF @EventInfo = '10AR' AND @SexCode = '2' AND @RegType = '1' SET @GG = '3'

	
	-- virtual team match
	SET @PhaseCode = '0'-- Final
	SET @UnitCode = '00'-- match code
	
	
	DECLARE @Count INT
	SELECT @Count = COUNT(A.F_MatchID) 
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
	LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
	LEFT JOIN TC_Sex AS S ON S.F_SexCode = C.F_SexCode
	WHERE C.F_EventInfo = @EventInfo 
			 AND C.F_PlayerRegTypeID = @RegType
			 AND B.F_PhaseCode = @PhaseCode 
			 AND A.F_MatchCode = @UnitCode
			 AND S.F_GenderCode = @SexCode

	DECLARE @TeamMatchID INT
	
	IF @Count = 1
	BEGIN
		SELECT @TeamMatchID = A.F_MatchID 
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		LEFT JOIN TC_Sex AS S ON S.F_SexCode = C.F_SexCode
		WHERE C.F_EventInfo = @EventInfo
			AND B.F_PhaseCode = @PhaseCode 
			AND A.F_MatchCode = @UnitCode
			AND S.F_GenderCode = @SexCode
	END
	
	RETURN @TeamMatchID

END

GO


-- SELECT DBO.Func_SH_GetTeamMatchID(1)
