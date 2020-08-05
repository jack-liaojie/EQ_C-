IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_GetDrawSheet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_GetDrawSheet]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_HO_GetDrawSheet]
--描    述：得到Event下分组抽签表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年09月06日


CREATE PROCEDURE [dbo].[Proc_Report_HO_GetDrawSheet](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
    CREATE TABLE #Tmp_Table(
                             F_PhaseID            INT,
                             F_MatchID            INT,
                             F_RegisterAID        INT,
                             F_RegisterBID        INT,
                             F_MatchDate          NVARCHAR(20),
                             F_MatchCourt         NVARCHAR(100),
                             F_MatchNum           NVARCHAR(10),
                             F_ContestResult      NVARCHAR(100),
                             F_MatchResult        NVARCHAR(100),
                             F_MatchStatus        INT
                           )

    DECLARE @EventCode NVARCHAR(10)
    SELECT @EventCode = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID

    INSERT INTO #Tmp_Table(F_PhaseID, F_MatchID, F_RegisterAID, F_RegisterBID, F_MatchDate, F_MatchCourt, F_MatchNum, F_MatchStatus)
    SELECT A.F_PhaseID, A.F_MatchID
    ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1)
    ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
    ,LEFT(CONVERT(NVARCHAR(30), A.F_StartTime, 20), 16)
    ,B.F_CourtShortName
    ,(@EventCode + ' - ' + CAST(A.F_RaceNum AS NVARCHAR(10)))
    ,A.F_MatchStatusID
    FROM TS_Match AS A
    LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID
    WHERE C.F_EventID = @EventID AND C.F_PhaseIsPool = 1

    INSERT INTO #Tmp_Table(F_PhaseID, F_MatchID, F_RegisterAID, F_RegisterBID, F_MatchDate, F_MatchCourt, F_MatchNum, F_MatchStatus)
    SELECT A.F_PhaseID, A.F_MatchID
    ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
    ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_MatchID = A.F_MatchID AND X.F_CompetitionPositionDes1 = 1)
    ,LEFT(CONVERT(NVARCHAR(30), A.F_StartTime, 20), 16)
    ,B.F_CourtShortName
    ,(@EventCode + ' - ' + CAST(A.F_RaceNum AS NVARCHAR(10)))
    ,A.F_MatchStatusID
    FROM TS_Match AS A
    LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID
    WHERE C.F_EventID = @EventID AND C.F_PhaseIsPool = 1

    UPDATE #Tmp_Table SET F_ContestResult = [dbo].[Fun_Report_HO_GetMatchResult](F_MatchID, F_RegisterAID, F_RegisterBID, 1)
	UPDATE #Tmp_Table SET F_ContestResult = F_MatchDate WHERE F_MatchStatus <> 110
    UPDATE #Tmp_Table SET F_MatchResult = F_MatchCourt + ',' + F_MatchNum WHERE F_MatchStatus <> 110

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End


GO

/*EXEC Proc_Report_HO_GetDrawSheet 16, 'CHN'*/


