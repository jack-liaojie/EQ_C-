IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetPlayerCardAndIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetPlayerCardAndIRM]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TVG_BDTT_GetPlayerCardAndIRM]
----功		  能：获取TVG需要的计分板
----作		  者：王强
----日		  期: 2011-04-26

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetPlayerCardAndIRM]
		@MatchID     INT,
		@MatchSplitID INT = -1
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @CurrentSetID INT
	DECLARE @CurrentGameID INT
	
	CREATE TABLE #TMP_TABLE
	(
		NOC NVARCHAR(20),
		PlayerName NVARCHAR(100),
		IRM NVARCHAR(20),
		[Card]NVARCHAR(30)
	)
	IF @MatchSplitID = -1
		SET @CurrentSetID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 1)
	ELSE	
		SET @CurrentSetID = @MatchSplitID
	
	IF @CurrentSetID = 0
		GOTO LABEL_END
	
	DECLARE @MatchType INT
	SELECT @MatchType = F_MatchTypeID FROM TS_Match WHERE F_MatchID = @MatchID
	
	--单打 
	IF @MatchType = 1
	BEGIN
		INSERT INTO #TMP_TABLE (NOC, PlayerName, IRM, [Card])
		(	
			--SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID),B1.F_TvShortName, '[Image]IRM_' + C.F_IRMCODE,
			--		CASE A.F_Comment1
			--		WHEN 1 THEN '[Image]Card_Yellow'
			--		WHEN 2 THEN '[Image]Card_Red'
			--		ELSE NULL
			--		END
			--FROM TS_Match_Split_Result AS A
			--LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
			--LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
			--WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = ISNULL(@CurrentSetID, @CurrentSetID)
			--		AND ( ( A.F_IRMID IS NOT NULL ) OR ( A.F_Comment1 IS NOT NULL ) )
			
			SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID),B1.F_TvShortName, '[Image]IRM_' + C.F_IRMCODE,
					CASE A.F_Comment1
					WHEN 1 THEN '[Image]Card_Yellow'
					WHEN 2 THEN '[Image]Card_Red'
					ELSE NULL
					END
			FROM TS_Match_Split_Result AS A
			LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
			LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
			WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = ISNULL(@CurrentSetID, @CurrentSetID)
					AND ( ( A.F_IRMID IS NOT NULL ) OR ( A.F_Comment1 IS NOT NULL ) )
		)
		--不存在则从Match上取IRM
		IF NOT EXISTS (SELECT * FROM #TMP_TABLE)
		BEGIN
			INSERT INTO #TMP_TABLE (NOC, PlayerName, IRM, [Card])
			(
				SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), B.F_TvShortName, '[Image]IRM_' + C.F_IRMCODE, NULL
				FROM TS_Match_Result AS A 
				LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
				LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
				WHERE A.F_MatchID = @MatchID AND A.F_IRMID IS NOT NULL
			)
		END
		ELSE
		BEGIN
			--存在的话，也用Match上的IRM更新
			UPDATE #TMP_TABLE SET IRM = 
			(
				SELECT C.F_IRMCODE 
				FROM TS_Match_Result AS A 
				LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
				WHERE A.F_MatchID = @MatchID AND A.F_IRMID IS NOT NULL
			)
		END
	END
	ELSE IF @MatchType = 3
	BEGIN
		
		SET @CurrentGameID = [dbo].[Fun_BD_GetCurrentSetAndGameID](@MatchID, 2)
		
		INSERT INTO #TMP_TABLE (NOC, PlayerName, IRM, [Card])
		(
			SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(D.F_RegisterID),B1.F_TvShortName, '[Image]IRM_' + C.F_IRMCODE,
					CASE A.F_Comment1
					WHEN 1 THEN '[Image]Card_Yellow'
					WHEN 2 THEN '[Image]Card_Red'
					ELSE NULL
					END
			FROM TS_Match_Split_Result AS A
			LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
			LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
			LEFT JOIN TS_Match_Result AS D ON D.F_MatchID = A.F_MatchID AND D.F_CompetitionPositionDes1 = A.F_CompetitionPosition
			WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentGameID
			AND ( ( A.F_IRMID IS NOT NULL ) OR ( A.F_Comment1 IS NOT NULL ) )
		)
		--不存在的话，则从盘上取
		IF NOT EXISTS (SELECT * FROM #TMP_TABLE)
		BEGIN
			
			--从盘上插入
			INSERT INTO #TMP_TABLE (NOC, PlayerName, IRM, [Card])
			(
				SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(D.F_RegisterID),B1.F_TvShortName, '[Image]IRM_' + C.F_IRMCODE,
						CASE A.F_Comment1
						WHEN 1 THEN '[Image]Card_Yellow'
						WHEN 2 THEN '[Image]Card_Red'
						ELSE NULL
						END
				FROM TS_Match_Split_Result AS A
				LEFT JOIN TR_Register_Des AS B1 ON B1.F_RegisterID = A.F_RegisterID AND B1.F_LanguageCode = 'ENG'
				LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
				LEFT JOIN TS_Match_Result AS D ON D.F_MatchID = A.F_MatchID AND D.F_CompetitionPositionDes1 = A.F_CompetitionPosition
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @CurrentSetID
				AND ( ( A.F_IRMID IS NOT NULL ) OR ( A.F_Comment1 IS NOT NULL ) )
			)
			--盘上没有判罚，则从Match上找判罚
			IF NOT EXISTS (SELECT * FROM #TMP_TABLE)
			BEGIN
				INSERT INTO #TMP_TABLE (NOC, PlayerName, IRM, [Card])
				(
					SELECT '[Image]' + dbo.Fun_BDTT_GetPlayerNOC(A.F_RegisterID), B.F_TvShortName, '[Image]IRM_' + C.F_IRMCODE, NULL
					FROM TS_Match_Result AS A 
					LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
					LEFT JOIN TC_IRM AS C ON C.F_IRMID = A.F_IRMID
					WHERE A.F_MatchID = @MatchID AND A.F_IRMID IS NOT NULL
				)
			END
			
		END
	END
	
	LABEL_END:	
	SELECT * FROM #TMP_TABLE

	
SET NOCOUNT OFF
END


GO


