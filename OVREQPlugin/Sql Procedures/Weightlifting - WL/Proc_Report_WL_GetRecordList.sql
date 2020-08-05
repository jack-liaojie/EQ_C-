IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_Report_WL_GetRecordList]
--��    ��: ��ȡ Records ����Ҫ����
--����˵��: 
--˵    ��: 
--�� �� ��: �ⶨ�P
--��    ��: 2010��10��12��
--�޸ļ�¼��
/*
	�޸�ʱ��     �޸���    ��ע
	2012/12/23   �޿�	 �޸Ļ�ȡ��¼������ƣ��¼Ӽ�¼����TC_RecordType ��TC_RecordType_Des��
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
         when @LanguageCode = 'CHN' AND (ER.F_SubEventCode IS NULL OR ER.F_SubEventCode = '3') then '�ܳɼ�' 
         when @LanguageCode = 'CHN' AND ER.F_SubEventCode = '1' then 'ץ��'
         when @LanguageCode = 'CHN' AND ER.F_SubEventCode = '2' then 'ͦ��'
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


