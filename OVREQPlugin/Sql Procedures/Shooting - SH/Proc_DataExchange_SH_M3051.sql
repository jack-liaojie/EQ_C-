IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_SH_M3051]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_SH_M3051]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_SH_M3051]
----功		  能：阶段成绩（个人）
----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:


CREATE PROCEDURE [dbo].[Proc_DataExchange_SH_M3051]
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
	
	
	
	CREATE TABLE #TMP_Athlete(MatchID INT,
							Phase VARCHAR(10),
							Unit VARCHAR(10),
							RegisterID INT,
							Registration VARCHAR(10),
							Bay VARCHAR(3),
							[Rank] NVARCHAR(10),
							Total NVARCHAR(20),
							InX		INT,
							Shoot_Off VARCHAR(10),
							Record VARCHAR(10),
							Record_Type VARCHAR(10),
							Qualified VARCHAR(10),
							Qualification VARCHAR(10),
							Off_Number INT,
							[Order] INT
							)


	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @StatusID INT

	SELECT 	@EventCode = Event_Code,
			@PhaseCode = Phase_Code,
			@MatchCode = Match_Code
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	IF @MatchCode = '50' RETURN -- now not send shoot off, the shoot off will be send with it's parent match

	IF @EventCode IN ('001', '003', '101', '103') AND @PhaseCode = '9' AND @MatchCode = '00'
	RETURN 

	SELECT @StatusID = F_MatchStatusID
	FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @StatusID NOT IN( 50,100,110 ) RETURN


	--shoot off table
	DECLARE @SHOTCOUT INT
	CREATE TABLE #SHOOT_OFF(F_RegisterID INT, F_RegisterCode NVARCHAR(20), F_Points NVARCHAR(100), F_ShotIndex INT)
	SELECT  @SHOTCOUT = dbo.[Func_SH_GetShootOffMatchID] (@MatchID)

	
	IF @PhaseCode IN ('A')
	BEGIN
		INSERT INTO #SHOOT_OFF(F_RegisterID, F_RegisterCode, F_Points, F_ShotIndex)
		SELECT TR.F_RegisterID, RR.F_RegisterCode, F_ActionDetail1/10, F_MatchSplitID
		FROM TS_Match_ActionList AS TR
		LEFT JOIN TR_Register AS RR ON TR.F_RegisterID = RR.F_RegisterID
		WHERE F_MatchID IN (
				SELECT  dbo.[Func_SH_GetShootOffMatchID] (@MatchID)
		) AND TR.F_RegisterID IS NOT NULL
	END

	ELSE IF @PhaseCode IN ( '1')	
	BEGIN
		IF @EventCode = '005'
		BEGIN
			INSERT INTO #SHOOT_OFF(F_RegisterID, F_RegisterCode, F_Points, F_ShotIndex)
			SELECT TR.F_RegisterID, RR.F_RegisterCode, 
			CAST(F_ActionDetail1 AS INT)/10, DENSE_RANK() OVER(ORDER BY F_MatchID )
			FROM TS_Match_ActionList AS TR
			LEFT JOIN TR_Register AS RR ON TR.F_RegisterID = RR.F_RegisterID
			WHERE F_MatchID IN (SELECT A.F_MatchID FROM TS_Match A
				LEFT JOIN TS_Phase B ON A.F_PhaseID = B.F_PhaseID
				LEFT JOIN TS_Event C ON B.F_EventID = C.F_EventID
				WHERE B.F_PhaseCode = @PhaseCode AND C.F_EventCode = @EventCode AND A.F_MatchCode = '50'
			) AND TR.F_RegisterID IS NOT NULL
						
						
		END
		ELSE
		BEGIN
			INSERT INTO #SHOOT_OFF(F_RegisterID, F_RegisterCode, F_Points, F_ShotIndex)
			SELECT TR.F_RegisterID, RR.F_RegisterCode, 
			CAST(CAST(F_ActionDetail1 AS DECIMAL(10,1))/10.0 AS DECIMAL(10,1)), F_MatchSplitID
			FROM TS_Match_ActionList AS TR
			LEFT JOIN TR_Register AS RR ON TR.F_RegisterID = RR.F_RegisterID
			WHERE F_MatchID IN (
					SELECT  dbo.[Func_SH_GetShootOffMatchID] (@MatchID)
			) AND TR.F_RegisterID IS NOT NULL 
			ORDER BY F_MatchSplitID
		END
	
	END

	ELSE IF @PhaseCode IN ( '9') AND @EventCode IN('007','009','011','013','105','107','109')
	BEGIN
		INSERT INTO #SHOOT_OFF(F_RegisterID, F_RegisterCode, F_Points, F_ShotIndex)
		SELECT TR.F_RegisterID, RR.F_RegisterCode, 
--		CAST(CAST(F_ActionDetail1 AS DECIMAL(10,1))/10.0 AS DECIMAL(10,1)), F_MatchSplitID
		CAST(F_ActionDetail1 AS INT)/10, F_MatchSplitID
		FROM TS_Match_ActionList AS TR
		LEFT JOIN TR_Register AS RR ON TR.F_RegisterID = RR.F_RegisterID
		WHERE F_MatchID IN (
				SELECT  dbo.[Func_SH_GetShootOffMatchID] (@MatchID)
		) AND TR.F_RegisterID IS NOT NULL
	END

	ELSE IF @PhaseCode IN ( '9') AND @EventCode IN ('005') AND @MatchCode = '02'
	BEGIN
		INSERT INTO #SHOOT_OFF(F_RegisterID, F_RegisterCode, F_Points, F_ShotIndex)
		SELECT TR.F_RegisterID, RR.F_RegisterCode, 
		CAST(F_ActionDetail1 AS INT)/10, F_MatchSplitID
		FROM TS_Match_ActionList AS TR
		LEFT JOIN TR_Register AS RR ON TR.F_RegisterID = RR.F_RegisterID
		WHERE F_MatchID IN (
				SELECT  dbo.[Func_SH_GetShootOffMatchID] (@MatchID)
		) AND TR.F_RegisterID IS NOT NULL
	END

	-- 25m rapid Men, need cast 1 as Bay:A, ...		
	DECLARE @NeedChar INT
	IF @EventCode IN ('005') 
	   SET @NeedChar = 1
	ELSE
	   SET @NeedChar = 0   
	
	
	
	INSERT #TMP_Athlete(MatchID, RegisterID, Registration, Bay, 
			[Rank], Total, Shoot_Off, Record, Record_Type, Qualified, 
			Qualification, Off_Number, [Order], Phase,  Unit, InX)
	SELECT @MatchID, A.F_RegisterID, C.F_RegisterCode, 
	case when @NeedChar = 1 then [dbo].[Func_SH_GetBay](A.F_CompetitionPositionDes1)
	     else cast(F_CompetitionPositionDes1 As  NVARCHAR(10)) end , 
			A.F_Rank, 
			A.F_Points,
			'0',
			'N',
			'',
			'N',
			B.F_IRMCODE,
			'0',
			ROW_NUMBER() OVER(ORDER BY A.F_Rank), 
			@PhaseCode, 
			@MatchCode,
			F_RealScore
	FROM TS_Match_Result AS A 
	LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
	LEFT JOIN TR_Register C ON C.F_RegisterID = A.F_RegisterID
	WHERE A.F_MatchID = @MatchID
	
	--IF @PhaseCode = '1'
	--BEGIN
	--	UPDATE #TMP_Athlete 
	--	SET [RANK] = NULL
	--	WHERE [Rank] IN('999','0')
	--END
	--ELSE
	
	IF @PhaseCode <> '1'
	BEGIN
		UPDATE #TMP_Athlete 
		SET [RANK] = NULL
		WHERE [Rank] IN('998','999','0')
	END
	
	
	-- record
	
	UPDATE #TMP_Athlete SET Record = 'Y', Record_Type = case when B.F_Equalled = 1 then 'E' + B.F_RecordTypeCode else B.F_RecordTypeCode end
	FROM #TMP_Athlete AS A 
			
			LEFT JOIN
			(	
				SELECT A.F_RegisterID, D.F_RecordTypeCode, A.F_Equalled
				FROM TS_Result_Record  AS A  
				LEFT JOIN TS_Event_Record AS C ON A.F_RecordID = C.F_RecordID 
				LEFT JOIN TC_RecordType AS D ON D.F_RecordTypeID = C.F_RecordTypeID
				WHERE F_MatchID = @MatchID
				) 
				
			 B ON A.RegisterID = B.F_RegisterID
			
	WHERE B.F_RecordTypeCode IS NOT NULL
				

	IF @PhaseCode IN( '9', 'A' )
	BEGIN	
		UPDATE #TMP_Athlete SET Total =  CAST(cast(Total as int)/10 AS NVARCHAR(10)) + '-' + CAST(isnull(InX,0) as NVARCHAR(10)) + 'x' 
	END
		
	IF @PhaseCode = '1'	
	BEGIN
		IF @EventCode = '005'		UPDATE #TMP_Athlete SET Total = cast(Total as int)/10
		ELSE 						UPDATE #TMP_Athlete SET Total = cast(cast(Total as int)/10.0 as decimal(10,1))
	END
	
	--test
	--select * from #TMP_Athlete
	
	
	
	DECLARE @COUNT INT
	SELECT @COUNT = COUNT(*) FROM #TMP_Athlete
	IF @COUNT <=0 RETURN


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
						 FROM #SHOOT_OFF AS Shoot_Off FOR XML AUTO , TYPE) 
						 FROM dbo.[Func_DataExchange_GetMessageHeader] ('SH', '1.0', 'VRS-001', 'M3051', @MatchID, 'ENG', 0) AS [Message]
						 FOR XML AUTO )
	
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader


	SELECT @OutputXML AS MessageXML
	

SET NOCOUNT OFF
END

GO


/*

EXEC [Proc_DataExchange_SH_M3051]  2188, 'ENG'
EXEC [Proc_DataExchange_SH_M3051]  16, 'ENG'

*/

 
