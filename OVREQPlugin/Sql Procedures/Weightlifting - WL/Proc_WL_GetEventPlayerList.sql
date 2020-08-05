IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetEventPlayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetEventPlayerList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









--名    称: [Proc_WL_GetEventPlayerList]
--描    述: 举重项目,获取所有比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月16日
--修改记录：
/*
			2011-01-27   崔凯   取整个event运动员信息
			2011-03-10   崔凯   添加签号，最好成绩的试举次数，先前试举重量，用于排名
			2011-05-10   崔凯   称重体重用TS_Phase_Result表F_PhasePointsCharDes1字段
*/



CREATE PROCEDURE [dbo].[Proc_WL_GetEventPlayerList]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @EventID	    INT
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

	CREATE TABLE #Temp_RegTable
	(
		F_RegisterID            INT,
    )
	INSERT #Temp_RegTable(F_RegisterID)
	(SELECT  DISTINCT MR.F_RegisterID
	FROM TS_Match_Result AS MR  
	WHERE MR.F_MatchID IN (
	SELECT F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	WHERE E.F_EventID = @EventID)
	AND MR.F_RegisterID IS NOT NULL
	)


	CREATE TABLE #Temp_Table
	(
		F_RegisterID            INT,
		TotalDisplayPosition	INT,
		TotalRank			    INT,
		[Group]                 NVARCHAR(10),
		Bib						INT,
		[Name]					NVARCHAR(100),
		NOC						CHAR(3),
		BodyWeight              NVARCHAR(10),
		SnatchResult			NVARCHAR(10),
		SnatchIRM				NVARCHAR(10),
		CleanJerkResult			NVARCHAR(10),
		CleanJerkIRM			NVARCHAR(10),
		TotalResult				NVARCHAR(10),
		TotalIRM				NVARCHAR(10),
		FinishOrder             INT,
		Record					NVARCHAR(100),
		ResultTimes				INT,
		LotNo					INT,
		LastAttempt				NVARCHAR(100),
		[IsContinue]			INT,
		Age						INT,
	)

	INSERT #Temp_Table
	(F_RegisterID,TotalDisplayPosition,TotalRank,[Group],Bib,[Name],NOC,BodyWeight,
	SnatchResult,SnatchIRM,CleanJerkResult,CleanJerkIRM,TotalResult,TotalIRM,FinishOrder,
	Record,ResultTimes,LotNo,LastAttempt,[IsContinue],Age)  
	(
	SELECT  DISTINCT
	 TRT.F_RegisterID
	, ER.F_EventDisplayPosition
	, ER.F_EventRank
	, P.F_PhaseCode
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum else R.F_Bib end) 
	, RD.F_LongName 
	, D.F_DelegationCode
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight)
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (ERID.F_IRMLongName ='DNS' OR ERID.F_IRMLongName ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND ERID.F_IRMLongName ='DNF' THEN ISNULL(MRSN.F_PointsCharDes4,'---')
	       WHEN (dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes1) =0 OR dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes1) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes2) =0 OR dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes2) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes3) =0 OR dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes3) =3) THEN '---'
	       ELSE MRSN.F_PointsCharDes4 END		
	, MRSNID.F_IRMLongName
	, CASE WHEN ER.F_IRMID IS NOT NULL AND (ERID.F_IRMLongName ='DNS' OR ERID.F_IRMLongName ='DSQ') THEN '---'
	       WHEN ER.F_IRMID IS NOT NULL AND ERID.F_IRMLongName ='DNF' THEN ISNULL(MRCJ.F_PointsCharDes4,'---')
	       WHEN (dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes1) =0 OR dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes1) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes2) =0 OR dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes2) =3)
	        AND (dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes3) =0 OR dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes3) =3) THEN '---'
	       ELSE MRCJ.F_PointsCharDes4 END
	, MRCJID.F_IRMLongName
	, CASE WHEN ER.F_IRMID IS NOT NULL THEN '---'
	       WHEN (MRSN.F_PointsCharDes1 IS NOT NULL AND (dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes1) = 0 OR dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes1) = 3) 
			 AND MRSN.F_PointsCharDes2 IS NOT NULL AND (dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes2) = 0 OR dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes2) = 3)  
			 AND MRSN.F_PointsCharDes3 IS NOT NULL AND (dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes3) = 0 OR dbo.Fun_WL_GetIsSuccess(MRSN.F_PointsNumDes3) = 3))
			 OR (MRCJ.F_PointsCharDes1 IS NOT NULL AND (dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes1) = 0 OR dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes1) = 3)  
			 AND MRCJ.F_PointsCharDes2 IS NOT NULL AND (dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes2) = 0 OR dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes2) = 3)  
			 AND MRCJ.F_PointsCharDes3 IS NOT NULL AND (dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes3) = 0 OR dbo.Fun_WL_GetIsSuccess(MRCJ.F_PointsNumDes3) = 3))
			THEN '---' 
			ELSE ER.F_EventPointsCharDes4 END
	, ERID.F_IRMLongName
	, ER.F_EventPointsCharDes1
	, dbo.Fun_WL_GetRecordSecString(@MatchID, TRT.F_RegisterID, NULL)
	, ISNULL(MRCJ.F_WinPoints,0)
	, I.F_Seed
	, CASE WHEN MRCJ.F_WinPoints =3 THEN
				MRCJ.F_PointsCharDes2 + MRCJ.F_PointsCharDes1
		   WHEN MRCJ.F_WinPoints =2 THEN 
				MRCJ.F_PointsCharDes1 
		   ELSE '' END AS [LastResult]
	,CASE WHEN @MatchCode ='02' AND ((MRSN.F_PointsCharDes4 IS NULL AND MRSN.F_PointsNumDes1 IS NOT NULL  AND MRSN.F_PointsNumDes2 IS NOT NULL  AND MRSN.F_PointsNumDes3 IS NOT NULL)
				OR MRSN.F_IRMID IS NOT NULL) THEN 1
		ELSE 0 END AS [IsContinue]
	, dbo.Fun_WL_GetPlayerAge(R.F_Birth_Date,GETDATE())
	FROM #Temp_RegTable AS TRT  
	LEFT JOIN TR_Register AS R ON TRT.F_RegisterID = R.F_RegisterID 
	LEFT JOIN TR_Register_Des AS RD ON TRT.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Match AS M ON M.F_MatchID = 
		(SELECT TOP 1 MR.F_MatchID FROM TS_Match_Result AS MR WHERE MR.F_RegisterID = TRT.F_RegisterID AND MR.F_MatchID IN
			(SELECT MM.F_MatchID FROM TS_Match AS MM LEFT JOIN TS_Phase AS PP ON PP.F_PhaseID =MM.F_PhaseID
						LEFT JOIN TS_Event AS EE ON EE.F_EventID = @EventID WHERE MM.F_MatchCode ='01'))	 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TR_Inscription AS I ON TRT.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID
	LEFT JOIN TS_Match_Result AS MRSN ON TRT.F_RegisterID = MRSN.F_RegisterID AND MRSN.F_MatchID IN
					(SELECT MM.F_MatchID FROM TS_Match AS MM WHERE MM.F_PhaseID IN 
						(SELECT F_PhaseID FROM TS_Phase WHERE F_EventID=@EventID) AND MM.F_MatchCode ='01')
	LEFT JOIN TS_Match_Result AS MRCJ ON TRT.F_RegisterID = MRCJ.F_RegisterID AND MRCJ.F_MatchID IN
					(SELECT MM.F_MatchID FROM TS_Match AS MM WHERE MM.F_PhaseID IN 
						(SELECT F_PhaseID FROM TS_Phase WHERE F_EventID=@EventID) AND MM.F_MatchCode ='02')	 
	LEFT JOIN TS_Phase_Result AS PR ON  PR.F_PhaseID = M.F_PhaseID AND TRT.F_RegisterID = PR.F_RegisterID
	LEFT JOIN TS_Event_Result AS ER ON  ER.F_EventID = @EventID AND TRT.F_RegisterID = ER.F_RegisterID
	--LEFT JOIN TC_IRM_Des AS MRID ON MR.F_IRMID = MRID.F_IRMID AND MRID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS MRSNID ON MRSN.F_IRMID = MRSNID.F_IRMID AND MRSNID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS MRCJID ON MRCJ.F_IRMID = MRCJID.F_IRMID AND MRCJID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS PRID ON PR.F_IRMID = PRID.F_IRMID AND PRID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS ERID ON ER.F_IRMID = ERID.F_IRMID AND ERID.F_LanguageCode = @LanguageCode
	)
    
	SELECT * FROM #Temp_Table order by case when TotalRank IS NULL THEN '999' ELSE TotalRank END ASC
									  ,case when TotalDisplayPosition is null then '999' else TotalDisplayPosition end ASC,[Group] desc


SET NOCOUNT OFF
END


GO


