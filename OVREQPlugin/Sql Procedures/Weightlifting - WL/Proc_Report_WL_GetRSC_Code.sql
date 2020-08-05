IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetRSC_Code]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetRSC_Code]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WL_GetRSC_Code]
--描    述: 项目报表获取 RSC Code, 即 DISCIPLINE(2), SEX(1), EVENT(3), EVENT_PARENT(3), PHASE(1), POOL(2), EVENT_UNIT(5) 等连接起来的字符串. 
--参数说明: 
--说    明: 
--创 建 人: 
--日    期: 2010年10月19日
--修改记录：
/*			
	日期					修改人		修改内容
	2011年3月26日 星期六	邓年彩		添加 C76 - Unofficial Team Classification;
										格式由 "DDSEEEEEEFPPUUUUU.(参数)" 改为 DDSEEEFUU.
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetRSC_Code]
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

	CREATE TABLE #RSC_Code
	(
		[DISCIPLINE]				CHAR(2),
		[SEX]						CHAR(1),
		[EVENT]						CHAR(3),
		[PHASE]						CHAR(1),
		[EVENT_UNIT]				CHAR(2)
	)

	INSERT #RSC_Code
	([DISCIPLINE], [SEX], [EVENT], [PHASE], [EVENT_UNIT])
	VALUES
	('00', '0', '000', '0', '00')

	-- 参数 @MatchID 有效
	IF @MatchID > 0
	BEGIN
		UPDATE #RSC_Code
		SET [DISCIPLINE] = D.F_DisciplineCode
			, [SEX] = E.F_GenderCode
			, [EVENT] = C.F_EventCode
			, [PHASE] = B.F_PhaseCode
			, [EVENT_UNIT] = A.F_MatchCode
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
		UPDATE #RSC_Code
		SET [DISCIPLINE] = C.F_DisciplineCode
			, [SEX] = D.F_GenderCode
			, [EVENT] = B.F_EventCode
			, [PHASE] = A.F_PhaseCode
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
		UPDATE #RSC_Code
		SET [DISCIPLINE] = B.F_DisciplineCode
			, [SEX] = C.F_GenderCode
			, [EVENT] = A.F_EventCode
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
		UPDATE #RSC_Code
		SET [DISCIPLINE] = A.F_DisciplineCode
		FROM TS_Discipline AS A
		WHERE A.F_DisciplineID = @DisciplineID
	END

	-- 根据 @ReportType 微调 RSC_Code

	-- ReportType 为 ALL
	-- 不需要 [DISCIPLINE](2), [SEX](1), [EVENT](3), [EVENT_PARENT](3), [PHASE](1), [EVENT_UNIT](5)
	IF @ReportType = N'ALL'
	BEGIN
		UPDATE #RSC_Code 
		SET [DISCIPLINE] = '00'
			, [SEX] = '0'
			, [EVENT] = '000'
			, [PHASE] = '0'
			, [EVENT_UNIT] = '00'
	END

	-- ReportType 为 
	--				 C08 (Competition Schedule),
	--               C30 (Number of Entries by NOC), 
	--               C32A (Entry List By NOC), 
	--               C38 (Entry Data Checklist), 
	--				 C67 (Official Communication), 
	--				 C76 (Unofficial Team Classification),
	--               C93 (Medallists by Event), C95 (Medal Standings),
	
	-- 不需要 [SEX](1), [EVENT](3), [EVENT_PARENT](3), [PHASE](1), [EVENT_UNIT](5)
	IF @ReportType = N'C08'
	    OR @ReportType = N'C30' 
	    OR @ReportType = N'C32A' 
	    OR @ReportType = N'C38' 
		OR @ReportType = N'C67'
		OR @ReportType = N'C76'
		OR @ReportType = N'C93' OR @ReportType = N'C95'
	BEGIN
		UPDATE #RSC_Code 
		SET [SEX] = '0'
			, [EVENT] = '000'
			, [PHASE] = '0'
			, [EVENT_UNIT] = '00'
	END

	-- ReportType 为 C32C (Entry List By Event), 
	--				 C92A (Medallists - Individual)
	-- 不需要 [PHASE](1), [EVENT_UNIT](5)
	IF @ReportType = N'C32C'
		OR @ReportType = N'C92A'
	BEGIN
		UPDATE #RSC_Code 
		SET [PHASE] = '0'
			, [EVENT_UNIT] = '00'
	END

	SELECT [DISCIPLINE] + [SEX] + [EVENT] + [PHASE] + [EVENT_UNIT] AS [KEY]
	FROM #RSC_Code

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_WL_GetRSC_Code] NULL, NULL, NULL, NULL, NULL, NULL, N'ALL'
EXEC [Proc_Report_WL_GetRSC_Code] 59, NULL, NULL, NULL, NULL, NULL, N'C32A'

*/