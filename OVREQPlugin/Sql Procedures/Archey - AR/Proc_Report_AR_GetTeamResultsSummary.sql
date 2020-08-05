IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetTeamResultsSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetTeamResultsSummary]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称：[Proc_Report_AR_GetTeamResultsSummary]
--描    述：得到Event下的一个Round下的Match信息
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年10月20日


CREATE PROCEDURE [dbo].[Proc_Report_AR_GetTeamResultsSummary](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 


	SET LANGUAGE ENGLISH
	
	SELECT DISTINCT
		  ISNULL(ER.F_EventRank,
					CASE WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL AND MR5.F_Rank IS NULL THEN 32
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL AND MR5.F_Rank=1 THEN 16
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL AND MR5.F_Rank =2 THEN 17 
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank IS NULL THEN 16
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank =1 THEN 8
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL AND MR4.F_Rank =2 THEN 9
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank IS NULL THEN 8
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank =1 THEN 4
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank IS NULL AND MR3.F_Rank =2 THEN 5
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank =1 THEN 2
						 WHEN MR1.F_Rank IS NULL AND MR2.F_Rank =2 THEN 4
						 WHEN MR1.F_Rank =1 AND MR1.F_MatchCode ='01' THEN 1
						 WHEN MR1.F_Rank =2 AND MR1.F_MatchCode ='01' THEN 2
						 WHEN MR1.F_Rank =1 AND MR1.F_MatchCode ='02' THEN 3
						 WHEN MR1.F_Rank =2 AND MR1.F_MatchCode ='02' THEN 4
						 ELSE 5 END) AS EventRank
		  , RD.F_PrintLongName AS Name
		  , D.F_DelegationCode AS NOC
		  , MRD.F_PrintLongName AS MembersName
		  , I.F_InscriptionRank AS QRank
		  , I.F_InscriptionResult AS QScore
		  ,MR5.F_Rank AS Rank5
		  ,MR5.TiedPoint AS TiedPoint5
		  ,CASE WHEN MR5.F_IRMID IS NOT NULL THEN IRM5.F_IRMCODE
			    WHEN (MR5.F_Points IS NULL OR  MR5.F_Points =0) AND MR5.F_Rank =1 THEN '-BYE-' ELSE CAST(MR5.F_Points AS NVARCHAR(10)) END AS Score5
		  ,MR4.F_Rank AS Rank4
		  ,MR4.TiedPoint AS TiedPoint4
		  ,CASE WHEN MR4.F_IRMID IS NOT NULL THEN IRM4.F_IRMCODE
			    WHEN (MR4.F_Points IS NULL OR  MR4.F_Points =0) AND MR4.F_Rank =1 THEN '-BYE-' ELSE CAST(MR4.F_Points AS NVARCHAR(10)) END AS Score4
		  ,MR3.F_Rank AS Rank3
		  ,MR3.TiedPoint AS TiedPoint3
		  ,CASE WHEN MR3.F_IRMID IS NOT NULL THEN IRM3.F_IRMCODE
			    WHEN (MR3.F_Points IS NULL OR  MR3.F_Points =0) AND MR3.F_Rank =1 THEN '-BYE-' ELSE CAST(MR3.F_Points AS NVARCHAR(10)) END AS Score3
		  ,MR2.F_Rank AS Rank2
		  ,MR2.TiedPoint AS TiedPoint2
		  ,CASE WHEN MR2.F_IRMID IS NOT NULL THEN IRM2.F_IRMCODE
			    WHEN (MR2.F_Points IS NULL OR  MR2.F_Points =0) AND MR2.F_Rank =1 THEN '-BYE-'  ELSE CAST(MR2.F_Points AS NVARCHAR(10)) END AS Score2
		  ,MR1.F_Rank AS Rank1
		  ,MR1.TiedPoint AS TiedPoint1
		  ,CASE WHEN MR1.F_IRMID IS NOT NULL THEN IRM1.F_IRMCODE
			    WHEN (MR1.F_Points IS NULL OR  MR1.F_Points =0) AND MR1.F_Rank =1 THEN '-BYE-'  ELSE CAST(MR1.F_Points AS NVARCHAR(10)) END AS Score1
		  , MI.F_InscriptionNum AS BackNo
		  FROM TR_Inscription AS I
			LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = I.F_RegisterID AND RM.F_Order IN (1,2,3)
			LEFT JOIN TS_Event AS E ON I.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Result AS ER ON ER.F_EventID = E.F_EventID AND ER.F_RegisterID = I.F_RegisterID
			LEFT JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID
			LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = I.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Register AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID
			LEFT JOIN TR_Register_Des AS MRD ON MRD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode
			LEFT JOIN TR_Inscription AS MI ON MI.F_RegisterID = RM.F_MemberRegisterID
			LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = R.F_DelegationID
			LEFT JOIN TC_Delegation_Des AS DD ON DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
			
			LEFT JOIN (SELECT F_RegisterID,F_Rank,F_Points,F_IRMID 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
							 FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '5' AND F_EventID=@EventID) AS MR5 
							ON I.F_RegisterID = MR5.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,F_Points,F_IRMID 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
							 FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '4' AND F_EventID=@EventID) AS MR4 
							ON I.F_RegisterID = MR4.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,F_Points,F_IRMID 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
							 FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '3' AND F_EventID=@EventID) AS MR3 
							ON I.F_RegisterID = MR3.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,F_Points,F_IRMID 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
							 FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '2' AND F_EventID=@EventID) AS MR2 
							ON I.F_RegisterID = MR2.F_RegisterID
			LEFT JOIN (SELECT F_RegisterID,F_Rank,F_Points,F_IRMID,M.F_MatchCode 
							,dbo.Fun_AR_GetMatchTiedString(MR.F_MatchID,MR.F_CompetitionPosition) AS TiedPoint
							 FROM TS_Match_Result AS MR
						LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID 
							LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID WHERE  P.F_PhaseCode = '1' AND F_EventID=@EventID) AS MR1 
							ON I.F_RegisterID = MR1.F_RegisterID
			LEFT JOIN TC_IRM AS IRM1 ON IRM1.F_IRMID = MR1.F_IRMID
			LEFT JOIN TC_IRM AS IRM2 ON IRM2.F_IRMID = MR2.F_IRMID
			LEFT JOIN TC_IRM AS IRM3 ON IRM3.F_IRMID = MR3.F_IRMID
			LEFT JOIN TC_IRM AS IRM4 ON IRM4.F_IRMID = MR4.F_IRMID
			LEFT JOIN TC_IRM AS IRM5 ON IRM5.F_IRMID = MR5.F_IRMID
			WHERE E.F_EventID = @EventID
			
			ORDER BY EventRank
			
			
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF




GO

/*
EXEC Proc_Report_AR_GetTeamResultsSummary 6,'ENG'
*/
