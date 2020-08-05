IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SearchMatches_JU]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SearchMatches_JU]
/****** Object:  StoredProcedure [dbo].[Proc_SearchMatches_JU]    Script Date: 08/02/2011 16:58:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_SearchMatches_JU]
--描    述: 柔道项目 DataEntry 中获取比赛列表.
--创 建 人: 宁顺泽
--日    期: 2011年7月14日 星期四
--修改记录：
/*			
	日期					修改人		修改内容
*/

Create PROCEDURE [dbo].[Proc_SearchMatches_JU]
	 @DisciplineCode					CHAR(2),
	 @EventID							INT,
	 @DateTime							NVARCHAR(50),
	 @VenueID							INT,
	 @PhaseID							INT,
	 @CourtID							INT
AS
BEGIN
SET NOCOUNT ON

	DECLARE @DisciplineID				INT
	DECLARE @LanguageCode				CHAR(3)
	
	SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_DisciplineCode = @DisciplineCode
	SELECT @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1
	
	CREATE TABLE #Competitors
	(
		F_MatchID						INT,
		F_CompetitionPositionDes1		INT,
		F_RegisterID					INT,
		F_NOC							NVARCHAR(20),
		F_Name							NVARCHAR(200),
		F_ResultID						INT,
		F_IRMID							INT
	)
	
	INSERT INTO #Competitors
	(F_MatchID, F_CompetitionPositionDes1, F_RegisterID, F_NOC, F_Name, F_ResultID, F_IRMID)
	SELECT MR.F_MatchID
		, MR.F_CompetitionPositionDes1
		, MR.F_RegisterID
		, DLD.F_DelegationShortName AS [F_NOC]
		, CASE MR.F_ResultID WHEN -1 THEN N'BYE' ELSE RD.F_LongName END AS [F_Name]
		, MR.F_ResultID
		, MR.F_IRMID
	FROM TS_Match_Result AS MR
	LEFT JOIN TR_Register AS R
		ON MR.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS DL
		ON R.F_DelegationID = DL.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DLD
		ON DL.F_DelegationID=DLD.F_DelegationID and DLD.F_LanguageCode=@LanguageCode
	INNER JOIN TS_Match AS M
		ON MR.F_MatchID = M.F_MatchID
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	WHERE E.F_DisciplineID = @DisciplineID
		AND (@EventID = -1 OR E.F_EventID = @EventID)
		AND (@DateTime = ' ALL' OR @DateTime = ' 全部' OR LEFT(CONVERT(NVARCHAR(30), M.F_MatchDate, 120), 10) = LTRIM(RTRIM(@DateTime)))
		AND (@VenueID = -1 OR M.F_VenueID = @VenueID)
		AND (@PhaseID = -1 OR M.F_PhaseID = @PhaseID)
		AND (@CourtID = -1 OR M.F_CourtID = @CourtID)
		AND M.F_MatchStatusID >= 30
	
	SELECT M.F_RaceNum AS [R.N.]
		, SD.F_StatusLongName AS [Status]
		, [Match] = 
			REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ED.F_EventLongName, 'Women''s ', 'W'), 'Men''s ', 'M'), 'Mixed ', 'X'), 'kg', ''), 'Individual Poomsae', 'I'), 'Team Poomsae', 'T')
			+ N' ' + CASE E.F_CompetitionTypeID
				WHEN 1 THEN 
					CASE P.F_PhaseCode 
						WHEN '1' THEN N'Final' 
						WHEN '2' THEN N'SF   '
						WHEN '3' THEN N'QF   '
						WHEN '4' THEN N'1/8  '
						WHEN '5' THEN N'1/16 '
						WHEN '6' THEN N'1/32 '
						WHEN '7' THEN N'1/64 '
						WHEN 'A' THEN N'RC1  '
						WHEN 'B' THEN N'RC2  '
						WHEN 'C' THEN N'RC3  '
						WHEN 'D' THEN N'RC4  '
						WHEN 'F' THEN N'Bron '
					END
				
			END
			+ N' ' + M.F_MatchCode
		, C1.F_NOC AS [Blue]
		, C2.F_NOC AS [White]
		, case when E.F_PlayerRegTypeID=1 then  dbo.[Func_Report_JU_GetResultByMatchID](M.F_MatchID, 1, 'ENG') 
			else dbo.[Func_Report_JU_GetTeamResultByMatchID](M.F_MatchID, 1, 'ENG') end AS [Result]
		, [Winner] = CASE WHEN C1.F_ResultID = 1 THEN C1.F_NOC WHEN C2.F_ResultID = 1 THEN C2.F_NOC END
		, M.F_MatchID
	FROM TS_Match AS M
	LEFT JOIN TC_Status_Des AS SD
		ON M.F_MatchStatusID = SD.F_StatusID AND SD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = 'ENG'
	INNER JOIN TC_Sex AS SX
		ON E.F_SexCode = SX.F_SexCode
	LEFT JOIN #Competitors AS C1
		ON M.F_MatchID = C1.F_MatchID AND C1.F_CompetitionPositionDes1 = 1
	LEFT JOIN #Competitors AS C2
		ON M.F_MatchID = C2.F_MatchID AND C2.F_CompetitionPositionDes1 = 2
	WHERE E.F_DisciplineID = @DisciplineID
		AND (@EventID = -1 OR E.F_EventID = @EventID)
		AND (@DateTime = ' ALL' OR @DateTime = ' 全部' OR LEFT(CONVERT(NVARCHAR(30), M.F_MatchDate, 120), 10) = LTRIM(RTRIM(@DateTime)))
		AND (@VenueID = -1 OR M.F_VenueID = @VenueID)
		AND (@PhaseID = -1 OR M.F_PhaseID = @PhaseID)
		AND (@CourtID = -1 OR M.F_CourtID = @CourtID)
		AND M.F_MatchStatusID >= 30
	ORDER BY M.F_RaceNum
	

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_SearchMatches_JU] 'KR', -1, ' ALL', -1

*/