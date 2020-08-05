IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetTeamQualificationResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetTeamQualificationResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_Report_AR_GetTeamQualificationResults]
----功		  能：得到当前Match信息
----作		  者  崔凯
----日		  期: 2011-10-19 

CREATE PROCEDURE [dbo].[Proc_Report_AR_GetTeamQualificationResults]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON
	SET LANGUAGE ENGLISH
	DECLARE @SQL		    NVARCHAR(max)
	DECLARE @PhaseID		INT
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @EventID		INT
	DECLARE @TeamEventID	INT

	SELECT   @EventID = E.F_EventID
    FROM TS_Match AS M 
    LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE M.F_MatchID = @MatchID
    
	SELECT @PhaseCode = P.F_PhaseCode,@PhaseID=F_PhaseID
    FROM TS_Phase AS P 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE E.F_EventID  = @EventID AND F_FatherPhaseID = 0
   
    SELECT @TeamEventID = P.F_EventID
    FROM TS_Phase AS P
    WHERE P.F_PhaseCode = @PhaseCode AND P.F_PhaseID !=@PhaseID AND P.F_EventID!= @EventID
    
	SELECT
		  MMR.F_CompetitionPosition  
        , MMR.F_RegisterID
		, MMR.F_Comment AS Bib
        , I.F_InscriptionRank AS [Rank]
        , I.F_Seed AS FITARanking
		, RD.F_PrintLongName AS Name
		, D.F_DelegationCode AS NOC
		, DD.F_DelegationLongName AS Delegation
        , MMR.F_Points AS IndividualTotal
        , I.F_InscriptionResult AS Total
        , ID.F_IRMLongName AS IRM
        , MMR.F_Service AS Remark        
        , '' AS Records
	FROM TR_Inscription AS I 	
		RIGHT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = I.F_RegisterID AND RM.F_Order IN (1,2,3)
		LEFT JOIN TS_Match_Result AS MMR ON MMR.F_RegisterID = RM.F_MemberRegisterID  
		LEFT JOIN TS_Match AS M ON MMR.F_MatchID = M.F_MatchID AND M.F_MatchCode = 'QR'
		LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
		LEFT JOIN TR_Register AS R ON MMR.F_RegisterID = R.F_RegisterID  
		LEFT JOIN TR_Register_Des AS RD ON MMR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode =  @LanguageCode
		LEFT JOIN TC_IRM AS II ON MMR.F_IRMID = II.F_IRMID AND II.F_DisciplineID = E.F_DisciplineID 
		LEFT JOIN TC_IRM_Des AS ID ON II.F_IRMID = ID.F_IRMID AND ID.F_LanguageCode = @LanguageCode 
		LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = R.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD ON DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode =  @LanguageCode 
			WHERE I.F_EventID = @TeamEventID
			AND P.F_PhaseCode IN (CASE WHEN @PhaseCode ='X' THEN 'A,C' 
									   WHEN @PhaseCode ='Y' THEN 'B,D'
									   ELSE @PhaseCode END)
									   
			ORDER BY I.F_InscriptionResult DESC 
			
SET NOCOUNT OFF
END


GO


/*
EXEC Proc_Report_AR_GetTeamQualificationResults 128,'CHN'
*/