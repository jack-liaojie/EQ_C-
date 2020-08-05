IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_SH_GetRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月12日

--修改记录：穆学峰



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetRecordList]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

    CREATE TABLE #Temp_Table
    (
        FatherRecordTypeID     INT,
        RecordTypeID           INT,
        FatherTypeName           NVARCHAR(100),
        [Event]              NVARCHAR(100),
        [Type]               NVARCHAR(10),
        Name           NVARCHAR(100),
        NOC            NVARCHAR(10),
        Result         NVARCHAR(100),
        [Date]         NVARCHAR(100),
        [Place]        NVARCHAR(100),
    )
    
    INSERT #Temp_Table
    (FatherRecordTypeID,RecordTypeID,FatherTypeName,[Event],[Type],Name,NOC,Result,[Date],[Place])
	(
    SELECT 
    FRT.F_RecordTypeID AS FatherRecordTypeID,
    RT.F_RecordTypeID AS RecordTypeID,
    FRTD.F_RecordTypeLongName AS FatherTypeName,
    ED.F_EventShortName AS [Event], 
    case when ER.F_Equalled = 0 then RT.F_RecordTypeCode
         when ER.F_Equalled = 1 then 'E' + RT.F_RecordTypeCode 
         else '' end AS [Type],
    RD.F_LongName,
    TR.F_NOC,
    case when RV.F_RecordID IS NULL then ER.F_RecordValue
         else ER.F_RecordValue + '(' + RV.F_CharValue1 + '+' + RV.F_CharValue2 + ')'
         end AS [Result],
    CONVERT(NVARCHAR(100), ER.F_RecordDate, 111) AS [Date],
    ER.F_Location AS [Place]
    FROM TS_Event_Record AS ER
    LEFT JOIN TC_RecordType AS RT ON ER.F_RecordTypeID = RT.F_RecordTypeID
    LEFT JOIN TC_RecordType AS FRT ON RT.F_FatherRecordTypeID = FRT.F_RecordTypeID
    LEFT JOIN TC_RecordType_Des AS FRTD ON FRT.F_RecordTypeID = FRTD.F_RecordTypeID AND FRTD.F_LanguageCode = @LanguageCode
    LEFT JOIN TS_Event AS E ON E.F_EventID = ER.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = ER.F_EventID AND ED.F_LanguageCode = @LanguageCode	
    LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = E.F_DisciplineID AND D.F_DisciplineID = @DisciplineID
    LEFT JOIN TS_Record_Values AS RV ON ER.F_RecordID = RV.F_RecordID AND RV.F_ValueNum = 1 
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS TR ON TR.F_RegisterID = RD.F_RegisterID
--    LEFT JOIN TC_Delegation AS DD ON DD.F_DelegationID = TR.F_DelegationID
    WHERE ER.F_RecordID NOT IN (SELECT F_NewRecordID FROM TS_Result_Record AS RR 
    LEFT JOIN TS_Match AS M ON RR.F_MatchID = M.F_MatchID 
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID WHERE D.F_DisciplineID = @DisciplineID)
	)

    SELECT * FROM #Temp_Table

SET NOCOUNT OFF
END

GO


-- Proc_Report_SH_GetRecordList 1,'eng'