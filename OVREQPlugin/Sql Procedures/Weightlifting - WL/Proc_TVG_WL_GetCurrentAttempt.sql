IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_WL_GetCurrentAttempt]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_WL_GetCurrentAttempt]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----存储过程名称：[Proc_TVG_WL_GetCurrentAttempt]
----功		  能：SCB得到当前运动员信息
----作		  者：崔凯
----日		  期: 2011-02-28 

CREATE PROCEDURE [dbo].[Proc_TVG_WL_GetCurrentAttempt]
             @MatchID         INT,
             @RegisterID      INT

AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @PhaseID   INT
	DECLARE @EventID   INT

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode,
    @EventID = e.F_EventID, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

    SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	SELECT 
	I.F_InscriptionNum AS Bib,
	N'Rank ' + Cast(ER.F_EventRank AS NVARCHAR) AS [Rank],
	RDE.F_TvLongName AS LongName_ENG,
	RDC.F_TvLongName AS LongName_CHN,
	CASE WHEN MDE.F_MatchLongName = 'CleanJerk' THEN 'Clean&Jerk' ELSE MDE.F_MatchLongName END AS Type_ENG,
	MDC.F_MatchLongName AS Type_CHN, 
	ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight) AS [Weight], 
	N'[Image]IRM_'+ IRM.F_IRMCODE AS IRM, 
	N'[Image]'+ D.F_DelegationCode  AS Flag, 
	D.F_DelegationCode  AS NOC, 
	CASE WHEN MR.F_Points = 0 OR  MR.F_Points = NULL THEN N'Attempt 1' 
				 WHEN MR.F_Points >3 THEN  N'Attempt 3'  ELSE N'Attempt ' + Cast(MR.F_Points AS NVARCHAR) END AS F_Points ,
	CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND MR.F_PointsNumDes1 IS NULL THEN '---'
	     WHEN MR.F_PointsNumDes1 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1)=3 THEN '---'
	     ELSE MR.F_PointsCharDes1+ N' kg' END  AS Attempt1,
	CASE WHEN (ER.F_IRMID IS NULL OR (ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF')) 
				AND MR.F_PointsNumDes1 IS NOT NULL  THEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1)
		ELSE NULL END AS Res1,
	CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' 
	     AND MR.F_PointsNumDes1 IS NULL  AND dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes1)<>1 THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,MR.F_RegisterID,Right(@MatchCode,1),MR.F_PointsCharDes1) END 
	      AS Record2,
	CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND MR.F_PointsNumDes2 IS NULL THEN '---'
	     WHEN MR.F_PointsNumDes2 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2)=3 THEN '---'
	     ELSE MR.F_PointsCharDes2 + N' kg' END   AS Attempt2,
	CASE WHEN (ER.F_IRMID IS NULL OR (ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF')) 
				AND MR.F_PointsNumDes2 IS NOT NULL THEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2)
		ELSE NULL END AS Res2,
	CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' 
	     AND MR.F_PointsNumDes2 IS NULL  AND dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes2)<>1 THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,MR.F_RegisterID,Right(@MatchCode,1),MR.F_PointsCharDes2) END 
	      AS Record2,
	CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND MR.F_PointsNumDes3 IS NULL THEN '---'
	     WHEN MR.F_PointsNumDes3 IS NOT NULL AND dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3)=3 THEN '---'
	     ELSE MR.F_PointsCharDes3 + N' kg' END   AS Attempt3,
	CASE WHEN (ER.F_IRMID IS NULL OR (ER.F_IRMID IS NOT NULL AND IRM.F_IRMCODE ='DNF')) 
				AND MR.F_PointsNumDes3 IS NOT NULL THEN dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3)
		ELSE NULL END AS Res3,
	CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' 
	     AND MR.F_PointsNumDes3 IS NULL AND dbo.Fun_WL_GetIsSuccess(MR.F_PointsNumDes3)<>1  THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,MR.F_RegisterID,Right(@MatchCode,1),MR.F_PointsCharDes3)  END 
	     AS Record3,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN MR.F_PointsCharDes1 + N' kg'
		 WHEN MR.F_Points =2 THEN MR.F_PointsCharDes2 + N' kg'
		 WHEN MR.F_Points =3 THEN MR.F_PointsCharDes3 + N' kg'
		 ELSE ''  END AttemptWeight,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes1,1)
		 WHEN MR.F_Points =2 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes2,1)
		 WHEN MR.F_Points =3 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,1)
		 ELSE ''  END Light1,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes1,2)
		 WHEN MR.F_Points =2 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes2,2)
		 WHEN MR.F_Points =3 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,2)
		 ELSE ''  END Light2,
	CASE WHEN MR.F_Points =1 OR MR.F_Points =0 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes1,3)
		 WHEN MR.F_Points =2 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes2,3)
		 WHEN MR.F_Points =3 THEN dbo.Fun_WL_GetLightStatus(MR.F_PointsNumDes3,3)
		 ELSE ''  END Light3
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes2 IS NULL THEN '---'
	     ELSE ER.F_EventPointsCharDes2 + N' kg' END   AS Snatch
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes3 IS NULL THEN '---'
	     ELSE ER.F_EventPointsCharDes3 + N' kg' END   AS CleanJerk
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN '---'
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes4 IS NULL THEN '---'
	     ELSE ER.F_EventPointsCharDes4 + N' kg' END   AS Total
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes2 IS NULL THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,ER.F_RegisterID,'1',ER.F_EventPointsCharDes2)  END 
	     AS SnatchRecord
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes3 IS NULL THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,ER.F_RegisterID,'2',ER.F_EventPointsCharDes3) END 
	      AS CJerkRecord
	,CASE WHEN ER.F_IRMID IS NOT NULL AND (IRM.F_IRMCode ='DNS' OR IRM.F_IRMCode ='DSQ') THEN NULL
	     WHEN ER.F_IRMID IS NOT NULL AND IRM.F_IRMCode ='DNF' AND ER.F_EventPointsCharDes4 IS NULL THEN NULL
	     ELSE dbo.Fun_WL_GetResultRecordForTVG(@EventID,ER.F_RegisterID,'3',ER.F_EventPointsCharDes4)  END 
	     AS TotalRecord
	
	FROM TS_Match_Result AS MR
	LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID	
	LEFT JOIN TS_Phase_Result AS PR ON PR.F_PhaseID = M.F_PhaseID AND PR.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TR_Register AS R ON R.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDE ON RDE.F_RegisterID = MR.F_RegisterID AND RDE.F_LanguageCode='ENG'
	LEFT JOIN TR_Inscription AS I ON I.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RDC ON RDC.F_RegisterID = MR.F_RegisterID AND RDC.F_LanguageCode='CHN'
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Match_Des AS MDE ON MDE.F_MatchID = MR.F_MatchID AND MDE.F_LanguageCode='ENG'
	LEFT JOIN TS_Match_Des AS MDC ON MDC.F_MatchID = MR.F_MatchID AND MDC.F_LanguageCode='CHN'
	LEFT JOIN TS_Event_Result AS ER ON ER.F_EventID= @EventID AND ER.F_RegisterID = MR.F_RegisterID
	LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = ER.F_IRMID
	WHERE (MR.F_RegisterID=@RegisterID OR @RegisterID =-1) AND MR.F_MatchID=@MatchID 
	ORDER BY 
	(CASE  WHEN MR.F_RealScore = 1 OR MR.F_RealScore =10 THEN 0
		 WHEN MR.F_RealScore = 0 OR MR.F_RealScore = 20 THEN 1 ELSE ISNULL(MR.F_RealScore,3) END), ISNULL(MR.F_CompetitionPositionDes2,999)
	
SET NOCOUNT OFF
END

GO


