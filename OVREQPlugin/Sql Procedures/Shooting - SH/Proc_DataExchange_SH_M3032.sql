IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_SH_M3032]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_SH_M3032]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_SH_M3032]
----功		  能：射击过程成绩（单发）
----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID

CREATE PROCEDURE [dbo].[Proc_DataExchange_SH_M3032]
		@MatchID			INT,
		@Language			NVARCHAR(10)
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @EventCode NVARCHAR(3)
	DECLARE @PhaseCode NVARCHAR(3)
	DECLARE @UnitCode NVARCHAR(3)
	DECLARE @StatusID INT
	
	SELECT @UnitCode = F_MatchCode,
			@StatusID = F_MatchStatusID 
	FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @UnitCode = '50' RETURN
	
	IF @StatusID NOT IN( 50, 100, 110 ) RETURN
	
	
	
	
	
	SELECT @EventCode = Event_Code, 
			@PhaseCode = Phase_Code 
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	-- IF the match is team match OR Qualification match, then not send to INFO
	DECLARE @IS_TEAM_MATCH INT
	SELECT @IS_TEAM_MATCH = [dbo].[Func_SH_IsTeamMatch](@MatchID)
	IF(@IS_TEAM_MATCH = 1) RETURN
	

	IF @PhaseCode <> '1' RETURN

	

	--CREATE TABLE #TMP_ShotIndex(CP INT,
	--						ShotIndex INT,
	--						ShotValue INT
	--						)
	--INSERT #TMP_ShotIndex(CP, ShotIndex)
	--SELECT F_CompetitionPosition, MAX(F_MatchSplitID) FROM TS_Match_ActionList 
	--WHERE F_MatchID = @MatchID
	--GROUP BY F_CompetitionPosition

	--UPDATE #TMP_ShotIndex
	--SET ShotValue = F_ActionDetail1 FROM #TMP_ShotIndex A
	--LEFT JOIN TS_Match_ActionList B ON A.CP = B.F_CompetitionPosition AND B.F_MatchSplitID = A.ShotIndex
	--WHERE F_MatchID = @MatchID
	
	CREATE TABLE #TMP_Athlete(MatchID INT,
							CP INT,
							RegisterID INT,
							Registration VARCHAR(10),
							Bay VARCHAR(3),
							Phase_Score NVARCHAR(10),
							Total_Score NVARCHAR(10),
							Current_Rank NVARCHAR(10),
							[Order] INT)


	CREATE TABLE #TMP_Result(CP INT,
							RegisterID INT,
							Shoot_No INT,
							Score NVARCHAR(10))
	
	INSERT #TMP_Athlete(MatchID, CP, RegisterID, Registration, Bay, Phase_Score, Current_Rank, Total_Score, [Order] )
	SELECT @MatchID, A.F_CompetitionPosition, A.F_RegisterID, C.F_RegisterCode, A.F_CompetitionPositionDes1,  
	D.ST, A.F_Rank, A.F_Points, ROW_NUMBER() OVER(ORDER BY A.F_Rank)
	FROM TS_Match_Result AS A 
	LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
	LEFT JOIN TR_Register C ON C.F_RegisterID = A.F_RegisterID
	LEFT JOIN dbo.Func_SH_GetMatchFinalResult(@MatchID) D ON D.REG_ID = A.F_RegisterID
	WHERE A.F_MatchID = @MatchID 
	
	--UPDATE #TMP_Athlete 
	--SET Current_Rank = NULL
	--WHERE Current_Rank IN('998','999','0')

	UPDATE #TMP_Athlete 
	SET Current_Rank = NULL
	WHERE Current_Rank IN('0')
		
	DECLARE @ShotCount INT
	SELECT 	@ShotCount = dbo.Func_SH_GetShotCount(@MatchID)
	
	DECLARE @NN INT
	SET @NN = 1
	
	WHILE @NN <= @ShotCount
	BEGIN
		INSERT #TMP_Result(CP, Shoot_No, Score)
		SELECT F_CompetitionPosition, @NN, ''
		FROM TS_Match_Result
		WHERE F_MatchID = @MatchID
		
		SET @NN = @NN + 1
	END
	
	CREATE TABLE #t(CP INT,
							RegisterID INT,
							Shoot_No INT,
							Score NVARCHAR(10))
							
	IF @PhaseCode = '9'
	BEGIN
		INSERT #t(CP, Shoot_No, Score)
		SELECT F_CompetitionPosition, F_MatchSplitID, F_ActionDetail1/10 
		FROM TS_Match_ActionList
		WHERE F_MatchID = @MatchID
	END

	IF @PhaseCode = '1'
	BEGIN
		IF @EventCode = '005'
		BEGIN
			INSERT #t(CP, Shoot_No, Score)
			SELECT F_CompetitionPosition, F_MatchSplitID, CAST(F_ActionDetail1/10 AS INT)
			FROM TS_Match_ActionList
			WHERE F_MatchID = @MatchID
		END
		ELSE
		BEGIN
			INSERT #t(CP, Shoot_No, Score)
			SELECT F_CompetitionPosition, F_MatchSplitID, CAST(F_ActionDetail1/10.0 AS DECIMAL(10,1))
			FROM TS_Match_ActionList
			WHERE F_MatchID = @MatchID
		END
	END
	
	UPDATE #TMP_Result SET Score = B.Score
	FROM #TMP_Result A
	LEFT JOIN #t B ON A.CP = B.CP AND A.Shoot_No = B.Shoot_No
	
	IF @PhaseCode = '9' UPDATE #TMP_Athlete SET Phase_Score = CAST(Phase_Score AS INT)/10, Total_Score = CAST(Total_Score AS INT)/10
	
	IF @EventCode = '005'
	BEGIN
		IF @PhaseCode = '1' UPDATE #TMP_Athlete SET Phase_Score = CAST(CAST(Phase_Score AS INT)/10 AS INT), Total_Score = CAST(CAST(Total_Score AS INT)/10 AS INT)
	END
	ELSE
	BEGIN
		IF @PhaseCode = '1' UPDATE #TMP_Athlete SET Phase_Score = CAST(CAST(Phase_Score AS INT)/10.0 AS DECIMAL(10,1)), Total_Score = CAST(CAST(Total_Score AS INT)/10.0 AS DECIMAL(10,1))
	END
	

	--IF NO RECORDS THEN RETURN
	DECLARE @CC INT
	SELECT @CC = COUNT(*) FROM #TMP_Athlete
	IF  @CC <= 0
	RETURN

	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @OutputHeader AS NVARCHAR(MAX)
	
	SET  @OutputHeader = (
			 SELECT [Version],
					 Category,
					 Origin,
					 RSC,
					 Discipline,
					 Gender,
					 [Event],
					 [Phase],
					 [Unit],
					 [Venue],
					 [Code],
					 [Type],
					 [Language],
					 [Date],
					 [Time],
					 Registration,
					 Bay, 
					 (SELECT Shoot_No, ISNULL(Score,'') Score FROM #TMP_Result Result WHERE CP = Athlete.CP ORDER BY Shoot_No FOR XML AUTO, TYPE),
					 ISNULL(Phase_Score,'') Phase_Score,
					 ISNULL(Total_Score,'') Total_Score,
					 ISNULL(Current_Rank,'')  Current_Rank,
					 [Order]
					 FROM dbo.[Func_DataExchange_GetMessageHeader] ('SH', '1.0', 'VRS-001', 'M3032', @MatchID, 'ENG', 0) AS [Message]
					 LEFT JOIN #TMP_Athlete as Athlete ON [Message].MatchID	 = Athlete.MatchID  
					 FOR XML AUTO )
	
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader
			
	SELECT @OutputXML AS MessageXML
	

SET NOCOUNT OFF
END

GO


/*

EXEC [Proc_DataExchange_SH_M3032]  3, 'ENG'
EXEC [Proc_DataExchange_SH_M3032]  1, 'ENG'
*/

 
