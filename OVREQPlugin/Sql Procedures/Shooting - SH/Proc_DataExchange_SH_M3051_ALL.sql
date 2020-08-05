IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_SH_M3051_ALL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_SH_M3051_ALL]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_SH_M3051_ALL]
----功		  能：阶段成绩（个人）
----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID

CREATE PROCEDURE [dbo].[Proc_DataExchange_SH_M3051_ALL]
		@MatchID			INT,
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON
	
	
	-- IF the match is team match  then not send to INFO
	DECLARE @IS_TEAM_MATCH INT
	SELECT @IS_TEAM_MATCH = [dbo].[Func_SH_IsTeamMatch](@MatchID)
	
	IF (@IS_TEAM_MATCH = 1)
	RETURN	

	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_code,
	@PhaseCode = Phase_Code,
	 @MatchCode = Match_Code
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @PhaseCode IN ( '9') AND @EventCode IN ('005') AND @MatchCode = '02'
	RETURN

	IF @EventCode IN('007','105','009','011','013','107','109') AND @PhaseCode = '9'
	RETURN
		
	IF @PhaseCode IN('1', 'A')
	RETURN


	--shoot off table
	DECLARE @SHOTCOUT INT
	CREATE TABLE #SHOOT_OFF(F_RegisterID INT, F_RegisterCode NVARCHAR(20), F_Points NVARCHAR(100), F_ShotIndex INT)
	SELECT  @SHOTCOUT = dbo.[Func_SH_GetShootOffMatchID] (@MatchID)
	
	
	INSERT INTO #SHOOT_OFF(F_RegisterID, F_RegisterCode, F_Points, F_ShotIndex)
	SELECT TR.F_RegisterID, RR.F_RegisterCode, F_ActionDetail1/10, F_MatchSplitID
	FROM TS_Match_ActionList AS TR
	LEFT JOIN TR_Register AS RR ON TR.F_RegisterID = RR.F_RegisterID
	WHERE F_MatchID IN (
			SELECT  dbo.[Func_SH_GetShootOffMatchID] (@MatchID)
	) AND TR.F_RegisterID IS NOT NULL	

	DECLARE @StatusID INT
	SELECT @StatusID = F_MatchStatusID
	FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @StatusID NOT IN( 50,100,110 ) RETURN

	CREATE TABLE #TMP_Athlete(MatchID INT,
							Phase VARCHAR(10),
							Unit VARCHAR(10),
							RegisterID INT,
							Registration VARCHAR(10),
							Bay VARCHAR(3),
							[Rank] NVARCHAR(10),
							Total NVARCHAR(10),
							Shoot_Off VARCHAR(10),
							Record VARCHAR(10),
							Record_Type VARCHAR(10),
							Qualified VARCHAR(10),
							Qualification VARCHAR(10),
							Off_Number INT,
							[Order] INT
							)

	
	IF @PhaseCode = '9'
	BEGIN
		INSERT #TMP_Athlete(MatchID, RegisterID, Registration, Bay, 
				[Rank], Total, Shoot_Off, Record, Record_Type, Qualified, 
				Qualification, Off_Number, [Order], Phase, Unit)
		SELECT @MatchID, C.F_RegisterID, C.F_RegisterCode, '',
				A.F_PhaseRank, A.F_PhasePoints, '0','N','','N',
				B.F_IRMCODE,'0',	ROW_NUMBER() OVER(ORDER BY A.F_PhaseRank), @PhaseCode, '00'
		FROM TS_Phase_Result AS A 
		LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
		LEFT JOIN TR_Register C ON C.F_RegisterID = A.F_RegisterID
		WHERE A.F_PhaseID = @PhaseID
	END	

	CREATE TABLE #T_QMatchID(F_MatchID INT)
	
	IF @EventCode = '005'
	BEGIN
		INSERT INTO #T_QMatchID(F_MatchID)		
		SELECT F_MatchID FROM TS_Match M
		WHERE M.F_PhaseID = (SELECT F_PhaseID FROM TS_MATCH WHERE F_MatchID = @MatchID) AND F_MatchCode IN ('02')
	END
	ELSE
	BEGIN
		INSERT INTO #T_QMatchID(F_MatchID)		
		SELECT F_MatchID FROM TS_Match M
		WHERE M.F_PhaseID = (SELECT F_PhaseID FROM TS_MATCH WHERE F_MatchID = @MatchID) AND F_MatchCode IN ('01','02','03','04','05')
	END
	
	UPDATE #TMP_Athlete 
	SET [RANK] = NULL
	WHERE [Rank] IN('998','999','0')
	
	
	UPDATE #TMP_Athlete 
	SET [RANK] = NULL
	WHERE Qualification IN ('DNS','DSQ')
	
	--DECLARE @ShotoffMatchId INT
	--SELECT @ShotoffMatchId = [dbo].[Func_SH_GetShootOffMatchID](@MatchID)
	--DECLARE @MatchCode CHAR(2)
	--SELECT @MatchCode = F_MatchCode FROM TS_Match WHERE F_MatchID = @ShotoffMatchId
	
	--DECLARE @COUNT INT
	--SELECT @COUNT = COUNT(*) FROM #TMP_Athlete
	--IF @COUNT <=0 RETURN
	
	
	
	--IF @MatchCode = '50'
	--BEGIN
	--	CREATE TABLE #TMP_ShotIndex(REGID INT,
	--					CP INT,
	--					ShotIndex INT,
	--					ShotValue INT
	--					)
	--	INSERT #TMP_ShotIndex(CP, ShotIndex)
	--	SELECT F_CompetitionPosition, MAX(F_MatchSplitID) FROM TS_Match_ActionList 
	--	WHERE F_MatchID = @ShotoffMatchId
	--	GROUP BY F_CompetitionPosition
		
	--	UPDATE #TMP_ShotIndex
	--	SET REGID = B.F_RegisterID, ShotValue = B.F_Points
	--	FROM #TMP_ShotIndex A 
	--	LEFT JOIN TS_Match_Result B ON A.CP = B.F_CompetitionPosition
	--	WHERE B.F_MatchID = @ShotoffMatchId
			
	--	UPDATE #TMP_Athlete SET Shoot_Off = ShotValue, Off_Number = A.ShotIndex
	--	FROM #TMP_ShotIndex A 
	--	LEFT JOIN #TMP_Athlete B ON A.REGID = B.RegisterID
		
	--	IF @PhaseCode IN ('9','A')	UPDATE #TMP_Athlete SET Shoot_Off = cast(Shoot_Off as int)/10
		
	--	IF @EventCode = '005'
	--		IF @PhaseCode = '1'	UPDATE #TMP_Athlete SET Shoot_Off = cast(cast(Shoot_Off as int)/10 as INT)
	--	ELSE
	--		IF @PhaseCode = '1'	UPDATE #TMP_Athlete SET Shoot_Off = cast(cast(Shoot_Off as int)/10.0 as decimal(10,1))
		
	--END	

	
	UPDATE #TMP_Athlete SET Record = 'Y', Record_Type = case when B.F_Equalled = 1 then 'E' + B.F_RecordTypeCode else B.F_RecordTypeCode end
	FROM #TMP_Athlete AS A 
			
			LEFT JOIN
			(	
				SELECT A.F_RegisterID, D.F_RecordTypeCode, A.F_Equalled
				FROM TS_Result_Record  AS A  
				LEFT JOIN TS_Event_Record AS C ON A.F_RecordID = C.F_RecordID 
				LEFT JOIN TC_RecordType AS D ON D.F_RecordTypeID = C.F_RecordTypeID
				WHERE F_MatchID IN (SELECT F_MatchID FROM #T_QMatchID) ) 
				
			 B ON A.RegisterID = B.F_RegisterID
			
			WHERE B.F_RecordTypeCode IS NOT NULL
				

	IF @PhaseCode IN( '9', 'A' )	
	BEGIN
		UPDATE #TMP_Athlete SET Total = CAST(cast(Total as int)/10 AS NVARCHAR(10)) + '-' + CAST(B.F_RealScore as NVARCHAR(10)) + 'x'
		FROM #TMP_Athlete AS A
		LEFT JOIN TS_Match_Result AS B ON A.RegisterID = B.F_RegisterID
		WHERE B.F_MatchID IN (SELECT F_MatchID FROM #T_QMatchID)
	END
	
	IF @EventCode = '005'
		IF @PhaseCode = '1'	UPDATE #TMP_Athlete SET Total = cast(cast(Total as INT)/10 as INT)
	ELSE
		IF @PhaseCode = '1'	UPDATE #TMP_Athlete SET Total = cast(cast(Total as decimal(10,1))/10.0 as decimal(10,1))
	
	--TEST
	--SELECT *FROM #TMP_Athlete
	
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
	 [Message].[Phase],
	 [Message].[Unit],
	 [Venue],
	 [Code],
	 [Type],
	 [Language],
	 [Date],
	 [Time],
	 
	(SELECT  Result.Phase,
	 Result.Unit,
	 Registration,
	 Bay, 
	 ISNULL([Rank], '') Rank,
	 ISNULL(Total,'') Total, 
	 ISNULL(Record, '') Record,
	 ISNULL(Record_Type, '') Record_Type,
	 ISNULL(Qualified,'') Qualified,
	 ISNULL(Qualification,'') Qualification,
	 [Order] FROM #TMP_Athlete as Result WHERE [Message].MatchID = Result.MatchID FOR XML AUTO, TYPE),
	 
	( SELECT F_ShotIndex AS Shoot_No,
		F_RegisterCode AS Registration,
		F_Points AS Result
	 FROM #SHOOT_OFF AS Shoot_Off ORDER BY F_ShotIndex FOR XML AUTO , TYPE) 
	 
	 FROM dbo.[Func_DataExchange_GetMessageHeader] ('SH', '1.0', 'VRS-001', 'M3051', @MatchID, 'ENG', 1) AS [Message]
	 FOR XML AUTO )
	
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader


	SELECT @OutputXML AS MessageXML
	

SET NOCOUNT OFF
END

GO

/*
EXEC [Proc_DataExchange_SH_M3051_ALL]  2188, 'ENG'
EXEC [Proc_DataExchange_SH_M3051_ALL]  1, 'ENG'
*/

 
