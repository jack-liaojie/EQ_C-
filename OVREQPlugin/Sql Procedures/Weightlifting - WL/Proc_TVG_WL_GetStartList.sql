IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WL_GetStartList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WL_GetStartList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----�洢�������ƣ�[Proc_TVG_WL_GetStartList]
----��		  �ܣ�TVG�õ���ǰMatchStartList��Ϣ
----��		  �ߣ��ⶨ�P
----��		  ��: 2010-10-19 

CREATE PROCEDURE [dbo].[Proc_TVG_WL_GetStartList]
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

	CREATE TABLE #StartList
	(
		BibNumber				INT,
        LotNo                   INT,
		[Name]					NVARCHAR(100),
		Flag					NVARCHAR(20),
		DelegationName          NVARCHAR(100),	
        DateOfBirth             NVARCHAR(100),
		EntryTotal				NVARCHAR(10),
		Body_Weight				NVARCHAR(10),
		[Order]					INT,
		IRM						NVARCHAR(30),
		NOC						CHAR(3),
		Lift						NVARCHAR(30),
		
	)

	-- ����ʱ���в��������Ϣ
	INSERT #StartList 
	(BibNumber, LotNo, [Name], Flag,NOC, DelegationName, DateOfBirth, EntryTotal,Body_Weight,IRM,[Order],Lift)
	(
	SELECT  
	  ISNULL(I.F_InscriptionNum ,R.F_Bib)  AS [BibNumber]
	, I.F_Seed AS [LotNo]
	, (SELECT REPLACE(RD.F_TvShortName,'/',nchar(10))) AS [Name]
	, '[image]'+ D.F_DelegationCode
	, D.F_DelegationCode 
	, DD.F_DelegationLongName
    , UPPER(LEFT(CONVERT (NVARCHAR(100), R.F_Birth_Date, 113), 11))
	, I.F_InscriptionResult AS [EntryTotal]
    , CASE WHEN PR.F_IRMID IS NOT NULL THEN NULL 
		ELSE ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight) END
    ,  N'[Image]IRM_'+ IRM.F_IRMCODE AS IRM
	, ROW_NUMBER() OVER(ORDER BY I.F_Seed)
	, CASE WHEN MD.F_MatchLongName = 'CleanJerk' THEN 'Clean&Jerk' ELSE MD.F_MatchLongName END
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID  
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des AS DD ON R.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = 'ENG'
	LEFT JOIN TC_Federation_Des AS FD ON R.F_FederationID = FD.F_FederationID AND FD.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID  
	LEFT JOIN TS_Match_DES AS MD ON MR.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode =  'ENG'
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID  
	LEFT JOIN TS_Match_Result AS SNMR ON MR.F_RegisterID = SNMR.F_RegisterID AND SNMR.F_MatchID = @SnatchMatchID 
	LEFT JOIN TS_Match_Result AS CJMR ON MR.F_RegisterID = CJMR.F_RegisterID AND CJMR.F_MatchID = @CleanJerkMatchID 
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = @PhaseID
	LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = PR.F_IRMID
	WHERE MR.F_MatchID = @MatchID  
	)

	SELECT * FROM #StartList order by [Order]

Set NOCOUNT OFF
End

GO


