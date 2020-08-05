IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WR_GetOneEventMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WR_GetOneEventMatches]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WR_GetOneEventMatches]
--描    述: 获取一个项目的比赛, 用于 C51A, C51B 及 C75 等报表.
--创 建 人: 邓年彩
--日    期: 2010年10月19日 星期二
--修改记录：
/*			
	日期					修改人		修改内容
	2010年10月26日 星期二	邓年彩		添加参数 @PhaseCode 及 @MatchCode, 当有效时, 可以取出一个 Phase 下的比赛或一场比赛;
										当 ContestNumber 无效时, 取 Winner.
	2010年10月27日 星期三	邓年彩		返回记录时, 删除一些无用字段;
										添加参数 @ReportType, ContestNumber 及 Result 根据报表类型不同而不同.
	2010年10月28日 星期四	邓年彩		当 ReportType 为 C51B 时, 以 EventID 为准; 考虑中文报表的 ReportType.
*/



CREATE PROCEDURE [dbo].[Proc_Report_WR_GetOneEventMatches]
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
		PositionA					NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PositionB					NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		NameA				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NameB				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NOCA				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		NOCB				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		ResultIDA			INT,
		ResultIDB			INT,
		ContestNumber		NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		PointsSplit1_red	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsSplit2_red	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsSplit3_red	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsSplit1_blue	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsSplit2_blue	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsSplit3_blue	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsTotal_red		NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		PointsTotal_blue	NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		ClassPts_red		NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		ClassPts_blue		NVARCHAR(20) COLLATE DATABASE_DEFAULT,
		Result				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		WinnerNoc			NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		WinnerPosition		NVARCHAR(200) COLLATE DATABASE_DEFAULT,
		Winner				NVARCHAR(200) COLLATE DATABASE_DEFAULT,
	)
	
	CREATE TABLE #Competitors
	(
		MatchID				INT,
		CompPosDes1			INT,
		Position			NVARCHAR(20) COLLATE DATABASE_DEFAULT,
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
	(MatchID, PhaseCode, MatchCode, ContestNumber,
	PointsSplit1_red,PointsSplit2_red,PointsSplit3_red,PointsTotal_red,ClassPts_red, 
	PointsSplit1_blue,PointsSplit2_blue,PointsSplit3_blue,PointsTotal_blue,ClassPts_blue,
	Result)
	SELECT M.F_MatchID
		, P.F_PhaseCode
		, M.F_MatchCode
		, M.F_RaceNum
		,[PointsSplit1_red]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1, 1,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,1,1)
			ELSE N''		
		END
		,[PointsSplit2_red]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1, 2,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,2,1)
			ELSE N''		
		END
		,[PointsSplit3_red]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,3,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,3,1)
			ELSE N''		
		END
		,[PointsTotal_red]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,4,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,4,1)
			ELSE N''		
		end
		,[ClassPts_red]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,5,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 1,5,1)
			ELSE N''		
		end
		
		,[PointsSplit1_blue]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2, 1,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,1,1)
			ELSE N''		
		END
		,[PointsSplit2_blue]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2, 2,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,2,1)
			ELSE N''		
		END
		,[PointsSplit3_blue]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,3,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,3,1)
			ELSE N''		
		END
		,[PointsTotal_blue]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,4,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID,2,4,1)
			ELSE N''		
		end
		,[ClassPts_blue]= CASE @ReportType
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,5,1)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByIDs](M.F_MatchID, 2,5,1)
			ELSE N''		
		end
		
		, [Result] = CASE @ReportType 
			WHEN N'C75' THEN dbo.[Func_Report_WR_GetResultByMatchID](M.F_MatchID, 1, @LanguageCode)
			WHEN N'Z75' THEN dbo.[Func_Report_WR_GetResultByMatchID](M.F_MatchID, 1, @LanguageCode)
			WHEN N'C51A' THEN dbo.[Func_Report_WR_GetResultByMatchID](M.F_MatchID, 1, @LanguageCode)
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
	(MatchID, CompPosDes1,Position, Name, NOC, ResultID)
	SELECT MR.F_MatchID
		, MR.F_CompetitionPositionDes1
		,isnull(convert(nvarchar(20),EP.F_EventPosition),N'')
		, case when ISNULL(I.F_InscriptionComment2,N'')=N'' then RD.F_PrintLongName
			else RD.F_PrintLongName+N' ('+I.F_InscriptionComment2+N')' END
		,DD.F_DelegationShortName
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
	LEFT JOIN TR_Inscription AS I
		ON I.F_RegisterID=MR.F_RegisterID AND I.F_EventID=@EventID
	LEFT JOIN TR_Register_Des AS RD
		ON R.F_RegisterID = RD.F_RegisterID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	LEFT JOIN TC_Delegation_Des as DD
		ON D.F_DelegationID=Dd.F_DelegationID and DD.F_LanguageCode=@LanguageCode
	LEFT JOIN TS_Event_Position AS EP
		ON P.F_EventID = EP.F_EventID AND MR.F_RegisterID = EP.F_RegisterID AND EP.F_RegisterID <> -1	
	WHERE P.F_EventID = @EventID
		AND (@PhaseCode = N'0' OR P.F_PhaseCode = @PhaseCode)
		AND (@MatchCode = N'00' OR M.F_MatchCode = @MatchCode)
	
	UPDATE #Matches 
	SET PositionA=C.Position
		,NameA = C.Name
		, NOCA = C.NOC
		, ResultIDA = C.ResultID
	FROM #Matches AS M
	INNER JOIN #Competitors AS C
		ON M.MatchID = C.MatchID AND C.CompPosDes1 = 1
	
	UPDATE #Matches 
	SET	PositionB=c.Position
		,NameB = C.Name
		, NOCB = C.NOC
		, ResultIDB = C.ResultID
	FROM #Matches AS M
	INNER JOIN #Competitors AS C
		ON M.MatchID = C.MatchID AND C.CompPosDes1 = 2
		
	UPDATE #Matches SET Winner = CASE WHEN ResultIDA = 1 THEN NameA WHEN ResultIDB = 1 THEN NameB END
	UPDATE #Matches SET WinnerNoc=CASE WHEN ResultIDA = 1 THEN NOCA WHEN ResultIDB = 1 THEN NOCB END
	UPDATE #Matches SEt WinnerPosition =CASE WHEN ResultIDA = 1 THEN PositionA WHEN ResultIDB = 1 THEN PositionB END
	IF @ReportType = N'C51A' OR @ReportType = N'Z51A' OR @ReportType=N'C75'
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
	
	IF @ReportType = N'C51A' 
	BEGIN
		update #Matches set Result=null
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