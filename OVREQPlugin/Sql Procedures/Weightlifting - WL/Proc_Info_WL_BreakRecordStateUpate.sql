IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Info_WL_BreakRecordStateUpate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Info_WL_BreakRecordStateUpate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_Info_WL_BreakRecordStateUpate]
----功		  能：For Info system 输出破记录成绩（M5042）
----作		  者：崔凯
----日		  期: 2010-12-20 
----修改	记录:

CREATE PROCEDURE [dbo].[Proc_Info_WL_BreakRecordStateUpate] 
	@MatchID  AS INT,
	@LanguageCode AS CHAR(3)
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @DisciplineID AS NVARCHAR(50)
    SET @LanguageCode = ISNULL(@LanguageCode,'ENG')
    
    DECLARE @OutputXML AS NVARCHAR(MAX)
    
    DECLARE @RegisterID     INT
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
    DECLARE @SexCode        NVARCHAR(1)
    DECLARE @GenderCode     NVARCHAR(1)    
	DECLARE @PhaseID   INT
	
	SELECT 
		@RegisterID = RR.F_RegisterID,
		@DisciplineCode = D.F_DisciplineCode,
		@EventCode = E.F_EventCode,
		@SexCode = E.F_SexCode,
		@GenderCode = S.F_GenderCode
		FROM TM_Match AS M
		LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
		LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
		LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = E.F_DisciplineID
		LEFT JOIN TC_Sex AS S ON S.F_SexCode = E.F_SexCode
		LEFT JOIN TS_Result_Record AS RR ON RR.F_MatchID = M.F_MatchID
		WHERE M.F_MatchID = @MatchID
				
		CREATE TABLE #NewRecord
		(
			[State]			varchar(30),
			Mode			int,
			Registration	varchar(10),
			[Date]			varchar(8),
			[Time]			varchar(4)		
		)
		INSERT #NewRecord
		([State],Mode,Registration,[Date],[Time])
		(SELECT
			--RTD.F_RecordTypeLongName AS [State], --[State]
			ISNull('Offical',''),
		    ISNull(ER.F_SubEventCode,'3') AS Mode,				 --Mode: 1-Snatch; 2-Clean&Jerk; 3-Total
			ISNull(R.F_RegisterCode,'') AS Registration,     --[Registration]
			ISNull(REPLACE(LEFT(CONVERT(NVARCHAR(MAX), ER.F_RecordDate , 23), 10), '-', '')
				,REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 23), 10), '-', '')) AS [Date],
			ISNull(REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), ER.F_RecordDate , 24), 5), ':', ''), '.', '')
				,REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 24 ), 5), ':', '')) AS [Time]
			 --Time, we don't have time column
			
			FROM TS_Result_Record AS RR
			LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = RR.F_NewRecordID
			LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
			LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = ER.F_RecordTypeID
			LEFT JOIN TS_Event_Record AS OER ON OER.F_RecordID = RR.F_RecordID
			LEFT JOIN TR_Register R ON R.F_RegisterID = RR.F_RegisterID
			WHERE RR.F_MatchID = @MatchID AND RTD.F_LanguageCode = @LanguageCode AND ER.F_Active =1)
		
		DECLARE @NewRecord_State AS NVARCHAR(MAX)
		Set @NewRecord_State = ( SELECT * FROM #NewRecord AS NewRecord_State --ORDER BY Result,[Date],[Time] DESC
					FOR XML AUTO)
		IF @NewRecord_State IS NULL
		BEGIN
			SET @NewRecord_State = N''
		END
		
		DECLARE @MessageHeader AS Nvarchar(max)
		Set @MessageHeader = N' Version="1.0"'
							+N' Category = "VRS"'
							+N' Origin = "VRS"'
							+N' RSC = "WL'+@GenderCode + @EventCode + '0' + '00"'
							+N' Discipline = "WL"'
							+N' Gender = "'+@GenderCode+'"'
							+N' Event = "' +@EventCode+'"'
							+N' Phase= "0"'
							+N' Unit= "00"'
							+N' Venue= "000"'
							+N' Code= "M5042"'
							+N' Type= "DATA"'
							+N' Language= "'+ @LanguageCode + '"'
							+N' Date ="'+ REPLACE(LEFT(CONVERT(NVARCHAR(MAX), GETDATE() , 120 ), 10), '-', '') + '"'
							+N' Time= "'+ REPLACE(REPLACE(RIGHT(CONVERT(NVARCHAR(MAX), GETDATE() , 121 ), 12), ':', ''), '.', '')+'"'
							
		IF(@NewRecord_State = N'')
		BEGIN
		SET @OutputXML = N''
		END
	ELSE
		BEGIN
		SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>
						   <Message ' + @MessageHeader +'>'
						+ @NewRecord_State
						+ N'
							</Message>'
		END
			
	SELECT @OutputXML AS OutputXML
	RETURN
				 		
SET NOCOUNT OFF
END
