if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DeletePhaseByeMatches]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DeletePhaseByeMatches]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_DeletePhaseByeMatches
----功		  能：删除Phase下轮空的比赛
----作		  者：王强
----日		  期: 2012-06-12 

CREATE PROCEDURE proc_DeletePhaseByeMatches 
	@PhaseID INT
	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @PhaseHasPool INT
	SELECT @PhaseHasPool = F_PhaseHasPools FROM TS_Phase WHERE F_PhaseID = @PhaseID
	CREATE TABLE #BYE_MATCHES
	(
		MatchID INT
	)
	IF @PhaseHasPool = 1
	BEGIN
		INSERT INTO #BYE_MATCHES (MatchID)
		(
			SELECT F_MatchID FROM TS_Match WHERE F_PhaseID IN (SELECT F_PhaseID FROM TS_Phase WHERE F_FatherPhaseID = @PhaseID AND F_PhaseHasPools = 0)
					AND F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
		)
		DELETE FROM TS_Match_Result WHERE F_MatchID IN (SELECT MatchID FROM #BYE_MATCHES)
		DELETE FROM TS_Match_Des WHERE F_MatchID IN (SELECT MatchID FROM #BYE_MATCHES)
		DELETE FROM TS_Match WHERE F_MatchID IN (SELECT MatchID FROM #BYE_MATCHES)
		DELETE FROM TS_Phase_Position WHERE F_RegisterID = -1 AND F_PhaseID IN
		(
			SELECT F_PhaseID FROM TS_Phase WHERE F_FatherPhaseID = @PhaseID AND F_PhaseHasPools = 0
		)
		
		
	END
	ELSE
	BEGIN
		INSERT INTO #BYE_MATCHES (MatchID)
		(
			SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID
					AND F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
		)
		DELETE FROM TS_Match_Result WHERE F_MatchID IN (SELECT MatchID FROM #BYE_MATCHES)
		DELETE FROM TS_Match_Des WHERE F_MatchID IN (SELECT MatchID FROM #BYE_MATCHES)
		DELETE FROM TS_Match WHERE F_MatchID IN (SELECT MatchID FROM #BYE_MATCHES)
		DELETE FROM TS_Phase_Position WHERE F_RegisterID = -1 AND F_PhaseID = @PhaseID
	END

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

