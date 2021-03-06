IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetGroupResult_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetGroupResult_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_BD_GetGroupResult_Team]
----功		  能：得到一个Event下一个组的比赛信息
----作		  者：张翠霞
----日		  期: 2010-01-26



CREATE PROCEDURE [dbo].[Proc_Report_BD_GetGroupResult_Team] 
                   (	
					@EventID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

        SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_PhaseID       INT,
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
                                   F_MatchDes      NVARCHAR(150)
                                )

        INSERT INTO #Temp_Table(F_PhaseID, F_MatchID, F_Date, F_StartTime, F_CourtCode, F_EventCode, F_RoundName, F_MatchNum, F_AName, F_ANOC, F_BName, F_BNOC, F_MatchResult, F_MatchDes)
        SELECT A.F_PhaseID, A.F_MatchID, [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 4), [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3), F.F_CourtCode, E.F_EventComment, C.F_PhaseShortName, CONVERT( INT,A.F_RaceNum)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID = A.F_MatchID)
        ,(SELECT Y.F_PrintShortName FROM TS_Match_Result AS X LEFT JOIN TR_Register_Des AS Y ON X.F_RegisterID = Y.F_RegisterID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID AND Y.F_LanguageCode = @LanguageCode)
        ,(SELECT Z.F_DelegationCode FROM TS_Match_Result AS X LEFT JOIN TR_Register AS Y ON X.F_RegisterID = Y.F_RegisterID LEFT JOIN TC_Delegation AS Z ON Y.F_DelegationID = Z.F_DelegationID WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID = A.F_MatchID)
        ,[dbo].[Fun_Report_BD_GetMatchResultDes](A.F_MatchID, 1, 0)
        ,DBO.Fun_Report_BD_GetMatchResultDes(A.F_MatchID, 2, 0)
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS C ON B.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS D ON B.F_EventID = D.F_EventID
        LEFT JOIN TS_Event_Des AS E ON D.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court AS F ON A.F_CourtID = F.F_CourtID
        WHERE D.F_EventID = @EventID AND (B.F_PhaseIsPool = 1 OR B.F_PhaseType=2) ORDER BY B.F_Order, A.F_MatchNum
				
--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)

        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END



GO

