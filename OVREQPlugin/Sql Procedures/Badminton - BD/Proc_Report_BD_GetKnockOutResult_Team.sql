IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetKnockOutResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetKnockOutResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_Report_BD_GetKnockOutResult]
--描    述：得到Event下淘汰赛成绩表
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年01月26日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetKnockOutResult_Team](
                       @EventID         INT,
                       @LanguageCode    NVARCHAR(3)
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	CREATE TABLE #Tmp_Table(
                                   F_MatchID       INT,
                                   F_Date          NVARCHAR(11),
                                   F_StartTime     NVARCHAR(10),
                                   F_CourtCode     NVARCHAR(10),
                                   F_EventCode     NVARCHAR(20),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(10),
                                   F_MatchResult   NVARCHAR(20),
                                   F_MatchDuration NVARCHAR(10),
                                   F_MatchDes      NVARCHAR(150)
							)

	DECLARE @DiscplineCode NVARCHAR(10)
	DECLARE @PhaseOrderF INT
	DECLARE @PhaseOrderB INT
	
	SELECT @DiscplineCode = B.F_DisciplineCode
	FROM TS_Event AS A
	LEFT JOIN TS_Discipline AS B ON B.F_DisciplineID = A.F_DisciplineID
	WHERE A.F_EventID = 1
	
	--IF @DiscplineCode = ''
	--	BEGIN
	--		SET @PhaseOrderF = 4
	--		SET @PhaseOrderB = 3	
	--	END
	--ELSE 
	--	BEGIN
	--		SET @PhaseOrderF = 3
	--		SET @PhaseOrderB = 99
	--	END
	--去掉铜牌赛之后的处理
	SET @PhaseOrderF = 3
	SET @PhaseOrderB = 99
	
    DECLARE @EventCode NVARCHAR(10)
    DECLARE @PhaseQFID INT
    DECLARE @PhaseSFID INT
    DECLARE @PhaseFID INT
    DECLARE @PhaseBID INT

    SELECT @PhaseQFID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 1 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @PhaseSFID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = 2 AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @PhaseFID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = @PhaseOrderF AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @PhaseBID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = @PhaseOrderB AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
    SELECT @EventCode = B.F_EventComment FROM TS_Phase AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
    WHERE A.F_PhaseID = @PhaseSFID

    INSERT INTO #Tmp_Table(F_MatchID, F_Date, F_StartTime, F_CourtCode, F_EventCode, F_RoundName, F_MatchNum, F_AName, F_ANOC, F_BName, F_BNOC, F_MatchResult, F_MatchDuration, F_MatchDes)
    SELECT A.F_MatchID, [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 4), [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F.F_CourtCode, E.F_EventComment, C.F_PhaseShortName, CONVERT( INT,A.F_RaceNum)
    ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
    ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
    ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
    ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
    ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 1, 0)
    ,[dbo].[Fun_BD_GetTimeForReport](A.F_SpendTime, @LanguageCode)
    ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 2, 0)
    FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
    LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
    LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
    WHERE D.F_EventID = @EventID
    AND B.F_PhaseID IN(@PhaseQFID, @PhaseSFID, @PhaseFID, @PhaseBID) ORDER BY A.F_MatchNum

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

