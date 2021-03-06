
GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetContestResult_Team]    Script Date: 10/15/2010 11:32:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetContestResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetContestResult_Team]
GO


GO

/****** Object:  StoredProcedure [dbo].[Proc_Report_BD_GetContestResult_Team]    Script Date: 10/15/2010 11:32:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_Report_BD_GetContestResult_Team]
----功		  能：得到团体赛Match的描述信息
----作		  者：张翠霞
----日		  期: 2010-01-25



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetContestResult_Team] 
                   (	
					@MatchID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        CREATE TABLE #Temp_table(
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(10),
                                   F_Court         NVARCHAR(100),
                                   F_EventCode     NVARCHAR(20),
                                   F_EventName     NVARCHAR(100),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ANOC          NVARCHAR(30),
                                   F_ACountry      NVARCHAR(100),
                                   F_BName         NVARCHAR(100),
                                   F_BNOC          NVARCHAR(30), 
                                   F_BCountry      NVARCHAR(100),
                                   F_AMatch        INT,
                                   F_BMatch        INT,
                                   F_MatchTime     NVARCHAR(10),
                                   F_MatchResult   NVARCHAR(100),
                                   F_AIRMID         INT,
                                   F_BIRMID         INT,
                                   F_AIRM           NVARCHAR(10),
                                   F_BIRM           NVARCHAR(10),
                                   F_MatchTitle     NVARCHAR(200),
                                   F_CourtNum       INT
                                )

        DECLARE @APosID INT
        DECLARE @BPosID INT
        DECLARE @GameCount INT
        SELECT @APosID = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
        SELECT @BPosID = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
        SET @GameCount = (SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1) + (SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2)

        INSERT INTO #Temp_Table(F_MatchID, F_StartTime, F_Court, F_EventCode, F_EventName, F_RoundName, F_MatchNum, F_AName, F_ANOC, F_ACountry, F_BName, F_BNOC, F_BCountry, F_AMatch, F_BMatch, F_MatchTime, F_MatchResult, F_AIRMID, F_BIRMID, F_CourtNum)
        SELECT A.F_MatchID, LEFT(CONVERT (NVARCHAR(100), A.F_StartTime, 108), 5), F.F_CourtShortName, E.F_EventComment, E.F_EventShortName, C.F_PhaseShortName, CONVERT( INT,A.F_RaceNum)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,dbo.Fun_BDTT_GetPlayerNOCName(G1.F_RegisterID)
        ,(SELECT W.F_DelegationShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID LEFT JOIN TC_Delegation_Des AS W ON Z.F_DelegationID = W.F_DelegationID AND W.F_LanguageCode = @LanguageCode WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,dbo.Fun_BDTT_GetPlayerNOCName(G2.F_RegisterID)
        ,(SELECT W.F_DelegationShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID LEFT JOIN TC_Delegation_Des AS W ON Z.F_DelegationID = W.F_DelegationID AND W.F_LanguageCode = @LanguageCode WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2)
        ,[dbo].[Fun_BD_GetTimeForReport](A.F_SpendTime, @LanguageCode)
        ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 1, 0)
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_IRMID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2)
        ,F.F_CourtID
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Match_Result AS G1 ON G1.F_MatchID = A.F_MatchID AND G1.F_CompetitionPositionDes1 = 1
        LEFT JOIN TS_Match_Result AS G2 ON G2.F_MatchID = A.F_MatchID AND G2.F_CompetitionPositionDes1 = 2
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court_Des AS F ON A.F_CourtID = F.F_CourtID AND F.F_LanguageCode = @LanguageCode
        WHERE A.F_MatchID = @MatchID

        UPDATE #Temp_table SET F_AIRM = '(' + B.F_IRMCODE + ')' FROM #Temp_table AS A LEFT JOIN TC_IRM AS B ON A.F_AIRMID = B.F_IRMID
        UPDATE #Temp_table SET F_BIRM = '(' + B.F_IRMCODE + ')' FROM #Temp_table AS A LEFT JOIN TC_IRM AS B ON A.F_BIRMID = B.F_IRMID
        UPDATE #Temp_table SET F_MatchTitle = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, -1, 1, @LanguageCode)
        
        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END


GO

