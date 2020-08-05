IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_BK_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_BK_Schedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_BK_Schedule]
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

CREATE PROCEDURE [dbo].[Proc_Info_BK_Schedule]
		@DateID			INT
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineCode AS NVARCHAR(50)
	DECLARE @OutputDiscCode AS NVARCHAR(50)
	DECLARE @LanguageCode   AS CHAR(3)
	
	SET @DisciplineCode = N'BK'
	SET @OutputDiscCode = N'BK'
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
								[F_RoundID]       INT,
								[F_PhaseID]		  INT,
								[F_EventID]		  INT,
								[F_DisciplineID]  INT,
								[F_MatchOrder]	  INT,
								[F_RoundOrder]    INT,
								[F_PhaseOrder]	  INT,
								[F_EventOrder]	  INT,
								[MatchCode]		  NVARCHAR(100),
								[PhaseCode]		  NVARCHAR(100),
								)


	IF @DateID = -1
	BEGIN
		INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [VenueCode], [Order], 
		 [F_MatchID], [F_RoundID], [F_PhaseID], [F_EventID], [F_DisciplineID], 
		 [F_MatchOrder], [F_RoundOrder], [F_PhaseOrder], [F_EventOrder], 
		 [MatchCode], [PhaseCode])
		SELECT @OutputDiscCode + Gender.F_GenderCode + 
		       [dbo].[Func_BK_GetOutputEventCode](Gender.F_GenderCode, E.F_EventCode) + 
		       CAST(R.F_Order AS NVARCHAR(10)) + Right('00' + M.F_MatchCode, 2) AS [Code],
			   ISNULL(DS.F_DisciplineLongName,'') + ISNULL(ES.F_EventLongName,'') + 
			   ISNULL(PS.F_PhaseLongName,'') + ISNULL(MS.F_MatchLongName,'') AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), M.F_MatchDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), M.F_StartTime , 121 ), 12), 8), ':', ''), '.', '') 
			   AS StartTime
			   , V.F_VenueCode, M.F_MatchNum, M.F_MatchID, R.F_RoundID, P.F_PhaseID, E.F_EventID, D.F_DisciplineID
			   , M.F_Order, R.F_Order, P.F_Order, E.F_Order
			   , M.F_MatchCode, P.F_PhaseCode
		FROM TS_Match AS M LEFT JOIN TS_Match_Des AS MS 
			   ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Phase_Des AS PS 
			   ON P.F_PhaseID = PS.F_PhaseID AND PS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Round AS R ON M.F_RoundID = R.F_RoundID LEFT JOIN TS_Round_Des AS RD
			   ON R.F_RoundID = RD.F_RoundID AND RD.F_LanguageCode = @LanguageCode
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
		INSERT INTO #Temp_Schedule ([Code], [Name], [StartDate], [StartTime], [VenueCode], [Order], 
		 [F_MatchID], [F_RoundID], [F_PhaseID], [F_EventID], [F_DisciplineID], 
		 [F_MatchOrder], [F_RoundOrder], [F_PhaseOrder], [F_EventOrder], 
		 [MatchCode], [PhaseCode])
		SELECT @OutputDiscCode + Gender.F_GenderCode + 
		       [dbo].[Func_BK_GetOutputEventCode](Gender.F_GenderCode, E.F_EventCode) + 
		       CAST(R.F_Order AS NVARCHAR(10)) + Right('00' + M.F_MatchCode, 2) AS [Code],
			   ISNULL(DS.F_DisciplineLongName,'') + ISNULL(ES.F_EventLongName,'') + 
			   ISNULL(PS.F_PhaseLongName,'') + ISNULL(MS.F_MatchLongName,'') AS [Name],
			   REPLACE(LEFT(CONVERT(NVARCHAR(MAX), M.F_MatchDate, 120 ), 10), '-', '') AS StartDate,
			   REPLACE(REPLACE(LEFT(RIGHT(CONVERT(NVARCHAR(MAX), M.F_StartTime , 121 ), 12), 8), ':', ''), '.', '') 
			   AS StartTime
			   , V.F_VenueCode, M.F_MatchNum, M.F_MatchID, R.F_RoundID, P.F_PhaseID, E.F_EventID, D.F_DisciplineID
			   , M.F_Order, R.F_Order, P.F_Order, E.F_Order
			   , M.F_MatchCode, P.F_PhaseCode
		FROM TS_Match AS M LEFT JOIN TS_Match_Des AS MS 
			   ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID LEFT JOIN TS_Phase_Des AS PS 
			   ON P.F_PhaseID = PS.F_PhaseID AND PS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Round AS R ON M.F_RoundID = R.F_RoundID LEFT JOIN TS_Round_Des AS RD
			   ON R.F_RoundID = RD.F_RoundID AND RD.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID LEFT JOIN TS_Event_Des AS ES 
			   ON E.F_EventID = ES.F_EventID AND ES.F_LanguageCode = @LanguageCode
			   LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID 
			   LEFT JOIN TS_Discipline_Des AS DS 
			   ON D.F_DisciplineID = DS.F_DisciplineID AND DS.F_LanguageCode = @LanguageCode
			   LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
			   LEFT JOIN TC_Sex AS Gender ON E.F_SexCode = Gender.F_SexCode
		WHERE D.F_DisciplineCode = @DisciplineCode AND M.F_MatchDate = @SelDate
	END
    
    --删除为满足成绩处理附加的虚拟相同比赛
    DELETE FROM #Temp_Schedule WHERE [Order] > 100
    --select * from #Temp_Schedule ORDER BY F_EventOrder, F_RoundOrder, F_MatchOrder
    
 	CREATE TABLE #Temp_Round(
								[Code]			  NVARCHAR(50),
								[Name]            NVARCHAR(100),
								[StartDate]       NVARCHAR(100),
								[StartTime]       NVARCHAR(100),
								[Order]			  INT,
								[VenueCode]		  NVARCHAR(100),
								[F_MatchID]		  INT,
								[F_RoundID]       INT,
								[F_PhaseID]       INT,
								[F_EventID]		  INT,
								[F_DisciplineID]  INT,								
								[F_MatchOrder]    INT,								
								[F_RoundOrder]    INT,
								[F_PhaseOrder]    INT,
								[F_EventOrder]    INT,
							)
    INSERT INTO #Temp_Round([Code],[Name],[StartDate],[StartTime],[Order],[VenueCode],
    [F_MatchID],[F_RoundID],[F_PhaseID],[F_EventID],[F_DisciplineID],
    [F_MatchOrder],[F_RoundOrder],[F_PhaseOrder],[F_EventOrder]) 
    SELECT distinct SUBSTRING([Code],1,7)+N'00',  
    DD.F_DisciplineLongName + ED.F_EventLongName + RD.F_RoundLongName,
    [StartDate], N'000000',[F_RoundOrder],N'',
    NULL,TS.[F_RoundID],NULL,TS.[F_EventID],TS.[F_DisciplineID],
    0,[F_RoundOrder],0,[F_EventOrder]
    FROM #Temp_Schedule AS TS
    LEFT JOIN TS_Round_Des AS RD ON TS.F_RoundID = RD.F_RoundID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event_Des AS ED ON TS.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline_Des DD ON TS.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode   
    
    --select * from #Temp_Round
 
    --select * from #Temp_Schedule ORDER BY F_EventOrder, F_RoundOrder, F_MatchOrder
    
    ----阶段成绩公告
 	CREATE TABLE #Temp_Phase(
								[Code]			  NVARCHAR(50),
								[Name]            NVARCHAR(100),
								[StartDate]       NVARCHAR(100),
								[StartTime]       NVARCHAR(100),
								[Order]			  INT,
								[VenueCode]		  NVARCHAR(100),
								[F_MatchID]		  INT,
								[F_RoundID]       INT,
								[F_PhaseID]		  INT,
								[F_EventID]		  INT,
								[F_DisciplineID]  INT,								
								[F_MatchOrder]    INT,								
								[F_RoundOrder]    INT,
								[F_PhaseOrder]    INT,
								[F_EventOrder]    INT,
							)

    INSERT INTO #Temp_Phase([Code],[Name],[StartDate],[StartTime],[Order],[VenueCode],
    [F_MatchID],[F_RoundID],[F_PhaseID],[F_EventID],[F_DisciplineID],
    [F_MatchOrder],[F_RoundOrder],[F_PhaseOrder],[F_EventOrder]) 
    SELECT CASE WHEN P.F_Order = 1 THEN SUBSTRING(T.[Code],1,6)+N'P00'
                WHEN P.F_Order = 2 THEN SUBSTRING(T.[Code],1,6)+N'F00'
                END AS [Code],
    ISNULL(T.Name,'') + ISNULL(PD.F_PhaseLongName,'') AS [Name], 
    REPLACE(LEFT(CONVERT(NVARCHAR(MAX), P.F_OpenDate, 120 ), 10), '-', '') AS StartDate, N'000000',P.F_Order,N'',        
    NULL,NULL,P.F_PhaseID,T.[F_EventID],T.[F_DisciplineID],
    888,888,P.F_Order,T.[F_EventOrder]
    FROM TS_Phase AS P
    LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    LEFT JOIN 
    (  
    SELECT distinct SUBSTRING([Code],1,6)+N'000' AS [Code],  
    (DD.F_DisciplineLongName + ED.F_EventLongName) AS [Name],
    TS.[F_EventID],TS.[F_DisciplineID],
    TS.[F_EventOrder]
    FROM #Temp_Schedule AS TS
    LEFT JOIN TS_Round_Des AS RD ON TS.F_RoundID = RD.F_RoundID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event_Des AS ED ON TS.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline_Des DD ON TS.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    ) AS T ON E.F_EventID = T.F_EventID
    WHERE P.F_FatherPhaseID = 0

    --select * from #Temp_Phase
       
    ----名次公告
 	CREATE TABLE #Temp_Event(
								[Code]			  NVARCHAR(50),
								[Name]            NVARCHAR(100),
								[StartDate]       NVARCHAR(100),
								[StartTime]       NVARCHAR(100),
								[Order]			  INT,
								[VenueCode]		  NVARCHAR(100),
								[F_MatchID]		  INT,
								[F_RoundID]       INT,
								[F_PhaseID]       INT,
								[F_EventID]		  INT,
								[F_DisciplineID]  INT,								
								[F_MatchOrder]    INT,								
								[F_RoundOrder]    INT,
								[F_PhaseOrder]    INT,
								[F_EventOrder]    INT,
							)

    INSERT INTO #Temp_Event([Code],[Name],[StartDate],[StartTime],[Order],[VenueCode],
    [F_MatchID],[F_RoundID],[F_PhaseID],[F_EventID],[F_DisciplineID],
    [F_MatchOrder],[F_RoundOrder],[F_PhaseOrder],[F_EventOrder]) 
    SELECT distinct SUBSTRING([Code],1,6)+N'000',  
    DD.F_DisciplineLongName + ED.F_EventLongName,
    REPLACE(LEFT(CONVERT(NVARCHAR(MAX), E.F_OpenDate, 120 ), 10), '-', '') AS StartDate, N'000000',1,N'',
    NULL,NULL,NULL,TS.[F_EventID],TS.[F_DisciplineID],
    999,999,999,TS.[F_EventOrder]
    FROM #Temp_Schedule AS TS
    LEFT JOIN TS_Round_Des AS RD ON TS.F_RoundID = RD.F_RoundID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS E ON TS.F_EventID = E.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON TS.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Discipline_Des DD ON TS.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode 
      
    --select * from #Temp_Event
   
   
    INSERT INTO #Temp_Schedule([Code],[Name],[StartDate],[StartTime],[Order],[VenueCode],
    [F_MatchID],[F_RoundID],[F_PhaseID],[F_EventID],[F_DisciplineID],
    [F_MatchOrder],[F_RoundOrder],[F_PhaseOrder],[F_EventOrder]) 
    SELECT * FROM #Temp_Round

    INSERT INTO #Temp_Schedule([Code],[Name],[StartDate],[StartTime],[Order],[VenueCode],
    [F_MatchID],[F_RoundID],[F_PhaseID],[F_EventID],[F_DisciplineID],
    [F_MatchOrder],[F_RoundOrder],[F_PhaseOrder],[F_EventOrder]) 
    SELECT * FROM #Temp_Phase

    INSERT INTO #Temp_Schedule([Code],[Name],[StartDate],[StartTime],[Order],[VenueCode],
    [F_MatchID],[F_RoundID],[F_PhaseID],[F_EventID],[F_DisciplineID],
    [F_MatchOrder],[F_RoundOrder],[F_PhaseOrder],[F_EventOrder]) 
    SELECT * FROM #Temp_Event
   
    --select * from #Temp_Schedule ORDER BY F_EventOrder, F_RoundOrder, F_MatchOrder
   
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
		SELECT Code, 0 AS [Type1], 0 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	WHERE F_MatchOrder > 0 AND F_MatchOrder < 100	
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 0 AS [Type1], 1 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	WHERE F_MatchOrder = 0 AND F_RoundOrder > 0
		
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 1 AS [Type1], 0 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	WHERE F_MatchOrder > 0 AND F_MatchOrder < 100	
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 1 AS [Type1], 1 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	WHERE F_MatchOrder = 0 AND F_RoundOrder > 0	
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 1 AS [Type1], 2 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	WHERE F_MatchOrder = 888 AND F_RoundOrder = 888	AND F_PhaseOrder = 1
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 1 AS [Type1], 3 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule
	WHERE F_MatchOrder = 888 AND F_RoundOrder = 888	AND F_PhaseOrder = 2
		
	INSERT INTO #Temp_Detail (Code, [Type1], [Type2], [FileName],[PhaseCode],[MatchCode])
		SELECT Code, 2 AS [Type1], 0 AS [Type2], NULL, [PhaseCode],[MatchCode] FROM #Temp_Schedule 
	WHERE F_MatchOrder = 999 AND F_RoundOrder = 999	
    
    --select * from #Temp_Detail

	UPDATE #Temp_Detail SET [Type] = N'C51' WHERE [Type1] = 0 AND [Type2] = 0
	UPDATE #Temp_Detail SET [Type] = N'C58' WHERE [Type1] = 0 AND [Type2] = 1

	UPDATE #Temp_Detail SET [Type] = N'C73' WHERE [Type1] = 1 AND [Type2] = 0
	UPDATE #Temp_Detail SET [Type] = N'C76' WHERE [Type1] = 1 AND [Type2] = 1
	UPDATE #Temp_Detail SET [Type] = N'C76A' WHERE [Type1] = 1 AND [Type2] = 2
	UPDATE #Temp_Detail SET [Type] = N'C76B' WHERE [Type1] = 1 AND [Type2] = 3
		
	UPDATE #Temp_Detail SET [Type] = N'C92' WHERE [Type1] = 2 AND [Type2] = 0

	UPDATE #Temp_Detail SET [FileName] = Code + N'.' + [Type] + N'.CHI.1.0' 
	
	UPDATE #Temp_Schedule SET Code = ISNULL(Code, N''), Name = ISNULL(Name, N''), [StartDate] = ISNULL([StartDate], N''),	                         [StartTime] = ISNULL([StartTime], N''), [Order] = ISNULL([Order], N''),
	                    VenueCode = ISNULL(VenueCode, N'')

	--SELECT * FROM #Temp_Schedule
/*	
	UPDATE #Temp_Detail SET [Type] = N'C51' WHERE [Type] = 'C51'
	UPDATE #Temp_Detail SET [Type] = N'C51' WHERE [Type] = 'C58'
	UPDATE #Temp_Detail SET [Type] = N'C73' WHERE [Type] = 'C73'
	UPDATE #Temp_Detail SET [Type] = N'C73' WHERE [Type] = 'C76'
	UPDATE #Temp_Detail SET [Type] = N'C76A' WHERE [Type] = 'C76A'
	UPDATE #Temp_Detail SET [Type] = N'C76B' WHERE [Type] = 'C76B'
	UPDATE #Temp_Detail SET [Type] = N'C93' WHERE [Type] = 'C92'
*/	
	
	UPDATE #Temp_Schedule SET [Order] = B.DisplayPos
	FROM #Temp_Schedule AS A 
	LEFT JOIN (SELECT ROW_NUMBER() OVER(ORDER BY F_EventOrder, F_RoundOrder, F_MatchOrder) AS DisplayPos,Code
			   FROM #Temp_Schedule) AS B 
			   ON A.Code = B.Code
	
	SET  @Content = (SELECT [Schedule].[Code], [Schedule].[Name], [Schedule].[StartDate], [Schedule].[StartTime],                                      [Schedule].[Order], [Schedule].[VenueCode], [Detail].[Type], [Detail].[FileName]
					 FROM (SELECT * FROM #Temp_Schedule) AS [Schedule] 
					 LEFT JOIN (SELECT * FROM #Temp_Detail) AS [Detail] ON [Schedule].Code = [Detail].Code
					 ORDER BY [Schedule].F_EventOrder, [Schedule].F_RoundOrder,
					 [Schedule].F_MatchOrder, [Detail].[Type] FOR XML AUTO)

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


--EXEC Proc_Info_BK_Schedule -1