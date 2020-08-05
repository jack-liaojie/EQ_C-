IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetMatchInfoByRound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetMatchInfoByRound]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[Proc_Report_TE_GetMatchInfoByRound] (	
	@PhaseID			INT,
	@LanguageCode       NVARCHAR(3)
)	
AS
BEGIN
SET NOCOUNT ON

		declare @eventid int
		select @eventid = F_EventID from ts_phase where f_phaseId = @PhaseID

		declare @roundid int 
		select @roundid = F_RoundID from TS_Match WHERE F_PhaseID = @PhaseID
		           
		create table #table_round_match(
			F_MatchID			INT,
			F_PhaseID			INT,
			F_PhaseLongName		NVARCHAR(100),
			F_PhaseShortName	NVARCHAR(100),
			F_EventName			NVARCHAR(100),
			F_FatherPhaseName   NVARCHAR(100),
			F_RoundName         NVARCHAR(100),
			F_PhaseOrder		INT,
			F_Order				INT,
			F_MatchNum			INT,
			F_HomePlayer		NVARCHAR(100),
			F_AwayPlayer		NVARCHAR(100),
			F_HomeTeam			NVARCHAR(100),
			F_AwayTeam			NVARCHAR(100),
			F_MatchDate			NVARCHAR(100),
			F_SetPoints			NVARCHAR(100),
			F_MatchPoints		NVARCHAR(100),
			F_MatchTime			NVARCHAR(100),
			F_VenueName         NVARCHAR(100),
			F_CourtName			NVARCHAR(100),
			F_TakeHours			NVARCHAR(100),
			F_IRM				NVARCHAR(100),
			F_MatchLongName		NVARCHAR(100),
			F_MatchShortName	NVARCHAR(100),
			F_HomePlayerDes		NVARCHAR(300),
			F_AwayPlayerDes		NVARCHAR(300),
			F_Report_CreateDate NVARCHAR(30),
			F_PhaseDate         NVARCHAR(20),
			F_SportName         NVARCHAR(100),
			F_DisciplineName    NVARCHAR(100),
			F_HIRMID            INT,
			F_VIRMID            INT
		)

		INSERT INTO #table_round_match(F_PhaseOrder, F_PhaseLongName, F_PhaseShortName, F_EventName, F_RoundName,  F_Order, F_MatchNum, F_MatchID, F_PhaseID, F_DisciplineName,F_SportName)
		   SELECT  B.F_Order, E.F_PhaseLongName, E.F_PhaseShortName, D.F_EventLongName, F.F_RoundLongName,  A.F_Order, A.F_RaceNum, A.F_MatchID, A.F_PhaseID,
		           GD.F_DisciplineLongName, SD.F_SportLongName
		      FROM ts_match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
		           LEFT JOIN TS_Phase_Des AS E ON B.F_PhaseID = E.F_PhaseID AND E.F_LanguageCode = @LanguageCode
		           LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID 
		           LEFT JOIN TS_Event_Des AS D ON C.F_EventID = D.F_EventID AND D.F_LanguageCode = @LanguageCode
		           LEFT JOIN TS_Round_Des AS F ON A.F_RoundID = F.F_RoundID AND F.F_LanguageCode = @LanguageCode
		           LEFT JOIN TS_Discipline AS G ON C.F_DisciplineID = G.F_DisciplineID
		           LEFT JOIN TS_Discipline_Des AS GD ON G.F_DisciplineID = GD.F_DisciplineID AND GD.F_LanguageCode = @LanguageCode
		           LEFT JOIN TS_Sport_Des AS SD ON G.F_SportID = SD.F_SportID AND SD.F_LanguageCode = @LanguageCode
		     --WHERE B.F_PhaseID = @PhaseID 
		     WHERE A.F_RoundID = @roundid
		            Order By B.F_Order, A.F_RaceNum


		update #table_round_match set F_MatchLongName = B.F_MatchLongName, F_MatchShortName = B.F_MatchShortName from #table_round_match as A left join TS_Match_Des as B on A.F_MatchID = B.F_MatchId AND B.F_LanguageCode = 'CHN'
	

		update #table_round_match set F_HomePlayer = C.F_PrintLongName, F_HomeTeam = E.F_DelegationShortName, F_HIRMID = B.F_IRMID
		      FROM #table_round_match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
		           LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		           LEFT JOIN TR_Register AS D ON B.F_RegisterID = D.F_RegisterID
		           LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode
		           
		update #table_round_match set F_AwayPlayer = C.F_PrintLongName, F_AwayTeam = E.F_DelegationShortName, F_VIRMID = B.F_IRMID
		        FROM #table_round_match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 2
		            LEFT JOIN TR_Register_Des AS C ON B.F_RegisterID = C.F_RegisterID AND C.F_LanguageCode = @LanguageCode
		            LEFT JOIN TR_Register AS D ON B.F_RegisterID = D.F_RegisterID
		            LEFT JOIN TC_Delegation_Des AS E ON D.F_DelegationID = E.F_DelegationID AND E.F_LanguageCode = @LanguageCode

		update #table_round_match set F_MatchDate = dbo.Func_Report_TE_GetDateTime(B.F_MatchDate,6,'CHN') from #table_round_match as A left join ts_match as B on A.F_MatchID = B.F_MatchId
		update #table_round_match set F_MatchTime = dbo.Func_Report_TE_GetDateTime(B.F_StartTime,4,'ENG') from #table_round_match as A left join ts_match as B on A.F_MatchID = B.F_MatchId

        update #table_round_match set F_VenueName = C.F_VenueShortName FROM #table_round_match AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TC_Venue_Des AS C ON B.F_VenueID = C.F_VenueID AND C.F_LanguageCode = @LanguageCode
		update #table_round_match set F_CourtName = C.F_CourtShortName from #table_round_match as A left join ts_match as B on A.F_MatchID = B.F_MatchId left join tc_court_des as c on c.F_CourtID = B.F_CourtID where c.F_languageCode = @LanguageCode

		update #table_round_match set F_SetPoints = dbo.Fun_Report_TE_GetMatchResultDes(F_MatchId) from #table_round_match
		
		update #table_round_match set F_TakeHours = CAST(B.F_SpendTime/3600 AS NVARCHAR(20))+ ':' + RIGHT(('00' + CAST((B.F_SpendTime%3600/60) AS NVARCHAR(20))),2) 
		         from #table_round_match as A left join ts_match as B on A.F_MatchID = B.F_MatchId
	
		update #table_round_match set F_MatchPoints =  CAST(B.F_Points AS NVARCHAR(100)) + ':' + CAST(C.F_Points AS NVARCHAR(100))
		     from #table_round_match AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND B.F_CompetitionPosition = 1
		          LEFT JOIN TS_Match_Result AS C ON A.F_MatchID = C.F_MatchID AND C.F_CompetitionPosition = 2

		update #table_round_match set F_FatherPhaseName = D.F_PhaseLongName
		     FROM #table_round_match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID =  B.F_PhaseID 
		          LEFT JOIN TS_Phase AS C ON B.F_FatherPhaseID = C.F_PhaseID 
		          LEFT JOIN TS_Phase_Des AS D ON C.F_PhaseID = D.F_PhaseID AND D.F_LanguageCode = @LanguageCode

        UPDATE #table_round_match SET F_IRM = F_HomePlayer + B.F_IRMLongName 
                 FROM #table_round_match AS A LEFT JOIN TC_IRM_Des AS B ON A.F_HIRMID = B.F_IRMID AND B.F_LanguageCode = @LanguageCode
                     WHERE F_HIRMID IS NOT NULL
                     
        UPDATE #table_round_match SET F_IRM = F_AwayPlayer + B.F_IRMLongName 
                 FROM #table_round_match AS A LEFT JOIN TC_IRM_Des AS B ON A.F_VIRMID = B.F_IRMID AND B.F_LanguageCode = @LanguageCode
                     WHERE F_VIRMID IS NOT NULL

        UPDATE #table_round_match SET F_Report_CreateDate = CONVERT (nvarchar(20), GETDATE(), 120)
        
        UPDATE #table_round_match SET F_PhaseDate = CONVERT(nvarchar(16), B.F_OpenDate, 120)
           FROM #table_round_match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
		
		--delete from #table_round_match where F_HomePlayer is null
		--delete from #table_round_match where F_AwayPlayer is null

		
		select * from #table_round_match order by F_PhaseID, F_MatchTime
	
SET NOCOUNT OFF
END

/*
--	select * from ts_phase
 Proc_Report_TE_GetMatchInfoByRound 22,'CHN'
*/

GO


