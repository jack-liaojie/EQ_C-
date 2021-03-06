IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_WLREC]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_WLREC]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_CIS_WLREC]
----功		  能：
----作		  者：wudingfang
----日		  期: 2011-02-15 
----修改	记录:


CREATE PROCEDURE [dbo].[Proc_CIS_WLREC]
		@DisciplineCode         AS CHAR(2),
		@LanguageCode		AS CHAR(3)
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @DisciplineID	AS NVARCHAR(50)
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

 
 	DECLARE @SQL		    NVARCHAR(max)


	SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D 
    WHERE F_DisciplineCode = @DisciplineCode

	CREATE TABLE #Temp_Record
	(
	    [EventID] INT,
	    [TypeID] INT,
	    [ID] NVARCHAR(10),  
	    [Name] NVARCHAR(50),
		[Order]	int,
	)

	INSERT #Temp_Record 
	([EventID],[TypeID],[ID],[Name],[Order])
	(
	SELECT  
	  ISNULL(E.F_EventID,'') AS [EventID]
	, ISNULL(ER.F_RecordTypeID,'') AS [TypeID]  
	, ('WL'+cast(SEX.F_GenderCode as NVARCHAR(1))+E.F_EventCode+'000') AS [ID] 
	, ISNULL(RTD.F_RecordTypeLongName,'') AS [Name]
	, ISNULL(RT.F_Order,'')  AS [Order]
	FROM TS_Event AS E
	LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Event_Record AS ER ON E.F_EventID = ER.F_EventID AND ER.F_Active = 1 AND F_SubEventCode = '3'
	LEFT JOIN TC_RecordType AS RT ON ER.F_RecordTypeID = RT.F_RecordTypeID
	LEFT JOIN TC_RecordType_Des AS RTD ON ER.F_RecordTypeID = RTD.F_RecordTypeID AND RTD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Sex AS SEX ON E.F_SexCode = SEX.F_SexCode
	WHERE E.F_DisciplineID = @DisciplineID
	)
	--select * from #Temp_Record

	CREATE TABLE #Temp_Unit
	(
	    [EventID]       INT,
	    [TypeID]        INT, 
		[UnitName]		NVARCHAR(50),
		[AthleteName]   NVARCHAR(50),
		[NOC_Code]      NVARCHAR(10),
		[Year]          NVARCHAR(12),
		[Lift]          NVARCHAR(10),
        [Order]			INT,
	)
	
	INSERT #Temp_Unit
	([EventID],[TypeID],[UnitName],[AthleteName],[NOC_Code],[Year],[Lift],[Order])
	(
	SELECT  
	  ISNULL(E.F_EventID,'') AS [EventID]
	, ISNULL(ER.F_RecordTypeID,'') AS [TypeID]  
	, case when ER.F_SubEventCode = '1' then 'Snatch'
	       when ER.F_SubEventCode = '2' then 'Clean&Jerk'
	       when ER.F_SubEventCode = '3' then 'Total' 
	       else '' end AS [UnitName]
	, ISNULL(RD.F_LongName,'') AS [AthleteName]
	, ISNULL(R.F_NOC,'') AS [NOC_Code]
	, dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,@LanguageCode) AS [Year]
	, ISNULL(ER.F_RecordValue,'') AS [Lift]
	, case when ER.F_SubEventCode = '1' then 1
	       when ER.F_SubEventCode = '2' then 2
	       when ER.F_SubEventCode = '3' then 3 
	       else '' end AS [Order]
	FROM TS_Event AS E
	LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event_Record AS ER ON E.F_EventID = ER.F_EventID AND ER.F_Active = 1
	LEFT JOIN TC_RecordType_Des AS RTD ON ER.F_RecordTypeID = RTD.F_RecordTypeID AND RTD.F_LanguageCode = @LanguageCode
	LEFT JOIN TR_Register AS R ON ER.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID	
	)
    --select * from #Temp_Unit    
	DECLARE @Temp_Record AS NVARCHAR(MAX)
	SET @Temp_Record = ( SELECT [Record].[ID] AS [ID],
	                        [Record].[Name] AS [Name],
	                        [Record].[Order] AS [Order],
	                        [Unit].[UnitName] AS [UnitName],
	                        [Unit].[AthleteName] AS [AthleteName],
	                        [Unit].[NOC_Code] AS [NOC_Code],
	                        [Unit].[Year] AS [Year],
	                        [Unit].[Lift] AS [Lift],
	                        [Unit].[Order] AS [Order]
	            FROM #Temp_Record AS [Record] 
				LEFT JOIN #Temp_Unit AS [Unit] 
					ON [Record].EventID = [Unit].EventID AND [Record].TypeID = [Unit].TypeID
				ORDER BY Record.EventID,Record.[Order], [Unit].[Order]
				FOR XML AUTO)

	IF @Temp_Record IS NULL
	BEGIN
		SET @Temp_Record = N''
	END


	DECLARE @MessageProperty AS NVARCHAR(MAX)
	SET @MessageProperty = N'Type = "WLREC"'
							+N' ID = "WL0000000"'
							+N' Discipline = "'+ @DisciplineCode + '"'
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
					   <Message ' + @MessageProperty +'>'
					+ @Temp_Record
					+ N'
						</Message>'


	SELECT @OutputXML AS OutputXML
	RETURN

SET NOCOUNT OFF
END
/*
    EXEC Proc_CIS_WLREC 'WL','ENG'
*/