IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Proc_DataExchange_OfficalCommunication') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_OfficalCommunication]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：Proc_DataExchange_OfficalCommunication
----功		  能：官方通告。
----作		  者：郑金勇
----日		  期: 2011-03-01 
----修 改 记  录: 
/*
         日期             修改人            修改内容
         2011-03-05		  郑金勇			将子节点的名称由TS_Offical_Communication改为Communications。
         2011-03-06		  郑金勇			将[Content]的取值由F_Note改为F_Text。
         2011-03-09		  郑金勇			如果消息体是空的就让整个消息为空,不发送此消息.
*/

CREATE PROCEDURE [dbo].[Proc_DataExchange_OfficalCommunication]
		@Discipline			AS NVARCHAR(50)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID		AS NVARCHAR(50)
	DECLARE @LanguageCode		AS CHAR(3)
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_DisciplineCode = @Discipline
	
	DECLARE @Content AS NVARCHAR(MAX)
	SET @Content = (SELECT F_NewsItem AS [Order]
						 , LEFT(CONVERT(NVARCHAR(MAX), F_Date , 120 ), 10) AS [Date]
						 , LEFT(RIGHT(CONVERT(NVARCHAR(MAX), F_Date , 121 ), 12), 5) AS [Time]
						 , F_Issued_by AS [Issued_By]
						 , F_Heading AS [Heading]
						 , F_SubTitle AS [Subheading]
						 , F_Text AS [Content]
						 , (CASE F_Type
							WHEN 1 THEN 1
							WHEN 3 THEN 1
							WHEN 5 THEN 1
							WHEN 7 THEN 1
							ELSE 0 END) AS [Affect_Result]
						 , (CASE F_Type
							WHEN 2 THEN 1
							WHEN 3 THEN 1
							WHEN 6 THEN 1
							WHEN 7 THEN 1
							ELSE 0 END) AS [Affect_Schedule]
						 , (CASE F_Type
							WHEN 4 THEN 1
							WHEN 5 THEN 1
							WHEN 6 THEN 1
							WHEN 7 THEN 1
							ELSE 0 END) AS [Affect_Others]
						  
						  FROM TS_Offical_Communication AS Communications
			FOR XML AUTO)

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
							+N' Code = "M6022"'
							+N' Type = "DATA"'
							+N' Language = "' + @LanguageCode + '"'
							+N' Date ="' + REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "' + REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '') + '"'

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


--EXEC Proc_DataExchange_OfficalCommunication 'TE'