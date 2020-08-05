IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetDayMatch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetDayMatch]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetDayMatch] 
                   (	
					@DisciplineID			INT,
					@DayID					INT
                   )	
AS
BEGIN
SET NOCOUNT ON

   SET LANGUAGE ENGLISH

		DECLARE @MatchDay DATETIME
		SELECT @MatchDay = F_Date FROM TS_DisciplineDate
		WHERE F_DisciplineDateID = @DayID

        CREATE TABLE #Temp_table(
                                   F_MatchName		NVARCHAR(100),
                                   F_MatchNameCHN		NVARCHAR(100),
                                   F_Date          NVARCHAR(100),
                                   F_EventName     NVARCHAR(100),
                                   F_EventNameCHN   NVARCHAR(100),
                                   F_PhaseName     NVARCHAR(100),
                                   F_PhaseNameCHN     NVARCHAR(100),
                                   F_FinishTime    NVARCHAR(100),
                                   F_StartTime     NVARCHAR(100),
                                   F_Location		NVARCHAR(100),
                                   F_ID				NVARCHAR(100),
                                   F_VenueID		INT,
                                   F_StatusID			INT,
                                   F_StatusDes		NVARCHAR(100),
                                   F_MatchID		INT,
                                   F_EventID		INT			
                                )


		DECLARE @DisciplineCode NVARCHAR(10)
		SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
		
        INSERT INTO #Temp_table(F_Date, F_StartTime, F_FinishTime, F_EventName, F_EventNameCHN,
        F_PhaseName, F_PhaseNameCHN, F_Location, F_ID, F_VenueID, F_StatusID, F_StatusDes, F_MatchID, F_EventID)
        SELECT [dbo].[Func_Report_GetDateTime](A.F_MatchDate, 5),
        [dbo].[Func_Report_GetDateTime](A.F_StartTime, 3), 
        [dbo].[Func_Report_GetDateTime](A.F_EndTime, 3), 
        H.F_EventLongName, 
        H_CHN.F_EventLongName, 
        F.F_PhaseLongName, 
        F_CHN.F_PhaseLongName, 
        M.F_CourtShortName,
        @DisciplineCode + N.F_GenderCode + C.F_EventCode + B.F_PhaseCode + A.F_MatchCode,
        A.F_VenueID,
        A.F_MatchStatusID,
        O.F_StatusLongName,
        A.F_MatchID,
        C.F_EventID
        FROM TS_Match AS A
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS F ON B.F_PhaseID = F.F_PhaseID AND F.F_LanguageCode = 'ENG'
        LEFT JOIN TS_Phase_Des AS F_CHN ON B.F_PhaseID = F_CHN.F_PhaseID AND F_CHN.F_LanguageCode = 'CHN'
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS H ON C.F_EventID= H.F_EventID AND H.F_LanguageCode = 'ENG'
        LEFT JOIN TS_Event_Des AS H_CHN ON C.F_EventID= H_CHN.F_EventID AND H_CHN.F_LanguageCode = 'CHN'
        LEFT JOIN TS_DisciplineDate AS G ON CONVERT(NVARCHAR(20),A.F_MatchDate,101) = CONVERT(NVARCHAR(20),G.F_Date,101)
        LEFT JOIN TC_Court_Des AS M ON M.F_CourtID = A.F_CourtID AND M.F_LanguageCode = 'ENG'
        LEFT JOIN TC_Sex N ON N.F_SexCode = C.F_SexCode
        LEFT JOIN TC_Status_Des O ON O.F_StatusID = A.F_MatchStatusID AND O.F_LanguageCode = 'ENG'
        WHERE G.F_DisciplineID = @DisciplineID AND C.F_DisciplineID = @DisciplineID 
				AND A.F_MatchDate IS NOT NULL AND A.F_VenueID IS NOT NULL
				AND F_Date = @MatchDay
				AND A.F_MatchCode NOT IN('50')
        ORDER BY A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), A.F_RaceNum



		DECLARE @GenderCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @MatchLongname NVARCHAR(100)	
		DECLARE @MatchLongnameCHN NVARCHAR(100)
		DECLARE @TMP_MatchID INT
		
		DECLARE SCHEDULE_CURSOR CURSOR FOR
		SELECT F_MatchID FROM #Temp_table
		OPEN SCHEDULE_CURSOR
		FETCH NEXT FROM SCHEDULE_CURSOR INTO @TMP_MatchID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT 
					@GenderCode = Gender_Code,
					@EventCode = Event_Code,
					@PhaseCode = Phase_Code,
					@MatchCode = Match_Code
			 FROM dbo.Func_SH_GetEventCommonCodeInfo(@TMP_MatchID)

			SELECT @MatchLongname = F_MatchLongName 
			FROM TS_Match_Des 
			WHERE F_MatchID = @TMP_MatchID AND F_LanguageCode = 'ENG'	

			SELECT @MatchLongnameCHN = F_MatchLongName 
			FROM TS_Match_Des 
			WHERE F_MatchID = @TMP_MatchID AND F_LanguageCode = 'CHN'	

			IF @MatchCode = '00' OR @PhaseCode = '1' OR @PhaseCode = '0' 
			BEGIN
				UPDATE #Temp_Table SET F_PhaseName = F_PhaseName, F_PhaseNameCHN = F_PhaseNameCHN
				WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode IN ('007','109','009','011','013','105','107')--25M STANDARD , 50M PRON WOMEN
			BEGIN
				UPDATE #Temp_Table SET F_PhaseName = F_PhaseName, F_PhaseNameCHN = F_PhaseNameCHN
				WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE 
			BEGIN
				UPDATE #Temp_Table SET F_PhaseName = F_PhaseName + ' ' + @MatchLongname,
					F_PhaseNameCHN = F_PhaseNameCHN + ' ' + @MatchLongnameCHN 
				WHERE CURRENT OF SCHEDULE_CURSOR
			END
			
			FETCH NEXT FROM SCHEDULE_CURSOR INTO @TMP_MatchID
		END
		CLOSE SCHEDULE_CURSOR
		DEALLOCATE SCHEDULE_CURSOR
		
		UPDATE #Temp_Table
		SET F_MatchNameCHN = F_EventNameCHN + ' ' + F_PhaseNameCHN,
		F_MatchName = F_EventName + ' ' + F_PhaseName

        SELECT * FROM #Temp_Table 
        ORDER BY F_EventName
        
SET NOCOUNT OFF
END

GO


-- Proc_SCB_SH_GetDayMatch 1,1