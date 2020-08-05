IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetRecordList]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_AR_GetRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月12日
--修改记录：
/*			
			日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_AR_GetRecordList]
	@MatchID				INT,
	@LanguageCode				CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	SET @LanguageCode=ISNULL(@LanguageCode,'ENG')
	
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
		RecordType				NVARCHAR(100),
		Record					NVARCHAR(10),
		LongReocrdA				NVARCHAR(10),
		LongReocrdB				NVARCHAR(10),
		ShortReocrdA			NVARCHAR(10),
		ShortReocrdB			NVARCHAR(10),
		TotalRecord				NVARCHAR(10),
		F_RegisterID			int,
		F_RecordID				int,
		F_IsNewCreated			int,
		F_SubCode				NVARCHAR(10),
	)

	INSERT #Temp_Table
	(RecordTypeID,RecordType,LongReocrdA,LongReocrdB,ShortReocrdA,ShortReocrdB,TotalRecord,Record,F_RegisterID,F_RecordID,F_IsNewCreated,F_SubCode)  
	(
    SELECT DISTINCT
    RTD.F_RecordTypeID,
    RTD.F_RecordTypeLongName AS [Type], 
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS LongReocrdA,
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS LongReocrdB,
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '3' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS ShortReocrdA,
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '4' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS ShortReocrdB,
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '0' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalRecord,
	RT.F_RecordTypeCode
	,ER.F_RegisterID
	,ER.F_RecordID
	,ER.F_IsNewCreated
	,ISNULL(ER.F_SubEventCode,'0')
    FROM TC_RecordType_Des AS RTD
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = RTD.F_RecordTypeID
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordTypeID = RTD.F_RecordTypeID
    WHERE ER.F_EventID = @EventID AND ER.F_Active = 1 AND RTD.F_LanguageCode=@LanguageCode
    )
    
    
    SELECT * FROM #Temp_Table order by TotalRecord desc
    

SET NOCOUNT OFF
END



/*
EXEC Proc_AR_GetRecordList 33 , 'ENG'
*/
GO


