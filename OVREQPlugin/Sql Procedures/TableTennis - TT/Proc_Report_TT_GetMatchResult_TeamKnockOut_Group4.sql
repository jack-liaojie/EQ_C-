
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TT_GetMatchResult_TeamKnockOut_Group4]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TT_GetMatchResult_TeamKnockOut_Group4]
GO



SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_Report_TT_GetMatchResult_TeamKnockOut_Group4]
--描    述：得到Event下淘汰赛成绩
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年06月08日


CREATE PROCEDURE [dbo].[Proc_Report_TT_GetMatchResult_TeamKnockOut_Group4](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                            F_MatchDateQF1          NVARCHAR(20),
                            F_MatchCourtQF1         NVARCHAR(100),
                            F_MatchNumQF1           NVARCHAR(10),
                            F_MatchQF1Home          NVARCHAR(110),
                            F_MatchQF1Away          NVARCHAR(110),
                            F_MatchQF1Result        NVARCHAR(100),
                            F_MatchQF1ResultDes     NVARCHAR(150),
                            F_MatchDateQF2          NVARCHAR(20),
                            F_MatchCourtQF2         NVARCHAR(100),
                            F_MatchNumQF2           NVARCHAR(10),
                            F_MatchQF2Home          NVARCHAR(110),
                            F_MatchQF2Away          NVARCHAR(110),
                            F_MatchQF2Result        NVARCHAR(100),
                            F_MatchQF2ResultDes     NVARCHAR(150),
                            F_MatchDateQF3          NVARCHAR(20),
                            F_MatchCourtQF3         NVARCHAR(100),
                            F_MatchNumQF3           NVARCHAR(10),
                            F_MatchQF3Home          NVARCHAR(110),
                            F_MatchQF3Away          NVARCHAR(110),
                            F_MatchQF3Result        NVARCHAR(100),
                            F_MatchQF3ResultDes     NVARCHAR(150),
                            F_MatchDateQF4          NVARCHAR(20),
                            F_MatchCourtQF4         NVARCHAR(100),
                            F_MatchNumQF4           NVARCHAR(10),
                            F_MatchQF4Home          NVARCHAR(110),
                            F_MatchQF4Away          NVARCHAR(110),
                            F_MatchQF4Result        NVARCHAR(100),
                            F_MatchQF4ResultDes     NVARCHAR(150),
                            F_MatchDateSF1          NVARCHAR(20),
                            F_MatchCourtSF1         NVARCHAR(100),
                            F_MatchNumSF1           NVARCHAR(10),
                            F_MatchSF1Home          NVARCHAR(110),
                            F_MatchSF1Away          NVARCHAR(110),
                            F_MatchSF1Result        NVARCHAR(100),
                            F_MatchSF1ResultDes     NVARCHAR(150),
                            F_MatchDateSF2          NVARCHAR(20),
                            F_MatchCourtSF2         NVARCHAR(100),
                            F_MatchNumSF2           NVARCHAR(10),
                            F_MatchSF2Home          NVARCHAR(110),
                            F_MatchSF2Away          NVARCHAR(110),
                            F_MatchSF2Result        NVARCHAR(100),
                            F_MatchSF2ResultDes     NVARCHAR(150),
                            F_MatchDateF1          NVARCHAR(20),
                            F_MatchCourtF1         NVARCHAR(100),
                            F_MatchNumF1           NVARCHAR(10),
                            F_MatchF1Home          NVARCHAR(110),
                            F_MatchF1Away          NVARCHAR(110),
                            F_MatchF1Result        NVARCHAR(100),
                            F_MatchF1ResultDes     NVARCHAR(150),
                            F_Winner              NVARCHAR(100)
							)


    DECLARE @EventCode NVARCHAR(10)
    DECLARE @PhaseIDQF INT
    DECLARE @PhaseIDSF INT
    DECLARE @PhaseIDF INT

    SELECT @PhaseIDQF = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 1 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @PhaseIDSF = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 2 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @PhaseIDF = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 3 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @EventCode = B.F_EventComment FROM TS_Phase AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
    WHERE A.F_PhaseID = @PhaseIDSF

    INSERT INTO #Tmp_Table(F_MatchDateQF1) VALUES(NULL)

    DECLARE @MatchIDQF1 INT
	DECLARE @MatchIDQF2 INT
	DECLARE @MatchIDQF3 INT
	DECLARE @MatchIDQF4 INT
    DECLARE @MatchIDSF1 INT
    DECLARE @MatchIDSF2 INT
    DECLARE @MatchIDF INT
    
    SELECT @MatchIDQF1 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDQF AND F_Order = 1
    SELECT @MatchIDQF2 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDQF AND F_Order = 2
    SELECT @MatchIDQF3 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDQF AND F_Order = 3
    SELECT @MatchIDQF4 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDQF AND F_Order = 4
    SELECT @MatchIDSF1 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDSF AND F_Order = 1
    SELECT @MatchIDSF2 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDSF AND F_Order = 2
    SELECT @MatchIDF = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseIDF AND F_Order = 1

    UPDATE #Tmp_Table SET F_MatchDateQF1 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtQF1 = B.F_CourtShortName, F_MatchNumQF1 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF1

    UPDATE #Tmp_Table SET F_MatchDateQF2 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtQF2 = B.F_CourtShortName, F_MatchNumQF2 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF2

    UPDATE #Tmp_Table SET F_MatchDateQF3 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtQF3 = B.F_CourtShortName, F_MatchNumQF3 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF3

    UPDATE #Tmp_Table SET F_MatchDateQF4 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtQF4 = B.F_CourtShortName, F_MatchNumQF4 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF4

    UPDATE #Tmp_Table SET F_MatchDateSF1 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtSF1 = B.F_CourtShortName, F_MatchNumSF1 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDSF1

    UPDATE #Tmp_Table SET F_MatchDateSF2 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtSF2 = B.F_CourtShortName, F_MatchNumSF2 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDSF2

    UPDATE #Tmp_Table SET F_MatchDateF1 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourtF1 = B.F_CourtShortName, F_MatchNumF1 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDF

    UPDATE #Tmp_Table SET F_MatchQF1Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF1 AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchQF1Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF1 AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_MatchQF2Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF2 AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchQF2Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF2 AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_MatchQF3Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF3 AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchQF3Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF3 AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_MatchQF4Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF4 AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchQF4Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDQF4 AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_MatchSF1Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDSF1 AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchSF1Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDSF1 AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_MatchSF2Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDSF2 AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchSF2Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDSF2 AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_MatchF1Home = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDF AND A.F_CompetitionPositionDes1 = 1
    UPDATE #Tmp_Table SET F_MatchF1Away = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDF AND A.F_CompetitionPositionDes1 = 2
    UPDATE #Tmp_Table SET F_Winner = B.F_PrintShortName FROM TS_Match_Result AS A LEFT JOIN TR_Register_Des AS B ON A.F_RegisterID = B.F_RegisterID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchIDF AND A.F_ResultID = 1

    UPDATE #Tmp_Table SET F_MatchQF1Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDQF1), F_MatchQF2Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDQF2), F_MatchQF3Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDQF3), 
    F_MatchQF4Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDQF4), F_MatchSF1Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDSF1), F_MatchSF2Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDSF2), 
    F_MatchF1Result = [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchIDF)

	
	    
    UPDATE #Tmp_Table SET F_MatchQF1Home = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF1 AND A.F_CompetitionPositionDes1 = 1)
    WHERE F_MatchQF1Home IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF1Away = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF1 AND A.F_CompetitionPositionDes1 = 2)
    WHERE F_MatchQF1Away IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF2Home = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF2 AND A.F_CompetitionPositionDes1 = 1)
    WHERE F_MatchQF2Home IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF2Away = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF2 AND A.F_CompetitionPositionDes1 = 2)
    WHERE F_MatchQF2Away IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF3Home = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF3 AND A.F_CompetitionPositionDes1 = 1)
    WHERE F_MatchQF3Home IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF3Away = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF3 AND A.F_CompetitionPositionDes1 = 2)
    WHERE F_MatchQF3Away IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF4Home = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF4 AND A.F_CompetitionPositionDes1 = 1)
    WHERE F_MatchQF4Home IS NULL AND @LanguageCode = 'ENG'
    
    UPDATE #Tmp_Table SET F_MatchQF4Away = 
    ( SELECT B.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), A.F_SourcePhaseRank) FROM TS_Match_Result AS A
		LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_SourcePhaseID AND B.F_LanguageCode = 'ENG'
		WHERE A.F_MatchID = @MatchIDQF4 AND A.F_CompetitionPositionDes1 = 2)
    WHERE F_MatchQF4Away IS NULL AND @LanguageCode = 'ENG'
    
    --UPDATE #Tmp_Table SET F_MatchQF1Away = 'Group B Rank 2' WHERE F_MatchQF1Away IS NULL AND @LanguageCode = 'ENG'
    --UPDATE #Tmp_Table SET F_MatchQF2Home = 'Group C Rank 1' WHERE F_MatchQF2Home IS NULL AND @LanguageCode = 'ENG'
   -- UPDATE #Tmp_Table SET F_MatchQF2Away = 'Group D Rank 2' WHERE F_MatchQF2Away IS NULL AND @LanguageCode = 'ENG'
    --UPDATE #Tmp_Table SET F_MatchQF3Home = 'Group B Rank 1' WHERE F_MatchQF3Home IS NULL AND @LanguageCode = 'ENG'
    --UPDATE #Tmp_Table SET F_MatchQF3Away = 'Group A Rank 2' WHERE F_MatchQF3Away IS NULL AND @LanguageCode = 'ENG'
    --UPDATE #Tmp_Table SET F_MatchQF4Home = 'Group D Rank 1' WHERE F_MatchQF4Home IS NULL AND @LanguageCode = 'ENG'
    --UPDATE #Tmp_Table SET F_MatchQF4Away = 'Group C Rank 2' WHERE F_MatchQF4Away IS NULL AND @LanguageCode = 'ENG'
    UPDATE #Tmp_Table SET F_MatchQF1Home = 'A组第一' WHERE F_MatchQF1Home IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF1Away = 'B组第二' WHERE F_MatchQF1Away IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF2Home = 'C组第一' WHERE F_MatchQF2Home IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF2Away = 'D组第二' WHERE F_MatchQF2Away IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF3Home = 'B组第一' WHERE F_MatchQF3Home IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF3Away = 'A组第二' WHERE F_MatchQF3Away IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF4Home = 'D组第一' WHERE F_MatchQF4Home IS NULL AND @LanguageCode = 'CHN'
    UPDATE #Tmp_Table SET F_MatchQF4Away = 'C组第二' WHERE F_MatchQF4Away IS NULL AND @LanguageCode = 'CHN'

    UPDATE #Tmp_Table SET F_MatchQF1ResultDes = (CASE WHEN F_MatchSF1Home IS NULL THEN (F_MatchCourtQF1 + ',' + F_MatchNumQF1) ELSE F_MatchQF1Result END)
    UPDATE #Tmp_Table SET F_MatchQF2ResultDes = (CASE WHEN F_MatchSF1Away IS NULL THEN (F_MatchCourtQF2 + ',' + F_MatchNumQF2) ELSE F_MatchQF2Result END)
    UPDATE #Tmp_Table SET F_MatchQF3ResultDes = (CASE WHEN F_MatchSF2Home IS NULL THEN (F_MatchCourtQF3 + ',' + F_MatchNumQF3) ELSE F_MatchQF3Result END)
    UPDATE #Tmp_Table SET F_MatchQF4ResultDes = (CASE WHEN F_MatchSF2Away IS NULL THEN (F_MatchCourtQF4 + ',' + F_MatchNumQF4) ELSE F_MatchQF4Result END)
    UPDATE #Tmp_Table SET F_MatchSF1ResultDes = (CASE WHEN F_MatchF1Home IS NULL THEN (F_MatchCourtSF1 + ',' + F_MatchNumSF1) ELSE F_MatchSF1Result END)
    UPDATE #Tmp_Table SET F_MatchSF2ResultDes = (CASE WHEN F_MatchF1Away IS NULL THEN (F_MatchCourtSF2 + ',' + F_MatchNumSF2) ELSE F_MatchSF2Result END)
    UPDATE #Tmp_Table SET F_MatchF1ResultDes = (CASE WHEN F_Winner IS NULL THEN (F_MatchCourtF1 + ',' + F_MatchNumF1) ELSE F_MatchF1Result END)

    UPDATE #Tmp_Table SET F_MatchSF1Home = F_MatchDateQF1 WHERE F_MatchSF1Home IS NULL
    UPDATE #Tmp_Table SET F_MatchSF1Away = F_MatchDateQF2 WHERE F_MatchSF1Away IS NULL
    UPDATE #Tmp_Table SET F_MatchSF2Home = F_MatchDateQF3 WHERE F_MatchSF2Home IS NULL
    UPDATE #Tmp_Table SET F_MatchSF2Away = F_MatchDateQF4 WHERE F_MatchSF2Away IS NULL
    UPDATE #Tmp_Table SET F_MatchF1Home = F_MatchDateSF1 WHERE F_MatchF1Home IS NULL
    UPDATE #Tmp_Table SET F_MatchF1Away = F_MatchDateSF2 WHERE F_MatchF1Away IS NULL
    UPDATE #Tmp_Table SET F_Winner = F_MatchDateF1 WHERE F_Winner IS NULL

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

