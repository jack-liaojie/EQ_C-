IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_SH_M0005]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_SH_M0005]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_DataExchange_SH_M0005]
----功		  能：射击过程成绩（资格赛）
----作		  者：穆学峰
----日		  期: 2010-11-29 
----修改	记录:

---实时成绩（男子，女子50米步枪三种姿势资格赛）
---资格赛）
-----------------	@Lang; @RSC; @Discipline; @Event; @Phase; @Unit; 
-----------------	@Gender; @Venue; @Date; @DisciplineID; @EventID; @PhaseID;
-----------------   @MatchID; @SessionID; @CourtID

CREATE PROCEDURE [dbo].[Proc_DataExchange_SH_M0005]
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

	CREATE TABLE #TMP_Athlete(
							MatchID INT,
							RegisterID INT,
							Registration NVARCHAR(10),
							Athlete_Name NVARCHAR(100),
							Athlete_Delegation NVARCHAR(100),
							CP INT,
							Bib VARCHAR(3),
							[Rank] NVARCHAR(10),
							Total NVARCHAR(20),
							InX		INT,
							Average NVARCHAR(10),
							Qualification NVARCHAR(10),
							[Order] INT,
							Memo NVARCHAR(50))
							
	CREATE TABLE #Result(	
							RegisterID INT,
							Stage_Code NVARCHAR(10),
							Sub_Total  NVARCHAR(10),
							Stage_Rank NVARCHAR(10),
							[Order] INT,
							Gesture		NVARCHAR(50),
							Result1		NVARCHAR(10),
							Result2		NVARCHAR(10),
							Result3		NVARCHAR(10),
							Result4		NVARCHAR(10),
							Result		NVARCHAR(10)
							)

	
	INSERT #TMP_Athlete(MatchID, Registration, CP, Bib, [Rank], Total, Qualification, [Order], RegisterID, InX, Athlete_Name, Athlete_Delegation)
	SELECT @MatchID, C.F_RegisterCode, A.F_CompetitionPosition, 
			C.F_Bib, A.F_Rank, A.F_Points, B.F_IRMCODE,	ROW_NUMBER() OVER(ORDER BY A.F_Rank) , A.F_RegisterID, A.F_RealScore,
			RD.F_PrintLongName, DD.F_DelegationLongName
	FROM TS_Match_Result AS A 
	LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
	LEFT JOIN TR_Register C ON C.F_RegisterID = A.F_RegisterID
	LEFT JOIN TR_Register_Des RD ON RD.F_RegisterID = C.F_RegTypeID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation_Des DD ON C.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	WHERE A.F_MatchID = @MatchID
	
	UPDATE #TMP_Athlete 
	SET [RANK] = ''
	WHERE Qualification IN('DSQ','DNS')
		
	UPDATE #TMP_Athlete 
	SET Average = CONVERT(NUMERIC(10,3), (1.0*CAST(Total AS INT)/ISNULL(B.SN,1))/100.0 ) 
	FROM #TMP_Athlete A
	LEFT JOIN 
	(SELECT F_CompetitionPosition, MAX(F_MatchSplitID) SN 
		FROM TS_Match_ActionList
		WHERE F_MatchID = @MatchID
		GROUP BY F_CompetitionPosition) B ON A.CP = B.F_CompetitionPosition
	
	
	IF @PhaseCode IN( '9', 'A') UPDATE #TMP_Athlete SET Total = CAST(cast(Total as int)/10 AS NVARCHAR(10)) + '-' + CAST(ISNULL(InX,0) as NVARCHAR(10)) + 'x' WHERE Total IS NOT NULL
	IF @PhaseCode = '1' UPDATE #TMP_Athlete SET Total = Total/10.0 WHERE Total IS NOT NULL
	
	
	
	INSERT INTO #Result(
							RegisterID,	
							Gesture,
							Result,
							Result1,
							Result2,
							Result3,
							Result4
						)	
								
	SELECT F_RegisterID, CASE F_Stage WHEN 1 THEN 'P' WHEN 2 THEN 'S' WHEN 3 THEN 'K' END, F_SubTotal, [1], [2], [3], [4] FROM 
	(
		SELECT A.F_RegisterID, A.F_Stage, F_Series, Series_Score,A.F_SubTotal FROM 
		( SELECT * FROM  dbo.Func_SH_GetStageScore(@MatchID) ) A LEFT JOIN
		( SELECT * FROM  dbo.Func_SH_GetSeriesScore(@MatchID) ) B  ON A.F_RegisterID = B.F_RegisterID AND A.F_Stage = B.F_Stage
	) A

	PIVOT
	(
		sum(Series_Score) for F_Series
		in ([1],[2],[3],[4])
	)
	AS S
	
	
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
							Row.Bib,
							ISNULL(Row.[Rank],'') Rank,
							Row.[Order],
							ISNULL(Row.Athlete_Delegation,'') DelegationName,
							ISNULL(Row.Athlete_Name,'') AthleteName,
							ISNULL(Row.Total,'') Result_Q,
						
							Row1.Gesture,
							ISNULL(Row1.Result1,'') Result_1,
							ISNULL(Row1.Result2,'') Result_2,
							ISNULL(Row1.Result3,'') Result_3,
							ISNULL(Row1.Result4,'') Result_4,
							ISNULL(Row1.Result ,'') Result
							
							
							FROM dbo.Func_DataExchange_GetMessageHeader ('SH', '1.0', 'VRS-001', 'M0001', @MatchID, 'ENG', 0) [Message]
							LEFT JOIN #TMP_Athlete AS Row ON [Message].MatchID = Row.MatchID
							LEFT JOIN #Result AS Row1 ON Row1.RegisterID = Row.RegisterID
							ORDER BY Row.[Order]
							
							FOR XML AUTO	)
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'
			+ @OutputHeader


	SELECT @OutputXML AS MessageXML
	

SET NOCOUNT OFF
END

GO

/*

EXEC [Proc_DataExchange_SH_M0005]  257, 'ENG'

*/

 
