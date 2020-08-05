IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetWeighInList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetWeighInList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_SCB_WL_GetWeighInList]
----功		  能：SCB得到当前比赛信息
----作		  者：崔凯
----日		  期: 2011-02-28 

CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetWeighInList]
             @MatchID         INT

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
	DECLARE @PhaseID   INT
	DECLARE @EventID   INT
	DECLARE @SnatchMatchID	INT
	DECLARE @CleanJerkMatchID	INT


	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode,
    @EventID = E.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

    SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID

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
    
	CREATE TABLE #ResultList
	(
		[No]				    INT,	
		[LOT]					INT,
		[Name_ENG]				NVARCHAR(100),
		[Name_CHN]				NVARCHAR(100),
		Flag					NVARCHAR(20),
		[Group_ENG]             NVARCHAR(10),
		[Group_CHN]             NVARCHAR(10),
		BodyWeight              NVARCHAR(10),
		DateOfBirth             NVARCHAR(11),
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
		[Rank]					INT,
		NOC						CHAR(3),
		Best1					NVARCHAR(1),
		Best2					NVARCHAR(1),
		Best3					NVARCHAR(1),
		Best4					NVARCHAR(1),
		Best5					NVARCHAR(1),
		Best6					NVARCHAR(1),
		[Current1]			    NVARCHAR(1),
		[Current2]			    NVARCHAR(1),
		[Current3]			    NVARCHAR(1),
		[Current4]			    NVARCHAR(1),
		[Current5]			    NVARCHAR(1),
		[Current6]			    NVARCHAR(1),
		ResultID				INT	
	)

	-- 在临时表中插入基本信息
	INSERT #ResultList 
	([Rank],[No],[LOT],[Name_ENG],[Name_CHN],Flag, NOC,DateOfBirth,[Group_ENG],[Group_CHN],BodyWeight,
	[Snatch1stAttempt],[Snatch1stRes],[Snatch2ndAttempt],[Snatch2ndRes],[Snatch3rdAttempt],[Snatch3rdRes],SnatchResult,
	[CleanJerk1stAttempt],[CleanJerk1stRes],[CleanJerk2ndAttempt],[CleanJerk2ndRes],[CleanJerk3rdAttempt],[CleanJerk3rdRes],CleanJerkResult,
	[Total],ResultID,Best1,Best2,Best3,Best4,Best5,Best6,Current1,Current2,Current3,Current4,Current5,Current6)
	(
	SELECT  
	 NULL
 	--,ROW_NUMBER() OVER(ORDER BY I.F_Seed) AS [No]
 	,I.F_InscriptionNum AS [No]
 	, I.F_Seed
	, (SELECT REPLACE(RDE.F_SBLongName,'/',nchar(10))) AS [Name_ENG] 
	, (SELECT REPLACE(RDC.F_SBLongName,'/',nchar(10))) AS [Name_CHN] 
	, '[image]' + D.F_DelegationCode 
	, D.F_DelegationCode 
	, dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,'ENG')
	, PDE.F_PhaseLongName
	, PDC.F_PhaseLongName
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight)
	, SNMR.F_PointsCharDes1
	, 2
	, null
	, 2
	, null
	, 2
	, null 
	, CJMR.F_PointsCharDes1
	, 2
	, null
	, 2
	, null
	, 2
	, null
	, null
	, ROW_NUMBER() OVER(ORDER BY I.F_Seed)
	, null AS Best1
	, null AS Best2
	, null AS Best3
	, null AS Best4
	, null AS Best5
	, null AS Best6
	, null
	, null
	, null
	, null
	, null
	, null
	
	FROM TS_Match_Result AS MR
	LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID	
	LEFT JOIN TS_Phase_Result AS PR ON PR.F_PhaseID = M.F_PhaseID AND PR.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RDE ON R.F_RegisterID = RDE.F_RegisterID AND RDE.F_LanguageCode = 'ENG' 
	LEFT JOIN TR_Register_Des AS RDC ON R.F_RegisterID = RDC.F_RegisterID AND RDC.F_LanguageCode = 'CHN' 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DDE ON R.F_DelegationID = DDE.F_DelegationID AND DDE.F_LanguageCode = 'ENG'	
	LEFT JOIN TC_Delegation_Des AS DDC ON R.F_DelegationID = DDC.F_DelegationID AND DDC.F_LanguageCode = 'CHN'			
	LEFT JOIN TC_Federation_Des AS FDE ON R.F_FederationID = FDE.F_FederationID AND FDE.F_LanguageCode = 'ENG'			
	LEFT JOIN TC_Federation_Des AS FDC ON R.F_FederationID = FDC.F_FederationID AND FDC.F_LanguageCode = 'CHN'			
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TS_Phase_Des AS PDE ON PDE.F_PhaseID = P.F_PhaseID AND PDE.F_LanguageCode = 'ENG'	
	LEFT JOIN TS_Phase_Des AS PDC ON PDC.F_PhaseID = P.F_PhaseID AND PDC.F_LanguageCode = 'CHN'		 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID
	--LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID =PR.F_RegisterID AND MR.F_MatchID = @MatchID	
	LEFT JOIN ( SELECT A.* FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchCode = '01' AND A.F_MatchID =@SnatchMatchID ) AS SNMR ON PR.F_RegisterID = SNMR.F_RegisterID 
	LEFT JOIN ( SELECT A.* FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchCode = '02' AND A.F_MatchID = @CleanJerkMatchID ) AS CJMR ON PR.F_RegisterID = CJMR.F_RegisterID 	

	LEFT JOIN TS_Event_Result AS ER ON MR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = E.F_EventID  
	LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID= ER.F_IRMID
	WHERE MR.F_MatchID =@MatchID ) order by ISNULL(I.F_Seed,999)
	
	
	
	

	CREATE TABLE #Records
	(
		ResultID				INT,
		RecordTypeID			INT,
		RecordType_ENG			NVARCHAR(100),
		
		SnatchName_ENG			NVARCHAR(100),
		SnatchFlag				NVARCHAR(20),
		SnatchNOC				CHAR(3),
		SnatchRecord			NVARCHAR(10),
		
		CleanJerkName_ENG		NVARCHAR(100),
		CleanJerkFlag			NVARCHAR(20),
		CleanJerkNOC			CHAR(3),
		CleanJerkRecord			NVARCHAR(10),
		
		TotalName_ENG			NVARCHAR(100),
		TotalFlag				NVARCHAR(20),
		TotalNOC				CHAR(3),
		TotalRecord			    NVARCHAR(10),
	)

	INSERT #Records
	(ResultID,RecordTypeID,RecordType_ENG,SnatchRecord,SnatchName_ENG,SnatchFlag,SnatchNOC,CleanJerkRecord,CleanJerkName_ENG,CleanJerkFlag,CleanJerkNOC,TotalRecord,TotalName_ENG,TotalFlag,TotalNOC)  
	(SELECT ROW_NUMBER() over(order by tmp.F_RecordTypeID)
	,tmp.F_RecordTypeID
    ,tmp.RecordType_ENG
    ,tmp.[SnatchResult]
    ,tmp.SnatchName_ENG
    ,'[image]' +tmp.SnatchNOC
    ,tmp.SnatchNOC
    ,tmp.CleanJerkResult
    ,tmp.CleanJerkName_ENG
    ,'[image]' +tmp.CleanJerkNOC
    ,tmp.CleanJerkNOC
    ,tmp.TotalResult
    ,tmp.TotalName_ENG
    ,'[image]' +tmp.TotalNOC
    ,tmp.TotalNOC
	from (SELECT distinct
    RTD.F_RecordTypeID as F_RecordTypeID
    ,RTD.F_RecordTypeLongName AS RecordType_ENG,
     (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS [SnatchResult],		 
     (SELECT TOP 1 ISNULL(RD.F_LongName,ERS.F_CompetitorReportingName) FROM TS_Event_Record AS ERS 
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ERS.F_RegisterID AND RD.F_LanguageCode='ENG' WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS [SnatchName_ENG],
     (SELECT TOP 1 ISNULL(RD.F_NOC,ERS.F_CompetitorNOC) FROM TS_Event_Record AS ERS 
		LEFT JOIN TR_Register AS RD ON RD.F_RegisterID = ERS.F_RegisterID WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS [SnatchNOC],
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS CleanJerkResult,
		 (SELECT TOP 1 ISNULL(RD.F_LongName,ERS.F_CompetitorReportingName) FROM TS_Event_Record AS ERS 
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ERS.F_RegisterID AND RD.F_LanguageCode='ENG' WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS [CleanJerkName_ENG],
     (SELECT TOP 1 ISNULL(RD.F_NOC,ERS.F_CompetitorNOC) FROM TS_Event_Record AS ERS 
		LEFT JOIN TR_Register AS RD ON RD.F_RegisterID = ERS.F_RegisterID WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS [CleanJerkNOC],
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '3' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalResult,
	(SELECT TOP 1 ISNULL(RD.F_LongName,ERS.F_CompetitorNOC) FROM TS_Event_Record AS ERS 
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ERS.F_RegisterID AND RD.F_LanguageCode='ENG' WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '3' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalName_ENG,
	(SELECT TOP 1 ISNULL(RD.F_NOC,ERS.F_CompetitorNOC) FROM TS_Event_Record AS ERS 
		LEFT JOIN TR_Register AS RD ON RD.F_RegisterID = ERS.F_RegisterID WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '3' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalNOC
    FROM TC_RecordType_Des AS RTD
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = RTD.F_RecordTypeID
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordTypeID = RTD.F_RecordTypeID
    WHERE ER.F_EventID = @EventID AND ER.F_Active = 1 AND RTD.F_LanguageCode='ENG'
    ) as tmp)
    
    CREATE TABLE #RankList
    (	RankID				     INT,
		RName_ENG				 NVARCHAR(100),
		RName_CHN				 NVARCHAR(100),
		RFlag					 NVARCHAR(20),
		RNOC					 CHAR(3),
		RBodyWeight              NVARCHAR(10),
		RDateOfBirth             NVARCHAR(11),
		RankResult				 NVARCHAR(10),
		EventRank				 INT,	
		RLotNo					 INT,
		[RSnatch1stAttempt]		 NVARCHAR(10),
		[RSnatch1stRes]			 NVARCHAR(10),
		[RSnatch2ndAttempt]		 NVARCHAR(10),
		[RSnatch2ndRes]          NVARCHAR(10),
		[RSnatch3rdAttempt]		 NVARCHAR(10),
		[RSnatch3rdRes]          NVARCHAR(10),
		RSnatchResult			 NVARCHAR(10),
		[RCleanJerk1stAttempt]	 NVARCHAR(10),
		[RCleanJerk1stRes]		 NVARCHAR(10),
		[RCleanJerk2ndAttempt]	 NVARCHAR(10),
		[RCleanJerk2ndRes]       NVARCHAR(10),
		[RCleanJerk3rdAttempt]	 NVARCHAR(10),
		[RCleanJerk3rdRes]        NVARCHAR(10),
		RCleanJerkResult			NVARCHAR(10),
		RBest1					INT,
		RBest2					INT,
		RBest3					INT,
		RBest4					INT,
		RBest5					INT,
		RBest6					INT,
		[RCurrent1]			    INT,
		[RCurrent2]			    INT,
		[RCurrent3]			    INT,
		[RCurrent4]			    INT,
		[RCurrent5]			    INT,
		[RCurrent6]			    INT
	)
	-- 在排名表中插入基本信息
	INSERT #RankList 
	([RankID],[RName_ENG],[RName_CHN],RFlag, RNOC,RDateOfBirth,RBodyWeight,
	[RankResult],[EventRank],RBest1,RBest2,RBest3,RBest4,RBest5,RBest6) 
	(SELECT TOP 3 ROW_NUMBER() OVER(ORDER BY ISNULL(ER.F_EventRank,999))
	,RDE.F_LongName
	,RDC.F_LongName
	, '[image]' +R.F_NOC
	,R.F_NOC
	, dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,'ENG')
	, R.F_Weight
	,ER.F_EventPointsCharDes4
	,ER.F_EventRank
	, case WHEN SNMR.F_PointsCharDes1 IS NOT NULL and SNMR.F_PointsNumDes1  IS NOT NULL 
			AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes1) =1 AND SNMR.F_PointsCharDes1 = SNMR.F_PointsCharDes4 THEN 1
			ELSE NULL END AS Best1
	, case WHEN SNMR.F_PointsCharDes2 IS NOT NULL and SNMR.F_PointsNumDes2  IS NOT NULL 
			AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes2) =1 AND SNMR.F_PointsCharDes2 = SNMR.F_PointsCharDes4 THEN 1
			ELSE NULL END AS Best2
	, case WHEN SNMR.F_PointsCharDes3 IS NOT NULL and SNMR.F_PointsNumDes3  IS NOT NULL 
			AND dbo.Fun_WL_GetIsSuccess(SNMR.F_PointsNumDes3) =1 AND SNMR.F_PointsCharDes3 = SNMR.F_PointsCharDes4 THEN 1
			ELSE NULL END AS Best3
	, case WHEN CJMR.F_PointsCharDes1 IS NOT NULL and CJMR.F_PointsNumDes1  IS NOT NULL 
			AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes1) =1 AND CJMR.F_PointsCharDes1 = CJMR.F_PointsCharDes4 THEN 1
			ELSE NULL END AS Best4
	, case WHEN CJMR.F_PointsCharDes2 IS NOT NULL and CJMR.F_PointsNumDes2  IS NOT NULL 
			AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes2) =1 AND CJMR.F_PointsCharDes2 = CJMR.F_PointsCharDes4 THEN 1
			ELSE NULL END AS Best5
	, case WHEN CJMR.F_PointsCharDes3 IS NOT NULL and CJMR.F_PointsNumDes3  IS NOT NULL 
			AND dbo.Fun_WL_GetIsSuccess(CJMR.F_PointsNumDes3) =1 AND CJMR.F_PointsCharDes3 = CJMR.F_PointsCharDes4 THEN 1
			ELSE NULL END AS Best6
	FROM TS_Event_Result AS ER
	LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RDE ON R.F_RegisterID = RDE.F_RegisterID AND RDE.F_LanguageCode = 'ENG' 
	LEFT JOIN TR_Register_Des AS RDC ON R.F_RegisterID = RDC.F_RegisterID AND RDC.F_LanguageCode = 'CHN' 
	LEFT JOIN (select SNR.F_MatchID,SNR.F_RegisterID,F_PointsCharDes1,F_PointsCharDes2,F_PointsCharDes3,F_PointsCharDes4,F_PointsNumDes1,F_PointsNumDes2,F_PointsNumDes3
				FROM TS_Match_Result AS SNR 
		LEFT JOIN TS_Match AS SM ON SNR.F_MatchID = SM.F_MatchID AND SM.F_MatchCode ='01') AS SNMR ON SNMR.F_RegisterID = ER.F_RegisterID  
	LEFT JOIN (select CNR.F_MatchID,CNR.F_RegisterID,F_PointsCharDes1,F_PointsCharDes2,F_PointsCharDes3,F_PointsCharDes4,F_PointsNumDes1,F_PointsNumDes2,F_PointsNumDes3
				 FROM TS_Match_Result AS CNR 
		LEFT JOIN TS_Match AS SM ON CNR.F_MatchID = SM.F_MatchID AND SM.F_MatchCode ='02') AS CJMR ON CJMR.F_RegisterID = ER.F_RegisterID  
	WHERE ER.F_EventID=@EventID ) 
    
	SELECT * FROM #ResultList AS R LEFT JOIN #Records AS T ON T.ResultID = R.ResultID
	LEFT JOIN #RankList AS RA ON RA.RankID = R.ResultID 
	ORDER by R.ResultID

SET NOCOUNT OFF
END

GO


/*
EXEC Proc_SCB_WL_GetWeighInList 33
*/