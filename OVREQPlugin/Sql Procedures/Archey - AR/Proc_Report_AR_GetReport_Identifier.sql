IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetReport_Identifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetReport_Identifier]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Report_AR_GetReport_Identifier]
--描    述: 射箭项目报表获取 Report Identifier 的组成元素, 如 Discipline Code(2), Gender(1), Event Code(3), Phase(1), EventUnit(5) 等等. 
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2011年10月18日
--修改记录：
/*			
			时间				修改人		修改内容
			2010年01月11日		邓年彩		初版, 添加公用模板的情况.
*/



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetReport_Identifier]
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

	DECLARE @DisciplineCode			CHAR(2)
	DECLARE @Gender					CHAR(1)
	DECLARE @EventCode				CHAR(3)
	DECLARE @Phase					CHAR(1)
	DECLARE @EventUnit				CHAR(2)
	
	SET @DisciplineCode = '00'
	SET @Gender = '0'
	SET @EventCode = '000'
	SET @Phase = '0'
	SET @EventUnit = '00'
	
	------------------------------------------------------------------------------------------------------
	-- 对 @DisciplineID, @EventID, @PhaseID, @MatchID 进行预处理
	------------------------------------------------------------------------------------------------------
	IF @MatchID > 0
		SELECT @PhaseID = M.F_PhaseID FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
	
	IF @PhaseID > 0
		SELECT @EventID = P.F_EventID FROM TS_Phase AS P WHERE P.F_PhaseID = @PhaseID
	
	IF @EventID > 0
		SELECT @DisciplineID = E.F_DisciplineID FROM TS_Event AS E WHERE E.F_EventID = @EventID
	
	IF @DisciplineID = -1
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
	
	------------------------------------------------------------------------------------------------------
	-- 根据 @ReportType 调整 @DisciplineID, @EventID, @PhaseID, @MatchID
	------------------------------------------------------------------------------------------------------
	/*	KR - Karate (空手道) 所需报表
		(1) C08 - Competition Schedule
		(2) C30 - Number of Entries by NOC
		(3) C32A - Entry List by NOC
		(4) C32C - Entry List by Event
		(5) C38 - Entry Data Checklist
		(6) C51A - Draw Sheet
		(7) C51B - Draw Sheet(without contest data)
		(8) C51C - Draw Sheet(with contest data)
		(9) C56 - Weigh-In List
		(10) C57 - Judges List
		(11) C59 - Kata List
		(12) C67 - Official Communication
		(13) C73 - Contest Results
		(14) C75 - Results Bracket
		(15) C92A - Medallists
		(16) C93 - Medallists by Event
		(17) C95 - Medal Standings
	*/		
	
	-- 参数 @DisciplineID 有效
	-- (1) C08 - Competition Schedule, (2) C30 - Number of Entries by NOC, (3) C32A - Entry List by NOC, 
	-- (5) C38 - Entry Data Checklist, (10) C57 - Judges List, (11) C59 - Kata List
	-- (12) C67 (Official Communication), (16) C93 - Medallists by Event, (17) C95 - Medal Standings
	IF @ReportType = N'C08' OR @ReportType = N'C30'  OR @ReportType = N'C32A' 
		OR @ReportType = N'C38' OR @ReportType = N'C57' OR @ReportType = N'C59'
		OR @ReportType = N'C67' OR @ReportType = N'C93' OR @ReportType = N'C95'
	BEGIN
		SET @EventID = NULL
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END
	
	-- 参数 @DisciplineID, @EventID 有效
	-- (4) C32C - Entry List by Event, 
	-- (6) C51A - Draw Sheet, (7) C51B - Draw Sheet(without contest data), (8) C51C - Draw Sheet(with contest data), 
	-- (9) C56 - Weigh-In List, (14) C75 - Results Bracket, (15) C92A - Medallists
	ELSE IF @ReportType = N'C32C'
		OR @ReportType = N'C51A' OR @ReportType = N'C51B' OR @ReportType = N'C51C'
		OR @ReportType = N'C56' OR @ReportType = N'C75' OR @ReportType = N'C92A' 
	BEGIN
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END
	
	------------------------------------------------------------------------------------------------------
	-- 获取 @DisciplineCode(2), @Gender(1), @EventCode(3), @Phase(1), @EventUnit(2)
	------------------------------------------------------------------------------------------------------
	SELECT @DisciplineCode = RIGHT(D.F_DisciplineCode, 2)
	FROM TS_Discipline AS D
	WHERE D.F_DisciplineID = @DisciplineID
	
	SELECT @Gender = RIGHT(S.F_GenderCode, 1)
		, @EventCode = RIGHT(E.F_EventCode, 3)
	FROM TS_Event AS E
	LEFT JOIN TC_Sex AS S
		ON E.F_SexCode = S.F_SexCode
	WHERE E.F_EventID = @EventID
	
	SELECT @Phase = RIGHT(P.F_PhaseCode, 1)
	FROM TS_Phase AS P
	WHERE P.F_PhaseID = @PhaseID
	
	SELECT @EventUnit = RIGHT(M.F_MatchCode, 2)
	FROM TS_Match AS M
	WHERE M.F_MatchID = @MatchID

	------------------------------------------------------------------------------------------------------
	-- 返回数据集
	------------------------------------------------------------------------------------------------------
	SELECT @DisciplineCode AS [DisciplineCode]
		, @Gender AS [Gender]
		, @EventCode AS [EventCode]
		, @Phase AS [Phase]
		, @EventUnit AS [EventUnit]

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_KR_GetReport_Identifier] NULL, NULL, NULL, NULL, NULL, NULL, NULL
EXEC [Proc_Report_KR_GetReport_Identifier] NULL, NULL, NULL, NULL, NULL, NULL, N'ALL'

*/

GO


