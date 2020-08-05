IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_WLSCH]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_WLSCH]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_CIS_WLSCH]
----功		  能：
----作		  者：wudingfang
----日		  期: 2011-01-14 
----修改	记录:
/*
			2011-03-01   崔凯	抓举挺举比赛应合并成一场比赛
*/


CREATE PROCEDURE [dbo].[Proc_CIS_WLSCH]
		@DisciplineCode         AS CHAR(2),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

 
 	DECLARE @SQL		    NVARCHAR(max)


	SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D 
    WHERE F_DisciplineCode = @DisciplineCode

	CREATE TABLE #Temp_Date
	(
	    [ID]   INT,
	    [Name] NVARCHAR(50),
	    [Date] NVARCHAR(10),         
		[Order]	int,
	)

	INSERT #Temp_Date 
	([ID],[Name],[Date],[Order])
	(
	SELECT  
	  ISNULL(DD.F_DisciplineDateID,'') AS [ID]
	, ISNULL(DDD.F_DateLongDescription,'') AS [Name]
	, ISNULL(CONVERT(NVARCHAR(100), DD.F_Date, 23),'')  AS [Date]
	, ISNULL(DD.F_DateOrder,'')  AS [Order]
	FROM TS_DisciplineDate AS DD 
	LEFT JOIN TS_DisciplineDate_Des AS DDD ON DD.F_DisciplineDateID = DDD.F_DisciplineDateID AND DDD.F_LanguageCode = @LanguageCode
	WHERE DD.F_DisciplineID = @DisciplineID
	)

	CREATE TABLE #Temp_Session
	(
	    [DateID]        INT,
	    [ID]            INT, 
		[Name]			NVARCHAR(50),
		[Start_Time]    NVARCHAR(10),
		[End_Time]      NVARCHAR(10),
        [Order]			INT,
	)
	
	INSERT #Temp_Session
	([DateID],[ID],[Name],[Start_Time],[End_Time],[Order])
	(SELECT 
	 DD.F_DisciplineDateID, 
	 S.F_SessionID,	 
	 ('Session '+cast(S.F_SessionNumber as NVARCHAR(10))) AS [Name],
	 LEFT(CONVERT(NVARCHAR(100), S.F_SessionTime, 114), 5),
	 LEFT(CONVERT(NVARCHAR(100), S.F_SessionEndTime, 114), 5),
	 S.F_SessionNumber
		FROM TS_DisciplineDate AS DD 
		LEFT JOIN TS_Session AS S ON DD.F_Date = S.F_SessionDate
		WHERE DD.F_DisciplineID = @DisciplineID
	)

	CREATE TABLE #Temp_Competition
	(
	    [SessionID]        INT,
	    [EventID]          NVARCHAR(10), 
	    [GroupID]          NVARCHAR(10), 
		[Name]			NVARCHAR(50),
		[Start_Time]    NVARCHAR(10),
		[End_Time]      NVARCHAR(10),
		[Status]        NVARCHAR(10),		
        [Order]			INT,
	)

	INSERT #Temp_Competition
	([SessionID],[EventID],[GroupID],[Name],[Start_Time],[End_Time],[Status],[Order])
	(SELECT distinct
	 S.F_SessionID,	 
	 ('WL'+cast(SEX.F_GenderCode as NVARCHAR(1))+E.F_EventCode+'000') AS [EventID],
	 ('WL'+cast(SEX.F_GenderCode as NVARCHAR(1))+E.F_EventCode+P.F_PhaseCode+'00') AS [GroupID],
 	 ED.F_EventLongName + ' - ' + PD.F_PhaseLongName AS [Name],
	 LEFT(CONVERT(NVARCHAR(100), M1.F_StartTime, 114), 5),
	 LEFT(CONVERT(NVARCHAR(100), M1.F_EndTime, 114), 5),
	 SD.F_StatusLongName,
	 ROW_NUMBER() OVER(ORDER BY S.F_SessionID, LEFT(CONVERT(NVARCHAR(100), M1.F_StartTime, 114), 5))
		FROM TS_Session AS S 
		INNER JOIN TS_Match AS M1 ON S.F_SessionID = M1.F_SessionID AND M1.F_MatchCode = '01'
		--INNER JOIN TS_Match AS M2 ON S.F_SessionID = M2.F_SessionID AND M2.F_MatchCode = '02'
		LEFT JOIN TS_Phase AS P ON M1.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Status_Des AS SD ON P.F_PhaseStatusID= SD.F_StatusID AND SD.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
		LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
		LEFT JOIN TC_Sex AS SEX ON E.F_SexCode = SEX.F_SexCode
		LEFT JOIN TC_Sex_Des AS SEXD ON E.F_SexCode = SEXD.F_SexCode AND SEXD.F_LanguageCode = @LanguageCode
		WHERE S.F_DisciplineID = @DisciplineID
	)
    
	DECLARE @Temp_Date AS NVARCHAR(MAX)
	SET @Temp_Date = ( SELECT [Date].[Name] AS [Name],
	                        [Date].[Date] AS [Date],
	                        [Date].[Order] AS [Order],
	                        [Session].[Name] AS [Name],
	                        [Session].[Start_Time] AS [Start_Time],
	                        [Session].[End_Time] AS [End_Time],
	                        [Session].[Order] AS [Order],
	                        [Competition].EventID AS [EventID],
	                        [Competition].GroupID AS [GroupID],
	                        [Competition].Name AS [Name],
	                        [Competition].[Start_Time] AS [Start_Time],
	                        [Competition].[End_Time] AS [End_Time],
	                        [Competition].[Status] AS [Status],
	                        [Competition].[Order] AS [Order]
	            FROM #Temp_Date AS [Date] 
				INNER JOIN #Temp_Session AS [Session] ON [Date].ID = [Session].DateID
				INNER JOIN #Temp_Competition AS [Competition] ON [Session].ID = [Competition].SessionID   
				ORDER BY [Date].[Order], [Session].[Order], [Competition].[Order]
			FOR XML AUTO)

	IF @Temp_Date IS NULL
	BEGIN
		SET @Temp_Date = N''
	END


	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Type = "WLSCH"'
							+N' ID = "WL0000000"'
							+N' Discipline = "'+ @DisciplineCode + '"'
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Temp_Date
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END
/*
    EXEC Proc_CIS_WLSCH 'WL','ENG'
*/
GO


