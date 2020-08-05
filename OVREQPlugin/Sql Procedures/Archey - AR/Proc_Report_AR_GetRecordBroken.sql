IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetRecordBroken]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetRecordBroken]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_AR_GetRecordBroken]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月25日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetRecordBroken]
	@EventID					INT,
	@RegTypeID					INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
	SET LANGUAGE ENGLISH
	
	DECLARE @SexCode int
	select @SexCode =F_SexCode FROM TS_Event WHERE F_EventID = @EventID

	IF(@RegTypeID =1)
	BEGIN
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
    ,OER.F_RecordValue AS OldRecordValue
	FROM TS_Event_Record AS NER
	LEFT JOIN TS_Event AS E ON NER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Record AS OER ON OER.F_EventID = NER.F_EventID AND OER.F_IsNewCreated =0 
				AND ISNULL(OER.F_SubEventCode,0) =ISNULL(NER.F_SubEventCode,0)
	LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = e.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = NER.F_RecordTypeID AND RTD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = NER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = NER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
    LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = R.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON  DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode = @LanguageCode 
    WHERE  NER.F_IsNewCreated =1 AND  E.F_SexCode = @SexCode AND E.F_PlayerRegTypeID = @RegTypeID
	END
	
	IF(@RegTypeID =3)
	BEGIN
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
    ,OER.F_RecordValue AS OldRecordValue
    ,MRD1.F_PrintLongName AS MembersName1
    ,MRD2.F_PrintLongName AS MembersName2
    ,MRD3.F_PrintLongName AS MembersName3
	FROM TS_Event_Record AS NER
	LEFT JOIN TS_Event AS E ON NER.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Record AS OER ON OER.F_EventID = NER.F_EventID AND OER.F_IsNewCreated =0 
				AND ISNULL(OER.F_SubEventCode,0) =ISNULL(NER.F_SubEventCode,0)
	LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = e.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = NER.F_RecordTypeID AND RTD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = NER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = NER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
    
    LEFT JOIN TR_Register_Member AS RM1 ON RM1.F_RegisterID = NER.F_RegisterID AND RM1.F_Order=1
    LEFT JOIN TR_Register AS MR1 ON MR1.F_RegisterID = RM1.F_MemberRegisterID
    LEFT JOIN TR_Register_Des AS MRD1 ON MRD1.F_RegisterID = RM1.F_MemberRegisterID AND MRD1.F_LanguageCode = @LanguageCode 
    
    LEFT JOIN TR_Register_Member AS RM2 ON RM2.F_RegisterID = NER.F_RegisterID AND RM2.F_Order=2
    LEFT JOIN TR_Register AS MR2 ON MR2.F_RegisterID = RM2.F_MemberRegisterID
    LEFT JOIN TR_Register_Des AS MRD2 ON MRD2.F_RegisterID = RM2.F_MemberRegisterID AND MRD2.F_LanguageCode = @LanguageCode 
        
    LEFT JOIN TR_Register_Member AS RM3 ON RM3.F_RegisterID = NER.F_RegisterID AND RM3.F_Order=3
    LEFT JOIN TR_Register AS MR3 ON MR3.F_RegisterID = RM3.F_MemberRegisterID
    LEFT JOIN TR_Register_Des AS MRD3 ON MRD3.F_RegisterID = RM3.F_MemberRegisterID AND MRD3.F_LanguageCode = @LanguageCode 
    
    LEFT JOIN TC_Delegation AS D ON D.F_DelegationID = R.F_DelegationID
    LEFT JOIN TC_Delegation_Des AS DD ON  DD.F_DelegationID = R.F_DelegationID AND DD.F_LanguageCode = @LanguageCode 
    WHERE  NER.F_IsNewCreated =1 AND  E.F_SexCode = @SexCode AND E.F_PlayerRegTypeID = @RegTypeID
	END

SET NOCOUNT OFF
END


/*
EXEC [Proc_Report_AR_GetRecordBroken] 1,3,'ENG'
*/
GO


