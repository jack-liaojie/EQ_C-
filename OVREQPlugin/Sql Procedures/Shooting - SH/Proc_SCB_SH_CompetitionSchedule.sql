IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_CompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_SCB_SH_CompetitionSchedule] 
                   (	
					@DisciplineID			INT,
					@LanguageCode           CHAR(3)		
                   )	
AS
BEGIN
SET NOCOUNT ON

   SET LANGUAGE ENGLISH


         CREATE TABLE #Temp_table(
                                   F_Date          NVARCHAR(100),
                                   F_EventName     NVARCHAR(100),
                                   F_PhaseName     NVARCHAR(100),
                                   F_StartTime     NVARCHAR(100),
                                   F_FinishTime    NVARCHAR(100),
                                   F_Location		NVARCHAR(100),
                                   F_ID				NVARCHAR(100),
                                   F_VenueID		INT,
                                   F_StatusID			INT,
                                   F_StatusDes		NVARCHAR(100),
                                   F_MatchID		INT			
                                )


		DECLARE @DisciplineCode NVARCHAR(10)
		SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
		
        INSERT INTO #Temp_table(F_Date, F_StartTime, F_FinishTime, F_EventName, F_PhaseName, F_Location, F_ID, F_VenueID, F_StatusID, F_StatusDes, F_MatchID)
        SELECT [dbo].[Func_Report_GetDateTime](A.F_MatchDate, 5),
        [dbo].[Func_Report_GetDateTime](A.F_StartTime, 3), 
        [dbo].[Func_Report_GetDateTime](A.F_EndTime, 3), 
        H.F_EventLongName, 
        F.F_PhaseLongName, 
        M.F_CourtShortName,
        @DisciplineCode + N.F_GenderCode + C.F_EventCode + B.F_PhaseCode + A.F_MatchCode,
        A.F_VenueID,
        A.F_MatchStatusID,
        O.F_StatusLongName,
        A.F_MatchID
        FROM TS_Match AS A
        LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
        LEFT JOIN TS_Phase_Des AS F ON B.F_PhaseID = F.F_PhaseID AND F.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
        LEFT JOIN TS_Event_Des AS H ON C.F_EventID= H.F_EventID AND H.F_LanguageCode = @LanguageCode
        LEFT JOIN TS_DisciplineDate AS G ON CONVERT(NVARCHAR(20),A.F_MatchDate,101) = CONVERT(NVARCHAR(20),G.F_Date,101)
        LEFT JOIN TC_Court_Des AS M ON M.F_CourtID = A.F_CourtID AND M.F_LanguageCode = @LanguageCode
        LEFT JOIN TC_Sex N ON N.F_SexCode = C.F_SexCode
        LEFT JOIN TC_Status_Des O ON O.F_StatusID = A.F_MatchStatusID AND O.F_LanguageCode = @LanguageCode
        WHERE G.F_DisciplineID = @DisciplineID AND C.F_DisciplineID = @DisciplineID 
				AND C.F_EventCode NOT IN ('002', '004', '006', '008', '010', '012', '014', 
											'102', '104', '106', '108', '110')
				AND A.F_MatchDate IS NOT NULL 
				AND A.F_VenueID IS NOT NULL 
				--AND A.F_StartTime IS NOT NULL 
				AND A.F_RaceNum IS NOT NULL
				AND A.F_MatchCode <> '50'
        ORDER BY A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), CAST(A.F_RaceNum AS INT)



		DECLARE @GenderCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @MatchLongname NVARCHAR(100)	
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
			WHERE F_MatchID = @TMP_MatchID AND F_LanguageCode = @LanguageCode	

			IF @MatchCode = '00' OR @PhaseCode = '1' OR @PhaseCode = '0' 
			BEGIN
				UPDATE #Temp_Table SET F_PhaseName = F_PhaseName WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode IN ('007','109','009','011','013','105','107')--25M STANDARD , 50M PRON WOMEN
			BEGIN
				UPDATE #Temp_Table SET F_PhaseName = F_PhaseName WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE 
			BEGIN
				UPDATE #Temp_Table SET F_PhaseName = F_PhaseName + ' ' + @MatchLongname WHERE CURRENT OF SCHEDULE_CURSOR
			END
			
			FETCH NEXT FROM SCHEDULE_CURSOR INTO @TMP_MatchID
		END
		CLOSE SCHEDULE_CURSOR
		DEALLOCATE SCHEDULE_CURSOR
		

        SELECT * FROM #Temp_Table
       
SET NOCOUNT OFF
END

GO


--		Proc_SCB_SH_CompetitionSchedule 1,'ENG'