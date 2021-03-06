IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_HO_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_HO_CompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_Report_HO_CompetitionSchedule]
----功		  能：得到该项目下的全部竞赛日程
----作		  者：张翠霞
----日		  期: 2012-09-03



CREATE PROCEDURE [dbo].[Proc_Report_HO_CompetitionSchedule] 
                   (	
					@EventID			    INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

   SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_Day           INT,
                                   F_Session       NVARCHAR(10),
                                   F_SStartTime    NVARCHAR(5),
                                   F_SEndTime      NVARCHAR(5),
                                   F_MatchID       INT,
                                   F_MatchNum      INT,
                                   F_Gender        NVARCHAR(50),
                                   F_PhaseName     NVARCHAR(200),
                                   F_Team          NVARCHAR(200),
                                   F_TeamA         NVARCHAR(150),
                                   F_TeamB         NVARCHAR(150),
                                   F_Date          NVARCHAR(11),
                                   F_StartTime     NVARCHAR(5),
                                   F_EndTime       NVARCHAR(5),
                                   F_Location      NVARCHAR(100),
                                   F_PhaseID       INT,
                                   F_PhaseIsPool   INT,
                                   F_EventName     NVARCHAR(100),
                                   F_EventCode     NVARCHAR(10)  
                                )

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
										F_SourceMatchRank		    INT
                                        )

        INSERT INTO #Temp_Table(F_Day, F_Session, F_SStartTime, F_SEndTime, F_MatchID, F_MatchNum, F_Gender, F_PhaseName, F_Date, F_StartTime, F_EndTime, F_Location, F_PhaseID, F_PhaseIsPool, F_EventName, F_EventCode)
        SELECT G.F_DateOrder, CAST(S.F_SessionNumber AS NVARCHAR(10)), RIGHT(LEFT(CONVERT(NVARCHAR(30), S.F_SessionTime, 20), 16), 5), RIGHT(LEFT(CONVERT(NVARCHAR(30), S.F_SessionEndTime, 20), 16), 5), A.F_MatchID, A.F_RaceNum, D.F_SexLongName, F.F_PhaseLongName, LEFT(CONVERT(NVARCHAR(30), A.F_MatchDate, 20), 10),
        RIGHT(LEFT(CONVERT(NVARCHAR(30), A.F_StartTime, 20), 16), 5), RIGHT(LEFT(CONVERT(NVARCHAR(30), A.F_EndTime, 20), 16), 5), E.F_CourtShortName, B.F_PhaseID, B.F_PhaseIsPool, H.F_EventLongName, C.F_EventCode
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS F ON B.F_PhaseID = F.F_PhaseID AND F.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS H ON C.F_EventID= H.F_EventID AND H.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Sex_Des AS D ON C.F_SexCode = D.F_SexCode AND D.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court_Des AS E ON A.F_CourtID = E.F_CourtID AND E.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_DisciplineDate AS G ON A.F_MatchDate = G.F_Date
        LEFT JOIN TS_Session AS S ON A.F_SessionID = S.F_SessionID
        WHERE C.F_EventID = @EventID ORDER BY A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), CAST(A.F_RaceNum AS INT), C.F_SexCode

        INSERT INTO #Temp_PlayerSource (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_RegisterID,
		F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_MatchName)
		SELECT A.F_MatchID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_RegisterID, A.F_StartPhaseID,
        A.F_StartPhasePosition, A.F_SourcePhaseID, A.F_SourcePhaseRank, A.F_SourceMatchID, A.F_SourceMatchRank, C.F_MatchLongName
        FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
        LEFT JOIN TS_Match_Des AS C ON B.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Phase AS D ON B.F_PhaseID = D.F_PhaseID
        LEFT JOIN TS_Event AS E ON D.F_EventID = E.F_EventID
        LEFT JOIN TS_DisciplineDate AS F ON B.F_MatchDate = F.F_Date
        WHERE E.F_EventID = @EventID

        UPDATE #Temp_PlayerSource SET F_StartPhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_StartPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourcePhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourcePhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseID = B.F_PhaseID, F_SourceMatchOrder = B.F_Order FROM #Temp_PlayerSource AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID 
		UPDATE #Temp_PlayerSource SET F_SourceMatchPhaseName = B.F_PhaseLongName FROM #Temp_PlayerSource AS A LEFT JOIN TS_Phase_Des AS B ON A.F_SourceMatchPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
        UPDATE #Temp_PlayerSource SET F_SourceMatchName = CAST(B.F_RaceNum AS NVARCHAR(100)) FROM #Temp_PlayerSource AS A LEFT JOIN TS_Match AS B ON A.F_SourceMatchID = B.F_MatchID

		UPDATE #Temp_PlayerSource SET F_RegisterName = DD.F_DelegationLongName
		FROM #Temp_PlayerSource AS A
		LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
		LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID
		LEFT JOIN TC_Delegation_Des AS DD ON C.F_DelegationID = DD.F_DelegationID AND DD.F_LanguageCode = @LanguageCode
        
        UPDATE #Temp_PlayerSource SET F_RegisterName = 'BYE' WHERE F_RegisterID = -1
		UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' Position ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
        UPDATE #Temp_PlayerSource SET F_RegisterName = LTRIM(RTRIM(F_StartPhaseName)) + ' 位置 ' + CAST(F_StartPhasePosition AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = RIGHT(LTRIM(RTRIM(F_SourcePhaseName)), 1) + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG'
        UPDATE #Temp_PlayerSource SET F_RegisterName = LEFT(LTRIM(RTRIM(F_SourcePhaseName)), 1) + CAST(F_SourcePhaseRank AS NVARCHAR(100)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN'
		UPDATE #Temp_PlayerSource SET F_RegisterName = 'Winner #' + LTRIM(RTRIM(F_SourceMatchName)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG' AND F_SourceMatchRank = 1
        UPDATE #Temp_PlayerSource SET F_RegisterName = '胜者 #' + LTRIM(RTRIM(F_SourceMatchName)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN' AND F_SourceMatchRank = 1
		UPDATE #Temp_PlayerSource SET F_RegisterName = 'Loser #' + LTRIM(RTRIM(F_SourceMatchName)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'ENG' AND F_SourceMatchRank = 2
        UPDATE #Temp_PlayerSource SET F_RegisterName = '负者 #' + LTRIM(RTRIM(F_SourceMatchName)) WHERE F_RegisterName IS NULL AND @LanguageCode = 'CHN' AND F_SourceMatchRank = 2
        		
        UPDATE #Temp_table SET F_Session = '单元' + F_Session WHERE @LanguageCode = 'CHN'
        UPDATE #Temp_table SET F_Session = 'Session' + F_Session WHERE @LanguageCode = 'ENG'
        UPDATE #Temp_Table SET F_TeamA = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
        WHERE B.F_CompetitionPositionDes1 = 1 AND A.F_TeamA IS NULL

        UPDATE #Temp_Table SET F_TeamB = B.F_RegisterName FROM #Temp_Table AS A LEFT JOIN #Temp_PlayerSource AS B ON A.F_MatchID = B.F_MatchID
        WHERE B.F_CompetitionPositionDes1 = 2 AND A.F_TeamB IS NULL

--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
        UPDATE #Temp_Table SET F_PhaseName = 'Preliminary - ' + F_PhaseName WHERE F_PhaseIsPool = 1 AND @LanguageCode = 'ENG' AND F_EventCode <> '001'
        UPDATE #Temp_Table SET F_PhaseName = '预赛 - ' + F_PhaseName WHERE F_PhaseIsPool = 1 AND @LanguageCode = 'CHN' AND F_EventCode <> '001'
        UPDATE #Temp_Table SET F_Team = F_TeamA + ' VS ' + F_TeamB

        ALTER TABLE #Temp_Table DROP COLUMN F_MatchID, F_TeamA, F_TeamB, F_PhaseID, F_PhaseIsPool

        SELECT * FROM #Temp_Table
SET NOCOUNT OFF
END

GO

/*EXEC Proc_Report_HO_CompetitionSchedule 16,'CHN'*/


