

/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_Record]    Script Date: 07/22/2011 15:55:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_Record]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_Record]
GO


/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_Record]    Script Date: 07/22/2011 15:55:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DataExchange_Record]
----功		  能：记录成绩信息(M0141)。
----作		  者：李燕
----日		  期: 2011-01-20
----修改	记录:
/*
                 2011-01-25     李燕      导出时，过滤那些新创建的记录
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_Record]
		@Discipline			AS NVARCHAR(50),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline
 

	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT  [Record].Discipline
			, [Record].Gender
			, [Record].[Event]
			, [Record].[Type]
			, [Record].Operate
			, [Record].Result
			, [Record].Holder
			, [Record].Game
			, [Record].City
			, [Record].[Date]
			, [Record].[Time]
			, [Record].Equal
			, [Record].Country
			, [Record].Nationality
			FROM (SELECT @Discipline AS Discipline, E.F_GenderCode AS Gender, B.F_EventCode AS [Event], I.F_RecordTypeCode AS [Type], 'ALL' AS Operate, ISNULL( CAST( A.F_RecordValue AS NVARCHAR(20)), '') AS Result,
			 ISNULL(F.F_ShortName, '') AS Holder,
			 ISNULL(A.F_RecordSport, '') AS Game, ISNULL(A.F_Location, '') AS City, ISNULL(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), A.F_RecordDate, 120 ), 10), '-', ''), '') AS [Date], '' AS [Time],  (CASE WHEN A.F_Equalled = 0 THEN 'Y' ELSE 'N' END) AS Equal,
			 ISNULL(A.F_LocationNOC, '') AS Country, ISNULL(C.F_NOC, '') AS Nationality  
			    FROM TS_Event_Record AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID 
				LEFT JOIN TR_Register AS C ON A.F_RegisterID = C.F_RegisterID 
				LEFT JOIN TS_Discipline AS D ON B.F_DisciplineID = D.F_DisciplineID
				LEFT JOIN TC_Sex AS E ON B.F_SexCode = E.F_SexCode
				LEFT JOIN TR_Register_Des AS F ON A.F_RegisterID = F.F_RegisterID AND F.F_LanguageCode = @LanguageCode
				LEFT JOIN TC_RecordType AS I ON A.F_RecordTypeID = I.F_RecordTypeID
				LEFT JOIN TC_Country_Des AS H ON C.F_NOC = H.F_NOC AND H.F_LanguageCode = @LanguageCode 
				WHERE D.F_DisciplineCode = @Discipline AND F_IsNewCreated <> 1) AS [Record]
				 FOR XML AUTO)

	IF @Content IS NULL
	BEGIN
		SET @Content = N''
	END

	IF @LanguageCode = 'CHN'
	BEGIN
		SET @LanguageCode = 'CHI'
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
							+N' Code = "M0141"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'

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


