
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_UpdateIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_UpdateIRM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--	NOT CHANGE SCORE AND RANK, ONLY CHANGE IRMID

----存储过程名称：[Proc_SH_UpdateIRM]
----功		  能：SET IRM
----作		  者：穆学峰 
----日		  期: 2010-09-25

CREATE PROCEDURE [dbo].[Proc_SH_UpdateIRM] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@IRMCODE					NVARCHAR(10)
)	
AS
BEGIN
	
SET NOCOUNT ON

	IF @CompetitionPosition IS NULL
	RETURN

	DECLARE @REG_ID INT
	SELECT @REG_ID = F_RegisterID FROM TS_Match_Result
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	
	IF @REG_ID IS NULL RETURN

	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = Phase_Code,
			 @MatchCode = Match_Code
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)

	DECLARE @Rank INT
	DECLARE @ITEMID AS INT

	IF @PhaseCode IN ('9','A')
	BEGIN
		IF @IRMCODE = 'DNS' SET @Rank = 998
		IF @IRMCODE = 'DSQ' SET @Rank = 999
	END
	
	IF (@IRMCODE = '' OR @IRMCODE IS NULL ) SET @Rank = NULL
	
	IF @IRMCODE IN( 'DNS', 'DSQ')
	BEGIN
		SELECT @ITEMID = F_IRMID FROM TC_IRM WHERE F_IRMCODE = @IRMCODE
		UPDATE TS_Match_Result SET F_IRMID = @ITEMID , F_Rank = @Rank, 
				F_RealScore = NULL, 
				F_Points = NULL
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		
		DELETE FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		
	END

	IF @IRMCODE IN( 'DNF')
	BEGIN
		SELECT @ITEMID = F_IRMID FROM TC_IRM WHERE F_IRMCODE = @IRMCODE
		UPDATE TS_Match_Result SET F_IRMID = @ITEMID 
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	END

	IF @IRMCODE = '' OR @IRMCODE IS NULL
	BEGIN
		UPDATE TS_Match_Result SET F_IRMID = NULL , F_Rank = @Rank
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
		
	END
	

	IF @IRMCODE IN ('DNS','DSQ','DNF') AND @PhaseCode = '1'
	BEGIN
	
			UPDATE TS_Match_Result SET F_Points = ISNULL(PR.F_PhasePoints,0)
				FROM TS_Match_Result MR
				LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID
				LEFT JOIN TS_Phase_Result PR ON MR.F_RegisterID = PR.F_RegisterID
				WHERE MR.F_MatchID = @MatchID AND MR.F_RegisterID = @REG_ID
				AND PR.F_PhaseID IN 
				(
					SELECT M.F_PhaseID FROM TS_Match AS M
						LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
						LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
						WHERE E.F_EventCode = @EventCode AND P.F_PhaseCode = '9'
				)
	
	END

	--udpate phase_result irm
			
	DECLARE @PHASEID INT
	DECLARE @PHASENUM INT
	SELECT @PHASENUM = ISNULL(MAX(ISNULL(F_PhaseResultNumber,0))+1,1) FROM TS_Phase_Result
	SELECT @PHASEID = F_PhaseID FROM TS_Phase_Result WHERE F_PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID )
	
	DECLARE @COUNT INT 
	SELECT @COUNT = COUNT(*) FROM TS_Phase_Result WHERE F_PhaseID = @PHASEID AND F_RegisterID = @REG_ID
		
	IF 	@COUNT <= 0
	BEGIN
		SELECT @PHASEID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
		INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber, F_RegisterID) VALUES(@PHASEID, @PHASENUM, @REG_ID)
	END
	
	IF @IRMCODE IN( 'DNS', 'DSQ')
	BEGIN
		SELECT @ITEMID = F_IRMID FROM TC_IRM WHERE F_IRMCODE = @IRMCODE
		UPDATE TS_Phase_Result SET F_IRMID = @ITEMID , F_PhaseRank = @Rank, F_PhasePoints = NULL
		WHERE F_PhaseID = ( SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID ) AND F_RegisterID = @REG_ID
	END

	IF @IRMCODE IN( 'DNF')
	BEGIN
		SELECT @ITEMID = F_IRMID FROM TC_IRM WHERE F_IRMCODE = @IRMCODE
		UPDATE TS_Phase_Result SET F_IRMID = @ITEMID 
		WHERE F_PhaseID = ( SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID ) AND F_RegisterID = @REG_ID
	END

	IF @IRMCODE = '' OR @IRMCODE IS NULL
	BEGIN
		UPDATE TS_Phase_Result SET F_IRMID = NULL , F_PhaseRank = @Rank
		WHERE F_PhaseID = ( SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID ) AND F_RegisterID = @REG_ID
	END
	
	EXECUTE Proc_SH_SetMatchRank @MatchID
		
	
	DECLARE @team_matchid INT
	SELECT @team_matchid = DBO.Func_SH_GetTeamMatchID(@MatchID)
	EXEC Proc_SH_SetTeamIRM @team_matchid
	
	
	
	IF @EventCode = '005' AND @PhaseCode = '9' AND @MatchCode = '01'
	BEGIN
		DECLARE @M2 INT
		SELECT @M2 = F_MATCHID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchCode = '02'

		--copy to match2
		SELECT  @CompetitionPosition = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @M2 AND F_RegisterID = @REG_ID
		exec [Proc_SH_UpdateIRM] @M2,@CompetitionPosition,@IRMCODE

	END
	
SET NOCOUNT OFF
END

GO


/*


 EXEC Proc_SH_UpdateIRM 1,29,'DNS'

 
*/