
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CIS_SH_GetEventRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CIS_SH_GetEventRecords]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_CIS_SH_GetEventRecords]
	@MatchID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ID NVARCHAR(50)
	DECLARE @PhaseCode CHAR(1)
	DECLARE @EventCode CHAR(3)
	DECLARE @MatchCode CHAR(2)
	DECLARE @SEXCODE CHAR(1)
	

	SELECT @PhaseCode = PHASE_CODE ,
		@EventCode = EVENT_CODE , 
		@MatchCode = Match_CODE ,
		@SEXCODE = GENDER_CODE
	FROM  dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)
		
		
	SET @ID = 'SH' + 	@SEXCODE + @EventCode + @PhaseCode + @MatchCode

	DECLARE @EventID	INT

	SELECT @EventID = P.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	WHERE M.F_MatchID = @MatchID

    CREATE TABLE #Temp_Table
    (
        F_RecordID             INT,
        FatherRecordTypeID     INT,
        RecordTypeID           INT,
        [Type]               NVARCHAR(10),
        Name           NVARCHAR(100),
        NOC            NVARCHAR(10),
        Result         NVARCHAR(100),
        [Date]         NVARCHAR(100),
        [Place]        NVARCHAR(100),
    )
    
    INSERT #Temp_Table EXEC [Proc_Report_SH_GetEventRecords] @MatchID, 'Q', 'ENG'
    INSERT #Temp_Table EXEC [Proc_Report_SH_GetEventRecords] @MatchID, 'F', 'ENG'
   
    DECLARE @OutputXML AS NVARCHAR(MAX)

	SET @OutputXML = (
    SELECT [Message].* ,
	Record.[Type], Name, ISNULL(NOC,'') AS NOC, Result, [Date], Place 		
	FROM (SELECT 'RECRD' [Type], 'SH' [Discipline], @ID [ID])  AS [Message],
	#Temp_Table AS Record
	FOR XML AUTO	
	)
	
	SET @OutputXML = N'<?xml version="1.0" encoding="UTF-8"?>'	+ @OutputXML

	SELECT @OutputXML AS MessageXML

    
SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
EXEC [Proc_CIS_SH_GetEventRecords] 4, 'ENG'
*/
