IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Func_SH_GetTeamSourceMatchID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Func_SH_GetTeamSourceMatchID]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Func_SH_GetTeamSourceMatchID]
								(
									@MatchID   INT
								)
RETURNS @retTable		 TABLE(
								F_MatchID INT
							)
AS
BEGIN

	DECLARE @EventCode	CHAR(3)
	DECLARE @PhaseCode	CHAR(1)
	DECLARE @UnitCode	CHAR(2)
		
	SELECT	@EventCode = Event_Code, 
			@PhaseCode = Phase_Code, 
			@UnitCode =  Match_Code 
	FROM dbo.[Func_SH_GetEventCommonCodeInfo] (@MatchID)
	
	IF @EventCode = '002' SET @EventCode = '001'
	IF @EventCode = '004' SET @EventCode = '003'
	IF @EventCode = '006' SET @EventCode = '005'
	IF @EventCode = '008' SET @EventCode = '007'
	IF @EventCode = '010' SET @EventCode = '009'
	IF @EventCode = '012' SET @EventCode = '011'
	IF @EventCode = '014' SET @EventCode = '013'
	
	IF @EventCode = '102' SET @EventCode = '101'
	IF @EventCode = '104' SET @EventCode = '103'
	IF @EventCode = '106' SET @EventCode = '105'
	IF @EventCode = '108' SET @EventCode = '107'
	IF @EventCode = '110' SET @EventCode = '109'
	
	SET @PhaseCode = '9'
	
	IF @EventCode IN ('011', '013', '107', '109' )--'009' 50m pistol
	BEGIN
		SET @PhaseCode = 'A'
	END
	
	IF @EventCode = '005'
	BEGIN
		INSERT INTO @retTable(F_MatchID)
		SELECT A.F_MatchID FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		WHERE C.F_EventCode = @EventCode AND B.F_PhaseCode = @PhaseCode AND A.F_MatchCode IN ('02')
	END

	ELSE IF @EventCode = '105'
	BEGIN
		INSERT INTO @retTable(F_MatchID)
		SELECT A.F_MatchID FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		WHERE C.F_EventCode = @EventCode AND B.F_PhaseCode = @PhaseCode AND A.F_MatchCode IN ('00')
	END

	ELSE
	BEGIN
		INSERT INTO @retTable(F_MatchID)
		SELECT A.F_MatchID FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		WHERE C.F_EventCode = @EventCode AND B.F_PhaseCode = @PhaseCode AND A.F_MatchCode IN ('01','02')
	END
		
		
	RETURN
	
END

GO


-- SELECT * FROM DBO.Func_SH_GetTeamSourceMatchID(51)
