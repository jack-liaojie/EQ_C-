IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetReportIdentifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetReportIdentifier]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--名    称: [Proc_Report_SL_GetReportIdentifier]
--描    述: 激流回旋项目报表获取 Report Identifier 的组成元素, 如 Discipline Code(2), Gender(1), Event Code(3), Phase(1), EventUnit(5) 等等. 
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月25日
--修改记录：


CREATE PROCEDURE [dbo].[Proc_Report_SL_GetReportIdentifier]
	@DisciplineID					INT,
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@DateID							INT,
	@SessionID						INT,
	@ReportType						NVARCHAR(20)
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #Report_Identifier
	(
		[DisciplineCode]			CHAR(2),
		[Gender]					CHAR(1),
		[EventCode]					CHAR(3),
		[Phase]						CHAR(1),
		[EventUnit]					CHAR(2)
	)

	INSERT #Report_Identifier
	([DisciplineCode], [Gender], [EventCode], [Phase], [EventUnit])
	VALUES
	('00', '0', '000', '0', '00')

	-- 参数 @MatchID 有效
	IF @MatchID > 0
	BEGIN
		UPDATE #Report_Identifier
		SET [DisciplineCode] = D.F_DisciplineCode
			, [Gender] = E.F_GenderCode
			, [EventCode] = C.F_EventCode
			, [Phase] = B.F_PhaseCode
			, [EventUnit] = A.F_MatchCode
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B
			ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Event AS C
			ON B.F_EventID = C.F_EventID
		LEFT JOIN TS_Discipline AS D
			ON C.F_DisciplineID = D.F_DisciplineID
		LEFT JOIN TC_Sex AS E
			ON C.F_SexCode = E.F_SexCode
		WHERE A.F_MatchID = @MatchID
	END

	-- 参数 @PhaseID 有效
	ELSE IF @PhaseID > 0
	BEGIN
		UPDATE #Report_Identifier
		SET [DisciplineCode] = C.F_DisciplineCode
			, [Gender] = D.F_GenderCode
			, [EventCode] = B.F_EventCode
			, [Phase] = A.F_PhaseCode
		FROM TS_Phase AS A
		LEFT JOIN TS_Event AS B
			ON A.F_EventID = B.F_EventID
		LEFT JOIN TS_Discipline AS C
			ON B.F_DisciplineID = C.F_DisciplineID
		LEFT JOIN TC_Sex AS D
			ON B.F_SexCode = D.F_SexCode
		WHERE A.F_PhaseID = @PhaseID
	END

	-- 参数 @EventID 有效
	ELSE IF @EventID > 0
	BEGIN
		UPDATE #Report_Identifier
		SET [DisciplineCode] = B.F_DisciplineCode
			, [Gender] = C.F_GenderCode
			, [EventCode] = A.F_EventCode
		FROM TS_Event AS A
		LEFT JOIN TS_Discipline AS B
			ON A.F_DisciplineID = B.F_DisciplineID
		LEFT JOIN TC_Sex AS C
			ON A.F_SexCode = C.F_SexCode
		WHERE A.F_EventID = @EventID
	END

	-- 参数 @DisciplineID 有效
	ELSE IF @DisciplineID > 0
	BEGIN
		UPDATE #Report_Identifier
		SET [DisciplineCode] = A.F_DisciplineCode
		FROM TS_Discipline AS A
		WHERE A.F_DisciplineID = @DisciplineID
	END

	-- 根据 @ReportType 微调 Report Identifier

	-- ReportType 为 ALL
	-- 不需要 [DisciplineCode](2), [Gender](1), [EventCode](3), [Phase](1), [EventUnit](2)
	IF @ReportType = N'ALL'
	BEGIN
		UPDATE #Report_Identifier 
		SET [DisciplineCode] = '00'
			, [Gender] = '0'
			, [EventCode] = '000'
			, [Phase] = '0'
			, [EventUnit] = '00'
	END

	-- ReportType 包含：
	    --SL_C08 - Competition Schedule 
	    --SL_C30 - Number of Entries by NOC
	    --SL_C32A - Entry List by NOC
	    --SL_C38 - Entry Data Checklist
	    --SL_C76 - Competition Summary
	    --SL_C93 - Medallists by Event
	    --SL_C95 - Medal Standings
	    --SL_C96 - Final Placing by NOC
	-- 不需要 [Gender](1), [EventCode](3), [Phase](1), [EventUnit](2)
	IF @ReportType = N'C08'
	    OR @ReportType = N'C30' OR @ReportType = N'C32A' OR @ReportType = N'C38' 
		OR @ReportType = N'C76' 
		OR @ReportType = N'C93' OR @ReportType = N'C95' OR @ReportType = N'C96'
	BEGIN
		UPDATE #Report_Identifier 
		SET [Gender] = '0'
			, [EventCode] = '000'
			, [Phase] = '0'
			, [EventUnit] = '00'
	END

	-- ReportType 包含：
	        --SL_C32C - Entry List by Event
			--SL_C92 - MedalLists 
	-- 不需要 [Phase](1), [EventUnit](2)
	IF @ReportType = N'C32C'
		OR @ReportType = N'C92'
	BEGIN
		UPDATE #Report_Identifier 
		SET [Phase] = '0'
			, [EventUnit] = '00'
	END

	SELECT [DisciplineCode]
		, [Gender]
		, [EventCode]
		, [Phase]
		, [EventUnit]
	FROM #Report_Identifier

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_Report_SL_GetReportIdentifier] NULL, NULL, NULL, NULL, NULL, NULL, NULL
EXEC [Proc_Report_SL_GetReportIdentifier] NULL, NULL, NULL, NULL, NULL, NULL, N'ALL'

*/