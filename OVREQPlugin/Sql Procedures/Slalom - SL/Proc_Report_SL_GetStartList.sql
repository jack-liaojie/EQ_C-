IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetStartList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_SL_GetStartList]
----功		  能：得到当前Match信息
----作		  者：吴定昉
----日		  期: 2010-01-13 

CREATE PROCEDURE [dbo].[Proc_Report_SL_GetStartList]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)

	CREATE TABLE #StartList
	(
        StartOrder				INT,
		BibNo					INT,
		[Name]					NVARCHAR(100),
		NOCCode					CHAR(3),
		DelegationName          NVARCHAR(100),				
		FederationName          NVARCHAR(100),
		InscriptionResult       NVARCHAR(100),
        WorldRank               INT,
		RunStartTime			NVARCHAR(50),
		RunResult			NVARCHAR(50),
	)

	-- 在临时表中插入基本信息
	INSERT #StartList 
	(StartOrder,BibNo, [Name], NOCCode, DelegationName,FederationName, InscriptionResult, WorldRank, RunStartTime,RunResult)
	(
	SELECT  
	MR.F_CompetitionPositionDes1 
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum else R.F_Bib end) 
	, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [Name]
	, D.F_DelegationCode 
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
	, I.F_InscriptionResult
    , I.F_InscriptionRank
	, MR.F_StartTimeCharDes 
	, ''
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	WHERE MR.F_MatchID = @MatchID  
	)

	SELECT * FROM #StartList order by StartOrder

Set NOCOUNT OFF
End
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetStartList] 2267,'eng'

*/
