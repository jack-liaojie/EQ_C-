IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetQualificationResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetQualificationResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_Report_AR_GetQualificationResults]
----功		  能：得到当前Match信息
----作		  者  崔凯
----日		  期: 2011-10-19 

CREATE PROCEDURE [dbo].[Proc_Report_AR_GetQualificationResults]
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
    DECLARE @SexCode        INT
    DECLARE @EventID        INT

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode,
	@PhaseCode = P.F_PhaseCode,
    @SexCode = E.F_SexCode,
    @EventID = E.F_EventID
    FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE M.F_MatchID = @MatchID
    
	CREATE TABLE #ResultList
	(
		[Rank]				    NVARCHAR(10),	
		[Name]					NVARCHAR(100),
		NOCCode					NVARCHAR(30),
		DelegationName          NVARCHAR(100),		
		FederationName          NVARCHAR(100),		
		InscriptionResult       NVARCHAR(100),
		DateOfBirth             NVARCHAR(11),
		[Group]                 NVARCHAR(10),
		BodyWeight              NVARCHAR(10),
		
		DistinceA				NVARCHAR(10),
		RankA					NVARCHAR(10),
		RecordA					NVARCHAR(10),
		
		DistinceB				NVARCHAR(10),
		RankB					NVARCHAR(10),
		RecordB					NVARCHAR(10),
		
		DistinceC				NVARCHAR(10),
		RankC					NVARCHAR(10),
		RecordC					NVARCHAR(10),
		
		DistinceD				NVARCHAR(10),
		RankD					NVARCHAR(10),
		RecordD					NVARCHAR(10),
		
		[Total]			        NVARCHAR(10),
		BackNo                  NVARCHAR(10),
		[10s]					NVARCHAR(10),
		[Xs]					NVARCHAR(10),
		Record					NVARCHAR(10),
	)

	-- 在临时表中插入基本信息
	INSERT #ResultList 
	([Rank], [Name], NOCCode,DelegationName,FederationName, InscriptionResult,DateOfBirth,[Group],BodyWeight,
	DistinceA,RankA,RecordA,  DistinceB,RankB,RecordB,  DistinceC,RankC,RecordC,  DistinceD,RankD,RecordD,
	[Total],BackNo,[10s],[Xs],Record )
	(
	SELECT  
	  MR.F_Rank
	, RD.F_PrintLongName AS [Name] 
	, DD.F_DelegationLongName 
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
	, I.F_InscriptionResult 
	, dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,@LanguageCode)
	, P.F_PhaseCode
	, R.F_Weight
	, MR.F_PointsNumDes1
	, MR.F_PointsCharDes1
	, '' AS RecordA
	, MR.F_PointsNumDes2
	, MR.F_PointsCharDes2
	, '' AS RecordB
	, MR.F_PointsNumDes3
	, MR.F_PointsCharDes3
	, '' AS RecordC
	, MR.F_PointsNumDes4
	, MR.F_PointsCharDes4
	, '' AS RecordD
	, CASE WHEN MR.F_IRMID IS NOT NULL THEN IRM.F_IRMCODE ELSE CAST(MR.F_Points AS NVARCHAR) END
	, MR.F_Comment 
	, MR.F_WinPoints
	, MR.F_LosePoints
	, '' AS Record
	FROM TS_Match_Result AS MR 
	LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID AND M.F_MatchCode = 'QR' 
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode			
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID AND P.F_PhaseCode IN ('A','B','C','D')
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND I.F_EventID = @EventID  
	LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = MR.F_IRMID	
	LEFT JOIN TC_IRM_DES AS IRMD ON IRMD.F_IRMID = MR.F_IRMID AND IRMD.F_LanguageCode = @LanguageCode	
	WHERE E.F_EventID = @EventID AND M.F_MatchCode = 'QR'
	)

	SELECT *  FROM #ResultList order by ISNULL(RIGHT('00000'+CONVERT(VARCHAR(10),[RANK]),5),999)

SET NOCOUNT OFF
END

GO


/*
exec  Proc_Report_AR_GetQualificationResults 129,'CHN'
*/