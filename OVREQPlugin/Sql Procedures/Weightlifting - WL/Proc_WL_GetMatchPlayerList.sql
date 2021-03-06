IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetMatchPlayerList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetMatchPlayerList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--名    称: [Proc_WL_GetMatchPlayerList]
--描    述: 举重项目,获取所有比赛队员信息
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月16日
--修改记录：
/*
			2011-03-10   崔凯   添加签号，最好成绩的试举次数，先前试举重量，用于排名
			2011-04-27   崔凯   用签号排序
			2011-05-10   崔凯   称重体重用TS_Phase_Result表F_PhasePointsCharDes1字段
*/



CREATE PROCEDURE [dbo].[Proc_WL_GetMatchPlayerList]
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
	DECLARE @SnatchMatchID	INT
	DECLARE @CleanJerkMatchID	INT
	

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


	CREATE TABLE #MatchResult
	(
		F_CompetitionPosition	INT,
		F_RegisterID            INT,
        LotNo                   INT,
        LightOrder			    INT,
		Bib						INT,
		[Name]					NVARCHAR(100),
		NOC						CHAR(3),
		BodyWeight              NVARCHAR(10),
		[1stAttempt]			NVARCHAR(10),
		[1stRes]				NVARCHAR(10),
		[2ndAttempt]			NVARCHAR(10),
		[2ndRes]				NVARCHAR(10),
		[3rdAttempt]			NVARCHAR(10),
		[3rdRes]				NVARCHAR(10),
		Result			        NVARCHAR(10),
		[Rank]			        NVARCHAR(10),
		IRM				        NVARCHAR(10),
		SnatchResult			NVARCHAR(10),
		SnatchIRM				NVARCHAR(10),
		CleanJerkResult			NVARCHAR(10),
		CleanJerkIRM			NVARCHAR(10),
		TotalResult				NVARCHAR(10),
		TotalIRM				NVARCHAR(10),
		[Status]				INT,
		Record					NVARCHAR(100),
		Position				INT,
		AttemptTime				INT,
		ResultTimes				INT,
		LastAttempt				NVARCHAR(10),
		IsContinue				INT,
		[Other1stAttempt]		NVARCHAR(10),
		[InscriptionResult]		NVARCHAR(10),
		Age						INT,
	)


	INSERT #MatchResult
	(F_CompetitionPosition,F_RegisterID,LotNo,LightOrder,Bib,[Name],NOC,BodyWeight,
	[1stAttempt],[1stRes],[2ndAttempt],[2ndRes],[3rdAttempt],[3rdRes],Result,[Rank],IRM,
	SnatchResult,SnatchIRM, CleanJerkResult,CleanJerkIRM, 
	TotalResult,TotalIRM,[Status],Record,Position,AttemptTime,ResultTimes,LastAttempt,
	IsContinue,[Other1stAttempt],[InscriptionResult],Age)
	(
	SELECT  
	  MR.F_CompetitionPosition  
	, MR.F_RegisterID
	, I.F_Seed
	, MR.F_CompetitionPositionDes2 
	, (case when I.F_InscriptionNum is not null and I.F_InscriptionNum <> '' then I.F_InscriptionNum else R.F_Bib end) 
	, RD.F_LongName 
	, D.F_DelegationCode
	, ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight)
	, MR.F_PointsCharDes1
	, case when MR.F_PointsNumDes1 is null then '' 
	       else Right(N'000' + cast(MR.F_PointsNumDes1 as varchar(3)), 3) end
	, MR.F_PointsCharDes2
	, case when MR.F_PointsNumDes2 is null then '' 
	       else Right(N'000' + cast(MR.F_PointsNumDes2 as varchar(3)), 3) end
	, MR.F_PointsCharDes3
	, case when MR.F_PointsNumDes3 is null then '' 
	       else Right(N'000' + cast(MR.F_PointsNumDes3 as varchar(3)), 3) end
	, MR.F_PointsCharDes4
	, MR.F_Rank
	, MRID.F_IRMLongName
	, MRSN.F_PointsCharDes4
	, MRSNID.F_IRMLongName
	, MRCJ.F_PointsCharDes4
	, MRCJID.F_IRMLongName
	, ER.F_EventPointsCharDes4
	, ERID.F_IRMLongName
	, MR.F_RealScore
	, case when @MatchCode = '01' then dbo.Fun_WL_GetRecordSecString(MR.F_MatchID,R.F_RegisterID, '1')
	       when @MatchCode = '02' then dbo.Fun_WL_GetRecordSecString(MR.F_MatchID,R.F_RegisterID, '2')
	       else '' end
	, MR.F_CompetitionPositionDes1 
	, MR.F_Points
	, ISNULL(MR.F_WinPoints,0)
	, CASE WHEN MR.F_WinPoints =2 THEN MR.F_PointsCharDes1
		   WHEN MR.F_WinPoints =3 THEN MR.F_PointsCharDes2 + MR.F_PointsCharDes1
		   ELSE '' END
	, CASE WHEN @MatchCode ='02' AND ((MRSN.F_PointsCharDes4 IS NULL AND MRSN.F_PointsNumDes1 IS NOT NULL  AND MRSN.F_PointsNumDes2 IS NOT NULL  AND MRSN.F_PointsNumDes3 IS NOT NULL)
				OR MRSN.F_IRMID IS NOT NULL) THEN 1
		ELSE 0 END AS [IsContinue]
	, CASE WHEN @MatchCode ='01' THEN MRCJ.F_PointsCharDes1
		   ELSE MRSN.F_PointsCharDes1 END
	, CASE WHEN @SexCode = 1 AND I.F_InscriptionResult IS NOT NULL then CONVERT(FLOAT,I.F_InscriptionResult)-20
		   WHEN @SexCode = 2 AND I.F_InscriptionResult IS NOT NULL then CONVERT(FLOAT,I.F_InscriptionResult)-15
		   ELSE '0' END
	, dbo.Fun_WL_GetPlayerAge(R.F_Birth_Date,GETDATE())
	FROM TS_Match_Result AS MR  
	LEFT JOIN TR_Register AS R ON MR.F_RegisterID = R.F_RegisterID 
	LEFT JOIN TR_Register_Des AS RD ON MR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Match AS M ON MR.F_MatchID = M.F_MatchID 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID  
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID  
	LEFT JOIN TR_Inscription AS I ON MR.F_RegisterID = I.F_RegisterID AND P.F_EventID = I.F_EventID 
	LEFT JOIN TS_Match_Result AS MRSN ON MR.F_RegisterID = MRSN.F_RegisterID AND MRSN.F_MatchID = @SnatchMatchID 
	LEFT JOIN TS_Match_Result AS MRCJ ON MR.F_RegisterID = MRCJ.F_RegisterID AND MRCJ.F_MatchID = @CleanJerkMatchID 
	LEFT JOIN TS_Phase_Result AS PR ON MR.F_RegisterID = PR.F_RegisterID AND PR.F_PhaseID = M.F_PhaseID 
	LEFT JOIN TS_Event_Result AS ER ON MR.F_RegisterID = ER.F_RegisterID AND ER.F_EventID = P.F_EventID 
	LEFT JOIN TC_IRM_Des AS MRID ON MR.F_IRMID = MRID.F_IRMID AND MRID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS MRSNID ON MRSN.F_IRMID = MRSNID.F_IRMID AND MRSNID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS MRCJID ON MRCJ.F_IRMID = MRCJID.F_IRMID AND MRCJID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS PRID ON PR.F_IRMID = PRID.F_IRMID AND PRID.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_IRM_Des AS ERID ON ER.F_IRMID = ERID.F_IRMID AND ERID.F_LanguageCode = @LanguageCode
	WHERE MR.F_MatchID = @MatchID)
    
    
	SELECT * FROM #MatchResult order by ISNULL(LotNo,999)


SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_WL_GetMatchPlayerList] 17,'ENG'

*/




