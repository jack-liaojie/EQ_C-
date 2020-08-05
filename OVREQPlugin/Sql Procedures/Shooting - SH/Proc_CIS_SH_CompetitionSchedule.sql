IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_SH_CompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_SH_CompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_CIS_SH_CompetitionSchedule] 
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
                                   F_StatusID		INT,
                                   F_StatusDes		NVARCHAR(100)			
                                )

		
		DECLARE @DisciplineCode NVARCHAR(10)
		SELECT @DisciplineCode = F_DisciplineCode FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
		
        INSERT INTO #Temp_Table(F_Date, F_StartTime, F_FinishTime, F_EventName, F_PhaseName, F_Location, F_ID, F_VenueID, F_StatusID, F_StatusDes)
        SELECT [dbo].[Func_Report_GetDateTime](A.F_MatchDate, 5),
        [dbo].[Func_Report_GetDateTime](A.F_StartTime, 3), 
        [dbo].[Func_Report_GetDateTime](A.F_EndTime, 3), 
        H.F_EventLongName, 
        F.F_PhaseLongName, 
        M.F_CourtLongName,
        @DisciplineCode + N.F_GenderCode + C.F_EventCode + B.F_PhaseCode + A.F_MatchCode,
        A.F_VenueID,
        A.F_MatchStatusID,
        O.F_StatusLongName
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
				AND A.F_MatchDate IS NOT NULL AND A.F_VenueID IS NOT NULL
				AND B.F_PhaseCode = '1'
				AND A.F_MatchCode <> '50'
        ORDER BY A.F_MatchDate, CONVERT(DateTime, CONVERT(NVARCHAR(20), A.F_StartTime, 114), 114), C.F_Order
		
		DECLARE @Schedule XML

		DECLARE @OutputXML AS NVARCHAR(MAX)
        
        SET @OutputXML = (
        SELECT [Message].* ,
		Competition.F_ID ID,
				Competition.F_EventName + ' ' + Competition.F_PhaseName Name,
				Competition.F_Date [Date],
				Competition.F_StartTime StartTime,
				Competition.F_StatusDes [Status]
		FROM (SELECT 'GBSCH' [Type], 'SH' [Discipline], 'SH0000000' [ID])  [Message],
		#Temp_Table Competition 
		FOR XML AUTO	
        )
        
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'	+ @OutputXML

		SELECT @OutputXML AS MessageXML
	
SET NOCOUNT OFF
END

GO


--	EXEC Proc_CIS_SH_CompetitionSchedule 1,'ENG'