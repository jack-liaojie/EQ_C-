IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetDrawSheet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetDrawSheet]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_BD_GetDrawSheet]
--描    述：得到Event下的一个Round下的Match信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月22日
--修	改：管仁良 2010.10.12 （添加了F_PhaseID到输出中，如果@PhaseRound == -1，返回所有Match信息）



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetDrawSheet](
                       @EventID         INT,
                       @PhaseRound      INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
							F_PhaseID		   INT,
                            F_MatchID          INT,
                            F_APlayerID        INT,
                            F_APos             INT,
                            F_APrintLN         NVARCHAR(200),
                            F_ARegisterCode    NVARCHAR(20),
                            F_ANOC             NVARCHAR(30),
                            F_AMatchFrom       NVARCHAR(10),
                            F_AMatchFromCourt  NVARCHAR(200),
                            F_AMatchFromDate   NVARCHAR(20),
                            F_BPlayerID        INT,
                            F_BPos             INT,
                            F_BPrintLN         NVARCHAR(200),
                            F_BRegisterCode    NVARCHAR(20),
                            F_BNOC             NVARCHAR(30),
                            F_BMatchFrom       NVARCHAR(10),
                            F_BMatchFromCourt  NVARCHAR(200),
                            F_BMatchFromDate   NVARCHAR(20),
                            F_MatchDes         NVARCHAR(10),
                            F_MatchCourt       NVARCHAR(200),
                            F_MatchDate        NVARCHAR(20),
                            F_ACourtMatch      NVARCHAR(200),
                            F_BCourtMatch      NVARCHAR(200),
                            F_MatchCourtNo     NVARCHAR(200),
                            F_NumberA          INT,
                            F_NumberB          INT,
                            F_PrintLongNameA   NVARCHAR(200),
                            F_PrintLongNameB   NVARCHAR(200),
                            F_SeedNumA         NVARCHAR(20),                             
                            F_SeedNumB         NVARCHAR(20)                             
							)

    DECLARE @EventName NVARCHAR(10)
    SELECT @EventName = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = @LanguageCode

    INSERT INTO #Tmp_Table(F_PhaseID, F_MatchID, 
							F_APlayerID, F_APos, F_AMatchFrom, F_AMatchFromCourt, F_AMatchFromDate, 
							F_BPlayerID, F_BPos, F_BMatchFrom, F_BMatchFromCourt, F_BMatchFromDate, 
							F_MatchDes, F_MatchCourt, F_MatchDate, F_NumberA, F_NumberB)
    SELECT A.F_PhaseID, A.F_MatchID
    -- PlayerA
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 1)
    ,ISNULL( dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 1), 0)
    ,(SELECT @EventName + X.F_RaceNum FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
    ,(SELECT [dbo].[Fun_Report_BD_GetDateTime](X.F_MatchDate, 12) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](X.F_StartTime, 3) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 1 AND Y.F_MatchID = A.F_MatchID)
    -- PalyerB
    ,(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID = A.F_MatchID AND F_CompetitionPositionDes1 = 2)
    ,ISNULL( dbo.Fun_BD_GetPlayerDrawPos(A.F_MatchID, 2), 0)
    ,(SELECT @EventName + X.F_RaceNum FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
    ,(SELECT Z.F_CourtShortName FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID LEFT JOIN TC_Court_Des AS Z ON X.F_CourtID = Z.F_CourtID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID AND Z.F_LanguageCode = @LanguageCode)
    ,(SELECT [dbo].[Fun_Report_BD_GetDateTime](X.F_MatchDate, 12) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](X.F_StartTime, 3) FROM TS_Match AS X LEFT JOIN TS_Match_Result AS Y ON X.F_MatchID = Y.F_SourceMatchID WHERE Y.F_CompetitionPositionDes1 = 2 AND Y.F_MatchID = A.F_MatchID)
    -- MatchDes
    ,@EventName + A.F_RaceNum
    ,(SELECT F_CourtShortName FROM TC_Court_Des WHERE F_CourtID = A.F_CourtID AND F_LanguageCode = @LanguageCode)
    ,([dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 12) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3))
    , ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2 - 1
    , ROW_NUMBER() OVER (ORDER BY A.F_MatchID) * 2
    FROM TS_Match AS A
    LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
    WHERE B.F_Order = (CASE WHEN @PhaseRound=-1 THEN B.F_Order ELSE @PhaseRound END) AND C.F_EventID = @EventID ORDER BY B.F_Order, A.F_Order
	
	-- PlayerA Des
    UPDATE #Tmp_Table SET F_APrintLN = W.F_PrintShortName,F_PrintLongNameA= W.F_PrintLongName, 
			F_ARegisterCode = Y.F_RegisterCode, F_ANOC = dbo.Fun_BDTT_GetPlayerNOCName(Y.F_RegisterID), 
			F_SeedNumA = CONVERT(NVARCHAR(20), H.F_Seed)
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
    LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
    LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Inscription AS H ON H.F_RegisterID = Y.F_RegisterID
    WHERE X.F_CompetitionPositionDes1 = 1 --AND F_AMatchFrom IS NULL

	-- PlayerB Des
    UPDATE #Tmp_Table SET F_BPrintLN = W.F_PrintShortName, F_PrintLongNameB = W.F_PrintLongName, F_BRegisterCode = Y.F_RegisterCode, 
			F_BNOC = dbo.Fun_BDTT_GetPlayerNOCName(Y.F_RegisterID),F_SeedNumB = CONVERT(NVARCHAR(20), H.F_Seed)
    FROM #Tmp_Table AS A LEFT JOIN TS_Match_Result AS X ON A.F_MatchID = X.F_MatchID
    LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID
    LEFT JOIN TR_Inscription AS H ON H.F_RegisterID = Y.F_RegisterID
    LEFT JOIN TR_Register_Des AS W ON X.F_RegisterID = W.F_RegisterID AND W.F_LanguageCode = @LanguageCode
    WHERE X.F_CompetitionPositionDes1 = 2 --AND F_BMatchFrom IS NULL

    UPDATE #Tmp_Table SET F_APrintLN = 'BYE', F_PrintLongNameA = 'BYE' WHERE F_APlayerID = -1
    UPDATE #Tmp_Table SET F_BPrintLN = 'BYE', F_PrintLongNameB = 'BYE' WHERE F_BPlayerID = -1
    UPDATE #Tmp_Table SET F_ACourtMatch = F_AMatchFromCourt + ', ' + F_AMatchFrom
    UPDATE #Tmp_Table SET F_BCourtMatch = F_BMatchFromCourt + ', ' + F_BMatchFrom
    UPDATE #Tmp_Table SET F_MatchCourtNo = F_MatchCourt + ', ' + F_MatchDes

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF



GO

