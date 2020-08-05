IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_Report_WL_GetRecordList]
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



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetRecordList]
	@DisciplineID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SET LANGUAGE N'English'

    SELECT 
    ED.F_EventLongName AS [BodyweightCategory], 
    RTD.F_RecordTypeLongName AS [Type],
    case when @LanguageCode = 'ENG' AND (ER.F_SubEventCode IS NULL OR ER.F_SubEventCode = '3') then 'Total' 
         when @LanguageCode = 'ENG' AND ER.F_SubEventCode = '1' then 'Snatch'
         when @LanguageCode = 'ENG' AND ER.F_SubEventCode = '2' then 'Clean & Jerk'
         when @LanguageCode = 'CHN' AND (ER.F_SubEventCode IS NULL OR ER.F_SubEventCode = '3') then '总成绩' 
         when @LanguageCode = 'CHN' AND ER.F_SubEventCode = '1' then '抓举'
         when @LanguageCode = 'CHN' AND ER.F_SubEventCode = '2' then '挺举'
         end AS [Lift],
    ISNULL(ER.F_SubEventCode,'3') AS [SubEventCode],
    ISNULL(RD.F_PrintLongName,ER.F_CompetitorReportingName) AS [Name],
	dbo.Fun_WL_GetDateTime(ISNULL(R.F_Birth_Date,ER.F_CompetitorBirthDate),1,@LanguageCode) AS [BirthDate],
    ISNULL(R.F_NOC,ER.F_CompetitorNOC) AS [NOC],
    ER.F_RecordValue AS [Result],
    dbo.Fun_WL_GetDateTime(F_RecordDate,1,@LanguageCode) AS [Date],
    ER.F_Location AS [Place],
    E.F_EventCode AS [EventCode],
    RT.F_RecordTypeCode AS RecordOrder
    FROM TS_Event_Record AS ER
    LEFT JOIN TS_Event AS E ON E.F_EventID = ER.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = ER.F_EventID AND ED.F_LanguageCode = @LanguageCode	
    LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = E.F_DisciplineID AND D.F_DisciplineID = @DisciplineID
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
    LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = RT.F_RecordTypeID
    LEFT JOIN  TR_Register AS R ON R.F_RegisterID = ER.F_RegisterID
    LEFT JOIN  TR_Register_Des AS RD ON RD.F_RegisterID = ER.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    WHERE ER.F_Active = 1 AND RTD.F_LanguageCode = @LanguageCode
	
SET NOCOUNT OFF
END


/*
exec Proc_Report_WL_GetRecordList 1,'chn'
*/
GO


