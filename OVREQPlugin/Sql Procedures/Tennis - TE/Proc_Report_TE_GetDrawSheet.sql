/****** Object:  StoredProcedure [dbo].[Proc_Report_TE_GetDrawSheet]    Script Date: 02/18/2011 17:56:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetDrawSheet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetDrawSheet]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_TE_GetDrawSheet]    Script Date: 02/18/2011 17:56:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO











--名    称：[Proc_Report_TE_GetDrawSheet]
--描    述：得到Event下的一个Round下的Match信息
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2010年10月21日


CREATE PROCEDURE [dbo].[Proc_Report_TE_GetDrawSheet](
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
                            F_ANOC             NVARCHAR(100),
                            F_AMatchFrom       NVARCHAR(10),
                            F_AMatchFromCourt  NVARCHAR(100),
                            F_AMatchFromDate   NVARCHAR(50),
                            F_BPlayerID        INT,
                            F_BPos             INT,
                            F_BPrintLN         NVARCHAR(100),
                            F_BPrintSN         NVARCHAR(50),
                            F_BIFRank          INT,
                            F_BSeed            NVARCHAR(20),
                            F_BRegisterCode    NVARCHAR(20),
                            F_BNOC             NVARCHAR(100),
                            F_BMatchFrom       NVARCHAR(10),
                            F_BMatchFromCourt  NVARCHAR(100),
                            F_BMatchFromDate   NVARCHAR(50),
                            F_MatchDes         NVARCHAR(10),
                            F_MatchCourt       NVARCHAR(100),
                            F_MatchDate        NVARCHAR(20),
                            F_ACourtMatch      NVARCHAR(100),
                            F_BCourtMatch      NVARCHAR(100),
                            F_MatchCourtNo     NVARCHAR(100),
                            F_NumberA          INT,
                            F_NumberB          INT,
                            F_InscripNumA      INT,
                            F_InscripNumB      INT,
                            F_ASourceMatchID   INT,
                            F_BSourceMatchID   INT,
                            F_APointDes		   NVARCHAR(100),
                            F_BPointDes		   NVARCHAR(100),
                            F_CurPointDes	   NVARCHAR(100),
                            F_WinnerPrintLN         NVARCHAR(100),
                            F_WinnerRegisterCode    NVARCHAR(20),
                            F_WinnerNOC             NVARCHAR(100),
                            F_WinnerSeed            NVARCHAR(20),
                            F_PhaseCode             NVARCHAR(10),
							)

    DECLARE @EventName NVARCHAR(10)
    SELECT @EventName = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode

    INSERT INTO #Tmp_Table(F_MatchID, F_APlayerID, F_APos, F_AMatchFrom, F_AMatchFromCourt, F_AMatchFromDate, F_BPlayerID, F_BPos, F_BMatchFrom, F_BMatchFromCourt, F_BMatchFromDate, F_MatchDes, F_MatchCourt, F_MatchDate, F_NumberA, F_NumberB,F_PhaseCode)
    SELECT A.F_MatchID
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
    ,(SELECT F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPosition = 1)
    ,(SELECT @EventName + CAST(X.F_RaceNum AS NVARCHAR(10)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
    ,(SELECT [dbo].[Func_Report_TE_GetDateTime](X.F_MatchDate, 7, @LanguageCode) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
    ,(SELECT F_StartPhasePosition FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPosition = 2)
    ,(SELECT @EventName + CAST(X.F_RaceNum AS NVARCHAR(10)) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
    ,(SELECT [dbo].[Func_Report_TE_GetDateTime](X.F_MatchDate, 7, @LanguageCode) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
    ,@EventName + CAST(A.F_RaceNum AS NVARCHAR(10))
    ,(SELECT F_CourtShortName FROM TC_Court_Des WHERE F_CourtID = A.F_CourtID AND F_LanguageCode = @LanguageCode)
    ,([dbo].[Func_Report_TE_GetDateTime](A.F_MatchDate,7, @LanguageCode) )
    , ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2 - 1
    , ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2
    , B.F_PhaseCode
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    WHERE (@PhaseCode = '-1' OR B.F_PhaseCode = @PhaseCode) AND C.F_EventID = @EventID
    ORDER BY A.F_MatchID

     CREATE TABLE #Temp_PlayerSource(
                                        F_MatchID                   INT,
                                        F_CompetitionPosition       INT,
                                        F_CompetitionPositionDes1   INT,
                                        F_MatchName				    NVARCHAR(150),
                                        F_RegisterID                INT,
                                        F_RegisterName              NVARCHAR(100),
                                        F_StartPhaseID			    INT,
										F_StartPhaseName		    NVARCHAR(100),
										F_StartPhasePosition	    INT,
										F_SourcePhaseID			    INT,
										F_SourcePhaseName		    NVARCHAR(100),
										F_SourcePhaseRank		    INT,
										F_SourceMatchPhaseID	    INT,
										F_SourceMatchPhaseName	    NVARCHAR(100),
										F_SourceMatchID			    INT,
										F_SourceMatchOrder		    INT,
										F_SourceMatchName		    NVARCHAR(100),
										F_SourceMatchRank		    INT,
                                        )

        INSERT INTO #Temp_PlayerSource (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_RegisterID,
		F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_MatchName)
		SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_RegisterID, A.F_StartPhaseID,
        A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, C.F_MatchLongName
        FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
        LEFT JOIN TS_Match_Des AS C ON B.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
        LEFT JOIN TS_Event AS E ON D.F_EventID = E.F_EventID
        LEFT JOIN TS_DisciplineDate AS F ON B.F_MatchDate = F.F_Date
         WHERE (@PhaseCode = '-1' OR D.F_PhaseCode = @PhaseCode) AND E.F_EventID = @EventID
               ORDER BY A.F_MatchID

        UPDATE #Temp_PlayerSource SET F_StartPhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourcePhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #Temp_PlayerSource AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourceMatchName = F_SourceMatchPhaseName + ' Match' + CAST (F_SourceMatchOrder AS NVARCHAR(10)) WHERE @LanguageCode = 'ENG'
        UPDATE #Temp_PlayerSource SET F_SourceMatchName = F_SourceMatchPhaseName + ' 第' + CAST (F_SourceMatchOrder AS NVARCHAR(10)) + '场' WHERE @LanguageCode = 'CHN'

		UPDATE #Temp_PlayerSource SET F_RegisterName = B.F_LongName FROM #Temp_PlayerSource AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' Rank ' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' Rank ' + CAST(F_SourceMatchRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
        
        UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' 签位' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourcePhaseName)) + ' 第' + CAST(F_SourcePhaseRank AS NVARCHAR(100)) + '名' WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_SourceMatchName)) + ' 第' + CAST(F_SourceMatchRank AS NVARCHAR(100)) + '名' WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
 
 
		UPDATE #Tmp_Table SET F_APrintLN = W.F_PrintLongName, F_ARegisterCode = Y.F_RegisterCode, F_ANOC = Z.F_DelegationShortName, F_APrintSN = W.F_PrintShortName
		   , F_AIFRank =  TRI.F_InscriptionRank, F_ASeed = CAST( TRI.F_Seed AS NVARCHAR(20)), F_InscripNumA = TRI.F_InscriptionNum
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = @EventID
		WHERE X.F_CompetitionPositionDes1 = 1 --AND F_AMatchFrom IS NULL 

		UPDATE #Tmp_Table SET F_BPrintLN = W.F_PrintLongName, F_BRegisterCode = Y.F_RegisterCode, F_BNOC = Z.F_DelegationShortName, F_BPrintSN = W.F_PrintShortName
			  , F_BIFRank = TRI.F_InscriptionRank, F_BSeed = CAST( TRI.F_Seed AS NVARCHAR(20)), F_InscripNumB = TRI.F_InscriptionNum
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS TRI ON Y.F_RegisterID = TRI.F_RegisterID AND TRI.F_EventID = @EventID
		WHERE X.F_CompetitionPositionDes1 = 2 --AND F_BMatchFrom IS NULL

		UPDATE #Tmp_Table SET F_APrintLN = CASE WHEN @LanguageCode = 'ENG' THEN 'BYE' ELSE '(轮空)' END WHERE F_APlayerID = -1
		UPDATE #Tmp_Table SET F_BPrintLN = CASE WHEN @LanguageCode = 'ENG' THEN 'BYE' ELSE '(轮空)' END WHERE F_BPlayerID = -1
		UPDATE #Tmp_Table SET F_ACourtMatch = F_AMatchFromCourt + ', ' + F_AMatchFrom
		UPDATE #Tmp_Table SET F_BCourtMatch = F_BMatchFromCourt + ', ' + F_BMatchFrom
		UPDATE #Tmp_Table SET F_MatchCourtNo = F_MatchCourt + ', ' + F_MatchDes
    
        UPDATE #Tmp_Table SET F_APrintLN = B.F_RegisterName, F_APrintSN = B.F_RegisterName
            FROM #Tmp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
               WHERE B.F_CompetitionPositionDes1 = 1 AND A.F_APrintLN IS NULL AND A.F_ANOC IS NULL
               
        UPDATE #Tmp_Table SET F_BPrintLN = B.F_RegisterName, F_BPrintSN = B.F_RegisterName
            FROM #Tmp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
               WHERE B.F_CompetitionPositionDes1 = 2 AND A.F_BPrintLN IS NULL AND A.F_BNOC IS NULL
        
		UPDATE #Tmp_Table SET F_ASeed = '(' + F_ASeed + ')' WHERE F_ASeed IS NOT NULL AND F_ASeed <> '0'
		UPDATE #Tmp_Table SET F_BSeed = '(' + F_BSeed + ')' WHERE F_BSeed IS NOT NULL AND F_BSeed <> '0'

	    
		UPDATE A SET A.F_ASourceMatchID = B.F_SourceMatchID FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
		UPDATE A SET A.F_BSourceMatchID = B.F_SourceMatchID FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2
		UPDATE #Tmp_Table SET F_APointDes = DBO.[Fun_TE_GetMatchSplitsPointsDes](F_ASourceMatchID, 2,0)
		, F_BPointDes = DBO.[Fun_TE_GetMatchSplitsPointsDes](F_BSourceMatchID, 2, 0)
		, F_CurPointDes = DBO.[Fun_TE_GetMatchSplitsPointsDes](F_MatchID, 2, 0)

		UPDATE #Tmp_Table SET F_WinnerPrintLN = W.F_PrintLongName, F_WinnerRegisterCode = Y.F_RegisterCode, F_WinnerNOC = Z.F_DelegationShortName
							 , F_WinnerSeed = CAST(I.F_Seed AS NVARCHAR(20))
		FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID AND X.F_Rank = 1
		LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
		LEFT JOIN TC_Delegation_Des AS Z ON Y.F_DelegationID = Z.F_DelegationID AND Z.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
		LEFT JOIN TR_Inscription AS I ON Y.F_RegisterID = I.F_RegisterID AND I.F_EventID = @EventID

		UPDATE #Tmp_Table SET F_WinnerSeed = '(' + F_WinnerSeed + ')' WHERE F_WinnerSeed IS NOT NULL AND F_WinnerSeed <> '0'
		SELECT  *  FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


--exec [Proc_Report_TE_GetDrawSheet] 1, 'A', 'chn'