IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Schedule_Single]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Schedule_Single]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_DataExchange_Schedule_Single]
----��		  �ܣ����¼ƻ�(M1011)��
----��		  �ߣ�֣����
----��		  ��: 2011-03-06 
----�� �� ��  ¼: 
/*
         ����             �޸���            �޸�����
		 2011-03-06		  ֣����			�˴洢���̽������͵�����Match��Schedule��Ϣ�仯��
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_Schedule_Single]
		@MatchID			AS INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @Discipline			AS NVARCHAR(10)
	DECLARE @LanguageCode		AS CHAR(3)
	DECLARE @OperateType		AS NVARCHAR(10)
	DECLARE @OutputXML			AS NVARCHAR(MAX)
	
	SET @LanguageCode = 'ENG'
	
	SELECT @Discipline = D.F_DisciplineCode FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID LEFT JOIN TS_Discipline AS D ON C.F_DisciplineID = D.F_DisciplineID

	IF EXISTS(SELECT * FROM TS_Match WHERE F_MatchID = @MatchID AND F_VenueID IS NOT NULL AND F_CourtID IS NOT NULL 
			AND F_MatchDate IS NOT NULL AND F_StartTime IS NOT NULL AND F_RaceNum IS NOT NULL
			AND ISNULL(F_MatchStatusID, 0) >= 30 )
	BEGIN
			SET @OperateType = 'MODIFY'
	END
	ELSE
	BEGIN
			SET @OperateType = 'DELETE'
	END 
	
	DECLARE @Content AS NVARCHAR(MAX)
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
			FROM (SELECT D.F_DisciplineCode, E.F_GenderCode, C.F_EventCode, B.F_PhaseCode, A.F_MatchCode, @OperateType AS Operate
					, K.F_StatusCode, G.F_VenueCode, H.F_CourtCode, 'Y' AS Start_Estimated, 'Y' AS Finish_Estimated
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
					LEFT JOIN TC_Venue AS G ON A.F_VenueID = G.F_VenueID 
					LEFT JOIN TC_Court AS H ON A.F_CourtID = H.F_CourtID
					LEFT JOIN TC_Status AS K ON A.F_MatchStatusID = K.F_StatusID
					LEFT JOIN TS_Session AS J ON A.F_SessionID = J.F_SessionID
					WHERE A.F_MatchID = @MatchID AND A.F_MatchCode IS NOT NULL 
							AND A.F_MatchDate IS NOT NULL AND A.F_StartTime IS NOT NULL
							AND A.F_VenueID IS NOT NULL AND A.F_CourtID IS NOT NULL
							AND A.F_RaceNum IS NOT NULL
							AND ISNULL(A.F_MatchStatusID, 0) >= 30) AS Schedule
			FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
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


--EXEC Proc_DataExchange_Schedule_Single 30