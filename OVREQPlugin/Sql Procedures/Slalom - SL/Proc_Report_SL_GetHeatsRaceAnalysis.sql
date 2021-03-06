IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetHeatsRaceAnalysis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetHeatsRaceAnalysis]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：Proc_Report_SL_GetHeatsRaceAnalysis
----功		  能：
----作		  者：吴定昉
----日		  期: 2010-01-15 

CREATE PROCEDURE [dbo].[Proc_Report_SL_GetHeatsRaceAnalysis]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @EventCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
	DECLARE @Run1MatchID	INT
	DECLARE @Run2MatchID	INT
	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @i	            INT

	DECLARE @GateCount	    INT
    SET @GateCount = 25

	SELECT @EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE F_MatchID = @MatchID

    IF @PhaseCode = '9'
    BEGIN 
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '01' 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = @PhaseCode
        AND M.F_MatchCode = '02' 
    END
    ELSE
    BEGIN
		SELECT @Run1MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '2'
        AND M.F_MatchCode = '01' 

		SELECT @Run2MatchID = M.F_MatchID FROM TS_Match AS M 
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		WHERE E.F_EventCode = @EventCode 
        AND E.F_SexCode = @SexCode
        AND P.F_PhaseCode = '1'
        AND M.F_MatchCode = '01' 
    END

	CREATE TABLE #ResultList
	(
        Run1StartOrder			INT,
        Run2StartOrder			INT,
		BibNo					INT,
		[Name]					NVARCHAR(100),
		NOCCode					CHAR(3),
		DelegationName          NVARCHAR(100),		
		FederationName          NVARCHAR(100),		
		Run1SplitTime1			NVARCHAR(50),
		Run1SplitTime2			NVARCHAR(50),
        Run1SplitTime3          NVARCHAR(50)
	)

	SET @SQL = '' 
	SET @SQL = @SQL + 'ALTER TABLE #ResultList ADD ' 
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'Run1Gate0' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'Run1Gate' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
		SET @i = @i + 1
    END
    SET @SQL = @SQL + '
		Run1Time			    NVARCHAR(50),
		Run1Pen			        NVARCHAR(50),
		Run1Result			    NVARCHAR(50),
        Run1Behind              NVARCHAR(50),
        Run1Rank                INT,
        Run1DisplayPosition     INT,
		Run2SplitTime1			NVARCHAR(50),
		Run2SplitTime2			NVARCHAR(50),
        Run2SplitTime3          NVARCHAR(50),'
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'Run2Gate0' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'Run2Gate' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
		SET @i = @i + 1
    END
    SET @SQL = @SQL + '
		Run2Time			    NVARCHAR(50),
		Run2Pen			        NVARCHAR(50),
		Run2Result			    NVARCHAR(50),
        Run2Behind              NVARCHAR(50),
        Run2Rank                INT,
        Run2DisplayPosition     INT,
		TotalResult			    NVARCHAR(50),
        TotalBehind             NVARCHAR(50),
        TotalRank               INT,
        TotalDisplayPosition    INT'
	EXEC (@SQL)


	-- 在临时表中插入基本信息
	SET @SQL = '' 
	SET @SQL = @SQL + 'INSERT #ResultList 
	(Run1StartOrder,Run2StartOrder,BibNo,[Name],NOCCode,DelegationName,FederationName,
	Run1SplitTime1,Run1SplitTime2,Run1SplitTime3,'
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'Run1Gate0' + CAST(@i AS NVARCHAR(10)) + ','
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'Run1Gate' + CAST(@i AS NVARCHAR(10)) + ','
        END
		SET @i = @i + 1
    END
	SET @SQL = @SQL + 'Run1Time,Run1Pen,Run1Result,Run1Behind,Run1Rank,Run1DisplayPosition,
	Run2SplitTime1,Run2SplitTime2,Run2SplitTime3,'
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'Run2Gate0' + CAST(@i AS NVARCHAR(10)) + ','
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'Run2Gate' + CAST(@i AS NVARCHAR(10)) + ','
        END
		SET @i = @i + 1
    END
	SET @SQL = @SQL + 'Run2Time,Run2Pen,Run2Result,Run2Behind,Run2Rank,Run2DisplayPosition,
	TotalResult,TotalBehind,TotalRank,TotalDisplayPosition )
	(
	SELECT 
	 MR1.F_CompetitionPositionDes1
	,MR2.F_CompetitionPositionDes1 
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '''' then I.F_InscriptionNum else R.F_Bib end)
	, RD.F_LongName
	, D.F_DelegationCode
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
    ,CAST(cast(CAST(MR1.F_PointsNumDes1 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))
    ,CAST(cast(CAST(MR1.F_PointsNumDes2 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))
	,CAST(cast(CAST(MR1.F_PointsNumDes3 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100)) ' 
	SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
		SET @SQL = @SQL + N',case when MR1.F_PointsCharDes3 is null 
				or Substring(MR1.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ', 2) = '''' 
				or Substring(MR1.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''-1''
				or Substring(MR1.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''00''
				then ''-'' 
				else cast(cast(Substring(MR1.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) as int) as NVARCHAR(10)) end'
		SET @i = @i + 1
	END
	SET @SQL = @SQL + ', MR1.F_PointsCharDes1
	, MR1.F_Points
	, (case when MR1.F_IRMID is not null then ID1.F_IRMLongName else MR1.F_PointsCharDes2 end) 
	, MR1.F_PointsCharDes4
	, MR1.F_Rank
	, MR1.F_DisplayPosition 
    ,CAST(cast(CAST(MR2.F_PointsNumDes1 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))
    ,CAST(cast(CAST(MR2.F_PointsNumDes2 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))
	,CAST(cast(CAST(MR2.F_PointsNumDes3 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100)) ' 
	SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
		SET @SQL = @SQL + N',case when MR2.F_PointsCharDes3 is null 
				or Substring(MR2.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ', 2) = '''' 
				or Substring(MR2.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''-1''
				or Substring(MR2.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''00''
				then ''-'' 
				else cast(cast(Substring(MR2.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) as int) as NVARCHAR(10)) end'
		SET @i = @i + 1
	END
	SET @SQL = @SQL + ', MR2.F_PointsCharDes1
	, MR2.F_Points
	, (case when MR2.F_IRMID is not null then ID2.F_IRMLongName else MR2.F_PointsCharDes2 end) 
	, MR2.F_PointsCharDes4
	, MR2.F_Rank
	, MR2.F_DisplayPosition 
	, (case when PR.F_IRMID is not null then IDP.F_IRMLongName else PR.F_PhasePointsCharDes2 end) 
	, PR.F_PhasePointsCharDes4
	, PR.F_PhaseRank
	, PR.F_PhaseDisplayPosition 
	FROM TS_Match_Result AS MR
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = ''' + @LanguageCode + '''
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID 
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = ''' + @LanguageCode + ''' 	
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = ''' + @LanguageCode + ''' 	
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
	LEFT JOIN TS_Match_Result AS MR1 ON MR.F_RegisterID = MR1.F_RegisterID AND MR1.F_MatchID = ''' + cast(@Run1MatchID as nvarchar(10)) + ''' 
	LEFT JOIN TS_Match_Result AS MR2 ON MR.F_RegisterID = MR2.F_RegisterID AND MR2.F_MatchID = ''' + cast(@Run2MatchID as nvarchar(10)) + '''  
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TC_IRM_Des AS ID1 ON MR1.F_IRMID = ID1.F_IRMID AND ID1.F_LanguageCode = ''eng''
	LEFT JOIN TC_IRM_Des AS ID2 ON MR2.F_IRMID = ID2.F_IRMID AND ID2.F_LanguageCode = ''eng''
	LEFT JOIN TC_IRM_Des AS IDP ON PR.F_IRMID = IDP.F_IRMID AND IDP.F_LanguageCode = ''eng''
 	WHERE MR.F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + '''
	)' 

	EXEC (@SQL)

	SELECT *  FROM #ResultList order by (case when TotalDisplayPosition Is NULL then 99 else TotalDisplayPosition end)

Set NOCOUNT OFF
End
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*

-- Just for test
EXEC [Proc_Report_SL_GetHeatsRaceAnalysis] 2267,'eng'

*/
