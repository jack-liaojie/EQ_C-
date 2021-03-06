IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetPlayerRecords]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetPlayerRecords]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_WL_GetPlayerRecords]
--描    述: 获取 某个运动员的 Records 内容
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年6月20日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_WL_GetPlayerRecords]
	@MatchID				INT,
	@CompetitionPosition		INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL		    NVARCHAR(max)
    DECLARE @DisciplineCode NVARCHAR(10)	
	DECLARE @EventCode		NVARCHAR(10)
	DECLARE @PhaseCode		NVARCHAR(10)
	DECLARE @MatchCode		NVARCHAR(10)
    DECLARE @SexCode        INT
	DECLARE @SnatchMatchID	INT
	DECLARE @CleanJerkMatchID	INT
	

	SELECT @DisciplineCode = D.F_DisciplineCode,
	@EventCode = E.F_EventCode, 
    @SexCode = E.F_SexCode, 
    @PhaseCode = P.F_PhaseCode, 
    @MatchCode = M.F_MatchCode FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
    WHERE F_MatchID = @MatchID

	SELECT @SnatchMatchID = M.F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventCode = @EventCode 
    AND E.F_SexCode = @SexCode
    AND P.F_PhaseCode = @PhaseCode
    AND M.F_MatchCode = '01'
    AND D.F_DisciplineCode = @DisciplineCode 

	SELECT @CleanJerkMatchID = M.F_MatchID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventCode = @EventCode 
    AND E.F_SexCode = @SexCode
    AND P.F_PhaseCode = @PhaseCode
    AND M.F_MatchCode = '02'
    AND D.F_DisciplineCode = @DisciplineCode 


	CREATE TABLE #Temp_Table
	(
	    RecordID                INT,
		RecordType				NVARCHAR(10),
		RecordTypeEx			NVARCHAR(10),
		Equalled                INT,
		OldRecordID             INT,
		OldRecordResult			NVARCHAR(10),
		OldName			        NVARCHAR(100),
		OldNOC			        NVARCHAR(10),
		OldDate			        NVARCHAR(10),
		OldLocation			    NVARCHAR(100),
		NewRecordResult			NVARCHAR(10),
		SubEventCode			INT,
	)

	INSERT #Temp_Table
	(RecordID,RecordType,RecordTypeEx,Equalled,
	OldRecordID,OldRecordResult,OldName,OldNOC,OldDate,OldLocation,
	NewRecordResult,SubEventCode)  
	(
    SELECT 
    NER.F_RecordID AS [RecordID],
    RT.F_RecordTypeCode AS [RecordType],
    case when RR.F_Equalled is null then RT.F_RecordTypeCode 
         when RR.F_Equalled = '0' then RT.F_RecordTypeCode
         when RR.F_Equalled = '1' then 'E'+RT.F_RecordTypeCode
         else '' end AS [RecordType],
    RR.F_Equalled AS [Equalled],
    OER.F_RecordID AS [OldRecordID],
    OER.F_RecordValue AS [OldRecordResult],
    case when OER.F_RegisterID IS NULL then (case when OER.F_CompetitorReportingName is null then OER.F_CompetitorFamilyName + ' ' + OER.F_CompetitorGivenName
                                                 else OER.F_CompetitorReportingName end)
         else ORD.F_LongName end AS [OldName],
    case when OER.F_RegisterID IS NULL then OER.F_CompetitorNOC
         else OD.F_DelegationCode end AS [OldNoc], 
    OER.F_RecordDate AS [OldDate],
    OER.F_Location AS [OldLocation],            
    NER.F_RecordValue AS [NewRecordResult],
    NER.F_SubEventCode AS SubEventCode
    FROM TS_Result_Record AS RR
    LEFT JOIN TS_Event_Record AS NER ON RR.F_NewRecordID = NER.F_RecordID
    LEFT JOIN TC_RecordType AS RT ON NER.F_RecordTypeID = RT.F_RecordTypeID
    LEFT JOIN TS_Event_Record AS OER ON RR.F_RecordID = OER.F_RecordID
    LEFT JOIN TR_Register AS OOR ON OER.F_RegisterID = OOR.F_RegisterID
    LEFT JOIN TR_Register_Des AS ORD ON OER.F_RegisterID = ORD.F_RegisterID AND ORD.F_LanguageCode = @LanguageCode
    LEFT JOIN TC_Delegation AS OD ON OOR.F_DelegationID = OD.F_DelegationID
    WHERE RR.F_MatchID in (@SnatchMatchID,@CleanJerkMatchID) AND RR.F_CompetitionPosition = @CompetitionPosition 
    )
    
    SELECT * FROM #Temp_Table
    

SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
EXEC [Proc_WL_GetPlayerRecords] 11, 10, 'ENG'
EXEC [Proc_WL_GetPlayerRecords] 4, 'CHN'
*/