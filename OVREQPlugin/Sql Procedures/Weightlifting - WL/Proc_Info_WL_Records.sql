IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_Records]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_Records]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Info_WL_Records]
----功		  能：For Info system 输出记录成绩（M0142）
----作		  者：崔凯
----日		  期: 2010-12-20 
----修改	记录:

CREATE PROCEDURE [dbo].[Proc_Info_WL_Records] 
	@EventID  AS INT,
	@LanguageCode AS CHAR(3)
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @DisciplineID AS NVARCHAR(50)
    SET @LanguageCode = ISNULL(@LanguageCode,'ENG')
    
    DECLARE @OutputXML AS NVARCHAR(MAX)
    
    DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
    DECLARE @SexCode        NVARCHAR(1)
    DECLARE @GenderCode     NVARCHAR(1)    
	DECLARE @SnatchMatchID	INT
	DECLARE @CleanJerkMatchID	INT
	DECLARE @PhaseID   INT
	
	SELECT 
		@DisciplineCode = D.F_DisciplineCode,
		@EventCode = E.F_EventCode,
		@SexCode = E.F_SexCode,
		@GenderCode = S.F_GenderCode
		FROM TS_Event AS E
		LEFT JOIN TS_Discipline D ON D.F_DisciplineID = E.F_DisciplineID 
		LEFT JOIN TC_Sex S ON S.F_SexCode = E.F_SexCode
		WHERE E.F_EventID = @EventID
				
		CREATE TABLE #Records
		(
			[Type]		varchar(30),
			Mode		int,
			Operate		varchar(6),
			Result		varchar(20),
			Holder		varchar(50),
			[Game]		varchar(200),
			City		varchar(50),
			[Date]		datetime,
			[Time]		time					
		)
		INSERT #Records
		([Type],Mode,Operate,Result,Holder,Game,City,[Date],[Time])
		(SELECT
			ISNULL(RTD.F_RecordTypeLongName,'') AS [Type],	 --[Type]
		    ISNULL(ER.F_SubEventCode,'3') AS Mode,				 --Mode: 1-Snatch; 2-Clean&Jerk; 3-Total
		    ISNULL('ALL','') AS Operate,					 --Operate
		    ISNULL(ER.F_RecordValue,'') AS Result,		     --Result    
			ISNULL(ER.F_CompetitorReportingName,RD.F_LongName) AS Holder,--Holder
			ISNULL(ER.F_RecordSport,'') AS Game,			 --Game
			ISNULL(ER.F_Location,'') AS City,				 --City
			ISNull(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), ER.F_RecordDate , 23), 10), '-', '')
				,REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 23), 10), '-', '')) AS [Date],
			ISNull(REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), ER.F_RecordDate , 24), 5), ':', ''), '.', '')
				,'0000') AS [Time]
			 --Time, we don't have time column
			
			FROM TS_Event_Record AS ER
			LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
			LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = ER.F_RecordTypeID
			LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ER.F_RegisterID AND RD.F_LanguageCode=@LanguageCode
			WHERE ER.F_EventID = @EventID AND RTD.F_LanguageCode = @LanguageCode AND ER.F_Active=1)
		
		DECLARE @Record AS NVARCHAR(MAX)
		Set @Record = ( SELECT * FROM #Records AS Record 
					FOR XML AUTO)
		IF @Record IS NULL
		BEGIN
			SET @Record = N''
		END
		
		DECLARE @MessageHeader AS Nvarchar(max)
		Set @MessageHeader = N' Version="1.0"'
							+N' Category = "CRS"'
							+N' Origin = "CRS"'
							+N' RSC = "WL'+@GenderCode + @EventCode + '0' + '00"'
							+N' Discipline = "WL"'
							+N' Gender = "'+@GenderCode+'"'
							+N' Event = "' +@EventCode+'"'
							+N' Phase= "0"'
							+N' Unit= "00"'
							+N' Venue= "000"'
							+N' Code= "M0142"'
							+N' Type= "DATA"'
							+N' Language= "'+ @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'
							
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
							<Message ' + @MessageHeader + '>'
							+@Record+
						 N' </Message>'
			
	SELECT @OutputXML AS OutputXML
	RETURN
				 		
SET NOCOUNT OFF
END
