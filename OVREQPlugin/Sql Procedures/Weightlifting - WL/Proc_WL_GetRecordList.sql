
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetRecordList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetRecordList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_WL_GetRecordList]
--描    述: 获取 Records 的主要内容
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月12日
--修改记录：
/*			
			日期					修改人		修改内容
			2012/12/23				崔凯		修改获取记录类别名称（新加记录类别表TC_RecordType 和TC_RecordType_Des）
*/



CREATE PROCEDURE [dbo].[Proc_WL_GetRecordList]
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
		SnatchResult			NVARCHAR(10),
		CleanJerkResult			NVARCHAR(10),
		TotalResult			    NVARCHAR(10),
	)

	INSERT #Temp_Table
	(RecordTypeID,RecordType,SnatchResult,CleanJerkResult,TotalResult,Record)  
	(
    SELECT DISTINCT
    RTD.F_RecordTypeID,
    RTD.F_RecordTypeLongName AS [Type],    
    --ERS.F_RecordValue AS [SnatchResult],
    --ERCJ.F_RecordValue AS [CleanJerkResult],
    --ERT.F_RecordValue AS [TotalResult]
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS [SnatchResult],
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND ERS.F_SubEventCode = '2' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID ORDER BY ERS.F_RecordValue DESC) AS CleanJerkResult,
    (SELECT TOP 1 ERS.F_RecordValue FROM TS_Event_Record AS ERS WHERE ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 AND (ERS.F_SubEventCode = '3' OR ERS.F_SubEventCode IS NULL) AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID 
			ORDER BY ERS.F_RecordValue DESC) AS TotalResult
	,RT.F_RecordTypeCode
    FROM TC_RecordType_Des AS RTD
    LEFT JOIN TC_RecordType AS RT ON RT.F_RecordTypeID = RTD.F_RecordTypeID
    LEFT JOIN TS_Event_Record AS ER ON ER.F_RecordTypeID = RTD.F_RecordTypeID
   -- LEFT JOIN TS_Event_Record AS ERS ON ERS.F_RecordTypeID = RTD.F_RecordTypeID 
		 --AND ERS.F_SubEventCode = '1' AND ERS.F_Active=1 AND ERS.F_EventID=ER.F_EventID
  --  LEFT JOIN TS_Event_Record AS ERCJ ON ERCJ.F_RecordTypeID = RTD.F_RecordTypeID
		--AND ERCJ.F_SubEventCode = '2' AND ERCJ.F_Active=1 AND ERCJ.F_EventID=ER.F_EventID
  --  LEFT JOIN TS_Event_Record AS ERT ON ERT.F_RecordTypeID = RTD.F_RecordTypeID 
		--AND (ERT.F_SubEventCode = '3' OR ERT.F_SubEventCode IS NULL) AND ERT.F_Active=1 AND ERT.F_EventID=ER.F_EventID
    WHERE ER.F_EventID = @EventID AND ER.F_Active = 1 AND RTD.F_LanguageCode=@LanguageCode
    )
    
    
    SELECT * FROM #Temp_Table
    

SET NOCOUNT OFF
END



/*
EXEC Proc_WL_GetRecordList 5 , 'ENG'
*/