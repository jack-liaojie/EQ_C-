IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetOneEventMatches_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetOneEventMatches_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_JU_GetOneEventMatches_Team]
--描    述: 获取一个项目的比赛, 用于 C51A, C51B 及 C75 等报表.
--创 建 人: 宁顺泽
--日    期: 2011年1月7日 星期五
--修改记录：
/*	
	日期					修改人			修改内容		
	2011年3月30号			宁顺泽			取shortname
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetOneEventMatches_Team]
	@EventID				INT,
	@PhaseID				INT,
	@MatchID				INT,
	@LanguageCode			CHAR(3),
	@PhaseCode				NVARCHAR(20),
	@MatchCode				NVARCHAR(40),
	@ReportType				NVARCHAR(20)
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #Matches
	(
		MatchID				INT,
		PhaseCode			NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		MatchCode			NVARCHAR(40) COLLATE DATABASE_DEFAULT,
		NameA				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NameB				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NOCA				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NOCB				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		ResultIDA			INT,
		ResultIDB			INT,
		ContestNumber		NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		Result				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		Winner				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
	)
	
	CREATE TABLE #Competitors
	(
		MatchID				INT,
		CompPosDes1			INT,
		Name				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NOC					NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		ResultID			INT,
	)
	
	IF @ReportType <> N'C51B' AND @ReportType <> N'Z51B'
	BEGIN
		-- 当 @MatchID 有效时, 以 @MatchID 为准
		IF @MatchID > 0
		BEGIN
			SELECT @PhaseID = F_PhaseID FROM TS_Match WHERE F_MatchID = @MatchID
		END
		
		-- 当 @PhaseID 有效时, 以 @PhaseID 为准
		IF @PhaseID > 0
		BEGIN
			SELECT @EventID = F_EventID FROM TS_Phase WHERE F_PhaseID = @PhaseID
		END
	END
	
	-- 添加基本信息
	-- 当报表类型为 C75 时, 显示成绩.
	INSERT INTO #Matches
	(MatchID, PhaseCode, MatchCode, ContestNumber, Result)
	SELECT M.F_MatchID
		, P.F_PhaseCode
		, M.F_MatchCode
		, M.F_RaceNum
		, [Result] = CASE @ReportType 
			WHEN N'C75' THEN dbo.[Func_Report_JU_GetTeamResultByMatchID](M.F_MatchID, 1, @LanguageCode) 
			WHEN N'Z75' THEN dbo.[Func_Report_JU_GetTeamResultByMatchID](M.F_MatchID, 1, @LanguageCode)
			WHEN N'C51A' THEN dbo.[Func_Report_JU_GetTeamResultByMatchID](M.F_MatchID, 1, @LanguageCode) 
			ELSE N''
		END
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	WHERE P.F_EventID = @EventID
		AND (@PhaseCode = N'0' OR P.F_PhaseCode = @PhaseCode)
		AND (@MatchCode = N'00' OR M.F_MatchCode = @MatchCode)
	ORDER BY P.F_Order, M.F_Order
	
	-- 添加参赛者信息
	INSERT INTO #Competitors
	(MatchID, CompPosDes1, Name, NOC, ResultID)
	SELECT MR.F_MatchID
		, MR.F_CompetitionPositionDes1
		, ISNULL(RD.F_ShortName, N'')
		, D.F_DelegationCode
		, MR.F_ResultID
	FROM TS_Match_Result AS MR
	LEFT JOIN TS_Match_Result_Des AS MRD
		ON MR.F_MatchID = MRD.F_MatchID AND MR.F_CompetitionPosition = MRD.F_CompetitionPosition
			AND MRD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Match AS M
		ON MR.F_MatchID = M.F_MatchID
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TR_Register AS R
		ON MR.F_RegisterID = R.F_RegisterID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TS_Event_Position AS EP
		ON P.F_EventID = EP.F_EventID AND MR.F_RegisterID = EP.F_RegisterID AND EP.F_RegisterID <> -1	
	WHERE P.F_EventID = @EventID
		AND (@PhaseCode = N'0' OR P.F_PhaseCode = @PhaseCode)
		AND (@MatchCode = N'00' OR M.F_MatchCode = @MatchCode)
	
	UPDATE #Matches 
	SET NameA = C.Name
		, NOCA = C.NOC
		, ResultIDA = C.ResultID
	FROM #Matches AS M
	INNER JOIN #Competitors AS C
		ON M.MatchID = C.MatchID AND C.CompPosDes1 = 1
	
	UPDATE #Matches 
	SET NameB = C.Name
		, NOCB = C.NOC
		, ResultIDB = C.ResultID
	FROM #Matches AS M
	INNER JOIN #Competitors AS C
		ON M.MatchID = C.MatchID AND C.CompPosDes1 = 2
		
	UPDATE #Matches SET Winner = CASE WHEN ResultIDA = 1 THEN NameA WHEN ResultIDB = 1 THEN NameB END
	IF @ReportType = N'C51A' OR @ReportType = N'Z51A'
	BEGIN
		UPDATE #Matches SET ContestNumber = Winner
	END
	IF @ReportType = N'C51B' OR @ReportType = N'Z51B'
	BEGIN
		UPDATE #Matches 
		SET ContestNumber = CASE 
			WHEN ContestNumber IS NULL OR LTRIM(RTRIM(ContestNumber)) = N'' 
			THEN Winner ELSE ContestNumber 
		END
	END
	ELSE
	BEGIN
		UPDATE #Matches SET ContestNumber = ISNULL(Winner, ContestNumber)
	END
	
	ALTER TABLE #Matches DROP COLUMN MatchID, ResultIDA, ResultIDB, Winner
	
	IF @PhaseCode <> N'0' AND @MatchCode <> N'00'
	BEGIN
		ALTER TABLE #Matches DROP COLUMN PhaseCode, MatchCode
	END
	
	SELECT * FROM #Matches

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetOneEventMatches] 8, -1, -1, 'ENG'
EXEC [Proc_Report_JU_GetOneEventMatches] 2, -1, -1, 'ENG'
EXEC [Proc_Report_JU_GetOneEventMatches] 7, -1, -1, 'ENG'

*/