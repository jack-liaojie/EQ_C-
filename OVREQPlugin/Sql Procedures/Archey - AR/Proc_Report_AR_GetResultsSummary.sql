IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetResultsSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetResultsSummary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_Report_AR_GetResultsSummary]
--描    述：得到Event下的一个Round下的Match信息
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年10月20日


CREATE PROCEDURE [dbo].[Proc_Report_AR_GetResultsSummary](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	--DECLARE @IsSetPoints INT
	--SELECT @IsSetPoints = M.F_MatchComment3 FROM TS_Match AS M
	--	LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
	--	LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
	--	WHERE E.F_EventID = @EventID 
		
	SET LANGUAGE ENGLISH
	SELECT DISTINCT MR.F_Points AS Total
		  --,ISNULL(ER.F_EventRank,(RANK() OVER(order by ISNULL(MR1.F_Rank,999),
				--ISNULL(MR2.F_Rank,999),ISNULL(MR3.F_Rank,999),ISNULL(MR4.F_Rank,999),ISNULL(MR5.F_Rank,999)))) AS EventRank
		  
		  ,ISNULL(ER.F_EventRank,
					CASE WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL AND MR5.F_Rank IS NULL  THEN 33
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL AND MR5.F_Rank =1  THEN 16
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL AND (MR5.F_Rank =2 OR MR5.F_IRMID IS NOT NULL) THEN 17
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank =1  THEN 8
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND (MR4.F_Rank =2 OR MR4.F_IRMID IS NOT NULL)  THEN 9
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank =1 THEN 4
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND (MR3.F_Rank =2 OR MR3.F_IRMID IS NOT NULL) THEN 5
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank =1 THEN 2
						 WHEN MR1.F_Rank IS NULL AND (MR2.F_Rank =2 OR MR2.F_IRMID IS NOT NULL) THEN 4
						 WHEN MR1.F_Rank =1 AND MR1.F_MatchCode ='01' THEN 1
						 WHEN (MR1.F_Rank =2 OR MR1.F_IRMID IS NOT NULL) AND MR1.F_MatchCode ='01' THEN 2
						 WHEN MR1.F_Rank =1 AND MR1.F_MatchCode ='02' THEN 3
						 WHEN (MR1.F_Rank =2 OR MR1.F_IRMID IS NOT NULL) AND MR1.F_MatchCode ='02' THEN 4
						 ELSE 32 END) AS EventRank
		  ,RD.F_PrintLongName AS Name
		  ,D.F_DelegationCode AS NOC
		  ,DD.F_DelegationLongName AS NOCName
		  ,MR.F_Rank AS QRank
		  ,CASE WHEN MR.F_IRMID IS NOT NULL THEN IRM.F_IRMCODE ELSE CAST(MR.F_Points  AS NVARCHAR(10)) END AS QScore
		  ,MR7.F_Rank AS Rank7
		  ,MR7.TiedPoint AS TiedPoint7
		  ,CASE WHEN MR7.F_IRMID IS NOT NULL THEN IRM7.F_IRMCODE ELSE CAST(MR7.F_Points AS NVARCHAR(10)) END AS Score7
		  ,MR6.F_Rank AS Rank6
		  ,MR6.TiedPoint AS TiedPoint6
		  ,CASE WHEN MR6.F_IRMID IS NOT NULL THEN IRM6.F_IRMCODE ELSE CAST(MR6.F_Points AS NVARCHAR(10)) END AS Score6
		  ,MR5.F_Rank AS Rank5
		  ,MR5.TiedPoint AS TiedPoint5
		  ,CASE WHEN MR5.F_IRMID IS NOT NULL THEN IRM5.F_IRMCODE ELSE CAST(MR5.F_Points AS NVARCHAR(10)) END AS Score5
		  ,MR4.F_Rank AS Rank4
		  ,MR4.TiedPoint AS TiedPoint4
		  ,CASE WHEN MR4.F_IRMID IS NOT NULL THEN IRM4.F_IRMCODE ELSE CAST(MR4.F_Points AS NVARCHAR(10)) END AS Score4
		  ,MR3.F_Rank AS Rank3
		  ,MR3.TiedPoint AS TiedPoint3
		  ,CASE WHEN MR3.F_IRMID IS NOT NULL THEN IRM3.F_IRMCODE ELSE CAST(MR3.F_Points AS NVARCHAR(10)) END AS Score3
		  ,MR2.F_Rank AS Rank2
		  ,MR2.TiedPoint AS TiedPoint2
		  ,CASE WHEN MR2.F_IRMID IS NOT NULL THEN IRM2.F_IRMCODE ELSE CAST(MR2.F_Points AS NVARCHAR(10)) END AS Score2
		  ,MR1.F_Rank AS Rank1
		  ,MR1.TiedPoint AS TiedPoint1
		  ,CASE WHEN MR1.F_IRMID IS NOT NULL THEN IRM1.F_IRMCODE ELSE CAST(MR1.F_Points AS NVARCHAR(10)) END AS Score1
		  FROM TS_Match_Result AS MR
			LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER ON ER.F_EventID = E.F_EventID AND ER.F_RegisterID = MR.F_RegisterID
			LEFT JOIN TR_Register AS R ON R.F_RegisterID = MR.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = MR.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = R.F_DelegationID
			LEFT JOIN TC_Delegation_DES AS DD ON DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode =@LanguageCode
			LEFT JOIN (SELECT F_RegisterID,F_Rank,
							CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							 WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR) ELSE CAST(F_Points AS NVARCHAR) END AS F_Points,F_IRMID
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '7' AND F_EventID=@EventID) AS MR7 
							ON MR.F_RegisterID = MR7.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,
							CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							 WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR) ELSE CAST(F_Points AS NVARCHAR) END AS F_Points,F_IRMID
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '6' AND F_EventID=@EventID) AS MR6 
							ON MR.F_RegisterID = MR6.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,
							CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							 WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR) ELSE CAST(F_Points AS NVARCHAR) END AS F_Points,F_IRMID
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '5' AND F_EventID=@EventID) AS MR5 
							ON MR.F_RegisterID = MR5.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							  WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR) ELSE CAST(F_Points AS NVARCHAR) END AS F_Points,F_IRMID 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint 
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '4' AND F_EventID=@EventID) AS MR4 
							ON MR.F_RegisterID = MR4.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							  WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR) ELSE CAST(F_Points AS NVARCHAR) END AS F_Points,F_IRMID
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint 
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '3' AND F_EventID=@EventID) AS MR3 
							ON MR.F_RegisterID = MR3.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							  WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR) ELSE CAST(F_Points AS NVARCHAR) END AS F_Points,F_IRMID 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '2' AND F_EventID=@EventID) AS MR2 
							ON MR.F_RegisterID = MR2.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,CASE WHEN (F_Points IS NULL OR F_Points =0)  AND (F_RealScore IS NULL OR F_RealScore=0) AND F_Rank =1 THEN '-BYE-'
							  WHEN F_MatchComment3 = 1 THEN CAST(F_RealScore AS NVARCHAR)  ELSE CAST(F_Points AS NVARCHAR) END AS F_Points ,F_IRMID,M.F_MatchCode 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
						FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '1' AND F_EventID=@EventID) AS MR1 
							ON MR.F_RegisterID = MR1.F_RegisterID
			LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = MR.F_IRMID
			LEFT JOIN TC_IRM AS IRM1 ON IRM1.F_IRMID = MR1.F_IRMID
			LEFT JOIN TC_IRM AS IRM2 ON IRM2.F_IRMID = MR2.F_IRMID
			LEFT JOIN TC_IRM AS IRM3 ON IRM3.F_IRMID = MR3.F_IRMID
			LEFT JOIN TC_IRM AS IRM4 ON IRM4.F_IRMID = MR4.F_IRMID
			LEFT JOIN TC_IRM AS IRM5 ON IRM5.F_IRMID = MR5.F_IRMID
			LEFT JOIN TC_IRM AS IRM6 ON IRM6.F_IRMID = MR6.F_IRMID
			LEFT JOIN TC_IRM AS IRM7 ON IRM7.F_IRMID = MR7.F_IRMID
			WHERE E.F_EventID = @EventID AND P.F_PhaseCode IN('A','B','C','D','X','Y') AND M.F_MatchCode = 'QR' 
			
			ORDER BY EventRank,Rank7,Rank6,Rank5,Rank4,Rank3,Rank2,Rank1,MR.F_Rank
			
			
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




GO

/*
EXEC Proc_Report_AR_GetResultsSummary 1,'ENG'
*/
