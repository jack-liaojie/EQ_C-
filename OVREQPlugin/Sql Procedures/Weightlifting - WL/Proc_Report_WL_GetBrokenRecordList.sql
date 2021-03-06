IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetBrokenRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetBrokenRecordList]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Report_WL_GetBrokenRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年11月07日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetBrokenRecordList]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
	SET LANGUAGE ENGLISH
	
	CREATE TABLE #TMP_Table
	(	F_EventID INT,
		F_MatchID INT,
		F_SubEventCode INT,
		F_RegisterID INT,
		F_RecordValue nvarchar(50) collate database_default
	)
	
	INSERT INTO #TMP_Table(F_EventID,F_MatchID,F_RegisterID,F_SubEventCode,F_RecordValue)
    (SELECT DISTINCT
    E.F_EventID,
    RR.F_MatchID AS [F_MatchID],
    RR.F_RegisterID,
    ISNULL(ER.F_SubEventCode,'3') AS F_SubEventCode,
    ER.F_RecordValue AS [F_RecordValue]
    FROM TS_Result_Record AS RR
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = RR.F_NewRecordID
    LEFT JOIN TS_Event AS E ON E.F_EventID = ER.F_EventID
    LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = E.F_DisciplineID AND D.F_DisciplineID = @DisciplineID
    WHERE E.F_EventID IS NOT NULL AND ER.F_RecordValue IS NOT NULL
	)
	
	
    SELECT DISTINCT
    ED.F_EventLongName AS [Event], 
    case when NER.F_SubEventCode = '3' OR NER.F_SubEventCode IS NULL then 'Total' 
         when NER.F_SubEventCode = '1' then 'Snatch'
         when NER.F_SubEventCode = '2' then 'Clean & Jerk'
         else '' end AS [SubEventType],
    T.F_RecordValue AS [Result],
    CASE WHEN NER.F_RegisterID IS NULL THEN NER.F_CompetitorReportingName ELSE  RD.F_PrintLongName END AS [Name],
    CASE WHEN  NER.F_RegisterID IS NULL THEN NER.F_CompetitorNOC ELSE R.F_NOC  END AS [NOC],
    CASE WHEN NER.F_RegisterID IS NULL 
		THEN dbo.Fun_WL_GetDateTime(NER.F_CompetitorBirthDate,1,@LanguageCode)
		 ELSE dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,@LanguageCode)
		  END AS [DateOfBirth],
    dbo.Fun_WL_GetDateTime(NER.F_RecordDate,1,'ENG') AS [Date],
    E.F_EventCode AS EventCode,
    T.F_SubEventCode AS SubEventCode,
    (SELECT COUNT(1) FROM TS_Event_Record AS WER
		LEFT JOIN TC_RecordType AS ZRT ON ZRT.F_RecordTypeID = WER.F_RecordTypeID
		 WHERE T.F_EventID = WER.F_EventID AND T.F_RecordValue = WER.F_RecordValue
    AND ISNULL(WER.F_SubEventCode,'3')= ISNULL(T.F_SubEventCode,3) AND WER.F_RegisterID = T.F_RegisterID AND ZRT.F_RecordTypeID = 1 )
		AS [WR],
		    (SELECT COUNT(1) FROM TS_Event_Record AS WER
		LEFT JOIN TC_RecordType AS ZRT ON ZRT.F_RecordTypeID = WER.F_RecordTypeID
		 WHERE T.F_EventID = WER.F_EventID AND T.F_RecordValue = WER.F_RecordValue 
    AND ISNULL(WER.F_SubEventCode,'3')= ISNULL(T.F_SubEventCode,3) AND WER.F_RegisterID = T.F_RegisterID AND ZRT.F_RecordTypeID = 2 )
		AS [YWR],
		    (SELECT COUNT(1) FROM TS_Event_Record AS WER
		LEFT JOIN TC_RecordType AS ZRT ON ZRT.F_RecordTypeID = WER.F_RecordTypeID
		 WHERE T.F_EventID = WER.F_EventID AND T.F_RecordValue = WER.F_RecordValue 
    AND ISNULL(WER.F_SubEventCode,'3')= ISNULL(T.F_SubEventCode,3) AND WER.F_RegisterID = T.F_RegisterID AND ZRT.F_RecordTypeID = 3 )
		AS [JWR]
    FROM #TMP_Table AS T
    LEFT JOIN TS_Event_Record AS NER ON T.F_EventID = NER.F_EventID
		AND T.F_RecordValue = NER.F_RecordValue AND ISNULL(NER.F_SubEventCode,'3')= ISNULL(T.F_SubEventCode,'3') AND NER.F_RegisterID = T.F_RegisterID
	LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = NER.F_RecordID
    LEFT JOIN TS_Event AS E ON E.F_EventID = T.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = T.F_EventID AND ED.F_LanguageCode = @LanguageCode	
    LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = E.F_DisciplineID AND D.F_DisciplineID = @DisciplineID
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = T.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = T.F_RegisterID AND RD.F_LanguageCode = @LanguageCode 
    --LEFT JOIN TS_Event_Record AS OER ON NER.F_EventID = OER.F_EventID AND NER.F_RecordType = OER.F_RecordType AND OER.F_RecordComment = 'Old'
    WHERE  NER.F_IsNewCreated =1 --NER.F_RecordComment = 'New'

SET NOCOUNT OFF
END


/*
EXEC [Proc_Report_WL_GetBrokenRecordList] 1, 'ENG'
EXEC [Proc_Report_WL_GetBrokenRecordList] 1, 'CHN'
*/