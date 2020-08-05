IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetShotCount]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetShotCount]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Func_SH_GetShotCount]
								(
									@MatchID   INT
								)
RETURNS INT
AS
BEGIN

 	DECLARE @SHOTCOUNT TABLE(
		EVENT_CODE NVARCHAR(10),
		PHASE_CODE NVARCHAR(10),
		SHOT_COUNT INT)		

	DECLARE @PhaseCode AS NVARCHAR(10)
	DECLARE @EventInfo AS NVARCHAR(10)
	DECLARE @RegType AS NVARCHAR(10)
	DECLARE @SexCode AS NVARCHAR(10)
	
	SELECT  @PhaseCode = PHASE_CODE, 
			@EventInfo = Event_Info,
			@RegType = RegType,
			@SexCode = Gender_Code
	FROM Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	DECLARE @Count INT

	--Ellimination
	IF @SexCode = 'M' AND @EventInfo = '50P' AND @RegType = 1 AND @PhaseCode = 'A' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = '50RF3P' AND @RegType = 1 AND @PhaseCode = 'A' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = '50RP' AND @RegType = 1 AND @PhaseCode = 'A' SET @Count = 6
	IF @SexCode = 'W' AND @EventInfo = '50RF3P' AND @RegType = 1 AND @PhaseCode = 'A' SET @Count = 6

	--Qualification
	IF @SexCode = 'M' AND @EventInfo = '10AP'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = '10AR'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = '25RF'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = '50P'    AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = '50RF3P' AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 12
	IF @SexCode = 'M' AND @EventInfo = '50RP'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'M' AND @EventInfo = 'SKEET'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 5
	IF @SexCode = 'M' AND @EventInfo = 'TRAP'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 5
	IF @SexCode = 'M' AND @EventInfo = 'DOUBLETRAP' AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 3
	
	IF @SexCode = 'W' AND @EventInfo = '10AP'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 4
	IF @SexCode = 'W' AND @EventInfo = '10AR'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 4
	IF @SexCode = 'W' AND @EventInfo = '25P'    AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'W' AND @EventInfo = '50RF3P' AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 6
	IF @SexCode = 'W' AND @EventInfo = 'TRAP'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 3
	IF @SexCode = 'W' AND @EventInfo = 'SKEET'   AND @RegType = 1 AND @PhaseCode = '9' SET @Count = 3

	--Final
	IF @SexCode = 'M' AND @EventInfo = '10AP'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'M' AND @EventInfo = '10AR'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'M' AND @EventInfo = '25RF'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 8
	IF @SexCode = 'M' AND @EventInfo = '50P'    AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'M' AND @EventInfo = '50RF3P' AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'M' AND @EventInfo = '50RP'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'M' AND @EventInfo = 'SKEET'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 25
	IF @SexCode = 'M' AND @EventInfo = 'TRAP'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 25
	IF @SexCode = 'M' AND @EventInfo = 'DOUBLETRAP' AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 25
	
	IF @SexCode = 'W' AND @EventInfo = '10AP'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'W' AND @EventInfo = '10AR'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'W' AND @EventInfo = '25P'    AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 8
	IF @SexCode = 'W' AND @EventInfo = '50RF3P' AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 10
	IF @SexCode = 'W' AND @EventInfo = 'SKEET'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 25
	IF @SexCode = 'W' AND @EventInfo = 'TRAP'   AND @RegType = 1 AND @PhaseCode = '1' SET @Count = 25

	RETURN @Count

END

GO


-- SELECT DBO.Func_SH_GetShotCount(1)
