IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_TE_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_TE_Schedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_TE_Schedule]
----功   能：比赛日程列表
----作	 者：郑金勇
----日   期：2010-08-20 

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

CREATE PROCEDURE [dbo].[Proc_Info_TE_Schedule]
		@DateID			INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @Discipline AS NVARCHAR(50)
	DECLARE @LanguageCode AS CHAR(3)
	
	SET @Discipline = N'TE'
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @SelDate AS DATETIME
	SELECT @SelDate = F_Date FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DateID

	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @Content AS NVARCHAR(MAX)
	

	CREATE TABLE #Temp_Schedule(
									[Code]					NVARCHAR(50),
									[Name]					NVARCHAR(100),
									[StartDate]             NVARCHAR(100),
									[StartTime]             NVARCHAR(100),
									[Order]					INT,
									[VenueCode]				NVARCHAR(100),
									[F_MatchID]				INT,
									[F_PhaseID]				INT,
									[F_EventID]				INT,
									[F_DisciplineID]		INT,
									[F_MatchOrder]			INT,
									[F_PhaseOrder]			INT,
									[F_EventOrder]			INT,
								)

	CREATE TABLE #Temp_Reports(
									[Code]					NVARCHAR(50),
									[Type]					NVARCHAR(100),--0=秩序单；1=成绩公告；2=名次公告；3=破纪录信息；4=其它表单
									[FileName]				NVARCHAR(100),
								)
								
	IF @DateID = -1
	BEGIN
		INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [VenueCode], [Order], [F_MatchID], [F_PhaseID], [F_EventID], [F_DisciplineID], [F_MatchOrder], [F_PhaseOrder], [F_EventOrder])
		SELECT D.F_DisciplineCode + Gender.F_GenderCode + E.F_EventCode + P.F_PhaseCode + M.F_MatchCode AS [Code],
			   DS.F_DisciplineLongName + ES.F_EventLongName + PS.F_PhaseLongName + MS.F_MatchLongName AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), M.F_MatchDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), M.F_StartTime , 121 ), 12), 8), ':', ''), '.', '') AS StartTime
			   , V.F_VenueCode, M.F_MatchNum, M.F_MatchID, P.F_PhaseID, E.F_EventID, D.F_DisciplineID, M.F_Order, P.F_Order, E.F_Order
			   FROM TS_Match AS M LEFT JOIN TS_Match_Des AS MS ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Phase_Des AS PS ON P.F_PhaseID = PS.F_PhaseID AND PS.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID LEFT JOIN TS_Event_Des AS ES ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID LEFT JOIN TS_Discipline_Des AS DS ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
			LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode
		WHERE M.F_RaceNum IS NOT NULL AND D.F_DisciplineCode = @Discipline
			--轮空的比赛不编排RaceNum，轮空的比赛也不做展现。
	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [VenueCode], [Order], [F_MatchID], [F_PhaseID], [F_EventID], [F_DisciplineID], [F_MatchOrder], [F_PhaseOrder], [F_EventOrder])
		SELECT D.F_DisciplineCode + Gender.F_GenderCode + E.F_EventCode + P.F_PhaseCode + M.F_MatchCode AS [Code],
			   DS.F_DisciplineLongName + ES.F_EventLongName + PS.F_PhaseLongName + MS.F_MatchLongName AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), M.F_MatchDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), M.F_StartTime , 121 ), 12), 8), ':', ''), '.', '') AS StartTime
			   , V.F_VenueCode, M.F_MatchNum, M.F_MatchID, P.F_PhaseID, E.F_EventID, D.F_DisciplineID, M.F_Order, P.F_Order, E.F_Order
			   FROM TS_Match AS M LEFT JOIN TS_Match_Des AS MS ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Phase_Des AS PS ON P.F_PhaseID = PS.F_PhaseID AND PS.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID LEFT JOIN TS_Event_Des AS ES ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID LEFT JOIN TS_Discipline_Des AS DS ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
			LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode
		WHERE M.F_RaceNum IS NOT NULL AND D.F_DisciplineCode = @Discipline AND M.F_MatchDate = @SelDate
			--轮空的比赛不编排RaceNum，轮空的比赛也不做展现。
	END

	INSERT INTO #Temp_Reports(Code, [FileName], [Type])
		SELECT Code, Code + N'.C75.CHI.1.0', N'C75' FROM #Temp_Schedule 

	----插入项目的名次公告
	INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [Order], [VenueCode], [F_EventID], F_EventOrder, F_PhaseOrder, F_MatchOrder)
		SELECT D.F_DisciplineCode + Gender.F_GenderCode + E.F_EventCode + N'000' AS [Code],
			   DS.F_DisciplineLongName + ES.F_EventLongName AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), E.F_OpenDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), E.F_OpenDate , 121 ), 12), 8), ':', ''), '.', '') AS StartTime
			   , 1 AS [Order]
			   , N'' AS [VenueCode]
			   , E.F_EventID
			   , E.F_Order
			   , 0 AS F_PhaseOrder
			   , 0 AS F_MatchOrder
			   FROM TS_Event AS E LEFT JOIN TS_Event_Des AS ES ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID 
					LEFT JOIN TS_Discipline_Des AS DS ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode

	INSERT INTO #Temp_Reports(Code, [FileName], [Type])
		SELECT D.F_DisciplineCode + Gender.F_GenderCode + E.F_EventCode + N'000' AS [Code]
			   , D.F_DisciplineCode + Gender.F_GenderCode + E.F_EventCode + N'000' + N'.C92A.CHI.1.0' AS [FileName]
			   , N'C92A'
			   FROM TS_Event AS E LEFT JOIN TS_Event_Des AS ES ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
					LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID 
					LEFT JOIN TS_Discipline_Des AS DS ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
					LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode

	SET		@Content = (
						SELECT [Schedule].[Code], [Schedule].[Name], [Schedule].[StartDate], [Schedule].[StartTime]
									, [Schedule].[Order], [Schedule].[VenueCode]
									, [Detail].[Type]
									, [Detail].[FileName]
							 FROM #Temp_Schedule AS [Schedule] LEFT JOIN #Temp_Reports AS [Detail]
								ON [Schedule].Code = [Detail].Code 
						FOR XML AUTO
						)


		 
		 
   --SELECT cast( @Content AS XML )
	
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'DisciplineCode = "' + @Discipline + '"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), 5), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'

	DECLARE @FileName	AS NVARCHAR(100)
	IF @DateID = -1
	BEGIN
		SET @FileName =	@Discipline + N'_Schedule_ALL'
	END
	ELSE
	BEGIN
		SET @FileName =	@Discipline + N'_Schedule_'+ LEFT(CONVERT(NVARCHAR(MAX), @SelDate, 120), 10)
	END
	
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC Proc_Info_TE_Schedule 1