IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Schedule_WL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Schedule_WL]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DataExchange_Schedule_WL]
----功		  能：赛事计划(M1011)。
----作		  者：崔凯
----日		  期: 2011-02-27 
----修 改 记  录: 
/*
         日期             修改人            修改内容
         2011-4-27       崔凯              Schedule中Status取Phase的Status
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_Schedule_WL]
		@Discipline			AS NVARCHAR(50),
		@MatchID			AS INT = NULL
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID		AS NVARCHAR(50)
	DECLARE @LanguageCode		AS CHAR(3)
	DECLARE @PhaseID			INT
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	
	DECLARE @Content AS NVARCHAR(MAX)
	IF (@MatchID IS NULL) OR (@MatchID = -1)
	BEGIN	
		SET @Content = (SELECT Schedule.F_DisciplineCode AS Discipline
			, Schedule.F_GenderCode AS Gender
			, Schedule.F_EventCode AS [Event]
			, Schedule.F_PhaseCode AS Phase
			, Schedule.F_MatchCode AS Unit
			, Schedule.Operate
			, ISNULL(Schedule.F_StatusCode, '') AS [Status]
			, ISNULL(Schedule.F_VenueCode, '') AS Venue
			, ISNULL(Schedule.F_CourtCode, '') AS Location
			, ISNULL(Schedule.Start_Date, '00000000') AS Start_Date
			, ISNULL(Schedule.Start_Time, '0000') AS Start_Time
			, ISNULL(Schedule.Start_Estimated, '') AS Start_Estimated
			, ISNULL(Schedule.Start_Date, '00000000') AS Finish_Date
			, ISNULL(Schedule.Finish_Time, '0000') AS Finish_Time
			, ISNULL(Schedule.Finish_Estimated, '') AS Finish_Estimated
			, ISNULL(Schedule.F_RaceNum, '') AS [Order]
			FROM (SELECT D.F_DisciplineCode, E.F_GenderCode, C.F_EventCode, B.F_PhaseCode, A.F_MatchCode, 'ALL' AS Operate
					, K.F_StatusCode, MD.F_MatchLongName,PD.F_PhaseLongName,ED.F_EventLongName, G.F_VenueCode, H.F_CourtCode, 'Y' AS Start_Estimated, 'Y' AS Finish_Estimated
					, A.F_MatchDate, A.F_StartTime, A.F_EndTime
					, REPLACE(LEFT(CONVERT(NVARCHAR(MAX), A.F_MatchDate , 120 ), 10), '-', '') AS Start_Date
					, REPLACE(SUBSTRING(CONVERT(NVARCHAR(MAX), A.F_StartTime , 121 ), 12, 5), ':', '')  AS Start_Time
					, REPLACE(SUBSTRING(CONVERT(NVARCHAR(MAX), A.F_EndTime , 121 ), 12, 5), ':', '')  AS Finish_Time 
					, A.F_RaceNum 
					FROM TS_Match AS A 
					LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
					LEFT JOIN TS_Discipline AS D ON C.F_DisciplineID = D.F_DisciplineID 
					LEFT JOIN TC_Sex AS E ON C.F_SexCode = E.F_SexCode 
					
					--For WL
					LEFT JOIN TS_Match_Des AS MD ON A.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Phase_Des AS PD ON B.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Event_Des AS ED ON C.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
					
					LEFT JOIN TC_Venue AS G ON A.F_VenueID = G.F_VenueID 
					LEFT JOIN TC_Court AS H ON A.F_CourtID = H.F_CourtID
					LEFT JOIN TC_Status AS K ON B.F_PhaseStatusID = K.F_StatusID
					LEFT JOIN TS_Session AS J ON A.F_SessionID = J.F_SessionID
					WHERE D.F_DisciplineID = @DisciplineID AND A.F_MatchCode IS NOT NULL 
							AND A.F_MatchDate IS NOT NULL AND A.F_StartTime IS NOT NULL
							AND A.F_VenueID IS NOT NULL
							--For WL
							AND A.F_MatchCode = '01' 
							--AND A.F_RaceNum IS NOT NULL
							AND ISNULL(B.F_PhaseStatusID, 0) >= 30) AS Schedule
			FOR XML AUTO)
	END
	ELSE
	BEGIN
		DECLARE @TMatchID  INT 
		SET @TMatchID = (SELECT TOP 1 F_MatchID FROM TS_Match 
				WHERE F_PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID) AND F_MatchCode='01') 
		SET @Content = (SELECT Schedule.F_DisciplineCode AS Discipline
			, Schedule.F_GenderCode AS Gender
			, Schedule.F_EventCode AS [Event]
			, Schedule.F_PhaseCode AS Phase
			, Schedule.F_MatchCode AS Unit
			, Schedule.Operate
			, ISNULL(Schedule.F_StatusCode, '') AS [Status]
			, ISNULL(Schedule.F_VenueCode, '') AS Venue
			, ISNULL(Schedule.F_CourtCode, '') AS Location
			, ISNULL(Schedule.Start_Date, '00000000') AS Start_Date
			, ISNULL(Schedule.Start_Time, '0000') AS Start_Time
			, ISNULL(Schedule.Start_Estimated, '') AS Start_Estimated
			, ISNULL(Schedule.Start_Date, '00000000') AS Finish_Date
			, ISNULL(Schedule.Finish_Time, '0000') AS Finish_Time
			, ISNULL(Schedule.Finish_Estimated, '') AS Finish_Estimated
			, ISNULL(Schedule.F_RaceNum, '') AS [Order]
			FROM (SELECT D.F_DisciplineCode, E.F_GenderCode, C.F_EventCode, B.F_PhaseCode, A.F_MatchCode, 'MODIFY' AS Operate
					, K.F_StatusCode, MD.F_MatchLongName,PD.F_PhaseLongName,ED.F_EventLongName, G.F_VenueCode, H.F_CourtCode, 'Y' AS Start_Estimated, 'Y' AS Finish_Estimated
					, A.F_MatchDate, A.F_StartTime, A.F_EndTime
					, REPLACE(LEFT(CONVERT(NVARCHAR(MAX), A.F_MatchDate , 120 ), 10), '-', '') AS Start_Date
					, REPLACE(SUBSTRING(CONVERT(NVARCHAR(MAX), A.F_StartTime , 121 ), 12, 5), ':', '')  AS Start_Time
					, REPLACE(SUBSTRING(CONVERT(NVARCHAR(MAX), A.F_EndTime , 121 ), 12, 5), ':', '')  AS Finish_Time 
					, A.F_RaceNum 
					FROM TS_Match AS A 
					LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID
					LEFT JOIN TS_Discipline AS D ON C.F_DisciplineID = D.F_DisciplineID 
					LEFT JOIN TC_Sex AS E ON C.F_SexCode = E.F_SexCode 
					
					--For WL
					LEFT JOIN TS_Match_Des AS MD ON A.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Phase_Des AS PD ON B.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Event_Des AS ED ON C.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
					
					LEFT JOIN TC_Venue AS G ON A.F_VenueID = G.F_VenueID 
					LEFT JOIN TC_Court AS H ON A.F_CourtID = H.F_CourtID
					LEFT JOIN TC_Status AS K ON  B.F_PhaseStatusID  = K.F_StatusID
					LEFT JOIN TS_Session AS J ON A.F_SessionID = J.F_SessionID
					WHERE A.F_MatchID = @TMatchID AND D.F_DisciplineID = @DisciplineID AND A.F_MatchCode IS NOT NULL 
							AND A.F_MatchDate IS NOT NULL AND A.F_StartTime IS NOT NULL
							AND A.F_VenueID IS NOT NULL
							--AND A.F_RaceNum IS NOT NULL	
							AND ISNULL(A.F_MatchStatusID, 0) >= 30) AS Schedule
							
			FOR XML AUTO)

	END 
	
	
	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Version = "1.0"'
							+N' Category = "VRS"' 
							+N' Origin = "VRS"'
							+N' RSC = "' + @Discipline + '0000000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "0"'
							+N' Event = "000"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M1011"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="' + REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "' + REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '') + '"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END


GO


/*

EXEC Proc_DataExchange_Schedule_WL 'WL',129

*/

