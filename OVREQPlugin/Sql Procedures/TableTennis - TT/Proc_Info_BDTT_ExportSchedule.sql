IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_BDTT_ExportSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_BDTT_ExportSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Info_BDTT_ExportSchedule]
----功		  能：获取Info需要的条目
----作		  者：王强
----日		  期: 2012-09-13

CREATE PROCEDURE [dbo].[Proc_Info_BDTT_ExportSchedule]
	
AS
BEGIN
	
SET NOCOUNT ON
	
	DECLARE @VenueCode NVARCHAR(10)
	DECLARE @DisCode NVARCHAR(10)
	DECLARE @Xml NVARCHAR(MAX)
	
	SELECT @VenueCode = C.F_VenueCode, @DisCode = A.F_DisciplineCode
	FROM TS_Discipline AS A 
	LEFT JOIN TD_Discipline_Venue AS B ON B.F_DisciplineID = A.F_DisciplineID
	LEFT JOIN TC_Venue AS C ON C.F_VenueID = B.F_VenueID
	WHERE A.F_Active = 1
	
	CREATE TABLE #TMP_TABLE
	( 
	    F_IsRank INT,
		F_InnerOrder INT,
		F_DateID INT,
		F_DayOrder INT,
		F_MatchID INT,
		F_EventID INT,
		F_PlayerType INT,
		F_PhaseType INT,
		F_StartTime DATETIME,
		F_MatchDate DATETIME,
		F_PhaseName NVARCHAR(100)
	)
	
	CREATE TABLE #REPORT_TYPE
	(
		ReportType NVARCHAR(10)
	)
	
	DECLARE @TypeString NVARCHAR(10)
	IF EXISTS (SELECT * FROM TS_Discipline WHERE F_Active = 1 AND F_DisciplineCode = 'BD' )
		SET @TypeString = 'C73A'
	ELSE
		SET @TypeString = 'C75'
	
	INSERT INTO #REPORT_TYPE
	        ( ReportType )
	VALUES  ( N'C51'),( @TypeString)
		
	DECLARE @Date DATETIME
	SELECT @Date = F_Date FROM TS_DisciplineDate WHERE F_DateOrder = 4
	
	INSERT INTO #TMP_TABLE
	        ( 
			  F_IsRank,
			  F_InnerOrder ,
			  F_DateID,
			  F_DayOrder,
	          F_MatchID ,
	          F_EventID ,
	          F_PlayerType ,
	          F_PhaseType,
			  F_StartTime,
			  F_MatchDate,
			  F_PhaseName
	          
	        )
	(
		SELECT 0,ROW_NUMBER() OVER(PARTITION BY D.F_DisciplineDateID, C.F_EventID,B.F_PhaseType ORDER BY A.F_StartTime, A.F_MatchID),
		D.F_DisciplineDateID, D.F_DateOrder,
		A.F_MatchID, B.F_EventID, C.F_PlayerRegTypeID, B.F_PhaseType,
		A.F_StartTime, A.F_MatchDate, CASE WHEN C.F_PlayerRegTypeID = 3 THEN 
							( CASE WHEN B.F_PhaseType = 2 THEN N'第一阶段' ELSE N'第二阶段' END ) 
							ELSE N'' END
							+ N'(' + DATENAME( dd,A.F_MatchDate) + N'日)'
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
		LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
		LEFT JOIN TS_DisciplineDate AS D ON DATEDIFF(dd, A.F_MatchDate, D.F_Date) = 0
		WHERE D.F_DisciplineDateID IS NOT NULL AND A.F_StartTime IS NOT NULL
				AND A.F_MatchDate IS NOT NULL
	)
	
	DECLARE @AddCount INT
	SELECT @AddCount = COUNT(F_MatchID) FROM #TMP_TABLE
	
	INSERT INTO #TMP_TABLE
	        ( 
	          F_IsRank,
			  F_InnerOrder ,
	          F_DateID ,
	          F_DayOrder ,
	          F_MatchID ,
	          F_EventID ,
	          F_PlayerType ,
	          F_PhaseType ,
	          F_StartTime ,
	          F_MatchDate ,
	          F_PhaseName
	        )
	( 
		SELECT 1, (ROW_NUMBER() OVER(PARTITION BY C.F_EventID ORDER BY F_MatchDate DESC, F_StartTime DESC)),
		-1,-1, A.F_MatchID, C.F_EventID, C.F_PlayerRegTypeID, B.F_PhaseType, A.F_StartTime, A.F_MatchDate, N'(' + DATENAME( dd,A.F_MatchDate) + N'日)'
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
		LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
		WHERE A.F_StartTime IS NOT NULL AND A.F_MatchDate IS NOT NULL
	)
	
	DELETE FROM #TMP_TABLE WHERE F_InnerOrder != 1
	
	UPDATE #TMP_TABLE SET F_InnerOrder = B.F_Order
	FROM #TMP_TABLE AS A
	LEFT JOIN 
	(
		SELECT ROW_NUMBER() OVER(ORDER BY F_MatchDate, F_IsRank, F_StartTime, F_PlayerType, F_MatchID) AS F_Order, F_MatchID 
		FROM #TMP_TABLE
	) AS B ON B.F_MatchID = A.F_MatchID
	
	--(SELECT 	@DisCode AS DisciplineCode, dbo.Fun_Report_BD_GetDateTime(GETDATE(), 10 ) AS [Date],
	--	     dbo.Fun_Report_BD_GetDateTime(GETDATE(), 14 ) AS [Time], N'CHI' AS [Language],
	SET @Xml = 

				  (
					SELECT dbo.Fun_Info_BDTT_LN_GetScheduleRSC(F_EventID, 
					CASE F_PlayerType WHEN 3 THEN (CASE F_PhaseType WHEN 31 THEN 2 ELSE 1 END)
						ELSE 0 END, F_DayOrder) AS Code,
				   F_PhaseName AS [Name],
				   dbo.Fun_Report_BD_GetDateTime(F_MatchDate, 10) AS StartDate,
				   dbo.Fun_Report_BD_GetDateTime(F_StartTime, 14) AS StartTime,
				   F_InnerOrder AS [Order],
				   ISNULL(@VenueCode,N'') AS VenueCode
				   ,
					   (
							SELECT ReportType AS [Type],
							dbo.Fun_Info_BDTT_LN_GetScheduleRSC( F_EventID, 
							CASE F_PlayerType WHEN 3 THEN (CASE F_PhaseType WHEN 31 THEN 2 ELSE 1 END)
							ELSE 0 END, 
							F_DayOrder) + N'UP.' +  ReportType + N'.CHI.1.0' AS [FileName]
							FROM #REPORT_TYPE WHERE F_IsRank = 0 FOR XML RAW(N'Detail'),TYPE
							
					   ) 
				   FROM #TMP_TABLE WHERE F_IsRank = 0
				   FOR XML RAW( N'Schedule')
				   )
	
	SET @Xml = @Xml +			   
				   ( 
					   SELECT dbo.Fun_Info_BDTT_LN_GetScheduleRSC(F_EventID, 
						CASE F_PlayerType WHEN 3 THEN (CASE F_PhaseType WHEN 31 THEN 2 ELSE 1 END)
							ELSE 0 END, F_DayOrder) AS Code,
					   F_PhaseName AS [Name],
					   dbo.Fun_Report_BD_GetDateTime(F_MatchDate, 10) AS StartDate,
					   dbo.Fun_Report_BD_GetDateTime(F_StartTime, 14) AS StartTime,
					   F_InnerOrder AS [Order],
					   ISNULL(@VenueCode,N'') AS VenueCode
					   ,
						   (
								SELECT 'C92' AS [Type],
								dbo.Fun_Info_BDTT_LN_GetScheduleRSC( F_EventID, 
								CASE F_PlayerType WHEN 3 THEN (CASE F_PhaseType WHEN 31 THEN 2 ELSE 1 END)
								ELSE 0 END, 
								F_DayOrder) + N'UP.C92.CHI.1.0' AS [FileName]
								FOR XML RAW(N'Detail'),TYPE
								
						   )
					   FROM #TMP_TABLE WHERE F_IsRank = 1 FOR XML RAW( N'Schedule')
					   ) 
	
	SET @xml = (
			 SELECT @DisCode AS DisciplineCode, dbo.Fun_Report_BD_GetDateTime(GETDATE(), 10 ) AS [Date],
		     dbo.Fun_Report_BD_GetDateTime(GETDATE(), 14 ) AS [Time], N'CHI' AS [Language], 
		     CONVERT( XML, @xml)
		     FOR XML RAW('Message') )
	SELECT N'<?xml version="1.0" encoding="UTF-8"?>' + @xml,'SCHEDULE_ALL'

SET NOCOUNT OFF
END


GO

--EXEC [dbo].[Proc_Info_BDTT_ExportSchedule]