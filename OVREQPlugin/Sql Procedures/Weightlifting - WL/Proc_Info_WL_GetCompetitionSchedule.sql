IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_GetCompetitionSchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----名   称：[Proc_Info_WL_GetCompetitionSchedule]
----功   能：举重 - Info获取赛事计划协议
----作	 者：崔凯
----日   期：2012年09月19日

/*
	参数说明：
	序号	参数名称	参数说明
	1		@DisciplineID	对应大项的ID  
	2		@LanguageCode
						展现内容的指定语言

*/

/*
	功能描述：Info系统获取赛事计划协议XML数据
*/

/*
	修改记录：
	序号	日期			修改者		修改内容
	1		2012-09-19		崔凯		修改内容描述。 
*/

CREATE PROCEDURE [dbo].[Proc_Info_WL_GetCompetitionSchedule]
		@DisciplineID       AS INT,
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON
 
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)
	
	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	 

	SELECT @DisciplineCode = D.F_DisciplineCode FROM TS_Discipline AS D WHERE D.F_DisciplineID = @DisciplineID 
    
			CREATE TABLE #Schedule
			(
									[Code]					NVARCHAR(50),
									[Name]					NVARCHAR(100),
									[StartDate]             NVARCHAR(100),
									[StartTime]             NVARCHAR(100),
									[Order]					INT,
									[VenueCode]				NVARCHAR(100),  
			)
			
			CREATE TABLE #Details(
									[Code]					NVARCHAR(50),
									[Type]					NVARCHAR(100),--0=秩序单；1=成绩公告；2=名次公告；3=破纪录信息；4=其它表单
									[FileName]				NVARCHAR(100),
								)

	-- 在临时表中插入基本信息
	INSERT #Schedule 
	([Code], [Name], [StartDate],StartTime,[Order],VenueCode)
	( 
	SELECT  
	DBO.Func_WL_GetRSCCode(1,E.F_EventID,NULL,NULL) AS [Code]
	,F_EventLongName AS [NAME]
	,REPLACE(dbo.Fun_WL_GetDateTime(E.F_OpenDate,1,@LanguageCode),'-','') AS StartDate
	,REPLACE(REPLACE(dbo.Fun_WL_GetDateTime(E.F_OpenDate,8,@LanguageCode),':',''),'.','') AS StartTime 
	,E.F_Order 
	,'WL01' 
	FROM TS_Event AS E
	LEFT JOIN TS_Event_DES AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode   
	
	)
	
	--插入秩序单
	INSERT INTO #Details(Code, [FileName], [Type])
		SELECT Code, Code + N'.C51.CHI.1.0', N'C51' FROM #Schedule 
	
	--插入成绩公告
	INSERT INTO #Details(Code, [FileName], [Type])
		SELECT Code, Code + N'.C73.CHI.1.0',N'C73'  FROM #Schedule 
	--插入名次公告
	INSERT INTO #Details(Code, [FileName], [Type])
		SELECT Code, Code + N'.C92A.CHI.1.0', N'C92A' FROM #Schedule 
	

	DECLARE @Result AS NVARCHAR(MAX)
	SET @Result = ( SELECT Schedule.[Code],[Name],[StartDate],[StartTime],[Order],[VenueCode]
									, [Detail].[Type]
									, [Detail].[FileName] FROM #Schedule AS Schedule 
						LEFT JOIN #Details AS Detail ON Detail.Code= Schedule.Code
						ORDER BY  [Order]
			FOR XML AUTO)

	IF @Result IS NULL
	BEGIN
		SET @Result = N''
	END

	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty =   N' DisciplineCode = "' + @DisciplineCode + '"' 
							+N' Date ="'+ REPLACE(dbo.Fun_WL_GetDateTime(GETDATE(),1,@LanguageCode), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(dbo.Fun_WL_GetDateTime(GETDATE(),8,@LanguageCode), ':', ''),'.','') + '"'
							+N' Language = "' + CASE WHEN @LanguageCode =N'CHN' THEN N'CHI' ELSE @LanguageCode END + '"' 

	IF(@Result = N'')
		BEGIN
		SET @OutputXML = N''
		END
	ELSE
		BEGIN
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						   <Message ' + @MessageProperty +'>'
						+ @Result
						+ N'
							</Message>'
		END

	IF (@Result IS NOT NULL AND @Result !='')
	BEGIN
	SELECT @OutputXML AS OutputXML
	RETURN
	END
 
SET NOCOUNT OFF
END


/*
exec Proc_Info_WL_GetCompetitionSchedule 1,'CHN' 
*/



GO


