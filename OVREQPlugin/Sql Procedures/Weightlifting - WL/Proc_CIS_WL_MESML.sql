IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_WL_MESML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_WL_MESML]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_CIS_WL_MESML]
--描    述: CIS获取所有项目奖牌获得者详细信息  
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年4月14日
--修改记录：
/*			
			时间				修改人		修改内容	
*/



CREATE PROCEDURE [dbo].[Proc_CIS_WL_MESML]
	@DisciplineCode			CHAR(2),
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
     SET Language English
     SET @LanguageCode = ISNULL(@LanguageCode,'ENG')
     
	 DECLARE @OutputXML AS NVARCHAR(MAX)	
	 DECLARE @DisciplineID INT
	 
	 SELECT @DisciplineID = F_DisciplineID 
		FROM TS_Discipline WHERE F_DisciplineCode = @DisciplineCode
	 
	CREATE TABLE #Temp_Event
	(
	    [EventID] INT, 
	    [EventName] NVARCHAR(50),
		[Order]	int,
	)

	INSERT #Temp_Event 
	([EventID],[EventName])
	(
		SELECT DISTINCT E.F_EventID
			, F.F_EventLongName AS [EventName]	
		FROM TS_Event_Result AS A	
		LEFT JOIN TS_Event AS E
			ON A.F_EventID = E.F_EventID 
		LEFT JOIN TS_Event_Des AS F
			ON A.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode
		WHERE A.F_MedalID IS NOT NULL
			AND E.F_DisciplineID = @DisciplineID
			AND E.F_EventStatusID > 100

	)
	
	CREATE TABLE #Temp_Medals
	(
	    [ID]			INT, 
	    [Type]			NVARCHAR(8),
	    [NOC]			NVARCHAR(8),
	    [Competitor]	NVARCHAR(250),
		[Date]			NVARCHAR(11),
		[EventID]		INT, 
	)

	INSERT #Temp_Medals 
	([ID],[Type],[NOC],[Competitor],[Date],[EventID])
	(
	 SELECT 
		  A.F_EventRank AS [ID]
		, B.F_MedalLongName AS [Type]
		, G.F_DelegationCode AS [NOC]
	    ,(SELECT REPLACE(D.F_PrintLongName,'/',nchar(10))) AS [Competitor]
		, UPPER(CONVERT(NVARCHAR(20), A.F_ResultCreateDate, 106)) AS [Date]
		, A.F_EventID AS [EventID]
	FROM TS_Event_Result AS A
	LEFT JOIN TC_Medal_Des AS B 
		ON A.F_MedalID = B.F_MedalID AND B.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS C
		ON A.F_RegisterID = C.F_RegisterID
	LEFT JOIN TR_Register_Des AS D
		ON A.F_RegisterID = D.F_RegisterID AND D.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E
		ON A.F_EventID = E.F_EventID 
	LEFT JOIN TS_Event_Des AS F
		ON A.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS G
		ON C.F_DelegationID = G.F_DelegationID
	WHERE A.F_MedalID IS NOT NULL
		AND E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID > 100 
	) ORDER BY A.F_EventRank
	
	DECLARE @Temp_MedalList AS NVARCHAR(MAX)
	SET @Temp_MedalList = ( SELECT [Event].EventName AS [Name],
	                        [Medal].ID AS [ID],
	                        [Medal].[Type] AS [Type],
	                        [Medal].[NOC] AS [NOC],
	                        [Medal].[Competitor] AS [Competitor],
	                        [Medal].[Date] AS [Date]
	            FROM #Temp_Event AS [Event] 
				LEFT JOIN #Temp_Medals AS [Medal] ON [Event].EventID = [Medal].EventID 
			FOR XML AUTO)

	IF @Temp_MedalList IS NULL
	BEGIN
		SET @Temp_MedalList = N''
	END
	
	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Type = "MESML"'
							+N' ID = "WL0000000"'
							+N' Discipline = "'+ @DisciplineCode + '"'
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Temp_MedalList
					+ N'
						</Message>'	
	
	SELECT @OutputXML AS OutputXML
	RETURN
	
	
SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_CIS_WL_MESML] 'WL'

*/