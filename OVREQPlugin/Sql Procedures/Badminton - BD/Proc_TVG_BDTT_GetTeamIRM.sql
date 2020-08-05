IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetTeamIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetTeamIRM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetTeamIRM]
----功		  能：获取TVG团体赛的IRM
----作		  者：王强
----日		  期: 2011-05-31

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetTeamIRM]
		@MatchID INT
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP_TABLE
	(
		NOC NVARCHAR(10),
		TeamName NVARCHAR(100),
		IRM NVARCHAR(20)
	)
	
	DECLARE @EventType INT
	SELECT @EventType = C.F_PlayerRegTypeID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	IF @EventType != 3
	BEGIN
		SELECT * FROM #TMP_TABLE
		RETURN
	END
	
	INSERT INTO #TMP_TABLE (NOC, TeamName, IRM)
	(
		SELECT dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), C.F_TvShortName, '[Image]IRM_' + B.F_IRMCODE
		FROM TS_Match_Result AS A
		LEFT JOIN TC_IRM AS B ON B.F_IRMID = A.F_IRMID
		LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchID AND A.F_IRMID IS NOT NULL
	)
	
	SELECT * FROM #TMP_TABLE
	
SET NOCOUNT OFF
END


GO


