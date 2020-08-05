IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_WL_GetRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_WL_GetRecordList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_SCB_WL_GetRecordList]
--描    述: 获取该级别所有记录信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年2月28日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SCB_WL_GetRecordList]
	@MatchID				INT
AS
BEGIN
SET NOCOUNT ON
	
	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @EventID	    INT

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode,
    @EventID = E.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

	CREATE TABLE #Temp_Table
	(
		RecordTypeID			INT,
		RecordType_ENG			NVARCHAR(100),
		RecordType_CHN			NVARCHAR(100),
		Record					NVARCHAR(10),
		SnatchRecordID			INT,
		SnatchName				NVARCHAR(100),
		SnatchNOC				CHAR(3),
		SnatchResult			NVARCHAR(10),
		CleanJerkRecordID		INT,
		CleanJerkName			NVARCHAR(100),
		CleanJerkNOC			CHAR(3),
		CleanJerkResult			NVARCHAR(10),
		TotalRecordID			INT,
		TotalName				NVARCHAR(100),
		TotalNOC				CHAR(3),
		TotalResult			    NVARCHAR(10),
	)

	INSERT #Temp_Table
	(RecordTypeID,RecordType_ENG,RecordType_CHN,SnatchRecordID,SnatchResult,CleanJerkRecordID,CleanJerkResult,TotalRecordID,TotalResult,Record)  
	(
    SELECT DISTINCT
     RTDE.F_RecordTypeID
    ,RTDE.F_RecordTypeLongName AS [Type_ENG] 
    ,RTDC.F_RecordTypeLongName AS [Type_CHN] 
    ,(SELECT TOP 1 ERS.F_RecordID FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTDE.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) 
		 AS SnatchRecordID
    ,(SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTDE.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) 
		 AS [SnatchResult]
	,(SELECT TOP 1 ERS.F_RecordID FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTDE.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) 
		 AS CleanJerkRecordID
	,(SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTDE.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) 
		 AS CleanJerkResult
	,(SELECT TOP 1 ERS.F_RecordID FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTDE.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '3' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalRecordID
	,(SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTDE.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '3' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalResult
	,RT.F_RecordTypeCode
    FROM TC_RecordType_Des AS RTDE
    LEFT JOIN TC_RecordType_Des AS RTDC ON RTDC.F_RecordTypeID = RTDE.F_RecordTypeID AND RTDC.F_LanguageCode='CHN'
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = RTDE.F_RecordTypeID
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordTypeID = RTDE.F_RecordTypeID
    WHERE ER.F_EventID = @EventID AND ER.F_Active = 1 AND RTDE.F_LanguageCode='ENG'
    )
    
    
    
    SELECT
     
    ER.F_EventID AS [F_EventID],
    ER.F_RecordID AS [F_RecordID],
    T.RecordTypeID, 
    T.RecordType_ENG,
    T.RecordType_CHN,
    'Snatch' AS [Lift_ENG],
    '抓举' AS [Lift_CHN],
    1 as SubEventCode,
    ISNULL(RDE.F_LongName,ER.F_CompetitorReportingName ) AS [Name_ENG],
    ISNULL(RDC.F_LongName,ER.F_CompetitorReportingName ) AS [Name_CHN],
    ISNULL(R.F_NOC,ER.F_CompetitorNOC) AS [NOC],
    ER.F_RecordValue AS [Result],
    CONVERT(NVARCHAR(100), ER.F_RecordDate, 111) AS [Date],
    ER.F_Location AS [Place]
    FROM #Temp_Table AS T
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = T.SnatchRecordID
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = ER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RDE ON RDE.F_RegisterID = ER.F_RegisterID AND RDE.F_LanguageCode='ENG'
    LEFT JOIN TR_Register_Des AS RDC ON RDC.F_RegisterID = ER.F_RegisterID AND RDC.F_LanguageCode='CHN'
    UNION
    SELECT 
     
    ER.F_EventID AS [F_EventID],
    ER.F_RecordID AS [F_RecordID],
    T.RecordTypeID, 
    T.RecordType_ENG,
    T.RecordType_CHN,
    'Clean&Jerk' AS [Lift_ENG],
    '挺举' AS [Lift_CHN],
    2 as SubEventCode,
    ISNULL(RDE.F_LongName,ER.F_CompetitorReportingName ) AS [Name_ENG],
    ISNULL(RDC.F_LongName,ER.F_CompetitorReportingName ) AS [Name_CHN],
    ISNULL(R.F_NOC,ER.F_CompetitorNOC) AS [NOC],
    ER.F_RecordValue AS [Result],
    CONVERT(NVARCHAR(100), ER.F_RecordDate, 111) AS [Date],
    ER.F_Location AS [Place]  FROM #Temp_Table AS T
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = T.CleanJerkRecordID
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = ER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RDE ON RDE.F_RegisterID = ER.F_RegisterID AND RDE.F_LanguageCode='ENG'
    LEFT JOIN TR_Register_Des AS RDC ON RDC.F_RegisterID = ER.F_RegisterID AND RDC.F_LanguageCode='CHN'
    
    UNION
    SELECT 
     
    ER.F_EventID AS [F_EventID],
    ER.F_RecordID AS [F_RecordID],
    T.RecordTypeID, 
    T.RecordType_ENG,
    T.RecordType_CHN,
    'Total' AS [Lift_ENG],
    '总成绩' AS [Lift_CHN],
    3 as SubEventCode,
    ISNULL(RDE.F_LongName,ER.F_CompetitorReportingName ) AS [Name_ENG],
    ISNULL(RDC.F_LongName,ER.F_CompetitorReportingName ) AS [Name_CHN],
    ISNULL(R.F_NOC,ER.F_CompetitorNOC) AS [NOC],
    ER.F_RecordValue AS [Result],
    CONVERT(NVARCHAR(100), ER.F_RecordDate, 111) AS [Date],
    ER.F_Location AS [Place]  FROM #Temp_Table AS T
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordID = T.TotalRecordID
    LEFT JOIN TR_Register AS R ON R.F_RegisterID = ER.F_RegisterID
    LEFT JOIN TR_Register_Des AS RDE ON RDE.F_RegisterID = ER.F_RegisterID AND RDE.F_LanguageCode='ENG'
    LEFT JOIN TR_Register_Des AS RDC ON RDC.F_RegisterID = ER.F_RegisterID AND RDC.F_LanguageCode='CHN'
    
    ORDER BY T.RecordTypeID,SubEventCode
    
SET NOCOUNT OFF
END


/*
exec Proc_SCB_WL_GetRecordList 61
*/