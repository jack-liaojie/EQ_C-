IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WL_GetPhaseResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WL_GetPhaseResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_TVG_WL_GetPhaseResult]
--描    述: 举重项目,获取所有比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年4月20日
--修改记录：
/*
*/



CREATE PROCEDURE [dbo].[Proc_TVG_WL_GetPhaseResult]
	@MatchID				INT
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
	DECLARE @EventID	INT
	

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @EventID = E.F_EventID,
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

	SELECT  
	  EDE.F_EventLongName AS Event_ENG
	, EDC.F_EventLongName AS Event_CHN
	, PDE.F_PhaseLongName AS Phase_ENG
	, PDC.F_PhaseLongName AS Phase_CHN 
	, RD.F_TvShortName AS Name_ENG 
	, RDC.F_TvShortName AS Name_CHN 
	, I.F_Seed AS Lot
	, ISNULL(I.F_InscriptionNum, R.F_Bib) AS Bib
	, '[image]' + D.F_DelegationCode AS Flag
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight)  AS Body_Weight
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN  ER.F_EventPointsCharDes2 IS NULL THEN '---'
	     ELSE ER.F_EventPointsCharDes2  END   AS Snatch
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN  ER.F_EventPointsCharDes3 IS NULL THEN '---'
	     ELSE ER.F_EventPointsCharDes3  END   AS CleanJerk
	,CASE WHEN ER.F_IRMID IS NOT NULL THEN ''
	     ELSE ER.F_EventPointsCharDes4  END   AS Total
	, N'[Image]IRM_'+ IRM.F_IRMCODE AS IRM
	, PR.F_PhaseRank AS [Rank]
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes4 IS NULL THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,ER.F_RegisterID,'3',ER.F_EventPointsCharDes4)  END 
	      AS Record
	, D.F_DelegationCode AS NOC
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = 'ENG'
	LEFT JOIN TR_Register_Des AS RDC ON MR.F_RegisterID = RDC.F_RegisterID AND RDC.F_LanguageCode = 'CHN'
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
	LEFT JOIN TS_Match_Result AS MRSN ON MR.F_RegisterID = MRSN.F_RegisterID AND MRSN.F_MatchID = @SnatchMatchID 
	LEFT JOIN TS_Match_Result AS MRCJ ON MR.F_RegisterID = MRCJ.F_RegisterID AND MRCJ.F_MatchID = @CleanJerkMatchID 
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = M.F_PhaseID 
	LEFT JOIN TS_Event_Result AS ER ON MR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = P.F_EventID 
	LEFT JOIN TC_IRM AS IRM ON ER.F_IRMID = IRM.F_IRMID
	LEFT JOIN TS_Phase_Des AS PDE ON PDE.F_PhaseID = P.F_PhaseID  AND PDE.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS PDC ON PDC.F_PhaseID = P.F_PhaseID  AND PDC.F_LanguageCode = 'CHN'
	LEFT JOIN TS_Event_Des AS EDE ON EDE.F_EventID = E.F_EventID AND EDE.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Event_Des AS EDC ON EDC.F_EventID = E.F_EventID AND EDC.F_LanguageCode = 'CHN'
	WHERE MR.F_MatchID = @MatchID 
	ORDER BY ISNULL(PR.F_PhaseRank,999) ,ISNULL(IRM.F_Order,0),ISNULL(I.F_Seed,999)


SET NOCOUNT OFF
END

GO


