IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetKnockOutDrawSheet_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetKnockOutDrawSheet_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_BD_GetKnockOutDrawSheet_Team]
--描    述：得到Event下淘汰赛分组抽签表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月25日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetKnockOutDrawSheet_Team](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                            F_MatchDate1          NVARCHAR(20),
                            F_MatchCourt1         NVARCHAR(100),
                            F_MatchNum1           NVARCHAR(10),
                            F_MatchDate2          NVARCHAR(20),
                            F_MatchCourt2         NVARCHAR(100),
                            F_MatchNum2           NVARCHAR(10),
                            F_MatchDate3          NVARCHAR(20),
                            F_MatchCourt3         NVARCHAR(100),
                            F_MatchNum3           NVARCHAR(10)
							)


    DECLARE @EventCode NVARCHAR(10)
    DECLARE @PhaseID1 INT
    DECLARE @PhaseID2 INT
    SELECT @PhaseID1 = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 2 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @PhaseID2 = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 3 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @EventCode = B.F_EventComment FROM TS_Phase AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID
    WHERE A.F_PhaseID = @PhaseID1 AND B.F_LanguageCode = @LanguageCode

    INSERT INTO #Tmp_Table(F_MatchDate1) VALUES(NULL)

    DECLARE @MatchID1 INT
    DECLARE @MatchID2 INT
    DECLARE @MatchID3 INT

    SELECT @MatchID1 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID1 AND F_Order = 1
    SELECT @MatchID2 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID1 AND F_Order = 2
    SELECT @MatchID3 = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID2 AND F_Order = 1

    UPDATE #Tmp_Table SET F_MatchDate1 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourt1 = B.F_CourtShortName, F_MatchNum1 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID1

    UPDATE #Tmp_Table SET F_MatchDate2 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourt2 = B.F_CourtShortName, F_MatchNum2 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID2

    UPDATE #Tmp_Table SET F_MatchDate3 = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F_MatchCourt3 = B.F_CourtShortName, F_MatchNum3 = @EventCode + A.F_RaceNum
    FROM TS_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID AND B.F_LanguageCode = @LanguageCode WHERE A.F_MatchID = @MatchID3

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

