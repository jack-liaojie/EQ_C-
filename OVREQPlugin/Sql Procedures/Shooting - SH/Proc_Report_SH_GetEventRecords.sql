
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetEventRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetEventRecords]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Îâ¶¨•P
-- ÄÂÑ§·å

CREATE PROCEDURE [dbo].[Proc_Report_SH_GetEventRecords]
	@MatchID				INT,
	@Phase                   NVARCHAR(1),
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @EventID	INT

	SELECT @EventID = P.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	WHERE M.F_MatchID = @MatchiD

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
    
    INSERT #Temp_Table
    (F_RecordID,FatherRecordTypeID,RecordTypeID,[Type],Name,NOC,Result,[Date],[Place])
	(
    SELECT ER.F_RecordID,
    FRT.F_RecordTypeID AS FatherRecordTypeID,
    RT.F_RecordTypeID AS RecordTypeID,
    RT.F_RecordTypeCode AS [Type],
    RD.F_LongName AS [Name],
    TR.F_NOC AS [NOC],
    ER.F_RecordValue AS [Result],
    dbo.Func_Report_GetDateTime(ER.F_RecordDate, 4) AS [Date],
    ER.F_Location AS [Place]
    FROM TS_Event_Record AS ER
    LEFT JOIN TC_RecordType AS RT ON ER.F_RecordTypeID = RT.F_RecordTypeID
    LEFT JOIN TC_RecordType AS FRT ON RT.F_FatherRecordTypeID = FRT.F_RecordTypeID
    LEFT JOIN TS_Event AS E ON E.F_EventID = ER.F_EventID
    LEFT JOIN TS_Record_Values AS RV ON ER.F_RecordID = RV.F_RecordID AND RV.F_ValueNum = 1 
    LEFT JOIN TR_Register AS TR ON TR.F_RegisterID = ER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = TR.F_DelegationID
    WHERE ER.F_EventID = @EventID
    AND ER.F_RecordID NOT IN (SELECT F_NewRecordID FROM TS_Result_Record AS RR 
							  LEFT JOIN TS_Match AS M ON RR.F_MatchID = M.F_MatchID 
							  LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
							  LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
							  WHERE E.F_EventID = @EventID)
	)

	DECLARE @DelQCnt	INT
	DECLARE @DelFCnt	INT
	DECLARE @DelDifCnt	INT
	SET @DelQCnt = 0
	SET @DelFCnt = 0
	SET @DelDifCnt = 0
	
	SELECT @DelQCnt = COUNT(*) FROM #Temp_Table WHERE SubString([Type],1,1) = 'F' OR SubString([Type],1,2) = 'EF'
	SELECT @DelFCnt = COUNT(*) FROM #Temp_Table WHERE SubString([Type],1,1) <> 'F' AND SubString([Type],1,2) <> 'EF'
	SET @DelDifCnt = ABS(@DelQCnt- @DelFCnt)

    IF @Phase = 'Q'
    BEGIN
       DELETE #Temp_Table WHERE SubString([Type],1,1) = 'F' OR SubString([Type],1,2) = 'EF'
       IF @DelQCnt > @DelFCnt
       BEGIN
			WHILE( @DelDifCnt > 0)
			BEGIN
				INSERT INTO #Temp_Table(F_RecordID) Values(9999)
				SET @DelDifCnt = @DelDifCnt - 1
			END
       END
    END
       
    IF @Phase = 'F'
     BEGIN
       DELETE #Temp_Table WHERE SubString([Type],1,1) <> 'F' AND SubString([Type],1,2) <> 'EF'
       IF @DelFCnt > @DelQCnt
       BEGIN
			WHILE( @DelDifCnt > 0)
			BEGIN
				INSERT INTO #Temp_Table(F_RecordID) Values(9999)
				SET @DelDifCnt = @DelDifCnt - 1
			END
       END       
    END
   
    
    SELECT * FROM #Temp_Table order by RecordTypeID

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
EXEC [Proc_Report_SH_GetEventRecords] 4, 'Q', 'ENG'
EXEC [Proc_Report_SH_GetEventRecords] 1, 'F', 'ENG'
*/