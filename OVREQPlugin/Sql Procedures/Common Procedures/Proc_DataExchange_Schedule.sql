IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Schedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DataExchange_Schedule]
----功		  能：赛事计划(M1011)。
----作		  者：郑金勇
----日		  期: 2010-04-19 
----修 改 记  录: 
/*
         日期             修改人            修改内容
         2010-12-22       李燕              Schedule中Status取自TC_Status中的F_StatusCode,与CommonCode一致
         2011-01-21       郑金勇            Schedule中Order取自Match中的RaceNum,要求各个单项应该输入RaceNum
         2011-01-24		  郑金勇			Schedule中要过滤掉不符合条件的赛事。
											要求比赛的场馆、场地、比赛的日期、时间都不允许为空的比赛才允许发送!
											而且要求比赛的状态为Scheduled以后的才允许发送，Available、Configured这两种状态的比赛是不进行发送的！
		 2011-02-10		  郑金勇			删除掉Schedule_Name这一属性.
		 2011-03-04		  郑金勇			根据协议要求，过滤掉没有指定RaceNum的比赛。也就是说要求比赛的场馆、场地、比赛的日期、时间、RaceNumber都不为空的比赛才允许发送!
		 2011-03-09		  郑金勇			根据协议要求，允许发送没有场地的比赛。也就是说要求比赛的场馆、比赛的日期、时间、RaceNumber都不为空的比赛才允许发送!
		 2011-03-09		  郑金勇			如果消息体是空的就让整个消息为空,不发送此消息.
		 2011-03-16       郑金勇            添加MatchID的参数，可以发送单条的MatchStatus的Modify的消息，当MatchID为NULL或者-1是发送全部的Schedule。当MatchID不为空时发送单条Match的Schedule。

*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_Schedule]
		@Discipline			AS NVARCHAR(50),
		@MatchID			AS INT = NULL
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID		AS NVARCHAR(50)
	DECLARE @LanguageCode		AS CHAR(3)
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline
	
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
					WHERE D.F_DisciplineID = @DisciplineID AND A.F_MatchCode IS NOT NULL 
							AND A.F_MatchDate IS NOT NULL AND A.F_StartTime IS NOT NULL
							AND A.F_VenueID IS NOT NULL
							AND A.F_RaceNum IS NOT NULL
							AND ISNULL(A.F_MatchStatusID, 0) >= 30) AS Schedule
			FOR XML AUTO)
	END
	ELSE
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
			FROM (SELECT D.F_DisciplineCode, E.F_GenderCode, C.F_EventCode, B.F_PhaseCode, A.F_MatchCode, 'MODIFY' AS Operate
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
					WHERE A.F_MatchID = @MatchID AND D.F_DisciplineID = @DisciplineID AND A.F_MatchCode IS NOT NULL 
							AND A.F_MatchDate IS NOT NULL AND A.F_StartTime IS NOT NULL
							AND A.F_VenueID IS NOT NULL
							AND A.F_RaceNum IS NOT NULL
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


