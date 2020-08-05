IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetRecordFormList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetRecordFormList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_WL_GetRecordFormList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月12日
--修改记录：
/*
	修改时间     修改人    备注
	2012/12/23   崔凯	 修改获取记录类别名称（新加记录类别表TC_RecordType 和TC_RecordType_Des）
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetRecordFormList]
	@PhaseID					INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SET LANGUAGE N'English'

	declare @EventID	int
	select @EventID = F_EventID  from TS_Phase where F_PhaseID= @PhaseID

    SELECT 
    ED.F_EventLongName AS [Event], 
    RTD.F_RecordTypeLongName AS [Type],
    case when ER.F_SubEventCode IS NULL OR ER.F_SubEventCode = '3' then 'Total' 
         when ER.F_SubEventCode = '1' then 'Snatch'
         when ER.F_SubEventCode = '2' then 'Clean & Jerk'
         end AS [Lift],
    ISNULL(ER.F_SubEventCode,'3') AS [SubEventCode],
    ISNULL(RD.F_PrintLongName,ER.F_CompetitorReportingName) AS [Name],
	dbo.Fun_WL_GetDateTime(ISNULL(R.F_Birth_Date,ER.F_CompetitorBirthDate),1,@LanguageCode) AS [DateOfBirth],
    ISNULL(R.F_NOC,ER.F_CompetitorNOC) AS [NOC],
    ER.F_RecordValue AS [Result],
    CAST(ER.F_RecordValue AS FLOAT)-20 AS [Barbell],
    (DATENAME(day,ER.F_RecordDate) + ' ' + LEFT(UPPER(DATENAME(month,ER.F_RecordDate)), 3) + ' ' + DATENAME(year,ER.F_RecordDate)) AS [Time],
    ER.F_Location AS [Place],
    E.F_EventCode AS [EventCode],
    RT.F_RecordTypeCode AS RecordType,
    ISNULL(PR.F_PhasePointsCharDes1, R.F_Weight) AS BodyWeight 
    FROM TS_Result_Record AS RR
    LEFT JOIN TS_Event_Record AS ER ON RR.F_NewRecordID = ER.F_RecordID
    LEFT JOIN TS_Event AS E ON E.F_EventID = ER.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = ER.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
    LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = RT.F_RecordTypeID
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = ER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = ER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Phase_Result AS PR ON PR.F_RegisterID = RR.F_RegisterID 
		AND PR.F_PhaseID = @PhaseID --IN (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID)
    WHERE ER.F_Equalled = 0 AND RTD.F_LanguageCode = @LanguageCode --AND ER.F_EventID = @EventID
		AND ER.F_RecordValue IS NOT NULL 
		AND RR.F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID)
	
SET NOCOUNT OFF
END


/*
EXEC [Proc_Report_WL_GetRecordFormList] 3,'ENG'
*/
GO


