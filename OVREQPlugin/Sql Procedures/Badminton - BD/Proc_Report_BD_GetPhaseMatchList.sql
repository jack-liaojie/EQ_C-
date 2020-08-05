IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetPhaseMatchList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetPhaseMatchList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









----存储过程名称：[Proc_Report_BD_GetPhaseMatchList]
----功		  能：得到该Phase下的所有Match的信息
----作		  者：李燕
----日		  期: 2011-03-16


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetPhaseMatchList] 
                   (	
					@PhaseID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON
        
        CREATE TABLE #Temp_Phase(
                                 F_MatchID         INT)
                                 
        INSERT INTO #Temp_Phase(F_MatchID)
                SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID
                
        CREATE TABLE #Temp_table(
                                   F_MatchID       INT,
                                   F_StartTime     NVARCHAR(10),
                                   F_Court         NVARCHAR(100),
                                   F_EventCode     NVARCHAR(20),
                                   F_RoundName     NVARCHAR(100),
                                   F_MatchNum      INT,
                                   F_AName         NVARCHAR(100),
                                   F_ASName        NVARCHAR(100),--新增
                                   F_ANOC          NVARCHAR(10),
                                   F_BName         NVARCHAR(100),
                                   F_BSName        NVARCHAR(100),--新增
                                   F_BNOC          NVARCHAR(10), 
                                   F_AMatch        INT,
                                   F_BMatch        INT,
                                   F_MatchTime     NVARCHAR(10),
                                   F_AIRMID        INT,
                                   F_BIRMID        INT,
                                   F_AIRM          NVARCHAR(10),
                                   F_BIRM          NVARCHAR(10),
                                   F_MatchDes      NVARCHAR(100),
                                   F_MatchTitle    NVARCHAR(100),
                                   F_Match         NVARCHAR(20),--add
                                   F_MatchResult   NVARCHAR(100),
                                   F_RegisterAID   INT,--add
                                   F_RegisterBID   INT--add
                                )

        INSERT INTO #Temp_Table(
			F_MatchID, F_StartTime, F_Court, F_EventCode, F_RoundName, F_MatchNum, F_RegisterAID, F_RegisterBID, F_AName, F_ASName, F_ANOC, F_BName, F_BSName, F_BNOC, F_AMatch, F_BMatch, F_MatchTime,
			F_AIRMID, F_BIRMID, F_MatchDes
        )
        SELECT 
        A.F_MatchID, [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F.F_CourtShortName, E.F_EventComment, C.F_PhaseShortName, CAST(A.F_RaceNum AS INT)
        ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT X.F_RegisterID FROM TS_Match_Result AS X WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintLongName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT F_Points FROM TS_Match_Result AS X WHERE X.F_MatchID = TP.F_MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_Points FROM TS_Match_Result AS X WHERE X.F_MatchID = TP.F_MatchID AND F_CompetitionPositionDes1 = 2)
        ,[dbo].[Fun_BD_GetTimeForReport](A.F_SpendTime, @LanguageCode)
        -- Math IRM
        ,(SELECT F_IRMID FROM TS_Match_Result AS X WHERE X.F_MatchID = TP.F_MatchID AND F_CompetitionPositionDes1 = 1)
        ,(SELECT F_IRMID FROM TS_Match_Result AS X WHERE X.F_MatchID = TP.F_MatchID AND  F_CompetitionPositionDes1 = 2)
       ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 2, 0)
        FROM #Temp_Phase AS TP LEFT JOIN  TS_Match AS A ON TP.F_MatchID = A.F_MatchID
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court_Des AS F ON A.F_CourtID = F.F_CourtID AND F.F_LanguageCode = @LanguageCode

        UPDATE #Temp_Table SET F_AIRM = (CASE WHEN A.F_AIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_AIRMID = B.F_IRMID
        UPDATE #Temp_Table SET F_BIRM = (CASE WHEN A.F_BIRMID IS NULL THEN '' ELSE '(' + B.F_IRMCODE + ')' END) FROM #Temp_Table AS A LEFT JOIN TC_IRM AS B ON A.F_BIRMID = B.F_IRMID
        --UPDATE #Temp_table SET F_MatchTitle = [dbo].[Fun_Report_BD_GetMatchTitle](@MatchID, 0, 1, @LanguageCode)
        UPDATE #Temp_table SET F_MatchTitle = F_AName + F_AIRM + ' - ' + F_BName + F_BIRM
        UPDATE #Temp_table SET F_Match = CAST(F_AMatch AS NVARCHAR(10)) + ' - ' + CAST(F_BMatch AS NVARCHAR(10)) WHERE F_AMatch + F_BMatch <> 0
        UPDATE #Temp_table SET F_MatchResult = [dbo].[Fun_Report_BD_GetMatchTitle](F_MatchID, 0, 2, @LanguageCode)
      
        SELECT * FROM #Temp_Table order by f_matchid
        
        
SET NOCOUNT OFF

END




GO


