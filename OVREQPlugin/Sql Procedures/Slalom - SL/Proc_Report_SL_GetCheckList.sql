IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetCheckList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：Proc_Report_SL_GetCheckList
----功		  能：
----作		  者：吴定昉
----日		  期: 2010-01-15 
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年7月31日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetCheckList]
             @MatchID         INT,
             @LanguageCode    CHAR(3),
             @S_StartOrder    INT,
             @E_StartOrder    INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @i	            INT

	DECLARE @GateCount	    INT
    SET @GateCount = 25

	CREATE TABLE #CheckList
	(
        StartOrder			    INT,
		BibNo					INT,
		[Name]					NVARCHAR(100),
		NOCCode					CHAR(3),
		DelegationName          NVARCHAR(100),
		FederationName          NVARCHAR(100),
		SplitTime1			NVARCHAR(50),
		SplitTime2			NVARCHAR(50),
        SplitTime3          NVARCHAR(50)
	)

	SET @SQL = '' 
	SET @SQL = @SQL + 'ALTER TABLE #CheckList ADD ' 
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'Gate0' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'Gate' + CAST(@i AS NVARCHAR(10)) + ' NVARCHAR(10),'
        END
		SET @i = @i + 1
    END
    SET @SQL = @SQL + '
		[Time]			    NVARCHAR(50),
		Pen			        NVARCHAR(50),
		Result			    NVARCHAR(50),
        Behind              NVARCHAR(50),
        Rank                INT,
        DisplayPosition     INT'
	EXEC (@SQL)

	-- 在临时表中插入基本信息
	SET @SQL = '' 
	SET @SQL = @SQL + 'INSERT #CheckList
	(StartOrder,BibNo,[Name],NOCCode,DelegationName,FederationName,
	SplitTime1,SplitTime2,SplitTime3,'
    SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
        IF @i < 10
        BEGIN
			SET @SQL = @SQL + 'Gate0' + CAST(@i AS NVARCHAR(10)) + ','
        END
        ELSE
        BEGIN
			SET @SQL = @SQL + 'Gate' + CAST(@i AS NVARCHAR(10)) + ','
        END
		SET @i = @i + 1
    END
	SET @SQL = @SQL + '[Time],Pen,[Result],Behind,[Rank],DisplayPosition)
	(
	SELECT 
	 MR.F_CompetitionPositionDes1
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '''' then I.F_InscriptionNum else R.F_Bib end)
	, RD.F_LongName
	, D.F_DelegationCode
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
	, CAST(cast(CAST(MR.F_PointsNumDes1 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100)) 
	, CAST(cast(CAST(MR.F_PointsNumDes2 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100)) 
	, CAST(cast(CAST(MR.F_PointsNumDes3 AS DECIMAL(20,2))/100 as DECIMAL(20,2)) AS NVARCHAR(100))'

	SET @i = 1
	WHILE @i <= @GateCount
	BEGIN
		SET @SQL = @SQL + N',case when MR.F_PointsCharDes3 is null 
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ', 2) = '''' 
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''-1''
				or Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) = ''00''
				then ''-''
				else cast(cast(Substring(MR.F_PointsCharDes3,' + CAST(@i * 2 - 1 AS NVARCHAR(10)) + ',2) as int) as NVARCHAR(10)) end'
		SET @i = @i + 1
	END
	SET @SQL = @SQL + ', MR.F_PointsCharDes1
	, MR.F_Points
	, MR.F_PointsCharDes2 
	, MR.F_PointsCharDes4
	, MR.F_Rank
	, MR.F_DisplayPosition 
	FROM TS_Match_Result AS MR 
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = ''' + @LanguageCode + '''
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = ''' + @LanguageCode + ''' 
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = ''' + @LanguageCode + ''' 
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
	WHERE MR.F_MatchID = ''' + cast(@MatchID as nvarchar(10)) +''' 
	)' 

	EXEC (@SQL)

    IF @S_StartOrder <> -1 AND @E_StartOrder <> -1 
    BEGIN
	  DELETE  FROM #CheckList WHERE StartOrder > @E_StartOrder OR StartOrder < @S_StartOrder
    END

	SELECT *  FROM #CheckList order by StartOrder

Set NOCOUNT OFF
End
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
exec Proc_Report_SL_GetCheckList 2267, 'ENG'
*/