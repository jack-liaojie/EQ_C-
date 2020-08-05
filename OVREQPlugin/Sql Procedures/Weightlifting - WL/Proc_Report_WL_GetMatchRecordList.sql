IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetMatchRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetMatchRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Report_WL_GetMatchRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年1月14日
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetMatchRecordList]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	SET LANGUAGE English
	SET @LanguageCode = ISNULL(@LanguageCode,'ENG')
	
	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @EventID	    INT
	DECLARE @PhaseID	    INT

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @PhaseID = P.F_PhaseID,
    @MatchCode = M.F_MatchCode,
    @EventID = E.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

	
    SELECT 
    ER.F_EventID AS [F_EventID],
    ED.F_EventShortName AS [Event],
    ER.F_RecordID AS [F_RecordID],
    ER.F_RecordTypeID AS [F_RecordTypeID],
    RTD.F_RecordTypeLongName AS [Type],
    case when (ER.F_SubEventCode IS NULL OR ER.F_SubEventCode = '3') then 'Total' 
         when ER.F_SubEventCode = '1' then 'Snatch'
         when ER.F_SubEventCode = '2' then 'Clean & Jerk'
         else '' end AS [Lift],
    CASE WHEN ER.F_RegisterID IS NULL THEN ER.F_CompetitorReportingName ELSE  RD.F_PrintLongName END AS [Name],
    CASE WHEN  ER.F_RegisterID IS NULL THEN ER.F_CompetitorNOC ELSE R.F_NOC  END AS [NOC],
    ER.F_RecordValue AS [Result],
    CASE WHEN ER.F_RegisterID IS NULL 
		THEN dbo.Fun_WL_GetDateTime(ER.F_CompetitorBirthDate,1,@LanguageCode)
		ELSE dbo.Fun_WL_GetDateTime(R.F_Birth_Date,1,@LanguageCode)
		  END AS [DateOfBirth],
    dbo.Fun_WL_GetDateTime(ER.F_RecordDate,1,@LanguageCode) AS [RecordDate],
    ER.F_Location AS [Place],
    ISNULL(ER.F_SubEventCode,'3') AS [SubEventCode]
    
    FROM TS_Result_Record AS RR    
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = RR.F_NewRecordID
    LEFT JOIN TS_Event AS E ON E.F_EventID = ER.F_EventID
    LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = ER.F_EventID AND ED.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = ER.F_RecordTypeID
    LEFT JOIN TC_RecordType_Des AS RTD ON RTD.F_RecordTypeID = RT.F_RecordTypeID AND RTD.F_LanguageCode = @LanguageCode
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = RR.F_RegisterID
    LEFT JOIN TR_Register_Des AS RD ON RD.F_RegisterID = RR.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
    WHERE RR.F_MatchID IN (SELECT F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID) AND RR.F_Equalled=0
	ORDER BY [SubEventCode],[F_RecordID] 

SET NOCOUNT OFF
END
/*
EXEC [Proc_Report_WL_GetMatchRecordList] 57, 'ENG'
EXEC [Proc_Report_WL_GetMatchRecordList] 7, 'CHN'
*/
GO


