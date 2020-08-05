
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_GetMatchResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_GetMatchResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----author  £ºMU XUEFENG
----date    : 2010-09-19

CREATE PROCEDURE [dbo].[Proc_SH_GetMatchResult] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP(
						REG_ID INT,
						CP INT,	
						FP NVARCHAR(3),
						BIB NVARCHAR(5),
						Name NVARCHAR(100),
						NOC NVARCHAR(50),
						S1 NVARCHAR(10),
						S2 NVARCHAR(10),
						S3 NVARCHAR(10),
						S4 NVARCHAR(10),
						S5 NVARCHAR(10),
						S6 NVARCHAR(10),
						S7 NVARCHAR(10),
						S8 NVARCHAR(10),
						S9 NVARCHAR(10),
						S10 NVARCHAR(10),
						S11 NVARCHAR(10),
						S12 NVARCHAR(10),
						S13 NVARCHAR(10),
						S14 NVARCHAR(10),
						S15 NVARCHAR(10),
						S16 NVARCHAR(10),
						S17 NVARCHAR(10),
						S18 NVARCHAR(10),
						S19 NVARCHAR(10),
						S20 NVARCHAR(10),
						S21 NVARCHAR(10),
						S22 NVARCHAR(10),
						S23 NVARCHAR(10),
						S24 NVARCHAR(10),
						S25 NVARCHAR(10),
						S26 NVARCHAR(10),
						S27 NVARCHAR(10),
						S28 NVARCHAR(10),
						S29 NVARCHAR(10),
						S30 NVARCHAR(10),
						S31 NVARCHAR(10),
						S32 NVARCHAR(10),
						S33 NVARCHAR(10),
						S34 NVARCHAR(10),
						S35 NVARCHAR(10),
						S36 NVARCHAR(10),
						S37 NVARCHAR(10),
						S38 NVARCHAR(10),
						S39 NVARCHAR(10),
						S40 NVARCHAR(10),
						S_Q NVARCHAR(50),
						S_F NVARCHAR(50),
						Total NVARCHAR(50),
						Add_Score INT,
						DIFF_RECORD DECIMAL(10,1),
						[Rank] INT,
						IRMID INT,
						Remark NVARCHAR(100),
						StartTime NVARCHAR(10),
						In_x	INT
	)

	DECLARE @SexCode   NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @PhaseCode AS NVARCHAR(10)
	DECLARE @RegType AS INT
	DECLARE @EventInfo AS NVARCHAR(10)
	
	SELECT	@EventCode = EVENT_CODE,
			@PhaseCode = Phase_Code ,
			@RegType = RegType,
			@EventInfo = Event_Info,
			@SexCode = Gender_Code
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
	
	
	
	-- is team match
	IF @RegType = 3
	BEGIN
		EXEC Proc_SH_GetTeamResult @MatchID
		RETURN 1
	END
	
	
	INSERT INTO #TMP(REG_ID, CP, FP, BIB, NAME, NOC, IRMID, StartTime, In_x)
	SELECT A.F_RegisterID, A.F_CompetitionPosition, F_CompetitionPositionDes1, F_Bib, F_PrintLongName, D.F_DelegationCode, A.F_IRMID, F_StartTimeCharDes, F_RealScore
	FROM TS_Match_Result  AS A 
	LEFT JOIN TR_Register AS E ON E.F_RegisterID = A.F_RegisterID
	LEFT JOIN TR_Register_Des AS C ON C.F_RegisterID = A.F_RegisterID AND C.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation D ON D.F_DelegationID = E.F_DelegationID
	WHERE F_MatchID = @MatchID 
		
	-- Get Points from TS_Match_ActionList, convert rows to columns
	UPDATE A SET 
	S1= [1], S2= [2], S3= [3], S4= [4], S5= [5], S6= [6], S7= [7], S8= [8], S9= [9], S10= [10], 
	S11= [11], S12= [12], S13= [13], S14= [14], S15= [15], S16= [16], S17= [17], S18= [18], S19= [19], S20= [20], 
	S21= [21], S22= [22], S23= [23], S24= [24], S25= [25], S26= [26], S27= [27], S28= [28], S29= [29], S30= [30], 
	S31= [31], S32= [32], S33= [33], S34= [34], S35= [35], S36= [36], S37= [37], S38= [38], S39= [39], S40= [40]
	FROM #TMP AS A LEFT JOIN
	(
	SELECT F_MatchID,F_CompetitionPosition,  
	[1], [2], [3], [4], [5], [6], [7], [8], [9], [10], 
	[11], [12], [13], [14], [15], [16], [17], [18], [19], [20], 
	[21], [22], [23], [24], [25], [26], [27], [28], [29], [30], 
	[31], [32], [33], [34], [35], [36], [37], [38], [39], [40]
	FROM 
	(SELECT F_MatchID,F_MatchSplitID,F_CompetitionPosition, F_ActionDetail1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID) A
	PIVOT
	(
	MIN (F_ActionDetail1)
	FOR F_MatchSplitID IN
	([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], 
	[11], [12], [13], [14], [15], [16], [17], [18], [19], [20], 
	[21], [22], [23], [24], [25], [26], [27], [28], [29], [30], 
	[31], [32], [33], [34], [35], [36], [37], [38], [39], [40]
	)
	) AS B
	) AS GG
	ON A.CP = GG.F_CompetitionPosition

	-- Prepare for format every shot from 1 to 120
	-- if phase is qualifcation then score = score/10
	-- if phase is final then score = score/10.0
	-- ( Total )
	
	DECLARE @UpdateQuery AS NVARCHAR(MAX)
	DECLARE @UpdatePart AS NVARCHAR(100)
	DECLARE @UpdateQuery2 AS NVARCHAR(MAX)
	DECLARE @UpdatePart2 AS NVARCHAR(100)
	DECLARE @UpdateQuery3 AS NVARCHAR(MAX)
	DECLARE @UpdatePart3 AS NVARCHAR(100)
	DECLARE @UpdateQuery4 AS NVARCHAR(MAX)
	DECLARE @UpdatePart4 AS NVARCHAR(100)
	SET @UpdateQuery2 = ''
	SET @UpdateQuery3 = ''
	SET @UpdateQuery4 = ''
	
	DECLARE @INDEX INT
	SET @INDEX = 1
	SET @UpdateQuery = 'UPDATE #TMP SET Total = 0 '
	
	WHILE @INDEX <= 40
	BEGIN
		SET @UpdatePart = ' + ISNULL( CAST(S' + CAST( @INDEX AS NVARCHAR(10) ) + ' AS INT), 0)'
		SET @UpdatePart2 = ',S' + CAST( @INDEX AS NVARCHAR(10)) + ' = CAST(S' + CAST( @INDEX AS NVARCHAR(10) ) + ' AS INT)'
		SET @UpdatePart3 = ',S' + CAST( @INDEX AS NVARCHAR(10)) + ' = CAST(S' + CAST( @INDEX AS NVARCHAR(10) ) + ' AS INT)/10'
		SET @UpdatePart4 = ',S' + CAST( @INDEX AS NVARCHAR(10)) + ' = CAST((CAST(S' + CAST( @INDEX AS NVARCHAR(10) ) + ' AS INT)/10.0) AS DECIMAL(10,1))'
		SET @UpdateQuery = @UpdateQuery + @UpdatePart
		SET @UpdateQuery2 = @UpdateQuery2 + @UpdatePart2
		SET @UpdateQuery3 = @UpdateQuery3 + @UpdatePart3
		SET @UpdateQuery4 = @UpdateQuery4 + @UpdatePart4
		SET @INDEX = @INDEX + 1
	END

	UPDATE #TMP SET S_Q = B.F_Points,
					Total = B.F_Points,
					[Rank] = B.F_Rank
	FROM #TMP AS A
	LEFT JOIN TS_Match_Result AS B ON B.F_RegisterID = A.REG_ID
	WHERE B.F_MatchID = @MatchID 	
		
	IF @PhaseCode = '1'
	BEGIN
		DECLARE @SourcePhaseID AS INT
		SELECT @SourcePhaseID = F_SourcePhaseID FROM TS_Match_Result 
				WHERE F_MatchID = @MatchID  
	
		UPDATE #TMP SET S_Q = B.F_PhasePoints
						FROM #TMP AS A
				LEFT JOIN TS_Phase_Result AS B ON B.F_RegisterID = A.REG_ID
				WHERE B.F_PhaseID = @SourcePhaseID 	
	END
	
	IF @PhaseCode IN ('9','A')
	BEGIN
		UPDATE #TMP 
		SET [Rank] = NULL
		FROM #TMP A
		LEFT JOIN TC_IRM B ON A.IRMID = B.F_IRMID
		WHERE B.F_IRMCODE IN('DSQ', 'DNS')
	END

	-- FORMAT Very Score, TOTAL
	DECLARE @UPCAST AS NVARCHAR(MAX)
	
	IF @PhaseCode = 'A' SET @UPCAST = 'UPDATE #TMP SET Total = Total' + @UpdateQuery3
	IF @PhaseCode = '9' SET @UPCAST = 'UPDATE #TMP SET Total = Total' + @UpdateQuery3
	IF @PhaseCode = '1' 
	BEGIN
		IF @EventInfo = '25RF'	SET	@UPCAST = 'UPDATE #TMP SET Total = Total' + @UpdateQuery3
		ELSE SET @UPCAST = 'UPDATE #TMP SET Total = Total' + @UpdateQuery4
	END
	
	EXEC (@UPCAST)				
	

	IF @PhaseCode = 'A' UPDATE #TMP SET Total = CAST(Total AS INT)/10 
	IF @PhaseCode = '9' UPDATE #TMP SET Total = CAST(Total AS INT)/10 
	IF @PhaseCode = '1' 
	BEGIN
		IF ( @EventInfo = '25RF' AND @SexCode = 'M' AND @RegType = 1 )
			UPDATE #TMP SET Total = CAST(CAST(Total AS DECIMAL)/10  AS INT), S_Q = CAST(S_Q AS INT)/10
		ELSE
			UPDATE #TMP SET Total = CAST(CAST(Total AS DECIMAL)/10.0  AS DECIMAL(10,1)), S_Q = CAST(S_Q AS INT)/10
	END
	
			
	-- set IRM
	UPDATE #TMP SET Remark = F_IRMCODE FROM #TMP AS A LEFT JOIN TC_IRM AS B ON A.IRMID = B.F_IRMID
	
	
	-- set record
	UPDATE #TMP SET Remark = case when B.F_Equalled = 1 then 'E' + B.F_RecordTypeCode else B.F_RecordTypeCode end
	FROM #TMP AS A 
				
			LEFT JOIN
			(	
				SELECT A.F_RegisterID, D.F_RecordTypeCode, A.F_Equalled 
				FROM TS_Result_Record  AS A  
				LEFT JOIN TS_Event_Record AS C ON A.F_RecordID = C.F_RecordID 
				LEFT JOIN TC_RecordType AS D ON D.F_RecordTypeID = C.F_RecordTypeID
				WHERE F_MatchID = @MatchID ) 
				
			 B ON A.REG_ID = B.F_RegisterID
				
	WHERE A.IRMID IS NULL
					
									
	-- Output: 
	-------------------------------------------------
	
	DECLARE @ShotCount AS INT
	SELECT @ShotCount = dbo.Func_SH_GetShotCount( @MatchID )

	DECLARE @SelectQuery AS NVARCHAR(MAX)
	DECLARE @SelectPart AS NVARCHAR(100)
	SET @INDEX = 1
	SET @SelectQuery = 'SELECT CP, FP, BIB, Name, NOC '
	WHILE @INDEX <= @ShotCount
	BEGIN
		SET @SelectPart = ', S' + CAST( @INDEX AS NVARCHAR(10) )
		SET @SelectQuery = @SelectQuery + @SelectPart
		SET @INDEX = @INDEX + 1
	END
	

	IF ( @EventInfo = '25RF' AND @SexCode = 'M' AND @RegType = 1 )
	BEGIN
		IF @PhaseCode = 'A' SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark, StartTime FROM #TMP '
		IF @PhaseCode = '9' SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark, StartTime FROM #TMP '
		IF @PhaseCode = '1' SET @SelectQuery = @SelectQuery + ', Total, Rank, Remark FROM #TMP '
	END

	ELSE IF ( @EventInfo = '25P' AND @SexCode = 'W' AND @RegType = 1 )
	BEGIN
		IF @PhaseCode = 'A' SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark, StartTime FROM #TMP '
		IF @PhaseCode = '9' SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark, StartTime FROM #TMP '
		IF @PhaseCode = '1' SET @SelectQuery = @SelectQuery + ', S_Q, Total, Rank, Remark FROM #TMP '
	END

	ELSE IF ( @EventInfo = '25P' AND @SexCode = 'M' AND @RegType = 1 )
	BEGIN
		IF @PhaseCode IN( '9', '1' ) SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark, StartTime FROM #TMP '
	END

	ELSE
	BEGIN
		IF @PhaseCode = 'A' SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark FROM #TMP '
		IF @PhaseCode = '9' SET @SelectQuery = @SelectQuery + ', In_x, Total, Rank, Remark FROM #TMP '
		IF @PhaseCode = '1' SET @SelectQuery = @SelectQuery + ', S_Q,  Total, Rank, Remark FROM #TMP '
	END
	
--	SELECT @SelectQuery
	
	EXEC ( @SelectQuery )


SET NOCOUNT OFF

END

-- EXEC Proc_SH_GetMatchResult 75,'ENG'
-- EXEC Proc_SH_GetMatchResult 341,'ENG'