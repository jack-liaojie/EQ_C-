IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_WLEVE]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_WLEVE]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_CIS_WLEVE]
----功		  能：
----作		  者：wudingfang
----日		  期: 2011-02-15 
----修改	记录:


CREATE PROCEDURE [dbo].[Proc_CIS_WLEVE]
		@DisciplineCode         AS CHAR(2),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	SET LANGUAGE ENGLISH
	
	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

 
 	DECLARE @SQL		    NVARCHAR(max)


	SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D 
    WHERE F_DisciplineCode = @DisciplineCode

	CREATE TABLE #Temp_Event
	(
	    [EventID] INT,
	    [ID]   NVARCHAR(10),
	    [Gender] NVARCHAR(10),
	    [EventName] NVARCHAR(50),
	    [VenueName] NVARCHAR(50),
	    [Date] NVARCHAR(11),
	    [Week] NVARCHAR(10),
	    [Time] NVARCHAR(10), 
	    [Status] NVARCHAR(10),      
	)

	INSERT #Temp_Event 
	([EventID],[ID],[Gender],[EventName],[VenueName],[Date],[Week],[Time],[Status])
	(
	SELECT  
	  ISNULL(E.F_EventID,'') AS [EventID]
	, ('WL'+cast(SEX.F_GenderCode as NVARCHAR(1))+E.F_EventCode+'000') AS [ID] 
	, SEXD.F_SexLongName AS [Gender]
	, ISNULL(ED.F_EventLongName,'') AS [EventName]
	, NULL AS [VenueName]
	, ISNULL(convert(varchar(11),E.F_OpenDate,113),'') AS [Date]
	, ISNULL(datename(weekday,E.F_OpenDate),'')  AS [Week]
	, ISNULL(convert(varchar(5),E.F_OpenDate,08),'') AS [Time]
	, ISNULL(SD.F_StatusLongName,'')  AS [Status]
	FROM TS_Event AS E 
	LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex AS SEX ON E.F_SexCode = SEX.F_SexCode
	LEFT JOIN TC_Sex_Des AS SEXD ON E.F_SexCode = SEXD.F_SexCode AND SEXD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Status_Des AS SD ON E.F_EventStatusID = SD.F_StatusID AND SD.F_LanguageCode = @LanguageCode	
	WHERE E.F_DisciplineID = @DisciplineID
	)

	CREATE TABLE #Temp_Group
	(
	    [EventID] INT,
	    [ID]   NVARCHAR(10),
	    [GroupName] NVARCHAR(50),
	    [VenueName] NVARCHAR(50),
	    [Date] NVARCHAR(11),
	    [Week] NVARCHAR(10),
	    [Time] NVARCHAR(10), 
	    [Status] NVARCHAR(10), 
		[Order]	int,
	)
	
	INSERT #Temp_Group 
	([EventID],[ID],[GroupName],[VenueName],[Date],[Week],[Time],[Status],[Order])
	(
	SELECT  
	  ISNULL(E.F_EventID,'') AS [EventID]
	, ('WL'+cast(SEX.F_GenderCode as NVARCHAR(1))+E.F_EventCode+P.F_PhaseCode+'00') AS [ID] 
	, ISNULL(PD.F_PhaseLongName,'') AS [GroupName]
	, VD.F_VenueLongName AS [VenueName]
	, ISNULL(convert(varchar(11),M.F_MatchDate,113),'') AS [Date]
	, ISNULL(datename(weekday,M.F_MatchDate),'')  AS [Week]
	, ISNULL(convert(varchar(5),M.F_StartTime,08),'') AS [Time]
	, ISNULL(SD.F_StatusLongName,'')  AS [Status]
	, '' AS [Order]
	FROM TS_Phase AS P 
	LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TC_Sex AS SEX ON E.F_SexCode = SEX.F_SexCode
	LEFT JOIN TC_Sex_Des AS SEXD ON E.F_SexCode = SEXD.F_SexCode AND SEXD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match AS M ON M.F_PhaseID = P.F_PhaseID AND M.F_MatchCode='01'
	LEFT JOIN TC_Status_Des AS SD ON P.F_PhaseStatusID = SD.F_StatusID AND SD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Venue_Des AS VD ON VD.F_VenueID = M.F_VenueID AND VD.F_LanguageCode=@LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID
	)

    
	DECLARE @Temp_Event AS NVARCHAR(MAX)
	SET @Temp_Event = ( SELECT [Event].[ID] AS [ID],
	                        [Event].[Gender] AS [Gender],
	                        [Event].[EventName] AS [EventName],
	                        [Event].[VenueName] AS [VenueName],
	                        [Event].[Date] AS [Date],
	                        [Event].[Week] AS [Week],
	                        [Event].[Time] AS [Time],
	                        [Event].[Status] AS [Status],	
	                        [Group].ID AS [ID],
	                        [Group].[GroupName] AS [GroupName],
	                        [Group].[VenueName] AS [VenueName],
	                        [Group].[Date] AS [Date],
	                        [Group].[Week] AS [Week],
	                        [Group].[Time] AS [Time],
	                        [Group].[Status] AS [Status],
	                        [Group].[Order] AS [Order]
	            FROM #Temp_Event AS [Event] 
				LEFT JOIN #Temp_Group AS [Group] ON [Event].EventID = [Group].EventID
			FOR XML AUTO)

	IF @Temp_Event IS NULL
	BEGIN
		SET @Temp_Event = N''
	END


	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Type = "WLEVE"'
							+N' ID = "WL0000000"'
							+N' Discipline = "'+ @DisciplineCode + '"'
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Temp_Event
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END
/*
    EXEC Proc_CIS_WLEVE 'WL','ENG'
*/