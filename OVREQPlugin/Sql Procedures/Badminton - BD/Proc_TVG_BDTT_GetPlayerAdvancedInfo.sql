IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetPlayerAdvancedInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetPlayerAdvancedInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetPlayerAdvancedInfo]
----功		  能：获取对阵双方的晋级历程
----作		  者：王强
----日		  期: 2011-04-28

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetPlayerAdvancedInfo]
		@MatchID     INT
AS
BEGIN
	
SET NOCOUNT ON
	
	CREATE TABLE #TMP_TABLE 
	(
	    NOC NVARCHAR(20),
	    PlayerName NVARCHAR(100),
	    CurrentPhaseName NVARCHAR(100),
	    NextPhaseName NVARCHAR(100)
	)
	
	INSERT INTO #TMP_TABLE (NOC, PlayerName, CurrentPhaseName)
	(
		SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), B.F_TvShortName, D.F_PhaseShortName  
		FROM TS_Match_Result AS A 
		LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Match AS C ON C.F_MatchID = A.F_MatchID
		LEFT JOIN TS_Phase_Des AS D ON D.F_PhaseID = C.F_PhaseID AND D.F_LanguageCode = 'ENG'
		WHERE A.F_ResultID = 1 AND A.F_MatchID = @MatchID
	)
	DECLARE @NextMatchID INT
	SELECT @NextMatchID = F_MatchID FROM TS_Match_Result WHERE F_SourceMatchID = @MatchID
	IF @NextMatchID IS NOT NULL
	BEGIN
		UPDATE #TMP_TABLE SET NextPhaseName = 
		( 
			SELECT C.F_PhaseShortName FROM TS_Match AS A 
			LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = B.F_PhaseID AND C.F_LanguageCode = 'ENG'
			WHERE A.F_MatchID = @NextMatchID
		)
	END
	
	SELECT NOC, REPLACE(PlayerName,'/',' / ') AS PlayerName,CurrentPhaseName + ' to ' + NextPhaseName AS AdvancedInfo FROM #TMP_TABLE

	
	
SET NOCOUNT OFF
END


GO


