IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetProgressionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetProgressionList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_WL_GetProgressionList]
----功		  能：得到当前Match信息
----作		  者：吴定昉
----日		  期: 2010-10-19 

CREATE PROCEDURE [dbo].[Proc_Report_WL_GetProgressionList]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON
	SET LANGUAGE ENGLISH
	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @SnatchMatchID	INT
	DECLARE @CleanJerkMatchID	INT
	DECLARE @PhaseID   INT


	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

	SELECT @SnatchMatchID = M.F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventCode = @EventCode 
    AND E.F_SexCode = @SexCode
    AND P.F_PhaseCode = @PhaseCode
    AND M.F_MatchCode = '01'
    AND D.F_DisciplineCode = @DisciplineCode 

	SELECT @CleanJerkMatchID = M.F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventCode = @EventCode 
    AND E.F_SexCode = @SexCode
    AND P.F_PhaseCode = @PhaseCode
    AND M.F_MatchCode = '02'
    AND D.F_DisciplineCode = @DisciplineCode 

    SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID

	CREATE TABLE #ProtocolList
	(
		LotNo					INT,
		[Name]					NVARCHAR(100),
		NOCCode					CHAR(3),
		DelegationName          NVARCHAR(100),		
		FederationName          NVARCHAR(100),		
		InscriptionResult       NVARCHAR(100),
		DateOfBirth             NVARCHAR(11),
		[Group]                 NVARCHAR(10),
		BodyWeight              NVARCHAR(10),
		[Snatch1stAttempt]		NVARCHAR(10),
		[Snatch1stRes]			NVARCHAR(10),
		[Snatch2ndAttempt]		NVARCHAR(10),
		[Snatch2ndRes]          NVARCHAR(10),
		[Snatch3rdAttempt]		NVARCHAR(10),
		[Snatch3rdRes]          NVARCHAR(10),
		SnatchResult			NVARCHAR(10),
		[CleanJerk1stAttempt]	NVARCHAR(10),
		[CleanJerk1stRes]		NVARCHAR(10),
		[CleanJerk2ndAttempt]	NVARCHAR(10),
		[CleanJerk2ndRes]       NVARCHAR(10),
		[CleanJerk3rdAttempt]	NVARCHAR(10),
		[CleanJerk3rdRes]       NVARCHAR(10),
		CleanJerkResult			NVARCHAR(10),
		[Total]			        NVARCHAR(10),
	)

	-- 在临时表中插入基本信息
	INSERT #ProtocolList 
	(LotNo, [Name], NOCCode,DelegationName,FederationName, InscriptionResult,DateOfBirth,[Group],BodyWeight,
	[Snatch1stAttempt],[Snatch1stRes],[Snatch2ndAttempt],[Snatch2ndRes],[Snatch3rdAttempt],[Snatch3rdRes],SnatchResult,
	[CleanJerk1stAttempt],[CleanJerk1stRes],[CleanJerk2ndAttempt],[CleanJerk2ndRes],[CleanJerk3rdAttempt],[CleanJerk3rdRes],CleanJerkResult,
	[Total])
	(
	SELECT
	 I.F_Seed AS [LotNo] 
	, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [Name] 
	, D.F_DelegationCode 
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
	, I.F_InscriptionResult 
	, dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,@LanguageCode)
	, P.F_PhaseCode
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight)
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes1 IS NULL THEN '---'
	       WHEN SNMR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1)=3 THEN '---'
	       WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes1 IS NULL THEN ''
	       ELSE SNMR.F_PointsCharDes1 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN 2
	       ELSE dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes2 IS NULL THEN '---'
	       WHEN SNMR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2)=3 THEN '---'
	       WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes2 IS NULL THEN ''
	       ELSE SNMR.F_PointsCharDes2 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN 2
	       ELSE dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND SNMR.F_PointsNumDes3 IS NULL THEN '---'
	       WHEN SNMR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3)=3 THEN '---'
	       WHEN ER.F_IRMID IS NULL AND SNMR.F_PointsNumDes3 IS NULL THEN ''
	       ELSE SNMR.F_PointsCharDes3 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN 2
	       ELSE dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' THEN ISNULL(SNMR.F_PointsCharDes4,'---')
	       WHEN (dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) =0 OR dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) =0 OR dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) =0 OR dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) =3) THEN '---'
	       ELSE SNMR.F_PointsCharDes4 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes1 IS NULL THEN '---'
	       WHEN CJMR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1)=3 THEN '---'
	       WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes1 IS NULL THEN ''
	       ELSE CJMR.F_PointsCharDes1 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN 2
	       ELSE dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes2 IS NULL THEN '---'
	       WHEN CJMR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2)=3 THEN '---'
	       WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes2 IS NULL THEN ''
	       ELSE CJMR.F_PointsCharDes2 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN 2
	       ELSE dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' AND CJMR.F_PointsNumDes3 IS NULL THEN '---'
	       WHEN CJMR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3)=3 THEN '---'
	       WHEN ER.F_IRMID IS NULL AND CJMR.F_PointsNumDes3 IS NULL THEN ''
	       ELSE CJMR.F_PointsCharDes3 END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN 2
	       ELSE dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) END
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCODE ='DNS' OR IRM.F_IRMCODE ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF' THEN ISNULL(CJMR.F_PointsCharDes4,'---')
	       WHEN (dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) =0 OR dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) =0 OR dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) =0 OR dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) =3) THEN '---'
	       ELSE CJMR.F_PointsCharDes4 END
	, CASE WHEN ER.F_IRMID IS NOT NULL THEN IRM.F_IRMCODE ELSE ER.F_EventPointsCharDes4 END
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	LEFT JOIN TS_Match_Result AS SNMR ON MR.F_RegisterID = SNMR.F_RegisterID AND SNMR.F_MatchID = @SnatchMatchID 
	LEFT JOIN TC_IRM AS SNIRM ON SNIRM.F_IRMID = SNMR.F_IRMID
	LEFT JOIN TS_Match_Result AS CJMR ON MR.F_RegisterID = CJMR.F_RegisterID AND CJMR.F_MatchID = @CleanJerkMatchID 
	LEFT JOIN TC_IRM AS CJIRM ON CJIRM.F_IRMID = CJMR.F_IRMID
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @PhaseID
	LEFT JOIN TS_Event_Result AS ER ON MR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = P.F_EventID
	LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID
	WHERE MR.F_MatchID = @MatchID 
	)

	SELECT *  FROM #ProtocolList order by LotNo

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO


/*

-- Just for test
EXEC [Proc_Report_WL_GetProgressionList] 61,'eng'

*/
