IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetContestInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetContestInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetContestInfo]
----功		  能：获取TVG需要的小组对阵及成绩
----作		  者：王强
----日		  期: 2011-04-25

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetContestInfo]
		@MatchID INT
AS
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @NOCA NVARCHAR(10)
	DECLARE @NOCB NVARCHAR(10)
	DECLARE @DuelPlayerAName_ENG NVARCHAR(100)
	DECLARE @DuelPlayerAName_CHN NVARCHAR(100)
	DECLARE @DuelPlayerBName_ENG NVARCHAR(100)
	DECLARE @DuelPlayerBName_CHN NVARCHAR(100)
	DECLARE @MatchScore NVARCHAR(20)
	
	SELECT @DuelPlayerAName_ENG = REPLACE(C1.F_TvShortName,'/',' / '), @DuelPlayerAName_CHN = C2.F_TvShortName,
		   @DuelPlayerBName_ENG = REPLACE(D1.F_TvShortName,'/',' / '), @DuelPlayerBName_CHN = D2.F_TvShortName,
		    @MatchScore = (CASE
		   WHEN (B1.F_Points IS NULL) AND (B2.F_Points IS NULL) THEN 'VS'
		   ELSE ISNULL( CONVERT( NVARCHAR(10), B1.F_Points ), '0') + ':' + ISNULL( CONVERT( NVARCHAR(10), B2.F_Points ), '0')
		   END), @NOCA = E2.F_DelegationCode, @NOCB = F2.F_DelegationCode
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS E1 ON E1.F_RegisterID = B1.F_RegisterID
	LEFT JOIN TC_Delegation AS E2 ON E2.F_DelegationID = E1.F_DelegationID
	
	LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = B2.F_RegisterID AND D1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = B2.F_RegisterID AND D2.F_LanguageCode = 'CHN'
	LEFT JOIN TR_Register AS F1 ON F1.F_RegisterID = B2.F_RegisterID
	LEFT JOIN TC_Delegation AS F2 ON F2.F_DelegationID = F1.F_DelegationID
	WHERE A.F_MatchID = @MatchID		
	
	--必须保证两个查询返回的所有列一致
	IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
	BEGIN
		SELECT '[Image]' + @NOCA AS NOCA, @DuelPlayerAName_ENG AS DuelPlayerAName_ENG, @DuelPlayerAName_CHN AS DuelPlayerAName_CHN,
			   '[Image]' + @NOCB AS NOCB, @DuelPlayerBName_ENG AS DuelPlayerBName_ENG, @DuelPlayerBName_CHN AS DuelPlayerBName_CHN,
			   @MatchScore AS MatchScore,
			   '' AS PlayerAName_ENG, '' AS PlayerAName_CHN,
			   '' AS PlayerBName_ENG, '' AS PlayerBName_CHN,
			   '' AS SetScore
	    RETURN
	END   

	CREATE TABLE #TMP_TABLE
	(
		NOCA NVARCHAR(20),
		DuelPlayerAName_ENG NVARCHAR(200),
		DuelPlayerAName_CHN NVARCHAR(200),
		NOCB NVARCHAR(20),
		DuelPlayerBName_ENG NVARCHAR(200),
		DuelPlayerBName_CHN NVARCHAR(200),
		MatchScore NVARCHAR(50),
		PlayerAName_ENG NVARCHAR(200),
		PlayerAName_CHN NVARCHAR(200),
		PlayerBName_ENG NVARCHAR(200),
		PlayerBName_CHN NVARCHAR(200),
		SetScore NVARCHAR(30),
		IRMA NVARCHAR(30),
		IRMB NVARCHAR(30)
	)
	INSERT INTO #TMP_TABLE
	SELECT '[Image]' + @NOCA AS NOCA, @DuelPlayerAName_ENG AS DuelPlayerAName_ENG, @DuelPlayerAName_CHN AS DuelPlayerAName_CHN,
	       '[Image]' + @NOCB AS NOCB, @DuelPlayerBName_ENG AS DuelPlayerBName_ENG, @DuelPlayerBName_CHN AS DuelPlayerBName_CHN,
	       @MatchScore AS MatchScore,
		   REPLACE((CASE WHEN A.F_MatchSplitType IN (1,2) THEN C1.F_TvShortName ELSE C1.F_TvShortName END),'/',' / ') AS PlayerAName_ENG, 
		   REPLACE((CASE WHEN A.F_MatchSplitType IN (1,2) THEN C2.F_TvShortName ELSE C2.F_TvShortName END),'/',' / ') AS PlayerAName_CHN,
		   REPLACE((CASE WHEN A.F_MatchSplitType IN (1,2) THEN D1.F_TvShortName ELSE D1.F_TvShortName END),'/',' / ') AS PlayerBName_ENG, 
		   REPLACE((CASE WHEN A.F_MatchSplitType IN (1,2) THEN D2.F_TvShortName ELSE D2.F_TvShortName END),'/',' / ') AS PlayerBName_CHN,
		   CASE
		   WHEN (B1.F_Points IS NULL) AND (B2.F_Points IS NULL) THEN 'VS'
		   ELSE ISNULL( CONVERT( NVARCHAR(10), B1.F_Points ), '0') + ':' + ISNULL( CONVERT( NVARCHAR(10), B2.F_Points ), '0')
		   END AS SetScore,
		   '[Image]IRM_' + X.F_IRMCODE AS IRMA, '[Image]IRM_' + Y.F_IRMCODE AS IRMB
	FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID 
				AND B1.F_CompetitionPosition = 1
	LEFT JOIN TC_IRM AS X ON X.F_IRMID = B1.F_IRMID
	LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID 
				AND B2.F_CompetitionPosition = 2
	LEFT JOIN TC_IRM AS Y ON Y.F_IRMID = B2.F_IRMID
	LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = B2.F_RegisterID AND D1.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = B2.F_RegisterID AND D2.F_LanguageCode = 'CHN'			
	WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 ORDER BY A.F_Order
	
	UPDATE #TMP_TABLE SET SetScore = '' WHERE PlayerAName_ENG IS NULL AND PlayerBName_ENG IS NULL
	
	SELECT * FROM #TMP_TABLE
SET NOCOUNT OFF
END


GO


--exec Proc_TVG_BDTT_GetContestInfo 70