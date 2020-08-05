IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetMatchResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetMatchResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_Report_AR_GetMatchResults]
--描    述: 射箭项目,获取某人局信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月11日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetMatchResults]
	@MatchID				INT,
	@LanguageCode			CHAR(3) = Null
AS
BEGIN
SET NOCOUNT ON
		
	if @LanguageCode = null
	begin
	 set @LanguageCode = @LanguageCode
	 END
	
		CREATE TABLE #Tmp_Table(
                            F_MatchID          INT,
                            F_PhaseID          INT,
                            F_EventID          INT,
                            F_APlayerID        INT,
                            F_APos             INT,
                            F_APrintLN         NVARCHAR(100),
                            F_APrintSN         NVARCHAR(50),
                            F_AIFRank          INT,
                            F_ASeed            NVARCHAR(20),
                            F_ARegisterCode    NVARCHAR(20),
                            F_ANOC             NVARCHAR(30),
                            F_AMatchFrom       NVARCHAR(30),
                            F_AMatchFromCourt  NVARCHAR(100),
                            F_AMatchFromDate   NVARCHAR(50),
                            F_BPlayerID        INT,
                            F_BPos             INT,
                            F_BPrintLN         NVARCHAR(100),
                            F_BPrintSN         NVARCHAR(50),
                            F_BIFRank          INT,
                            F_BSeed            NVARCHAR(20),
                            F_BRegisterCode    NVARCHAR(20),
                            F_BNOC             NVARCHAR(30),
                            F_BMatchFrom       NVARCHAR(30),
                            F_BMatchFromCourt  NVARCHAR(100),
                            F_BMatchFromDate   NVARCHAR(50),
                            F_MatchDes         NVARCHAR(30),
                            F_MatchCourt       NVARCHAR(100),
                            F_MatchDate        NVARCHAR(50),
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
                            F_WinnerRegisterCode    NVARCHAR(30),
                            F_WinnerNOC             NVARCHAR(30),
                            F_WinnerSeed            NVARCHAR(20),
                            F_PhaseCode             NVARCHAR(10),
                            
                            F_ABackNumber				INT,
                            F_BBackNumber				INT,
                            F_AQRank					INT,
                            F_BQRank					INT,
                            F_AScore					INT,
                            F_BScore					INT,
							F_MatchNo				NVARCHAR(100),
							F_StartDate				NVARCHAR(100),
							F_StartTime				NVARCHAR(100),
							F_Court					NVARCHAR(100),
							F_ARecord				NVARCHAR(100),
							F_BRecord				NVARCHAR(100),
							F_ATarget				NVARCHAR(100),
							F_BTarget				NVARCHAR(100),
							F_A10Num				NVARCHAR(20),
							F_B10Num				NVARCHAR(20),
							F_AXNum					NVARCHAR(20),
							F_BXNum					NVARCHAR(20),
							F_AComment				NVARCHAR(100),
							F_BComment				NVARCHAR(100),
							F_IsSetPoints			INT,
							F_ArrowsCoount			INT,
							)

		INSERT INTO #Tmp_Table(F_MatchID,F_PhaseID,F_EventID, F_APlayerID, F_APos, F_AMatchFrom, F_AMatchFromCourt, F_AMatchFromDate, F_BPlayerID, F_BPos, 
		F_BMatchFrom, F_BMatchFromCourt, F_BMatchFromDate, F_MatchDes, F_MatchCourt, F_MatchDate, F_NumberA, F_NumberB, F_PhaseCode
		,F_MatchNo,F_StartDate,F_StartTime,F_Court,F_IsSetPoints,F_ArrowsCoount)
		SELECT A.F_MatchID,b.F_PhaseID,c.F_EventID
		,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
		,(SELECT F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
		,(SELECT  CAST(X.F_RaceNum AS NVARCHAR(10)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
		,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
		,(SELECT [dbo].[Func_Report_TE_GetDateTime](X.F_MatchDate, 7, @LanguageCode) + ' ' + [dbo].[Func_Report_TE_GetDateTime](X.F_StartTime, 4, @LanguageCode) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
		,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
		,(SELECT F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
		,(SELECT  CAST(X.F_RaceNum AS NVARCHAR(10)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
		,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
		,(SELECT [dbo].[Fun_AR_GetDateTime](X.F_MatchDate, 7, @LanguageCode) + ' ' + [dbo].[Fun_AR_GetDateTime](X.F_StartTime, 3, @LanguageCode) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
		, CAST(A.F_RaceNum AS NVARCHAR(10))
		,(SELECT F_CourtShortName FROM TC_Court_Des WHERE F_CourtID = A.F_CourtID AND F_LanguageCode = @LanguageCode)
		,([dbo].[Fun_AR_GetDateTime](A.F_MatchDate, 7, @LanguageCode) + ' ' + [dbo].[Fun_AR_GetDateTime](A.F_StartTime, 4, @LanguageCode))
		, ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2 - 1
		, ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2
		, B.F_PhaseCode
		, CASE WHEN A.F_RaceNum IS NULL THEN ''
			   WHEN @LanguageCode ='CHN' THEN '比赛编码. '+ A.F_RaceNum 
			   ELSE  'Match No. '+ A.F_RaceNum END  AS F_MatchNo
		, DBO.Fun_AR_GetDateTime(A.F_MatchDate, 7,@LanguageCode) + ' - '+DBO.Fun_AR_GetDateTime(A.F_StartTime, 4,@LanguageCode) AS F_StartDate
		, DBO.Fun_AR_GetDateTime(A.F_StartTime, 4,@LanguageCode) AS F_StartTime
		, D.F_CourtLongName
		, CAST(ISNULL(A.F_MatchComment3,0) AS INT)
		, CAST(ISNULL(A.F_MatchComment1,0) AS INT)* CAST(ISNULL(A.F_MatchComment2,0) AS INT) 
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
		LEFT JOIN TC_Court_Des AS D ON D.F_CourtID = A.F_CourtID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_MatchID = @MatchID
		ORDER BY A.F_MatchID

		----Player A
		UPDATE #Tmp_Table SET F_APrintLN = W.F_PrintLongName, F_ARegisterCode = Y.F_RegisterCode, F_ANOC = Z.F_DelegationShortName, 
		F_APrintSN = W.F_PrintShortName, F_AIFRank = X.F_Rank , F_ASeed = CAST( TRI.F_Seed AS NVARCHAR(20))
		,F_ABackNumber = TRI.F_InscriptionNum, F_AQRank = QR.F_Rank, F_AScore = X.F_Points,F_ARecord = '',
		F_ATarget = X.F_Comment,F_A10Num = X.F_WinPoints,F_AXNum = X.F_LosePoints,
		F_AComment = CASE WHEN X.F_IRMID IS NOT NULL THEN IRM.F_IRMCODE 
						  WHEN X.F_Rank = 1 AND @LanguageCode ='CHN' THEN '胜者' 
						  WHEN X.F_Rank = 1 AND @LanguageCode ='ENG' THEN 'Winner' ELSE NULL END
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_DES AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = A.F_EventID
		LEFT JOIN TS_Phase AS QP ON QP.F_EventID = A.F_EventID AND QP.F_PhaseCode IN ( 'A','B','C','D')
		LEFT JOIN TS_Match AS QM ON QM.F_PhaseID = QP.F_PhaseID AND QM.F_MatchCode = 'QR'
		LEFT JOIN TS_Match_Result AS QR ON QR.F_RegisterID = X.F_RegisterID AND QR.F_MatchID = QM.F_MatchID
		LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = X.F_IRMID 
		WHERE X.F_CompetitionPositionDes1 = 1 --AND F_AMatchFrom IS NULL 

		----Player B
		UPDATE #Tmp_Table SET F_BPrintLN = W.F_PrintLongName, F_BRegisterCode = Y.F_RegisterCode, F_BNOC = Z.F_DelegationShortName, 
		F_BPrintSN = W.F_PrintShortName, F_BIFRank =  X.F_Rank , F_BSeed = CAST( TRI.F_Seed AS NVARCHAR(20))
		,F_BBackNumber = TRI.F_InscriptionNum, F_BQRank = QR.F_Rank, F_BScore = X.F_Points ,F_BRecord = '',
		F_BTarget = X.F_Comment,F_B10Num = X.F_WinPoints,F_BXNum = X.F_LosePoints,
		F_BComment = CASE WHEN X.F_IRMID IS NOT NULL THEN IRM.F_IRMCODE 
						  WHEN X.F_Rank = 1 AND @LanguageCode ='CHN' THEN '胜者' 
						  WHEN X.F_Rank = 1 AND @LanguageCode ='ENG' THEN 'Winner' ELSE NULL END
		FROM #Tmp_Table AS A 
		LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_DES AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = A.F_EventID
		LEFT JOIN TS_Phase AS P ON P.F_EventID = A.F_EventID AND P.F_PhaseCode IN ( 'A','B','C','D')
		LEFT JOIN TS_Match AS M ON M.F_PhaseID = P.F_PhaseID AND M.F_MatchCode = 'QR'
		LEFT JOIN TS_Match_Result AS QR ON QR.F_RegisterID = X.F_RegisterID AND QR.F_MatchID = M.F_MatchID
		LEFT JOIN TC_IRM AS IRM ON IRM.F_IRMID = X.F_IRMID 
		WHERE X.F_CompetitionPositionDes1 = 2 --AND F_BMatchFrom IS NULL

		UPDATE #Tmp_Table SET F_APrintLN = N'-BYE-',F_APrintSN = N'-BYE-'  WHERE F_APlayerID = -1
		UPDATE #Tmp_Table SET F_BPrintLN = N'-BYE-',F_BPrintSN = N'-BYE-'  WHERE F_BPlayerID = -1
		UPDATE #Tmp_Table SET F_ACourtMatch = F_AMatchFromCourt + ', ' + F_AMatchFrom
		UPDATE #Tmp_Table SET F_BCourtMatch = F_BMatchFromCourt + ', ' + F_BMatchFrom
		UPDATE #Tmp_Table SET F_MatchCourtNo = F_MatchCourt + ', ' + F_MatchDes
	    
		UPDATE #Tmp_Table SET F_ASeed = F_ASeed WHERE F_ASeed IS NOT NULL AND F_ASeed <> '0'
		UPDATE #Tmp_Table SET F_BSeed = F_BSeed WHERE F_BSeed IS NOT NULL AND F_BSeed <> '0'
		
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
		UPDATE #Tmp_Table SET F_CurPointDes = DBO.[Fun_AR_GetSetPointDesString](F_MatchID, 2)

		UPDATE #Tmp_Table SET F_WinnerPrintLN = W.F_PrintLongName, F_WinnerRegisterCode = Y.F_RegisterCode, F_WinnerNOC = Z.F_DelegationCode
							 , F_WinnerSeed = CAST(I.F_Seed AS NVARCHAR(20))
		FROM #Tmp_Table AS A 
		LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID AND X.F_Rank = 1
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS I ON Y.F_RegisterID = I.F_RegisterID AND I.F_EventID = A.F_EventID

		UPDATE #Tmp_Table SET F_WinnerSeed = '(' + F_WinnerSeed + ')' WHERE F_WinnerSeed IS NOT NULL AND F_WinnerSeed <> '0'
		SELECT  *  FROM #Tmp_Table

SET NOCOUNT OFF
END

GO

/*
exec Proc_Report_AR_GetMatchResults 1,'CHN'
*/
