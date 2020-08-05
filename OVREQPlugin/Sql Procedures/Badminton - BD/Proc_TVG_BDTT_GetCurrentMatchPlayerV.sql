IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetCurrentMatchPlayerV]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetCurrentMatchPlayerV]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetCurrentMatchPlayerV]
----功		  能：获取当前比赛的场上队员，列显示
----作		  者：王强
----日		  期: 2011-04-28

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetCurrentMatchPlayerV]
		@MatchID INT,
		@MatchSplitID INT = -1
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP_TABLE
	(
		NOC NVARCHAR(20),
		PlayerName_ENG NVARCHAR(100),
		PlayerName_CHN NVARCHAR(100)
	)
	

	DECLARE @MatchType INT
	DECLARE @CurrentSetID INT
	
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	IF @MatchType = 1
	BEGIN
		INSERT INTO #TMP_TABLE (NOC, PlayerName_ENG, PlayerName_CHN)
		(SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), REPLACE(B1.F_TvShortName,'/',' / '), B2.F_TvShortName FROM TS_Match_Result AS A
		LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
		WHERE A.F_MatchID = @MatchID)
	END
	ELSE IF @MatchType = 3
	BEGIN
		
		IF @MatchSplitID != -1
			SET @CurrentSetID = @MatchSplitID
		ELSE
			SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
			
		INSERT INTO #TMP_TABLE (NOC, PlayerName_ENG, PlayerName_CHN)
		(SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(C.F_RegisterID), REPLACE(B1.F_TvShortName,'/',' / '), B2.F_TvShortName FROM TS_Match_Split_Result AS A
		LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
		LEFT JOIN TR_Register_Des AS B2 ON B2.F_RegisterID = A.F_RegisterID AND B2.F_LanguageCode = 'CHN'
		LEFT JOIN TS_Match_Result AS C ON C.F_MatchID = A.F_MatchID AND C.F_CompetitionPositionDes1 = A.F_CompetitionPosition
		WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID)
		
	END
	
	SELECT * FROM #TMP_TABLE
	
SET NOCOUNT OFF
END


GO


