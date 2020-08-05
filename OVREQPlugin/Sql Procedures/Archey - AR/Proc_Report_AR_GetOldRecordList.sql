IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetOldRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetOldRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_AR_GetOldRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月25日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetOldRecordList]
	@EventID					INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
	SET LANGUAGE ENGLISH
	

    SELECT DISTINCT
     ED.F_EventLongName AS [Event], 
     ED.F_EventID  AS [EventID], 
     RTD.F_RecordTypeLongName AS [RecordType], 
     RTD.F_RecordTypeID  AS [RecordTypeID],  
     E.F_PlayerRegTypeID  AS [RegTypeID], 
     NER.F_Location AS Place
    ,D.F_DelegationCode AS NOC
    ,DD.F_DelegationLongName AS NOCName
    ,DBO.FUN_AR_GETDATETIME(NER.F_RecordDate,1,@LanguageCode) AS OfDate
    ,RD.F_PrintLongName AS Name
    ,NER.F_SubEventCode AS SubCode
    ,NER.F_RecordSport AS [Description]
    ,NER.F_RecordValue AS NewRecordValue
    ,NER.F_Location AS Location
	FROM TS_Event_Record AS NER
	LEFT JOIN TS_Event AS E ON NER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = e.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = NER.F_RecordTypeID AND RTD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = NER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = NER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
    LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = R.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON  DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode = @LanguageCode 
    WHERE  NER.F_IsNewCreated =0 AND  E.F_EventID = @EventID

	
SET NOCOUNT OFF
END


/*
EXEC [Proc_Report_AR_GetOldRecordList] 1,3,'ENG'
*/
GO


