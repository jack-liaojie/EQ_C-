IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchDescription]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--名    称：[Proc_GetMatchDescription]
--描    述：得到当前比赛描述信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009年05月01日
--修改：2010年01月11日，张翠霞，考虑到更改主客队，提取方式不一样。
--修改：2010年10月13日，穆学峰，增加列: F_DateReport, F_TimeReport, F_MatchLongName, F_MatchShortName, F_MatchCommet,2,3

CREATE PROCEDURE [dbo].[Proc_GetMatchDescription](
				 @MatchID		INT,--当前比赛的ID
                 @LanguageCode  NVARCHAR(3) --比赛语言代码
)
	
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #table_Match (
                                        F_SportDes         NVARCHAR(100),
                                        F_MatchDes         NVARCHAR(100),
										F_DateDes	       NVARCHAR(100),
										F_DateReport       NVARCHAR(100),		
										F_TimeReport       NVARCHAR(100),	
										F_MatchLongName	   NVARCHAR(100),	
										F_MatchShortName   NVARCHAR(100),	
										F_MatchCommnet     NVARCHAR(100),	
										F_MatchCommnet2    NVARCHAR(100),	
										F_MatchCommnet3    NVARCHAR(100),	
										F_VenueDes	       NVARCHAR(100),
                                        F_CourtDes         NVARCHAR(100),
										F_HomeName         NVARCHAR(100),
                                        F_AwayName         NVARCHAR(100),
                                        F_MatchStatusID    INT,
                                        F_HomeScore        INT,
                                        F_AwayScore        INT,
										F_HomeID           INT,
                                        F_AwayID           INT,
                                        F_HomePos          INT,
                                        F_AwayPos          INT,
                                        F_SportName        NVARCHAR(100),
                                        F_DisciplineName   NVARCHAR(100),
                                        F_MatchID          INT,
                                        F_EventID          INT,
                                        F_EventDes		   NVARCHAR(100),
                                        F_PhaseID          INT,
                                        F_StartDate        DATETIME,
                                        F_StartTime        DATETIME,
                                        F_VenueID          INT,
                                        F_CourtID          INT,
                                        F_MatchTypeID      INT,
                                        F_Order            INT,
										F_SpendTime		   INT
									 )

    CREATE TABLE #table_Pos (
                              F_CompetitionPosition         INT
                             )

    DECLARE @ComPosA AS INT
    DECLARE @ComPosB AS INT

    INSERT INTO #table_Pos (F_CompetitionPosition)
    SELECT F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID ORDER BY F_CompetitionPositionDes1, F_CompetitionPosition

    DECLARE @Pos AS INT
    DECLARE @Index AS INT
	SET @Index = 1

	DECLARE ONE_CURSOR CURSOR FOR SELECT F_CompetitionPosition FROM #table_Pos
	OPEN ONE_CURSOR
	FETCH NEXT FROM ONE_CURSOR INTO @Pos
	WHILE @@FETCH_STATUS =0 
	BEGIN
		IF @Index = 1 SET @ComPosA = @Pos
		IF @Index = 2 SET @ComPosB = @Pos
		FETCH NEXT FROM ONE_CURSOR INTO @Pos
		SET @Index = @Index +1
	END
	CLOSE ONE_CURSOR
	DEALLOCATE ONE_CURSOR
    --END
    
    INSERT INTO #table_Match (F_HomePos, F_AwayPos, F_MatchID, F_EventID, F_PhaseID, F_StartDate, F_StartTime, F_VenueID, F_CourtID, F_MatchTypeID, F_Order, F_MatchStatusID, F_SpendTime)
    SELECT @ComPosA AS F_HomePos, @ComPosB AS F_AwayPos, @MatchID AS F_MatchID, B.F_EventID, A.F_PhaseID, A.F_MatchDate, A.F_StartTime, A.F_VenueID, A.F_CourtID, A.F_MatchTypeID, A.F_Order, A.F_MatchStatusID, A.F_SpendTime FROM TS_Match AS A LEFT JOIN TS_Phase
    AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    UPDATE #table_Match SET F_VenueDes = B.F_VenueLongName FROM #table_Match AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_CourtDes = B.F_CourtLongName FROM #table_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_HomeID = B.F_RegisterID, F_HomeScore = B.F_Points FROM #table_Match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = @ComPosA
    UPDATE #table_Match SET F_AwayID = B.F_RegisterID, F_AwayScore = B.F_Points FROM #table_Match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = @ComPosB
    UPDATE #table_Match SET F_HomeName = B.F_LongName FROM #table_Match AS A LEFT JOIN TR_Register_Des AS B ON A.F_HomeID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_AwayName = B.F_LongName FROM #table_Match AS A LEFT JOIN TR_Register_Des AS B ON A.F_AwayID = B.F_RegisterID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_DisciplineName = C.F_DisciplineLongName, F_SportName = E.F_SportLongName FROM #table_Match AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Discipline_Des AS C
    ON B.F_DisciplineID = C.F_DisciplineID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Sport_Des AS E ON E.F_SportID = D.F_SportID WHERE C.F_LanguageCode = @LanguageCode AND
    E.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_EventDes = B.F_EventLongName FROM #table_Match AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_SportDes = F_SportName + '  ' + F_DisciplineName

	DECLARE @PhaseID INT
	DECLARE @FatherPhaseID INT
	DECLARE @MatchDes NVARCHAR(500)
	DECLARE @MatchTemp NVARCHAR(500)

	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	SELECT @MatchDes = F_PhaseLongName FROM TS_Phase_Des WHERE F_PhaseID = @PhaseID AND F_LanguageCode = @LanguageCode
	SELECT @FatherPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID

	WHILE (@FatherPhaseID != 0)
	BEGIN
	  SELECT @MatchTemp = F_PhaseLongName FROM TS_Phase_Des WHERE F_PhaseID = @FatherPhaseID AND F_LanguageCode = @LanguageCode
	  SET @MatchDes = @MatchTemp + ' ' + @MatchDes
	  SELECT @FatherPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @FatherPhaseID
	END

    DECLARE @strTemp1 NVARCHAR(10)
    DECLARE @strTemp2 NVARCHAR(10)
    SET @strTemp1 = ''
    SET @strTemp2 = ''

    IF (@LanguageCode = 'CHN')
    BEGIN
    SET @strTemp1 = '  第'
    SET @strTemp2 = '场'
    END
    ELSE IF (@LanguageCode = 'ENG')
    BEGIN
    SET @strTemp1 = '  Match'
    SET @strTemp2 = ''
    END

    UPDATE #table_Match SET F_MatchDes = F_EventDes + '  ' + @MatchDes +  @strTemp1 + CAST(F_Order AS NVARCHAR(10)) + @strTemp2
    UPDATE #table_Match SET F_DateDes = LEFT(CONVERT (NVARCHAR(100), F_StartDate, 120), 11) + RIGHT(CONVERT (NVARCHAR(100), F_StartTime, 120), 8)
    UPDATE #table_Match SET F_DateReport = dbo.Func_Report_GetDateTime(F_StartDate, 2)
    UPDATE #table_Match SET F_TimeReport = dbo.Func_Report_GetDateTime(F_StartTime, 3)
	UPDATE #table_Match SET F_MatchLongName = B.F_MatchLongName, F_MatchShortName = B.F_MatchShortName, F_MatchCommnet = B.F_MatchComment,
				F_MatchCommnet2 = B.F_MatchComment2, F_MatchCommnet3 = B.F_MatchComment3
			FROM #table_Match AS A LEFT JOIN TS_Match_Des AS B ON A.F_MatchID = B.F_MatchID
		WHERE B.F_LanguageCode = @LanguageCode
		
    SELECT * FROM #table_Match

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


