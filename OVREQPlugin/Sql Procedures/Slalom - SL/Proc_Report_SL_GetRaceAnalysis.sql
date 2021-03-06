IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetRaceAnalysis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetRaceAnalysis]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：Proc_Report_SL_GetRaceAnalysis
----功		  能：
----作		  者：吴定昉
----日		  期: 2010-01-15 

CREATE PROCEDURE [dbo].[Proc_Report_SL_GetRaceAnalysis]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @EventCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @i	            INT

	DECLARE @GateCount	    INT
    SET @GateCount = 25


	CREATE TABLE #ResultList
	(
        RunStartOrder			INT,
		BibNo					INT,
		[Name]					NVARCHAR(100),
		NOCCode					CHAR(30),
		DelegationName          NVARCHAR(100),		
		FederationName          NVARCHAR(100),		
		RunSplitTime1			NVARCHAR(50),
		RunSplitTime2			NVARCHAR(50),
        RunSplitTime3          NVARCHAR(50)
	)

	SET @SQL = '' 
	SET @SQL = @SQL + 'ALTER TABLE #ResultList ADD ' 
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'RunGate0' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'RunGate' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
		SET @i = @i + 1
    END
    SET @SQL = @SQL + '
		RunTime			    NVARCHAR(50),
		RunPen			        NVARCHAR(50),
		RunResult			    NVARCHAR(50),
        RunBehind              NVARCHAR(50),
        RunRank                INT,
        RunDisplayPosition     INT,
		TotalResult			    NVARCHAR(50),
        TotalBehind             NVARCHAR(50),
        TotalRank               INT,
        TotalDisplayPosition    INT'
	EXEC (@SQL)


	-- 在临时表中插入基本信息
	SET @SQL = '' 
	SET @SQL = @SQL + 'INSERT #ResultList 
	(RunStartOrder,BibNo,[Name],NOCCode,DelegationName,FederationName,
	RunSplitTime1,RunSplitTime2,RunSplitTime3,'
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'RunGate0' + CAST(@i AS NVARCHAR(10)) + ','
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'RunGate' + CAST(@i AS NVARCHAR(10)) + ','
        END
		SET @i = @i + 1
    END
	SET @SQL = @SQL + 'RunTime,RunPen,RunResult,RunBehind,RunRank,RunDisplayPosition,
	TotalResult,TotalBehind,TotalRank,TotalDisplayPosition )
	(
	SELECT 
	 MR.F_CompetitionPositionDes1
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '''' then I.F_InscriptionNum else R.F_Bib end)
	, (case when R.f_regtypeid = 1 then RD.F_LongName 
	        when R.f_regtypeid = 2 then (RD1.F_LongName + ''/'' + RD2.F_LongName) 
	        end) AS [Name]
	, D.F_DelegationCode
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
    ,CAST(cast(CAST(MR.F_PointsNumDes1 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))
    ,CAST(cast(CAST(MR.F_PointsNumDes2 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))
	,CAST(cast(CAST(MR.F_PointsNumDes3 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100)) ' 
	SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
		SET @SQL = @SQL + N',case when MR.F_PointsCharDes3 is null 
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = '''' 
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''-1''
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''00''			
				then ''-'' 
				else cast(cast(Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) as int) as NVARCHAR(10)) end'
		SET @i = @i + 1
	END
	SET @SQL = @SQL + ', MR.F_PointsCharDes1
	, MR.F_Points
	, (case when MR.F_IRMID is not null then IDM.F_IRMLongName else MR.F_PointsCharDes2 end) 
	, MR.F_PointsCharDes4
	, MR.F_Rank
	, MR.F_DisplayPosition 
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
	LEFT JOIN TR_Register_Member AS RM1 ON R.F_RegisterID = RM1.F_RegisterID AND RM1.F_Order = 1
	LEFT JOIN TR_Register AS R1 ON RM1.F_MemberRegisterID = R1.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD1 ON R1.F_RegisterID = RD1.F_RegisterID AND RD1.F_LanguageCode = ''' + @LanguageCode + ''' 
	LEFT JOIN TC_Federation_Des AS FD1 ON R1.F_FederationID = FD1.F_FederationID AND FD1.F_LanguageCode = ''' + @LanguageCode + '''
	LEFT JOIN TR_Register_Member AS RM2 ON R.F_RegisterID = RM2.F_RegisterID AND RM2.F_Order = 2
	LEFT JOIN TR_Register AS R2 ON RM2.F_MemberRegisterID = R2.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD2 ON R2.F_RegisterID = RD2.F_RegisterID AND RD2.F_LanguageCode = ''' + @LanguageCode + ''' 
	LEFT JOIN TC_Federation_Des AS FD2 ON R2.F_FederationID = FD2.F_FederationID AND FD2.F_LanguageCode = ''' + @LanguageCode + '''
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TC_IRM_Des AS IDM ON MR.F_IRMID = IDM.F_IRMID AND IDM.F_LanguageCode = ''eng''
	LEFT JOIN TC_IRM_Des AS IDP ON PR.F_IRMID = IDP.F_IRMID AND IDP.F_LanguageCode = ''eng''
	WHERE MR.F_MatchID = ''' + cast(@MatchID as nvarchar(10)) + '''
	)' 

	EXEC (@SQL)


	SELECT *  FROM #ResultList order by (case when RunDisplayPosition Is NULL then 99 else RunDisplayPosition end)


Set NOCOUNT OFF
End
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/*

-- Just for test
EXEC [Proc_Report_SL_GetRaceAnalysis] 2267,'eng'

*/
