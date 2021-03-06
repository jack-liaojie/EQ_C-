IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_SH_M3031]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_SH_M3031]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_SH_M3031]
----功		  能：射击过程成绩（资格赛）
----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID

CREATE PROCEDURE [dbo].[Proc_DataExchange_SH_M3031]
		@MatchID			INT,
--		@Auto				INT,
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @UnitCode NVARCHAR(10)
	DECLARE @StatusID INT
	
	SELECT @UnitCode = F_MatchCode,
		   @StatusID = F_MatchStatusID
	FROM TS_Match WHERE F_MatchID = @MatchID
	
	IF @UnitCode = '50' RETURN
	IF @StatusID NOT IN( 50,100,110 ) RETURN
	
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = Phase_Code 
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	IF @PhaseCode = '1' RETURN
	
	--VIRTUAL MATCH, SUM
	--IF @EventCode IN ('001', '003', '101', '103') AND @PhaseCode = '9' AND @UnitCode = '00'
	IF @UnitCode = '00'
	RETURN 
	
	DECLARE @IS_TEAM_MATCH INT
	SELECT @IS_TEAM_MATCH = [dbo].[Func_SH_IsTeamMatch](@MatchID)
	
	IF (@IS_TEAM_MATCH = 1)
	RETURN	
	
	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @OutputHeader AS NVARCHAR(MAX)

	CREATE TABLE #TMP_Athlete(MatchID INT,
							RegisterID INT,
							Registration NVARCHAR(10),
							Athlete_Name NVARCHAR(100),
							Athlete_Delegation NVARCHAR(100),
							CP INT,
							Bay VARCHAR(3),
							[Rank] NVARCHAR(10),
							Total NVARCHAR(20),
							InX		INT,
							Average NVARCHAR(10),
							Qualification VARCHAR(10),
							[Order] INT)

	CREATE TABLE #Stage(	
							RegisterID INT,
							CP INT,
							Stage INT,
							Stage_Code VARCHAR(10),
							Sub_Total  VARCHAR(10),
							Stage_Rank  VARCHAR(10),
							[Order] INT)

	CREATE TABLE #Series(	
							F_RegisterID INT,
							CP INT,
							Stage INT,
							Series INT,
							Series_Code VARCHAR(10),
							Score VARCHAR(10),
							[Order] INT)
	
	
	DECLARE @NeedChar INT

	IF @EventCode IN ('005') 
	   SET @NeedChar = 1
	ELSE
	   SET @NeedChar = 0   
	
	INSERT #TMP_Athlete(MatchID, Registration, CP, Bay, [Rank], Total, Qualification, [Order], RegisterID, InX)
	SELECT @MatchID, C.F_RegisterCode, A.F_CompetitionPosition, 
	case when @NeedChar = 1 then [dbo].[Func_SH_GetBay](A.F_CompetitionPositionDes1)
	     else cast(F_CompetitionPositionDes1 As  NVARCHAR(10)) end , 
			A.F_Rank, A.F_Points, B.F_IRMCODE,	ROW_NUMBER() OVER(ORDER BY A.F_Rank) , A.F_RegisterID, A.F_RealScore
	FROM TS_Match_Result AS A 
	LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
	LEFT JOIN TR_Register C ON C.F_RegisterID = A.F_RegisterID
	LEFT JOIN TR_Register_Des RD ON RD.F_RegisterID = C.F_RegTypeID
	LEFT JOIN TC_Delegation_Des DD ON C.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID
	
	UPDATE #TMP_Athlete 
	SET [RANK] = ''
	WHERE Qualification IN('DSQ','DNS')
		
	UPDATE #TMP_Athlete 
	SET Average = CONVERT(NUMERIC(10,3), (1.0*CAST(Total AS INT)/ISNULL(B.SN,1))/100.0 ) FROM #TMP_Athlete A
	LEFT JOIN 
	(SELECT F_CompetitionPosition, MAX(F_MatchSplitID) SN FROM TS_Match_ActionList
		WHERE F_MatchID = @MatchID
		GROUP BY F_CompetitionPosition) B ON A.CP = B.F_CompetitionPosition
	
	
	IF @PhaseCode IN( '9', 'A') UPDATE #TMP_Athlete SET Total = CAST(cast(Total as int)/10 AS NVARCHAR(10)) + '-' + CAST(ISNULL(InX,0) as NVARCHAR(10)) + 'x' WHERE Total IS NOT NULL
	IF @PhaseCode = '1' UPDATE #TMP_Athlete SET Total = Total/10.0 WHERE Total IS NOT NULL
	
	INSERT #Stage(CP, Stage, Stage_Code, Sub_Total, Stage_Rank, RegisterID, [Order])
	SELECT F_CompetitionPosition, F_Stage, F_StageCode, F_SubTotal, F_StageRank, F_RegisterID, F_Stage FROM dbo.[Func_SH_GetStageScore](@MatchID)
	

	INSERT #Series(CP, Stage, Series, Series_Code, Score, F_RegisterID, [Order])
	SELECT F_CompetitionPosition, F_Stage, F_Series, Series_Code, Series_Score, F_RegisterID, F_Series FROM dbo.Func_SH_GetSeriesScore(@MatchID)
	
	--SELECT * FROM #TMP_Athlete
	--SELECT * FROM #Stage
	--SELECT * FROM #Series
	
	
	SET @OutputHeader = (
					SELECT	[Message].[Version],
							[Message].Category,
							[Message].Origin,
							[Message].RSC,
							[Message].Discipline,
							[Message].Gender,
							[Message].[Event],
							[Message].Phase,
							[Message].Unit,
							[Message].Venue,
							[Message].Code,
							[Message].[Type],
							[Message].[Language],
							[Message].[Date],
							[Message].[Time],
							Row.Registration,
							Row.Bay,
							ISNULL(Row.[Rank],'') Rank,
							ISNULL(Row.Total,'') Total,
							ISNULL(Row.Average,'') Average,
							ISNULL(Row.Qualification,'') Qualification,
							Row.[Order],
							
							Stage.Stage_Code,
							ISNULL(Stage.Sub_Total,'') Sub_Total,
							ISNULL(Stage.Stage_Rank,'') Stage_Rank,
							Stage.Stage [Order],
							
							Series.Series_Code,
							ISNULL(Series.Score,'') Score,
							Series.Series [Order]
							
							FROM dbo.Func_DataExchange_GetMessageHeader ('SH', '1.0', 'VRS-001', 'M3031', @MatchID, 'ENG', 0) [Message]
							LEFT JOIN #TMP_Athlete AS Row ON [Message].MatchID = Row.MatchID
							LEFT JOIN #Stage Stage ON Row.RegisterID = Stage.RegisterID
							LEFT JOIN #Series Series ON Series.F_RegisterID = Row.RegisterID AND Series.Stage = Stage.Stage	 			
							ORDER BY Row.[Order], Stage.[Order], Series.[Order]
							
							FOR XML AUTO	)
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader


	SELECT @OutputXML AS MessageXML
	

SET NOCOUNT OFF
END

GO

/*

EXEC [Proc_DataExchange_SH_M3031]  2188, 'ENG'
EXEC [Proc_DataExchange_SH_M3031]  3, 'ENG'

*/

 
