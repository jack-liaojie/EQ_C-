IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetCompetitorCard]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetCompetitorCard]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_WL_GetCompetitorCard]
----功		  能：得到当前Match信息
----作		  者：吴定昉
----日		  期: 2010-10-19 

CREATE PROCEDURE [dbo].[Proc_Report_WL_GetCompetitorCard]
             @MatchID         INT,
             @BibNumber       INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

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

	CREATE TABLE #TempList
	(
		BibNumber				INT,
        LotNo                   INT,
		[Name]					NVARCHAR(100),
		NOCCode					CHAR(3),
		DelegationName          NVARCHAR(100),				
		FederationName          NVARCHAR(100),
		InscriptionResult       NVARCHAR(100),
        DateOfBirth             datetime,
        Category                NVARCHAR(100),
        Bodyweight              NVARCHAR(100),
		EntryTotal				NVARCHAR(10),
	)

	-- 在临时表中插入基本信息
	INSERT #TempList 
	(BibNumber, LotNo, [Name], NOCCode, DelegationName, FederationName, InscriptionResult, DateOfBirth, Category, Bodyweight, EntryTotal)
	(
	SELECT  
	(case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum else R.F_Bib end)
	, I.F_Seed AS [LotNo]
	, (SELECT REPLACE(RD.F_LongName,'/',nchar(10))) AS [Name]
	, D.F_DelegationCode 
	, DD.F_DelegationLongName
	, FD.F_FederationLongName
	, I.F_InscriptionResult
	, R.F_Birth_Date
    , ED.F_EventLongName + ' ' + P.F_PhaseCode AS [Category]
    , ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight) AS [Bodyweight]
	, I.F_InscriptionResult AS [EntryTotal]
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	LEFT JOIN TS_Match_Result AS SNMR ON MR.F_RegisterID = SNMR.F_RegisterID AND SNMR.F_MatchID = @SnatchMatchID 
	LEFT JOIN TS_Match_Result AS CJMR ON MR.F_RegisterID = CJMR.F_RegisterID AND CJMR.F_MatchID = @CleanJerkMatchID 
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @PhaseID
	LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode 
	WHERE MR.F_MatchID = @MatchID  
	)
	
	SET @BibNumber=ISNULL(@BibNumber,-1)
	SET LANGUAGE ENGLISH
	IF(@BibNumber >=0)
		BEGIN 
		SELECT  BibNumber, LotNo, [Name], NOCCode, DelegationName, FederationName, InscriptionResult, 
				dbo.Fun_WL_GetDateTime([DateOfBirth],1,@LanguageCode) AS DateOfBirth, Category, Bodyweight, EntryTotal 
			  FROM #TempList WHERE [BibNumber] = @BibNumber order by BibNumber,LotNo 
		END
	ELSE
		BEGIN
		SELECT  BibNumber, LotNo, [Name], NOCCode, DelegationName, FederationName, InscriptionResult, 
				 dbo.Fun_WL_GetDateTime([DateOfBirth],1,@LanguageCode) AS DateOfBirth, Category, Bodyweight, EntryTotal 
			  FROM #TempList order by BibNumber,LotNo 
		END
Set NOCOUNT OFF
End
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetCompetitorCard] 61,null,'eng'

*/
