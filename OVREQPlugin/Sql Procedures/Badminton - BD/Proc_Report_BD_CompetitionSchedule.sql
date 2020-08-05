IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_CompetitionSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_BD_CompetitionSchedule]
----功		  能：得到该项目下的全部竞赛日程
----作		  者：张翠霞
----日		  期: 2010-01-19



CREATE PROCEDURE [dbo].[Proc_Report_BD_CompetitionSchedule] 
                   (	
					@DisciplineID			INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

    SET LANGUAGE ENGLISH

        CREATE TABLE #Temp_table(
                                   F_MatchID       INT,
                                   F_CourtCode     NVARCHAR(10),
                                   F_EventName     NVARCHAR(50),
                                   F_RoundName     NVARCHAR(50),
                                   F_Session       INT,
                                   F_StartTime     NVARCHAR(5),
                                   F_EndTime       NVARCHAR(5),
                                   F_Date          NVARCHAR(11),
                                   F_Day           INT,
                                   F_PhaseID       INT,
                                   F_EventID       INT,
                                   F_FatherPhaseID INT,
                                   F_PhaseIsPool   INT,
                                   F_MatchTime     DATETIME      
                                )

		CREATE TABLE #Temp_Schedule(
									[Day]			    INT,
									[Date]		        NVARCHAR(11),
									[RoundName]		    NVARCHAR(1000),
									Session				INT,
									[StartTime]		    NVARCHAR(5),
									[FinishTime]	    NVARCHAR(5),
									[EventRoundName]	NVARCHAR(100),
									[NoMatches]	        INT,
									[NoCourts]			INT,
                                    EventName           NVARCHAR(50),
                                    F_StartTime         DATETIME,
                                    F_EventID           INT,
                                    F_PhaseID           INT
								    )

        INSERT INTO #Temp_Table(F_MatchID, F_EventName, F_CourtCode, F_Session, F_StartTime, F_EndTime, F_Date, F_Day, F_PhaseID, F_FatherPhaseID, F_PhaseIsPool, F_MatchTime, F_EventID)
        SELECT A.F_MatchID, C.F_EventLongName, E.F_CourtCode, F.F_SessionNumber,
        [dbo].[Fun_Report_BD_GetDateTime](F.F_SessionTime, 3), [dbo].[Fun_Report_BD_GetDateTime](F.F_SessionEndTime, 3),
        [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 8), G.F_DateOrder, B.F_PhaseID, B.F_FatherPhaseID, B.F_PhaseIsPool
        , CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114)
        , M.F_EventID
        FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Event AS M ON B.F_EventID = M.F_EventID
        LEFT JOIN TS_Event_Des AS C ON C.F_EventID = M.F_EventID AND C.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Court AS E ON A.F_CourtID = E.F_CourtID
        LEFT JOIN TS_Session AS F ON A.F_SessionID = F.F_SessionID
        LEFT JOIN TS_DisciplineDate AS G ON A.F_MatchDate = G.F_Date
        WHERE G.F_DisciplineID = @DisciplineID AND M.F_DisciplineID = @DisciplineID
        ORDER BY G.F_DateOrder, F.F_SessionNumber
        
        UPDATE #Temp_Table SET F_RoundName = B.F_PhaseLongName FROM #Temp_Table AS A LEFT JOIN TS_Phase_Des AS B ON B.F_PhaseID = A.F_PhaseID 
        WHERE B.F_LanguageCode = @LanguageCode
				
--		--删除轮空比赛
		DELETE FROM #Temp_Table WHERE F_MatchID IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
        
        INSERT INTO #Temp_Schedule([Day], [Date], [RoundName], Session, [StartTime], [FinishTime], [EventRoundName], EventName, F_EventID, F_StartTime, F_PhaseID)
        SELECT F_Day, F_Date, F_RoundName, F_Session, F_StartTime, F_EndTime, F_EventName + ' ' + F_RoundName, F_EventName, F_EventID, MIN(F_MatchTime), F_PhaseID
        FROM #Temp_Table GROUP BY F_Day, F_Date, F_RoundName, F_Session, F_StartTime, F_EndTime, F_EventName + ' ' + F_RoundName, F_EventName, F_EventID, F_PhaseID
        
        UPDATE #Temp_Schedule SET [NoMatches] = (SELECT COUNT(B.F_MatchID) FROM #Temp_Table AS B
        WHERE A.[Day] = B.F_Day AND A.Session = B.F_Session AND A.[RoundName] = B.F_RoundName
        AND A.EventName = B.F_EventName) FROM #Temp_Schedule AS A

        UPDATE #Temp_Schedule SET [NoCourts] = (SELECT COUNT(DISTINCT B.F_CourtCode) FROM #Temp_Table AS B
        WHERE A.[Session] = B.F_Session) FROM #Temp_Schedule AS A


/*
        DECLARE @Day INT
        DECLARE @DayRoundName NVARCHAR(1000)
		DECLARE ONE_CURSOR CURSOR FOR SELECT [Day] FROM #Temp_Schedule
		OPEN ONE_CURSOR
		FETCH NEXT FROM ONE_CURSOR INTO @Day
		WHILE @@FETCH_STATUS =0 
		BEGIN
			SET @DayRoundName = [dbo].[Fun_Report_BD_GetRoundName](@Day, @DisciplineID, @LanguageCode)

            UPDATE #Temp_Schedule SET [RoundName] = @DayRoundName WHERE [Day] = @Day
			FETCH NEXT FROM ONE_CURSOR INTO @Day
		END
		CLOSE ONE_CURSOR
		DEALLOCATE ONE_CURSOR
*/
	
	UPDATE A SET A.RoundName = C.F_PhaseLongName FROM #Temp_Schedule AS A INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
		INNER JOIN TS_Phase_Des AS C ON B.F_FatherPhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
		WHERE B.F_PhaseType = 2
	
	SELECT * FROM #Temp_Schedule ORDER BY [Day], Session, F_StartTime, F_PhaseID

SET NOCOUNT OFF
END




GO


--execute Proc_Report_BD_CompetitionSchedule 1, 'ENG'