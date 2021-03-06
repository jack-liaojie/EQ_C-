IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_FB_GetMatchInfo]
----功		  能：得到当前Match信息
----作		  者：李燕
----日		  期: 2010-03-21

CREATE PROCEDURE [dbo].[Proc_Report_FB_GetMatchInfo]
             @MatchID         INT,
             @LanguageCode    CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
    CREATE TABLE #table_Match(
		F_DisciplineName	NVARCHAR(50),
        F_EventName         NVARCHAR(100),
        F_PhaseName         NVARCHAR(100),
	F_FatherPhaseName   NVARCHAR(100),
        F_UniteName         NVARCHAR(100),
	F_MatchFullName		NVARCHAR(100),
        F_VenueName         NVARCHAR(100),
        F_StartDate         DATETIME,
        F_Date              NVARCHAR(11),
        F_StartTime         NVARCHAR(5),
        F_EndTime           NVARCHAR(5),
        F_Gender            NVARCHAR(10),
        F_DisciplineCode    NVARCHAR(2),
        F_GenderCode        NVARCHAR(1),
        F_EventCode         NVARCHAR(10),
        F_PhaseCode         NVARCHAR(10),
        F_MatchCode         NVARCHAR(10),
        F_ReportName        NVARCHAR(20),
        F_DisciplineID      INT,
        F_EventID           INT,
        F_PhaseID           INT,
	F_FatherPhaseID    INT,
        F_VenueID           INT,
        F_SexCode           INT,
        F_WeekENG           NVARCHAR(10),
        F_WeekCHN           NVARCHAR(10),
        F_Report_TitleDate  NVARCHAR(20),
        F_Report_CreateDate NVARCHAR(30),
        F_MatchComment      NVARCHAR(100),
        F_PhaseIsPool       INT,
    )

    INSERT INTO #table_Match(F_StartDate, F_Date, F_StartTime, F_EndTime, F_PhaseCode, F_MatchCode, F_EventID, F_PhaseID,F_FatherPhaseID, F_VenueID, F_WeekENG, F_MatchComment, F_PhaseIsPool)
    SELECT A.F_MatchDate, LEFT(CONVERT(NVARCHAR(100), A.F_MatchDate, 120), 11), LEFT(CONVERT(NVARCHAR(100), A.F_StartTime, 114), 5), LEFT(CONVERT(NVARCHAR(100), A.F_EndTime, 114), 5), B.F_PhaseCode, 
    A.F_MatchCode, B.F_EventID 
	,B.F_PhaseID 
    ,(CASE WHEN B.F_PhaseIsPool  = 1 THEN B.F_FatherPhaseID ELSE -1 END)
    ,A.F_VenueID, UPPER(LEFT(DATENAME(WEEKDAY, A.F_MatchDate), 3)), A.F_MatchComment1, B.F_PhaseIsPool
    FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    UPDATE #table_Match SET F_EventCode = B.F_EventCode, F_SexCode = B.F_SexCode, F_DisciplineID = B.F_DisciplineID FROM #table_Match AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
    
    UPDATE #table_Match SET F_GenderCode = B.F_GenderCode FROM #table_Match AS A LEFT JOIN TC_Sex AS B ON A.F_SexCode = B.F_SexCode

    UPDATE #table_Match SET F_DisciplineName = UPPER(B.F_DisciplineLongName) FROM #table_Match AS A LEFT JOIN TS_Discipline_Des AS B ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode
   
    UPDATE #table_Match SET F_EventName = UPPER(B.F_EventLongName) FROM #table_Match AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_PhaseName = UPPER(B.F_PhaseShortName) FROM #table_Match AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
UPDATE #table_Match SET F_FatherPhaseName = UPPER(B.F_PhaseShortName) FROM #table_Match AS A LEFT JOIN TS_Phase_Des AS B ON A.F_FatherPhaseID = B.F_PhaseID AND B.F_LanguageCode = @LanguageCode
	
	--UPDATE #table_Match SET F_FatherPhaseName =ISNULL(F_FatherPhaseName,N'')

    UPDATE #table_Match SET F_UniteName = UPPER(B.F_MatchShortName) FROM #table_Match AS A LEFT JOIN TS_Match_Des AS B ON B.F_MatchID = @MatchID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_MatchFullName = CASE F_PhaseIsPool WHEN 1 THEN ISNULL(F_FatherPhaseName + ' - ','')+F_PhaseName + ' - ' + F_UniteName ELSE F_PhaseName + '-' + F_UniteName END
  
    UPDATE #table_Match SET F_VenueName = UPPER(B.F_VenueShortName) FROM #table_Match AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_DisciplineCode = B.F_DisciplineCode FROM TS_Discipline AS B LEFT JOIN #table_Match
    AS A ON B.F_DisciplineID = A.F_DisciplineID

    UPDATE #table_Match SET F_ReportName = F_DisciplineCode + F_GenderCode + F_EventCode + F_PhaseCode + F_MatchCode
    
    UPDATE #table_Match SET F_StartTime = RIGHT(F_StartTime, 4) WHERE LEFT(F_StartTime, 1) = '0'

    UPDATE #table_Match SET F_EndTime = RIGHT(F_EndTime, 4) WHERE LEFT(F_EndTime, 1) = '0'

    UPDATE #table_Match SET F_Gender = UPPER(B.F_SexShortName) FROM #table_Match AS A LEFT JOIN TC_Sex_Des AS B ON A.F_SexCode = B.F_SexCode AND B.F_LanguageCode = @LanguageCode
    
    UPDATE #table_Match SET F_Report_TitleDate = [dbo].[Func_Report_FB_GetDateTime](GETDATE(), 1,@LanguageCode)
    UPDATE #table_Match SET F_Report_CreateDate = [dbo].[Func_Report_FB_GetDateTime](GETDATE(), 6,@LanguageCode)

    SET LANGUAGE N'简体中文'
    UPDATE #table_Match SET F_WeekCHN = DATENAME(WEEKDAY, F_StartDate)

    SELECT * FROM #table_Match

Set NOCOUNT OFF
End

GO


--EXEC Proc_Report_FB_GetMatchInfo 1,'ENG'