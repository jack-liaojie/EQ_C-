IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetTeamStartBrackets]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetTeamStartBrackets]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_AR_GetTeamStartBrackets]
--描    述：得到Event下的一个Round下的Match信息
--参数说明： 
--说    明：
--创 建 人：崔凯
--日    期：2011年10月20日


CREATE PROCEDURE [dbo].[Proc_Report_AR_GetTeamStartBrackets](
                       @EventID         INT,
                       @PhaseCode       NVARCHAR(10),   ---如果@PhaseCode == '-1'，返回所有Match信息
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
		
		
	CREATE TABLE #Tmp_Table(
                            F_MatchID          INT,
                            F_APlayerID        INT,
                            F_APos             INT,
                            F_APrintLN         NVARCHAR(100),
                            F_APrintSN         NVARCHAR(50),
                            F_AIFRank          INT,
                            F_ASeed            NVARCHAR(20),
                            F_ARegisterCode    NVARCHAR(20),
                            F_ANOC             NVARCHAR(10),
                            F_AMatchFrom       NVARCHAR(10),
                            F_AMatchFromCourt  NVARCHAR(100),
                            F_AMatchFromDate   NVARCHAR(20),
                            F_BPlayerID        INT,
                            F_BPos             INT,
                            F_BPrintLN         NVARCHAR(100),
                            F_BPrintSN         NVARCHAR(50),
                            F_BIFRank          INT,
                            F_BSeed            NVARCHAR(20),
                            F_BRegisterCode    NVARCHAR(20),
                            F_BNOC             NVARCHAR(10),
                            F_BMatchFrom       NVARCHAR(10),
                            F_BMatchFromCourt  NVARCHAR(100),
                            F_BMatchFromDate   NVARCHAR(20),
                            F_MatchDes         NVARCHAR(10),
                            F_MatchCourt       NVARCHAR(100),
                            F_MatchDate        NVARCHAR(20),
                            F_ACourtMatch      NVARCHAR(100),
                            F_BCourtMatch      NVARCHAR(100),
                            F_MatchCourtNo     NVARCHAR(100),
                            F_NumberA          INT,
                            F_NumberB          INT,
                            F_ASourceMatchID   INT,
                            F_BSourceMatchID   INT,
                            F_APointDes		   NVARCHAR(100),
                            F_BPointDes		   NVARCHAR(100),
                            F_APoint		   NVARCHAR(100),
                            F_BPoint		   NVARCHAR(100),
                            F_CurPointDes	   NVARCHAR(100),
                            F_WinnerPrintLN         NVARCHAR(100),
                            F_WinnerRegisterCode    NVARCHAR(20),
                            F_WinnerNOC             NVARCHAR(10),
                            F_WinnerSeed            NVARCHAR(20),
                            F_PhaseCode             NVARCHAR(10),
                            
                            F_ABackNumber				INT,
                            F_BBackNumber				INT,
                            F_AQRank					INT,
                            F_AScore					INT,
                            F_BQRank					INT,
                            F_BScore					INT,
							F_MatchNo				NVARCHAR(100),
							F_StartDate				NVARCHAR(100),
							F_StartTime				NVARCHAR(100),
							F_Court					NVARCHAR(100),
							F_ARecord				NVARCHAR(100),
							F_BRecord				NVARCHAR(100),
							F_IsSetPoints			INT,
							F_IsOfficial			INT,
                            F_ARank					INT,
                            F_BRank					INT,
							
							F_AMembers1				NVARCHAR(100),
							F_BMembers1				NVARCHAR(100),
							F_AMembers2				NVARCHAR(100),
							F_BMembers2				NVARCHAR(100),
							F_AMembers3				NVARCHAR(100),
							F_BMembers3				NVARCHAR(100),
							
							F_AMembers1No				NVARCHAR(100),
							F_BMembers1No				NVARCHAR(100),
							F_AMembers2No				NVARCHAR(100),
							F_BMembers2No				NVARCHAR(100),
							F_AMembers3No				NVARCHAR(100),
							F_BMembers3No				NVARCHAR(100),
							)

    DECLARE @EventName NVARCHAR(10)
    SELECT @EventName = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode

    INSERT INTO #Tmp_Table(F_MatchID, F_APlayerID, F_APos, F_AMatchFrom, F_AMatchFromCourt, F_AMatchFromDate, F_BPlayerID, F_BPos, 
    F_BMatchFrom, F_BMatchFromCourt, F_BMatchFromDate, F_MatchDes, F_MatchCourt, F_MatchDate, F_NumberA, F_NumberB, F_PhaseCode
    ,F_MatchNo,F_StartDate,F_StartTime,F_Court,F_IsSetPoints,F_IsOfficial)
    SELECT A.F_MatchID
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
    ,(SELECT F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
    ,(SELECT @EventName + CAST(X.F_RaceNum AS NVARCHAR(10)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
    ,(SELECT [dbo].[Func_Report_TE_GetDateTime](X.F_MatchDate, 7, @LanguageCode) + ' ' + [dbo].[Func_Report_TE_GetDateTime](X.F_StartTime, 3, @LanguageCode) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
    ,(SELECT F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
    ,(SELECT @EventName + CAST(X.F_RaceNum AS NVARCHAR(10)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
    ,(SELECT [dbo].[Func_Report_TE_GetDateTime](X.F_MatchDate, 7, @LanguageCode) + ' ' + [dbo].[Func_Report_TE_GetDateTime](X.F_StartTime, 3, @LanguageCode) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
    ,@EventName + CAST(A.F_RaceNum AS NVARCHAR(10))
    ,(SELECT F_CourtShortName FROM TC_Court_Des WHERE F_CourtID = A.F_CourtID AND F_LanguageCode = @LanguageCode)
    ,([dbo].[Func_Report_TE_GetDateTime](A.F_MatchDate, 7, @LanguageCode) + ' ' + [dbo].[Func_Report_TE_GetDateTime](A.F_StartTime, 3, @LanguageCode))
    , ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2 - 1
    , ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2
    , B.F_PhaseCode
    , CASE WHEN A.F_RaceNum IS NULL THEN ''
		ELSE '比赛. '+ A.F_RaceNum END  AS F_MatchNo
    , DBO.Fun_AR_GetDateTime(A.F_MatchDate, 7,'CHN') + ' - ' + DBO.Fun_AR_GetDateTime(A.F_StartTime, 4,'CHN') AS F_StartDate 
    , DBO.Fun_AR_GetDateTime(A.F_StartTime, 4,'CHN') AS F_StartTime
    , D.F_CourtLongName
    , CAST(ISNULL(A.F_MatchComment3,0) AS INT)
    , case when a.F_MatchStatusID >100 then 1 else 0 end AS IsOfficial
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    LEFT JOIN TC_Court_Des AS D ON D.F_CourtID = A.F_CourtID AND D.F_LanguageCode = @LanguageCode
    WHERE (@PhaseCode = '-1' OR B.F_PhaseCode = @PhaseCode) AND C.F_EventID = @EventID
    ORDER BY A.F_MatchID

	----Player A
    UPDATE #Tmp_Table SET F_APrintLN = W.F_PrintLongName, F_ARegisterCode = Y.F_RegisterCode, F_ANOC = Z.F_DelegationCode, 
    F_APrintSN = W.F_PrintShortName, F_AIFRank =  TRI.F_InscriptionRank, F_ASeed = CAST( TRI.F_Seed AS NVARCHAR(20))
    ,F_ABackNumber = TRI.F_InscriptionNum, F_AQRank = TRI.F_InscriptionRank, F_AScore = TRI.F_InscriptionResult,F_ARecord = '',F_ARank = X.F_Rank
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
    LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
    LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = @EventID
    LEFT JOIN TS_Phase AS P ON P.F_PhaseID = A.F_MatchID
    WHERE X.F_CompetitionPositionDes1 = 1 --AND F_AMatchFrom IS NULL 

	----Player B
    UPDATE #Tmp_Table SET F_BPrintLN = W.F_PrintLongName, F_BRegisterCode = Y.F_RegisterCode, F_BNOC = Z.F_DelegationCode, 
    F_BPrintSN = W.F_PrintShortName, F_BIFRank = TRI.F_InscriptionRank, F_BSeed = CAST( TRI.F_Seed AS NVARCHAR(20))
    ,F_BBackNumber = TRI.F_InscriptionNum, F_BQRank = TRI.F_InscriptionRank, F_BScore = TRI.F_InscriptionResult ,F_BRecord = '',F_BRank = X.F_Rank
    FROM #Tmp_Table AS A 
    LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
    LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
    LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = @EventID
    WHERE X.F_CompetitionPositionDes1 = 2 --AND F_BMatchFrom IS NULL

    UPDATE #Tmp_Table SET F_APrintLN = '-轮空-' WHERE F_APlayerID = -1
    UPDATE #Tmp_Table SET F_BPrintLN = '-轮空-' WHERE F_BPlayerID = -1
    UPDATE #Tmp_Table SET F_ACourtMatch = F_AMatchFromCourt + ', ' + F_AMatchFrom
    UPDATE #Tmp_Table SET F_BCourtMatch = F_BMatchFromCourt + ', ' + F_BMatchFrom
    UPDATE #Tmp_Table SET F_MatchCourtNo = F_MatchCourt + ', ' + F_MatchDes
    
    UPDATE #Tmp_Table SET F_ASeed = F_ASeed  WHERE F_ASeed IS NOT NULL AND F_ASeed <> '0'
    UPDATE #Tmp_Table SET F_BSeed = F_BSeed  WHERE F_BSeed IS NOT NULL AND F_BSeed <> '0'
	
	UPDATE #Tmp_Table SET F_APoint = (CASE WHEN A.F_IsSetPoints =0 THEN CAST(B.F_Points AS VARCHAR) ELSE CAST(B.F_RealScore AS VARCHAR) END ) 
	FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
	UPDATE #Tmp_Table SET F_BPoint = (CASE WHEN A.F_IsSetPoints =0 THEN  CAST(B.F_Points AS VARCHAR) ELSE CAST(B.F_RealScore AS VARCHAR) END ) 
	FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2
	   
	UPDATE #Tmp_Table SET F_APointDes =  dbo.Fun_AR_GetSetPointDesString(A.F_MatchID,1) 
	FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
	UPDATE #Tmp_Table SET F_BPointDes = dbo.Fun_AR_GetSetPointDesString(A.F_MatchID,2)
	FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2
	
	UPDATE A SET A.F_ASourceMatchID = B.F_SourceMatchID FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
	UPDATE A SET A.F_BSourceMatchID = B.F_SourceMatchID FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2
	UPDATE #Tmp_Table SET F_CurPointDes = DBO.Fun_AR_GetSetPointDesString(F_MatchID, 2)

	UPDATE #Tmp_Table SET F_AMembers1 = RD.F_PrintLongName,F_AMembers1No = MR.F_Comment FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_APlayerID AND RM.F_Order = 1
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID 
	UPDATE #Tmp_Table SET F_AMembers2 = RD.F_PrintLongName,F_AMembers2No = MR.F_Comment  FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_APlayerID AND RM.F_Order = 2
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID 
	UPDATE #Tmp_Table SET F_AMembers3 = RD.F_PrintLongName,F_AMembers3No = MR.F_Comment  FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_APlayerID AND RM.F_Order = 3
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID 
	
	UPDATE #Tmp_Table SET F_BMembers1 = RD.F_PrintLongName,F_BMembers1No = MR.F_Comment  FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_BPlayerID AND RM.F_Order = 1
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID 
	UPDATE #Tmp_Table SET F_BMembers2 = RD.F_PrintLongName,F_BMembers2No = MR.F_Comment  FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_BPlayerID AND RM.F_Order = 2
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID 
	UPDATE #Tmp_Table SET F_BMembers3 = RD.F_PrintLongName,F_BMembers3No = MR.F_Comment  FROM #Tmp_Table AS A 
		LEFT JOIN TR_Register_Member AS RM ON RM.F_RegisterID = A.F_BPlayerID AND RM.F_Order = 3
		LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RM.F_MemberRegisterID AND RD.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Match_Result AS MR ON MR.F_RegisterID = RM.F_MemberRegisterID 
		
	UPDATE #Tmp_Table SET F_WinnerPrintLN = W.F_PrintLongName, F_WinnerRegisterCode = Y.F_RegisterCode, F_WinnerNOC = Z.F_DelegationCode
	                     , F_WinnerSeed = CAST(I.F_Seed AS NVARCHAR(20))
    FROM #Tmp_Table AS A 
    LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID AND X.F_Rank = 1
    LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
    LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Inscription AS I ON Y.F_RegisterID = I.F_RegisterID AND I.F_EventID = @EventID

    UPDATE #Tmp_Table SET F_WinnerSeed = '(' + F_WinnerSeed + ')' WHERE F_WinnerSeed IS NOT NULL AND F_WinnerSeed <> '0'
	SELECT  *  FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO


/*
exec Proc_Report_AR_GetTeamStartBrackets 3,'4','CHN'
*/