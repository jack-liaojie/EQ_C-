
/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchDescription]    Script Date: 08/30/2012 08:37:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HB_GetMatchDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HB_GetMatchDescription]
GO


/****** Object:  StoredProcedure [dbo].[Proc_HB_GetMatchDescription]    Script Date: 08/30/2012 08:37:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO










--名    称：[Proc_HB_GetMatchDescription]
--描    述：得到当前水球比赛描述信息
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2010年9月19日

CREATE PROCEDURE [dbo].[Proc_HB_GetMatchDescription](
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
                                        F_DisciplineID     INT,
                                        F_EventID          INT,
                                        F_EventDes		   NVARCHAR(100),
                                        F_PhaseID          INT,
                                        F_StartDate        DATETIME,
                                        F_StartTime        DATETIME,
                                        F_VenueID          INT,
                                        F_CourtID          INT,
                                        F_MatchTypeID      INT,
                                        F_Order            INT,
										F_SpendTime		   INT, 
                                        F_MatchComment1    NVARCHAR(50),
                                        F_HomeService      INT,
                                        F_VisitService     INT,
                                        F_MatchCode        NVARCHAR(20),
                                        F_IsPoolMatch	   INT,--1,YES;0,NO;
									 )

    
    
    INSERT INTO #table_Match (F_HomePos, F_AwayPos, F_MatchID, F_EventID, F_PhaseID, F_StartDate, F_StartTime, F_VenueID, F_CourtID, F_MatchTypeID, F_Order, F_MatchStatusID, F_SpendTime, F_MatchComment1,F_IsPoolMatch)
    SELECT 1 AS F_HomePos, 2 AS F_AwayPos, @MatchID AS F_MatchID, B.F_EventID, A.F_PhaseID, A.F_MatchDate, A.F_StartTime, A.F_VenueID, A.F_CourtID, A.F_MatchTypeID, A.F_Order, A.F_MatchStatusID, A.F_SpendTime, A.F_MatchComment1,B.F_PhaseIsPool FROM TS_Match AS A LEFT JOIN TS_Phase
    AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID

    UPDATE #table_Match SET F_MatchCode = A.F_MatchCode FROM TS_Match AS A WHERE A.F_MatchID = @MatchID
    UPDATE #table_Match SET F_VenueDes = B.F_VenueLongName FROM #table_Match AS A LEFT JOIN TC_Venue_Des AS B ON A.F_VenueID = B.F_VenueID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_CourtDes = B.F_CourtLongName FROM #table_Match AS A LEFT JOIN TC_Court_Des AS B ON A.F_CourtID = B.F_CourtID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_HomeID = B.F_RegisterID, F_HomeScore = B.F_Points, F_HomeService = B.F_Service FROM #table_Match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 1
    UPDATE #table_Match SET F_AwayID = B.F_RegisterID, F_AwayScore = B.F_Points, F_VisitService = B.F_Service FROM #table_Match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchID = @MatchID AND B.F_CompetitionPosition = 2
    UPDATE #table_Match SET F_HomeName = C.F_DelegationCode FROM #table_Match AS A LEFT JOIN TR_Register AS B ON A.F_HomeID = B.F_RegisterID LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID  
    UPDATE #table_Match SET F_AwayName = C.F_DelegationCode FROM #table_Match AS A LEFT JOIN TR_Register AS B ON A.F_AwayID = B.F_RegisterID LEFT JOIN TC_Delegation AS C ON B.F_DelegationID = C.F_DelegationID 
    UPDATE #table_Match SET F_DisciplineID = C.F_DisciplineID, F_DisciplineName = C.F_DisciplineLongName, F_SportName = E.F_SportLongName FROM #table_Match AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Discipline_Des AS C
    ON B.F_DisciplineID = C.F_DisciplineID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Sport_Des AS E ON E.F_SportID = D.F_SportID WHERE C.F_LanguageCode = @LanguageCode AND
    E.F_LanguageCode = @LanguageCode

    UPDATE #table_Match SET F_EventDes = B.F_EventLongName FROM #table_Match AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID WHERE B.F_LanguageCode = @LanguageCode
    UPDATE #table_Match SET F_SportDes = F_SportName + '  ' + F_DisciplineName



	DECLARE @PhaseID INT
	DECLARE @FatherPhaseID INT
	DECLARE @MatchName NVARCHAR(500)
	DECLARE @PhaseName NVARCHAR(500)
	DECLARE @FatherPhaseName NVARCHAR(500)
	DECLARE @MatchTemp NVARCHAR(500)
	DECLARE @HasPool INT
	SET @FatherPhaseName = NULL
	
	SELECT @MatchName = F_MatchLongName FROM TS_Match_Des WHERE F_MatchID = @MatchID AND F_LanguageCode = @LanguageCode
	SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
	SELECT @PhaseName = F_PhaseLongName FROM TS_Phase_Des WHERE F_PhaseID = @PhaseID AND F_LanguageCode = @LanguageCode
	SELECT @FatherPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	IF (@FatherPhaseID > 0)
	BEGIN
		select @HasPool = F_PhaseHasPools from TS_Phase WHERE F_PhaseID = @FatherPhaseID
		IF @HasPool = 1
			BEGIN
				SELECT @FatherPhaseName = F_PhaseLongName FROM TS_Phase_Des WHERE F_PhaseID = @FatherPhaseID AND F_LanguageCode = @LanguageCode
			END
	END
	
    UPDATE #table_Match SET F_MatchDes = F_EventDes + '  ' + ISNULL(@FatherPhaseName+' - ','') +@PhaseName + ' - '+@MatchName
    UPDATE #table_Match SET F_DateDes = LEFT(CONVERT (NVARCHAR(100), F_StartDate, 120), 11) + RIGHT(CONVERT (NVARCHAR(100), F_StartTime, 120), 8)

    SELECT * FROM #table_Match

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO


