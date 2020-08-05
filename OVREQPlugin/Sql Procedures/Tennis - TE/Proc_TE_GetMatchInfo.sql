IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchInfo]
----功		  能：得到一场比赛的详细信息,网球项目
----作		  者：郑金勇 
----日		  期: 2009-08-12

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchInfo] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET LANGUAGE 'ENGLISH'
	SELECT A.F_MatchID, A.F_MatchDate, A.F_StartTime, A.F_MatchCode, B.F_MatchLongName, C.F_PhaseID, D.F_PhaseLongName, E.F_EventID, F.F_EventLongName
			,E.F_DisciplineID, G.F_DisciplineLongName, A.F_VenueID, H.F_VenueLongName, A.F_CourtID, I.F_CourtLongName
			, G.F_DisciplineLongName + N' ' + F.F_EventLongName AS EventDes
			, D.F_PhaseLongName + N' ' + B.F_MatchLongName + N' (' + A.F_MatchCode + N')' AS MatchDes
			, V.F_VenueCode + N' ' + I.F_CourtShortName AS VenueDes
			, ISNULL(LEFT(CONVERT (NVARCHAR(100), A.F_MatchDate, 120), 10), N'') + N' ' + ISNULL(SUBSTRING(CONVERT (NVARCHAR(100), A.F_StartTime, 120), 11, 9), N'') AS DateDes
			, A.F_CompetitionRuleID, A.F_MatchStatusID
		FROM TS_Match AS A 
			LEFT JOIN TS_Match_Des AS B ON A.F_MatchID=B.F_MatchID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase AS C ON A.F_PhaseID = C.F_PhaseID 
			LEFT JOIN TS_Phase_Des AS D ON C.F_PhaseID = D.F_PhaseID AND D.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event AS E ON C.F_EventID = E.F_EventID
			LEFT JOIN TS_Event_Des AS F ON E.F_EventID = F.F_EventID AND F.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Discipline_Des AS G ON E.F_DisciplineID = G.F_DisciplineID AND G.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Venue AS V ON A.F_VenueID = V.F_VenueID
			LEFT JOIN TC_Venue_Des AS H ON A.F_VenueID = H.F_VenueID AND H.F_LanguageCode = @LanguageCode
			LEFT JOIN TC_Court_Des AS I ON A.F_CourtID = I.F_CourtID AND I.F_LanguageCode = @LanguageCode
				WHERE A.F_MatchID = @MatchID

SET NOCOUNT OFF
END






GO

 --EXEC [Proc_TE_GetMatchInfo] 1,'ENG'
