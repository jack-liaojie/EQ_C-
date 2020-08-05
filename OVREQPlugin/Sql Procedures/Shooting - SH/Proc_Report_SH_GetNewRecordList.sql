IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetNewRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetNewRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_SH_GetNewRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年11月06日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetNewRecordList]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

    CREATE TABLE #Temp_Table
    (
        TitleID                INT,
        RecordTypeID           INT,
        Equalled               INT,
        FatherTypeName           NVARCHAR(100),
        [Event]              NVARCHAR(100),
        [Phase]              NVARCHAR(100),
        [Type]               NVARCHAR(10),
        Name           NVARCHAR(100),
        NOC            NVARCHAR(10),
        OldRecordID    INT,
        NewRecordID    INT,
        OldNew         NVARCHAR(100),
        [Date]         NVARCHAR(100),
        [Place]        NVARCHAR(100),
    )
    
    INSERT #Temp_Table
    (TitleID,RecordTypeID,Equalled,FatherTypeName,[Event],[Phase],[Type],Name,NOC,OldRecordID,NewRecordID,OldNew,[Date],[Place])
	(
    SELECT 
    100*RT.F_RecordTypeID + RR.F_Equalled AS  TitleID,
    RT.F_RecordTypeID AS RecordTypeID,
    RR.F_Equalled AS Equalled,
    (case when P.F_PhaseCode IN ('9','A') then (case when RR.F_Equalled is not null and RR.F_Equalled = 1 then 'EQUALLED' + ' ' + OFRTD.F_RecordTypeLongName 
										     else OFRTD.F_RecordTypeLongName end)
		 when P.F_PhaseCode = '1' then (case when RR.F_Equalled is not null and RR.F_Equalled = 1 then 'EQUALLED FINAL' + ' ' + OFRTD.F_RecordTypeLongName 
										     else 'NEW FINAL' + ' ' + OFRTD.F_RecordTypeLongName end) 								     
         else ''end )AS FatherTypeName,
    ED.F_EventShortName AS [Event],
    case when P.F_PhaseCode = '9' then 'Qualif.'
		 when P.F_PhaseCode = 'A' then 'Elimination'
         when P.F_PhaseCode = '1' then 'Finals' 
         else '' end AS [Phase], 
    case when RR.F_Equalled = 0 then RT.F_RecordTypeCode
         when RR.F_Equalled = 1 then 'E' + RT.F_RecordTypeCode 
         else '' end AS [Type],
    RD.F_LongName AS [Name],
    D.F_DelegationCode AS [NOC],
    OER.F_RecordID,
    NER.F_RecordID,
    OER.F_RecordValue + ' / ' + NER.F_RecordValue AS [Result],
    CONVERT(NVARCHAR(100), NER.F_RecordDate, 111) AS [Date],
    NER.F_Location AS [Place]
    FROM TS_Result_Record AS RR 
    LEFT JOIN TS_Event_Record AS OER ON RR.F_RecordID = OER.F_RecordID
    LEFT JOIN TC_RecordType AS RT ON OER.F_RecordTypeID = RT.F_RecordTypeID
    LEFT JOIN TC_RecordType AS FRT ON RT.F_FatherRecordTypeID = FRT.F_RecordTypeID
    LEFT JOIN TC_RecordType_Des AS OFRTD ON FRT.F_RecordTypeID = OFRTD.F_RecordTypeID AND OFRTD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS R ON RR.F_RegisterID = R.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RR.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D ON R.F_DelegationID = D.F_DelegationID
    LEFT JOIN TS_Event_Record AS NER ON NER.F_RecordID = RR.F_NewRecordID
    LEFT JOIN TS_Match AS M ON RR.F_MatchID = M.F_MatchID
    LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON OER.F_EventID = E.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode	
    LEFT JOIN TS_Discipline AS DD ON E.F_DisciplineID = DD.F_DisciplineID AND DD.F_DisciplineID = @DisciplineID
	)

    SELECT * FROM #Temp_Table order by TitleID

SET NOCOUNT OFF
END

GO


