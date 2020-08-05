IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WR_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WR_Schedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_WR_Schedule]
----功   能：比赛日程列表
----作	 者：宁顺泽
----日   期：2012-08-20 

/*
	参数说明：
	序号	参数名称	参数说明
*/

/*
	功能描述：按照交换协议规范，组织数据。
			  此存储过程遵照内部的MS SQL SERVER编码规范。
			  
*/

/*
修改记录：
	序号	日期			修改者		修改内容
	1						

*/

CREATE PROCEDURE [dbo].[Proc_Info_WR_Schedule]
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
	

	CREATE TABLE #REPORT_TYPE
	(
		ReportType NVARCHAR(10)
	)
	
	CREATE TABLE #TMP_TABLE
	(
		Code nvarchar(10),
		Name nvarchar(100),
		StartDate nvarchar(20),
		StartTime nvarchar(20),
		[Order]   nvarchar(10),
		VenueCode nvarchar(20)
	)
	
				insert into  #TMP_TABLE(Code,Name,StartDate,StartTime,[Order],VenueCode)
				select 
						@DisCode+Gender.F_GenderCode+e.F_EventCode+'000' as Code
						,Ed.F_EventLongName as Name
						,REPLACE(LEFT(CONVERT(NVARCHAR(MAX), E.F_OpenDate , 120 ), 10), '-', '') as StartDate
						,REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), E.F_OpenDate , 121 ), 12), 8), ':', ''), '.', '') AS [StartTime]
						,CONVERT(nvarchar(10),e.F_Order) as [Order]
						,V.F_VenueCode as VenueCode
						from TS_Event as E
					LEFT JOIN TS_Discipline as D
						ON E.F_DisciplineID=D.F_DisciplineID
					LEFT JOIN TD_Discipline_Venue as DV
						ON DV.F_DisciplineID=D.F_DisciplineID
					LEFT JOIN TC_Venue as V
						ON V.F_VenueID=DV.F_VenueID
					LEFT JOIN TC_Sex as Gender
						ON E.F_SexCode=Gender.F_SexCode
					LEFT JOIN TS_Event_Des as ED
						ON E.F_EventID=ED.F_EventID and Ed.F_LanguageCode='CHN'		
	
	INSERT INTO #REPORT_TYPE
	        ( ReportType )
	VALUES  ( N'C51'),( N'C73'),(N'C92')
		
	DECLARE @Date DATETIME
	SELECT @Date = F_Date FROM TS_DisciplineDate WHERE F_DateOrder = 4
	
	SET @Xml = 
	(SELECT 	@DisCode AS [DisciplineCode], REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') AS [Date],
		     REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), 8), ':', ''), '.', '') AS [Time], 
		     N'CHI' AS [Language],
				  (
				  select 
					Code as [Code]
				    ,Name as Name
				    ,StartDate as StartDate
				    ,StartTime as StartTime
				    ,[Order] 
				    ,VenueCode,
						(
							SELECT ReportType AS [Type],
							Code+N'.'+ReportType + N'.CHI.1.0' AS [FileName]
							FROM #REPORT_TYPE FOR XML RAW(N'Detail'),TYPE
					   ) 

				   FROM #TMP_TABLE FOR XML RAW( N'Schedule'),TYPE
				 ) FOR XML RAW(N'Message')
	)
	
	SELECT N'<?xml version="1.0" encoding="UTF-8"?>' + @xml,@DisCode+N'_Schedule_All'

SET NOCOUNT OFF
END





GO


--EXEC Proc_Info_WR_Schedule 