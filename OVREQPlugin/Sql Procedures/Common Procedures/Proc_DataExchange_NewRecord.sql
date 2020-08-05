
/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_NewRecord]    Script Date: 07/22/2011 15:51:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_DataExchange_NewRecord]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_DataExchange_NewRecord]
GO

/****** Object:  StoredProcedure [dbo].[Proc_DataExchange_NewRecord]    Script Date: 07/22/2011 15:51:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_DataExchange_NewRecord]
----功		  能：破纪录信息(M4041)。
----作		  者：吴定昉
----日		  期: 2011-03-25 
----修 改 记  录: 


CREATE PROCEDURE [dbo].[Proc_DataExchange_NewRecord]
		@Discipline			AS NVARCHAR(50),
		@EventID            AS INT
AS
BEGIN
	
SET NOCOUNT ON

SET NOCOUNT ON

	DECLARE @DisciplineID		AS NVARCHAR(50)
	DECLARE @LanguageCode		AS CHAR(3)
    DECLARE @DisciplineCode NVARCHAR(10)	
    DECLARE @SexCode        NVARCHAR(1)
    DECLARE @GenderCode     NVARCHAR(1)
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @RegType        INT
	
	SET @LanguageCode = ISNULL( @LanguageCode, 'ENG')
	
	DECLARE @OutputXML AS NVARCHAR(MAX)

	SELECT @DisciplineID = D.F_DisciplineID,
	@DisciplineCode = D.F_DisciplineCode,
    @SexCode = E.F_SexCode, 
    @GenderCode = S.F_GenderCode,     
	@EventCode = E.F_EventCode,
	@RegType = E.F_PlayerRegTypeID
    FROM TS_Event AS E 
	LEFT JOIN TC_Sex AS S ON E.F_SexCode = S.F_SexCode	
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_EventID = @EventID
	
	CREATE TABLE #NewRecord
	(
	    [F_RegisterID]      INT, 
	    [Type]  varchar(10),
	    [Reg_ID] varchar(10),
	    [Date] varchar(10),
	    [Time] varchar(10),
		[NOC]  varchar(3),
		[Result]  varchar(20),
		[Old_Result]  varchar(20),
		[Holder]  varchar(50),
		[Old_Date] varchar(10),
		[Old_Time] varchar(10),
		[Mode]  INT
	)
	
	INSERT INTO #NewRecord([F_RegisterID],[Type],[Reg_ID],[Date],[Time],[NOC],[Result],[Old_Result],[Holder],[Old_Date],[Old_Time],[Mode])
	(SELECT RR.F_RegisterID AS [F_RegisterID],
								case when RR.F_NewRecordID is null then '' 
													 when RR.F_NewRecordID is not null and RR.F_Equalled = 0 then ISNULL(RT.F_RecordTypeCode,'') 
													 when RR.F_NewRecordID is not null and RR.F_Equalled = 1 then ('E' + ISNULL(RT.F_RecordTypeCode,''))
													 else '' end AS [Type],
											   NR.F_RegisterCode AS [Reg_ID],
											   ISNULL(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), NER.F_RecordDate, 120 ), 10), '-', ''),'00000000' ) AS [Date],
											   ISNULL(left(REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX),RR.F_RecordTime , 121 ), 12), ':', ''), '.', ''),4),'0000') AS [Time],
											   case when NR.F_DelegationID is not null then NRD.F_DelegationCode 
											        else NR.F_NOC end AS [NOC],
											   NER.F_RecordValue AS [Result],
											   OER.F_RecordValue AS [Old_Result],
											   OORD.F_LongName AS [Holder],
											   ISNULL(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), OER.F_RecordDate , 120 ), 10), '-', ''),'00000000') AS [Old_Date],
											   REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), '0000' , 121 ), 12), ':', ''), '.', '') AS [Old_Time],
											   ISNULL(NER.F_SubEventCode,0) AS [Mode]
								FROM TS_Result_Record AS RR
								LEFT JOIN TS_Event_Record AS NER ON RR.F_NewRecordID = NER.F_RecordID
								LEFT JOIN TC_RecordType AS RT ON NER.F_RecordTypeID = RT.F_RecordTypeID
								LEFT JOIN TR_Register AS NR ON RR.F_RegisterID = NR.F_RegisterID
								LEFT JOIN TC_Delegation AS NRD ON NR.F_DelegationID = NRD.F_DelegationID
								LEFT JOIN TS_Event_Record AS OER ON RR.F_RecordID = OER.F_RecordID
								LEFT JOIN TR_Register AS OOR ON OER.F_RegisterID = OOR.F_RegisterID
								LEFT JOIN TR_Register_Des AS OORD ON OOR.F_RegisterID = OORD.F_RegisterID AND OORD.F_LanguageCode =@LanguageCode
								WHERE RR.F_MatchID IN (SELECT F_MatchID FROM TS_Match AS M 
								                                   LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
								                                   LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
								                                   WHERE E.F_DisciplineID = @DisciplineID AND E.F_EventID = @EventID)
	)
	
	DECLARE @Count        INT
	SET @Count = 0
	SELECT @Count = COUNT(*) FROM #NewRecord
	IF @Count is null OR @Count = 0
	    return 
								
	CREATE TABLE #Athlete
	(
	    [F_RegisterID]      INT, 
	    [Registration]  varchar(10),
	    [Order] varchar(10),
	)
	
	INSERT INTO #Athlete([F_RegisterID],[Registration],[Order])
	(SELECT NewRecord.[F_RegisterID],OOR.F_RegisterCode,RM.F_Order FROM #NewRecord AS NewRecord
	 INNER JOIN TR_Register_Member AS RM ON NewRecord.F_RegisterID = RM.F_RegisterID
	 LEFT JOIN TR_Register AS OOR ON RM.F_MemberRegisterID = OOR.F_RegisterID
	 )

								
	DECLARE @Content AS NVARCHAR(MAX)
	IF @RegType = 1
	SET @Content = ( SELECT NewRecord.[Type] AS [Type],
	                        NewRecord.[Reg_ID] AS [Reg_ID],
	                        NewRecord.[Date] AS [Date],
	                        NewRecord.[Time] AS [Time],
	                        NewRecord.[NOC] AS [NOC],
	                        NewRecord.[Result] AS [Result],
	                        NewRecord.[Old_Result] AS [Old_Result],
	                        NewRecord.[Holder] AS [Holder],
	                        NewRecord.[Old_Date] AS [Old_Date],
	                        NewRecord.[Old_Time] AS [Old_Time],
	                        NewRecord.[Mode] AS [Mode]
						FROM #NewRecord AS NewRecord
			FOR XML AUTO)
	ELSE 
	SET @Content = ( SELECT NewRecord.[Type] AS [Type],
	                        NewRecord.[Reg_ID] AS [Reg_ID],
	                        NewRecord.[Date] AS [Date],
	                        NewRecord.[Time] AS [Time],
	                        NewRecord.[NOC] AS [NOC],
	                        NewRecord.[Result] AS [Result],
	                        NewRecord.[Old_Result] AS [Old_Result],
	                        NewRecord.[Holder] AS [Holder],
	                        NewRecord.[Old_Date] AS [Old_Date],
	                        NewRecord.[Old_Time] AS [Old_Time],
	                        NewRecord.[Mode] AS [Mode],
	                        Athlete.[Registration] AS [Registration],
	                        Athlete.[Order] AS [Order] 
						FROM #NewRecord AS NewRecord
						LEFT JOIN #Athlete AS Athlete ON NewRecord.F_RegisterID = Athlete.F_RegisterID
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
							+N' RSC = "' + @Discipline + @GenderCode + @EventCode + '000"'
							+N' Discipline = "'+ @Discipline +'"'
							+N' Gender = "' + @GenderCode +'"'
							+N' Event = "' + @EventCode + '"'
							+N' Phase = "0"'
							+N' Unit = "00"'
							+N' Venue ="000"'
							+N' Code = "M4041"'
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


