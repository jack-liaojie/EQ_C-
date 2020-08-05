IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_CommonCode_GenerateUnitFromDB]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_CommonCode_GenerateUnitFromDB]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_CommonCode_GenerateUnitFromDB]
--描    述: 从数据库中生成 Common Code 中一个大项的 CSIC_Phase 表.
--创 建 人: 邓年彩
--日    期: 2011年6月15日 星期三
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_CommonCode_GenerateUnitFromDB]
	@DisciplineCode			CHAR(2)
AS
BEGIN
SET NOCOUNT ON	
	
	CREATE TABLE #CSIC_Unit
	(
		DISCIPLINE_CODE		NVARCHAR(255),
		GENDER_CODE			NVARCHAR(255),
		[EVENT]				NVARCHAR(255),
		PHASE				NVARCHAR(255),
		UNIT				NVARCHAR(255),
		LANGUAGE_CODE		NVARCHAR(255),
		SHORTNAME			NVARCHAR(255),
		LONGNAME			NVARCHAR(255),
		TVNAME				NVARCHAR(255),
		PRINTNAME			NVARCHAR(255)
	)
	
	-- 添加大项
	INSERT INTO #CSIC_Unit
	SELECT @DisciplineCode AS DISCIPLINE_CODE
		, N'0' AS GENDER_CODE
		, N'000' AS [EVENT]
		, N'0' AS PHASE
		, N'00' AS UNIT
		, CASE DD.F_LanguageCode WHEN 'CHN' THEN 'CHI' ELSE DD.F_LanguageCode END AS LANGUAGE_CODE
		, DD.F_DisciplineShortName AS SHORTNAME
		, DD.F_DisciplineLongName AS LONGNAME
		, DD.F_DisciplineShortName AS TVNAME
		, DD.F_DisciplineLongName AS PRINTNAME
	FROM TS_Discipline AS D
	LEFT JOIN TS_Discipline_Des AS DD
		ON D.F_DisciplineID = DD.F_DisciplineID
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	-- 添加日期
	
	-- 添加单元
	
	-- 添加小项
	INSERT INTO #CSIC_Unit
	SELECT @DisciplineCode AS DISCIPLINE_CODE
		, S.F_GenderCode AS GENDER_CODE
		, E.F_EventCode AS [EVENT]
		, N'0' AS PHASE
		, N'00' AS UNIT
		, CASE ED.F_LanguageCode WHEN 'CHN' THEN 'CHI' ELSE ED.F_LanguageCode END AS LANGUAGE_CODE
		, ED.F_EventShortName AS SHORTNAME
		, ED.F_EventLongName AS LONGNAME
		, ED.F_EventShortName AS TVName
		, ED.F_EventLongName AS PRINTNAME
	FROM TS_Event AS E
	INNER JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID
	INNER JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	-- 添加小项的颁奖仪式
	INSERT INTO #CSIC_Unit
	SELECT @DisciplineCode AS DISCIPLINE_CODE
		, S.F_GenderCode AS GENDER_CODE
		, E.F_EventCode AS [EVENT]
		, N'M' AS PHASE
		, N'00' AS UNIT
		, CASE ED.F_LanguageCode WHEN 'CHN' THEN 'CHI' ELSE ED.F_LanguageCode END AS LANGUAGE_CODE
		, ED.F_EventShortName + CASE ED.F_LanguageCode WHEN 'CHN' THEN N'颁奖仪式' ELSE N' Medal Ceremony' END AS SHORTNAME
		, ED.F_EventLongName + CASE ED.F_LanguageCode WHEN 'CHN' THEN N'颁奖仪式' ELSE N' Medal Ceremony' END AS LONGNAME
		, ED.F_EventShortName + CASE ED.F_LanguageCode WHEN 'CHN' THEN N'颁奖仪式' ELSE N' Medal Ceremony' END AS TVName
		, CASE ED.F_LanguageCode WHEN 'CHN' THEN N'颁奖仪式' ELSE N'Medal Ceremony' END AS PRINTNAME
	FROM TS_Event AS E
	INNER JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID
	INNER JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	-- 添加小项的 Phase
	INSERT INTO #CSIC_Unit
	SELECT @DisciplineCode AS DISCIPLINE_CODE
		, S.F_GenderCode AS GENDER_CODE
		, E.F_EventCode AS [EVENT]
		, P.F_PhaseCode AS PHASE
		, N'00' AS UNIT
		, CASE PD.F_LanguageCode WHEN 'CHN' THEN 'CHI' ELSE PD.F_LanguageCode END AS LANGUAGE_CODE
		, SHORTNAME = ED.F_EventShortName + CASE PD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END
			+ ISNULL(FPD.F_PhaseShortName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseShortName
		, LONGNAME = ED.F_EventLongName + CASE PD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END 
			+ ISNULL(FPD.F_PhaseLongName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseLongName
		, TVName = ED.F_EventShortName + CASE PD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END
			+ ISNULL(FPD.F_PhaseShortName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseShortName
		, PRINTNAME = ISNULL(FPD.F_PhaseLongName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseLongName 
	FROM TS_Phase AS P
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID
	LEFT JOIN TS_Phase_Des AS FPD
		ON P.F_FatherPhaseID = FPD.F_PhaseID AND PD.F_LanguageCode = FPD.F_LanguageCode
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND PD.F_LanguageCode = ED.F_LanguageCode
	INNER JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	INNER JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	-- 添加 Match
	INSERT INTO #CSIC_Unit
	SELECT @DisciplineCode AS DISCIPLINE_CODE
		, S.F_GenderCode AS GENDER_CODE
		, E.F_EventCode AS [EVENT]
		, P.F_PhaseCode AS PHASE
		, M.F_MatchCode AS UNIT
		, CASE MD.F_LanguageCode WHEN 'CHN' THEN 'CHI' ELSE MD.F_LanguageCode END AS LANGUAGE_CODE
		, SHORTNAME = ED.F_EventShortName + CASE PD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END 
			+ ISNULL(FPD.F_PhaseShortName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseShortName + N' - ' 
			+ MD.F_MatchShortName
		, LONGNAME = ED.F_EventLongName + CASE PD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END 
			+ ISNULL(FPD.F_PhaseLongName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseLongName + N' - '
			+ MD.F_MatchLongName
		, TVNAME = ED.F_EventShortName + CASE PD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END 
			+ ISNULL(FPD.F_PhaseShortName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' ' END, N'') 
			+ PD.F_PhaseShortName + N' - '
			+ MD.F_MatchShortName
		, PRINTNAME = ISNULL(FPD.F_PhaseLongName + CASE FPD.F_LanguageCode WHEN 'CHN' THEN N'' ELSE N' - ' END, N'') 
			+ PD.F_PhaseLongName + N' - '
			+ MD.F_MatchLongName
	FROM TS_Match AS M
	LEFT JOIN TS_Match_Des AS MD
		ON M.F_MatchID = MD.F_MatchID
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND MD.F_LanguageCode = PD.F_LanguageCode
	LEFT JOIN TS_Phase_Des AS FPD
		ON P.F_FatherPhaseID = FPD.F_PhaseID AND PD.F_LanguageCode = FPD.F_LanguageCode
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON E.F_EventID = ED.F_EventID AND PD.F_LanguageCode = ED.F_LanguageCode
	INNER JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	INNER JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE D.F_DisciplineCode = @DisciplineCode
	
	SELECT * 
	FROM #CSIC_Unit
	ORDER BY GENDER_CODE
		, [EVENT]
		, PHASE
		, UNIT
		, LANGUAGE_CODE

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_CommonCode_GenerateUnitFromDB] 'WP'

*/