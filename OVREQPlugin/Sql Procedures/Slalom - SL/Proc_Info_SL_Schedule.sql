IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_SL_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_SL_Schedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_SL_Schedule]
----功   能：比赛日程列表
----作	 者：吴定昉
----日   期：2012-09-11 

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

CREATE PROCEDURE [dbo].[Proc_Info_SL_Schedule]
		@DateID			INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineCode AS NVARCHAR(50)
	DECLARE @OutputDiscCode AS NVARCHAR(50)
	DECLARE @LanguageCode   AS CHAR(3)
	
	SET @DisciplineCode = N'SL'
	SET @OutputDiscCode = N'CS'
	SET @LanguageCode = ISNULL( @LanguageCode, 'CHN')
	
	DECLARE @SelDate AS DATETIME
	SELECT @SelDate = F_Date FROM TS_DisciplineDate WHERE F_DisciplineDateID = @DateID

	DECLARE @OutputXML AS NVARCHAR(MAX)
	DECLARE @Content AS NVARCHAR(MAX)
	

	CREATE TABLE #Temp_Schedule(
								[Code]			  NVARCHAR(50),
								[Name]			  NVARCHAR(100),
								[StartDate]       NVARCHAR(100),
								[StartTime]       NVARCHAR(100),
								[Order]			  INT,
								[VenueCode]		  NVARCHAR(100),
								[F_MatchID]		  INT,
								[F_PhaseID]		  INT,
								[F_EventID]		  INT,
								[F_DisciplineID]  INT,
								[F_MatchOrder]	  INT,
								[F_PhaseOrder]	  INT,
								[F_EventOrder]	  INT,
								[PhaseCode]		  NVARCHAR(100),
								[MatchCode]		  NVARCHAR(100),
								)


	IF @DateID = -1
	BEGIN
		INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [VenueCode], [Order], [F_MatchID],
		 [F_PhaseID], [F_EventID], [F_DisciplineID], [F_MatchOrder], [F_PhaseOrder], [F_EventOrder], [PhaseCode], [MatchCode])
		SELECT @OutputDiscCode + Gender.F_GenderCode + 
		       [dbo].[Func_SL_GetOutputEventCode](Gender.F_GenderCode, E.F_EventCode) + 
		       P.F_PhaseCode + M.F_MatchCode AS [Code],
			   DS.F_DisciplineLongName + ES.F_EventLongName + PS.F_PhaseLongName + ISNULL(MS.F_MatchLongName,'') AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), M.F_MatchDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), M.F_StartTime , 121 ), 12), 8), ':', ''), '.', '') 
			   AS StartTime
			   , V.F_VenueCode, M.F_MatchNum, M.F_MatchID, P.F_PhaseID, E.F_EventID, D.F_DisciplineID
			   , M.F_Order, P.F_Order, E.F_Order
			   , P.F_PhaseCode, M.F_MatchCode
		FROM TS_Match AS M LEFT JOIN TS_Match_Des AS MS 
			   ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Phase_Des AS PS 
			   ON P.F_PhaseID = PS.F_PhaseID AND PS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID LEFT JOIN TS_Event_Des AS ES 
			   ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID 
			   LEFT JOIN TS_Discipline_Des AS DS 
			   ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
			   LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode
		WHERE D.F_DisciplineCode = @DisciplineCode
	END
	ELSE
	BEGIN
		INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [VenueCode], [Order], [F_MatchID],
		 [F_PhaseID], [F_EventID], [F_DisciplineID], [F_MatchOrder], [F_PhaseOrder], [F_EventOrder], [PhaseCode], [MatchCode])
		SELECT @OutputDiscCode + Gender.F_GenderCode + 
		       [dbo].[Func_SL_GetOutputEventCode](Gender.F_GenderCode, E.F_EventCode) + 
		       P.F_PhaseCode + M.F_MatchCode AS [Code],
			   DS.F_DisciplineLongName + ES.F_EventLongName + PS.F_PhaseLongName + ISNULL(MS.F_MatchLongName,'') AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), M.F_MatchDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), M.F_StartTime , 121 ), 12), 8), ':', ''), '.', '') 
			   AS StartTime
			   , V.F_VenueCode, M.F_MatchNum, M.F_MatchID, P.F_PhaseID, E.F_EventID, D.F_DisciplineID, 
			   M.F_Order, P.F_Order, E.F_Order
			   , P.F_PhaseCode, M.F_MatchCode			   
		FROM TS_Match AS M LEFT JOIN TS_Match_Des AS MS 
			   ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Phase_Des AS PS 
			   ON P.F_PhaseID = PS.F_PhaseID AND PS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID LEFT JOIN TS_Event_Des AS ES 
			   ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID 
			   LEFT JOIN TS_Discipline_Des AS DS 
			   ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
			   LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode
		WHERE D.F_DisciplineCode = @DisciplineCode AND M.F_MatchDate = @SelDate
	END
    
    --select * from #Temp_Schedule
    
	CREATE TABLE #Temp_Detail(
								[Code]			  NVARCHAR(50),
								[Type1]		      INT,--0=秩序单；1=成绩公告；2=名次公告；3=破纪录信息；4=其它表单
								[Type2]           INT,--0=单场；1=阶段
								[Type]		      NVARCHAR(100),
								[FileName]		  NVARCHAR(100),
								[PhaseCode]		  NVARCHAR(100),
								[MatchCode]		  NVARCHAR(100),
								)
								
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 0 AS [Type1], 1 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule 
		WHERE PhaseCode = '9' AND MatchCode = '01'
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 0 AS [Type1], 0 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule 
		WHERE (PhaseCode = '2' AND MatchCode = '01') OR (PhaseCode = '1' AND MatchCode = '01')	
		
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 1 AS [Type1], 0 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 1 AS [Type1], 1 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule 
		WHERE PhaseCode = '9' AND MatchCode = '02'
		
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 2 AS [Type1], 0 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule 
		WHERE PhaseCode = '1'
    
    --select * from #Temp_Detail

	UPDATE #Temp_Detail SET [Type] = N'C51A' WHERE [PhaseCode] = '9' AND [MatchCode] = '01' AND [Type1] = 0 AND [Type2] = 1
	UPDATE #Temp_Detail SET [Type] = N'C51B' WHERE [PhaseCode] = '2' AND [MatchCode] = '01' AND [Type1] = 0
	UPDATE #Temp_Detail SET [Type] = N'C51B' WHERE [PhaseCode] = '1' AND [MatchCode] = '01' AND [Type1] = 0

	UPDATE #Temp_Detail SET [Type] = N'C73A' WHERE [PhaseCode] = '9' AND [MatchCode] = '01' AND [Type1] = 1
	UPDATE #Temp_Detail SET [Type] = N'C73A' WHERE [PhaseCode] = '9' AND [MatchCode] = '02' AND [Type1] = 1 AND [Type2] = 0
	UPDATE #Temp_Detail SET [Type] = N'C73B' WHERE [PhaseCode] = '9' AND [MatchCode] = '02' AND [Type1] = 1 AND [Type2] = 1
	UPDATE #Temp_Detail SET [Type] = N'C73A' WHERE [PhaseCode] = '2' AND [MatchCode] = '01' AND [Type1] = 1
	UPDATE #Temp_Detail SET [Type] = N'C73A' WHERE [PhaseCode] = '1' AND [MatchCode] = '01' AND [Type1] = 1
		
	UPDATE #Temp_Detail SET [Type] = N'C92' WHERE [PhaseCode] = '1' AND [MatchCode] = '01' AND [Type1] = 2

	UPDATE #Temp_Detail SET [FileName] = Code + N'.' + [Type] + N'.CHI.1.0' 
	
	UPDATE #Temp_Schedule SET Code = ISNULL(Code, N''), Name = ISNULL(Name, N''), [StartDate] = ISNULL([StartDate], N''),	                         [StartTime] = ISNULL([StartTime], N''), [Order] = ISNULL([Order], N''),
	                    VenueCode = ISNULL(VenueCode, N'')

	--SELECT * FROM #Temp_Schedule
/*	
	UPDATE #Temp_Detail SET [Type] = N'C51' WHERE [Type] = 'C51A'
	UPDATE #Temp_Detail SET [Type] = N'C51' WHERE [Type] = 'C51B'
	UPDATE #Temp_Detail SET [Type] = N'C73' WHERE [Type] = 'C73A'
	UPDATE #Temp_Detail SET [Type] = N'C73' WHERE [Type] = 'C73B'
	UPDATE #Temp_Detail SET [Type] = N'C92' WHERE [Type] = 'C92'
*/	
	
	UPDATE #Temp_Schedule SET [Order] = B.DisplayPos
	FROM #Temp_Schedule AS A 
	LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY F_EventOrder, F_PhaseOrder, F_MatchOrder) AS DisplayPos,Code
			   FROM #Temp_Schedule) AS B 
			   ON A.Code = B.Code
	
	SET  @Content = (SELECT [Schedule].[Code], [Schedule].[Name], [Schedule].[StartDate], [Schedule].[StartTime],                                        [Schedule].[Order], [Schedule].[VenueCode], [Detail].[Type], [Detail].[FileName]
					 FROM (SELECT * FROM #Temp_Schedule) AS [Schedule] 
					 LEFT JOIN (SELECT * FROM #Temp_Detail) AS [Detail] ON [Schedule].Code = [Detail].Code
					 ORDER BY [Schedule].F_EventOrder, [Schedule].[Order], [Detail].[Type] FOR XML AUTO)

   --SELECT cast( @Content AS XML )
	
	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'DisciplineCode = "' + @OutputDiscCode + '"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX),
							 GETDATE() , 121 ), 12), 5), ':', ''), '.', '')+'"'

	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Content
					+ N'
						</Message>'

	DECLARE @FileName	AS NVARCHAR(100)
	IF @DateID = -1
	BEGIN
		SET @FileName =	@OutputDiscCode + N'_Schedule_ALL'
	END
	ELSE
	BEGIN
		SET @FileName =	@OutputDiscCode + N'_Schedule_'+ LEFT(CONVERT(NVARCHAR(MAX), @SelDate, 120), 10)
	END
	
		
	SELECT @OutputXML AS OutputXML, @FileName AS [FileName]
	RETURN

SET NOCOUNT OFF
END





GO


--EXEC Proc_Info_SL_Schedule -1