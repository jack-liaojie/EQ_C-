
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_UpdateInnerX]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_UpdateInnerX]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SH_UpdateInnerX]
----功		  能：SET IRM
----作		  者：穆学峰 
----日		  期: 2010-4-19

CREATE PROCEDURE [dbo].[Proc_SH_UpdateInnerX] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@COUNT						INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	IF @CompetitionPosition IS NULL
	RETURN
	
	UPDATE TS_Match_Result SET F_RealScore = @COUNT 
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	
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


 EXEC Proc_SH_UpdateInnerX 28,10,30

 
*/