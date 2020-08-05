
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_UpdatePerInnerX]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_UpdatePerInnerX]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SH_UpdatePerInnerX]
----功		  能：SET IRM
----作		  者：穆学峰 
----日		  期: 2010-4-19

CREATE PROCEDURE [dbo].[Proc_SH_UpdatePerInnerX] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@ShotIndex					INT,
	@COUNT						INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	IF @CompetitionPosition IS NULL
	RETURN
	
	DECLARE @RC INT
	SELECT @RC = COUNT(*) FROM TS_Match_ActionList
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	AND F_MatchSplitID = @ShotIndex AND F_ActionTypeID = 2
	
	IF @RC = 1
	BEGIN
		UPDATE TS_Match_ActionList SET F_ActionDetail2 = @COUNT
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		AND F_MatchSplitID = @ShotIndex AND F_ActionTypeID = 2
		
		SELECT @COUNT = SUM(F_ActionDetail2) FROM TS_Match_ActionList
		WHERE F_MatchID = @MatchID
		AND F_CompetitionPosition = @CompetitionPosition
		
		UPDATE TS_Match_Result SET F_RealScore = @COUNT 
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		
	END
	
	EXECUTE Proc_SH_SetMatchRank @MatchID
	
	
	
	--	--Copy score to match2
	
	DECLARE @RegID INT
	SELECT @RegID = F_RegisterID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	
	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = Phase_Code,
			 @MatchCode = Match_Code
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)


	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID
	FROM TS_Match
	WHERE F_MatchID = @MatchID
	
	IF @EventCode = '005' AND @PhaseCode = '9' AND @MatchCode = '01'
	BEGIN
		DECLARE @M2 INT
		SELECT @M2 = F_MATCHID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchCode = '02'

		UPDATE TS_Match_Result SET F_RealScore = @COUNT 
		WHERE F_MatchID = @M2 AND F_RegisterID = @RegID
		
		EXECUTE Proc_SH_SetMatchRank @M2

	END

	
	
	
SET NOCOUNT OFF
END

GO


/*

	SP_COLUMNS TS_Match_Split_Info
 EXEC Proc_SH_UpdatePerInnerX 11,2,1,9
 EXEC Proc_SH_UpdatePerInnerX 17,18,2,9
 
 	INSERT INTO TS_Match_Split_Result(F_MatchID, F_MatchSplitID, F_CompetitionPosition, F_Points)
	SELECT 17, 1, 2, 10

 
*/

 
