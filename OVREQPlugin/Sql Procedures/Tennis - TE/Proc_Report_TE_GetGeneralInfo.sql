IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetGeneralInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetGeneralInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_TE_GetGeneralInfo]
--描    述: 空手道项目报表获取基本信息, 如 Venue, Discipline, Event, EventUnit, Weekday, Date, StartTime, EndTime, CreateTime, AsOfDate 等等,  
--参数说明: 
--说    明: 
--创 建 人: 邓年彩
--日    期: 2010年1月8日
--修改记录：
/*			
			时间				修改人		修改内容
			2010年01月08日		邓年彩		初版, 添加公用模板的情况.	
			2010年01月10日		邓年彩		添加模板 C32A (Entry List By NOC), C32C (Entry List By Event) 的情况.
			2010年01月12日		邓年彩		添加模板 C56 (Weigh-in List), C38 (Entry Data Checklist) 的情况.
			2010年01月14日		邓年彩		添加模板 C30 (Number of Entries by NOC) 的情况.
			2010年01月15日		邓年彩		添加模板 C45 (Number Allocation), C51A (Draw Sheet), C51B (Draw Sheet(without contest data)), C51C (Draw Sheet(with contest data)) 的情况.
			2010年1月18日		邓年彩		添加模板 C67 (Official Communication), C92A (Medallists - Individual) 的情况;
											添加模板 C93 (Medallists by Event), C95 (Medal Standings) 的情况.
			2010年1月19日		邓年彩		添加模板 C08 (Competition Schedule) 的情况.
			2010年1月20日		邓年彩		添加参数 @SessionID.
			2010年1月21日		邓年彩		添加模板 C57 (Judge List) 的情况; 当参数有 @EventID, 取出这个小项共有多少比赛.
			2010年1月22日		邓年彩		添加模板 C73 (Contest Result) 的情况.
			2010年1月27日		邓年彩		添加模板 C75 (Results) 的情况.
			2010年1月28日		邓年彩		日期取大写.
			2010年2月4日		邓年彩		取日期使用统一的函数 [Func_Report_KR_GetDateTime], 日期不以 0 开头.
			2010年2月5日		邓年彩		StartTime 小时不以 0 开头.
			2010年5月10日		邓年彩		C73 时, 获取 MatchType: 1-组手单人, 2-组手团体, 3-型单人, 4-型团体.
			2010年6月23日		邓年彩		当 @DisciplineID = -1, 取默认的 DisciplineID.
			2010年7月6日		邓年彩		对 @DisciplineID, @EventID, @PhaseID 等进行预处理; 场馆使用简称.
*/



CREATE PROCEDURE [dbo].[Proc_Report_TE_GetGeneralInfo]
	@DisciplineID					INT,
	@EventID						INT,
	@PhaseID						INT,
	@MatchID						INT,
	@DateID							INT,
	@SessionID						INT,
	@ReportType						NVARCHAR(20),
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON
	
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

	IF @LanguageCode = 'CHN'
	BEGIN
		SET LANGUAGE '简体中文'		
	END
	ELSE 
	BEGIN
		SET LANGUAGE 'us_english'
	END

	-- ReportType 为 ALL, 即为公用模板, 参数 @LanguageCode
	IF @ReportType IS NULL OR @ReportType = N'' OR @ReportType = N'ALL'
	BEGIN
		SELECT 
			CASE @LanguageCode
				WHEN 'CHN' THEN N'DISCIPLINE NAME(中文)'
				ELSE N'DISCIPLINE NAME(EN)'
			END AS [Discipline]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'GENDER, EVENT NAME (中文)'
				ELSE N'GENDER, EVENT NAME (EN)'
			END AS [Event]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'EVENT PHASE, EVENT UNIT (中文)'
				ELSE N'EVENT PHASE, EVENT UNIT (EN)'
			END AS [EventUnit]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'VENUE NAME (中文)'
				ELSE N'VENUE NAME (EN)'
			END AS [Venue]
			, dbo.[Func_Report_KR_GetDateTime](GETDATE(), 2, @LanguageCode) AS [Weekday]
			, dbo.[Func_Report_KR_GetDateTime](GETDATE(), 1, @LanguageCode) AS [Date]
			, N'Start Time' AS [StartTime]
			, N'End Time' AS [EndTime]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [CreatedTime]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [AsOfDate]
	END

	-- ReportType 为 C32A (Entry List By NOC), C32C (Entry List By Event), C56 (Weigh-in List), C38 (Entry Data Checklist)
	--				 C30 (Number of Entries by NOC), C45 (Number Allocation), C67 (Official Communication), C93 (Medallists by Event),
	--				 C95 (Medal Standings),	C08 (Competition Schedule), C57 (Judge List)			 
	-- 参数 @DisciplineID, @LanguageCode
	ELSE IF @ReportType = N'C32A' OR @ReportType = N'C32C' OR @ReportType = N'C56' OR @ReportType = N'C38'
		OR @ReportType = N'C30' OR @ReportType = N'C45' OR @ReportType = N'C67' OR @ReportType = N'C93'
		OR @ReportType = N'C95' OR @ReportType = N'C08' OR @ReportType = N'C57'
	BEGIN
		SELECT UPPER(B.F_DisciplineLongName) AS [Discipline]
			, UPPER(D.F_VenueShortName) AS [Venue]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 2, @LanguageCode) AS [Weekday]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [AsOfDate]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [CreatedTime]
			, (
				SELECT COUNT(X.F_EventID)
				FROM TS_Event AS X
				WHERE X.F_DisciplineID = @DisciplineID
			) AS [AllEventCount]
			, (
				SELECT COUNT(X.F_EventID)
				FROM TS_Event AS X
				WHERE X.F_DisciplineID = @DisciplineID
					AND X.F_EventStatusID = 110
			) AS [FinishedEventCount]
		FROM TS_Discipline AS A
		LEFT JOIN TS_Discipline_Des AS B
			ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TD_Discipline_Venue AS C
			ON A.F_DisciplineID = C.F_DisciplineID
		LEFT JOIN TC_Venue_Des AS D
			ON C.F_VenueID = D.F_VenueID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_DisciplineID = @DisciplineID 
	END
	
	-- ReportType 为 C51A (Draw Sheet), C51B (Draw Sheet(without contest data)), C51C (Draw Sheet(with contest data)),
	--				 C92A (Medallists - Individual), C75 (Results)
	-- 参数 @EventID, @LanguageCode
	ELSE IF @ReportType = N'C51A' OR @ReportType = N'C51B' OR @ReportType = N'C51C' 
		OR @ReportType = N'C92A' OR @ReportType = N'C75'
	BEGIN
		SELECT UPPER(C.F_DisciplineLongName) AS [Discipline]
			, UPPER(B.F_EventLongName) AS [Event]
			, UPPER(E.F_VenueShortName) AS [Venue]
			, dbo.[Func_Report_TE_GetDateTime](A.F_CloseDate, 2, @LanguageCode) AS [Weekday]
			, dbo.[Func_Report_TE_GetDateTime](A.F_CloseDate, 1, @LanguageCode) AS [Date]
			, dbo.[Func_Report_TE_GetDateTime](A.F_CloseDate, 4, @LanguageCode) AS [StartTime]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [AsOfDate]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [CreatedTime]
			, (
				SELECT COUNT(A.F_MatchID)
				FROM TS_Match AS A
				LEFT JOIN TS_Phase AS B
					ON A.F_PhaseID = B.F_PhaseID
				WHERE B.F_EventID = @EventID
			) AS [MatchCount]
		FROM TS_Event AS A
		LEFT JOIN TS_Event_Des AS B
			ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Discipline_Des AS C
			ON A.F_DisciplineID = C.F_DisciplineID AND C.F_LanguageCode = @LanguageCode
		LEFT JOIN TD_Discipline_Venue AS D
			ON A.F_DisciplineID = D.F_DisciplineID
		LEFT JOIN TC_Venue_Des AS E
			ON D.F_VenueID = E.F_VenueID AND E.F_LanguageCode = @LanguageCode
		WHERE A.F_EventID = @EventID
	END
	
	ELSE IF @ReportType = N'C73A' OR @ReportType = N'C73B'
	BEGIN
		SELECT UPPER(B.F_VenueShortName) AS [Venue]
			, UPPER(F.F_DisciplineLongName) AS [Discipline]
			, UPPER(E.F_EventLongName) AS [Event]
			, UPPER(H.F_PhaseLongName) AS [Phase]
			, C.F_PhaseCode AS [PhaseCode]
			, UPPER(I.F_RoundLongName) AS [Round] 
			, A.F_RaceNum AS [ContestNo]
			, dbo.[Func_Report_TE_GetDateTime](A.F_MatchDate, 2, @LanguageCode) AS [Weekday] 
			, dbo.[Func_Report_TE_GetDateTime](A.F_MatchDate, 1, @LanguageCode) AS [Date] 
			, A.F_StartTime AS [StartTime]
			, dbo.[Func_Report_TE_GetDateTime](GETDATE(), 7, @LanguageCode) AS [CreatedTime]
			, dbo.[Fun_KR_GetMatchType](@MatchID) AS [MatchType]
		FROM TS_Match AS A
		LEFT JOIN TC_Venue_Des AS B
			ON A.F_VenueID = B.F_VenueID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Phase AS C
			ON A.F_PhaseID = C.F_PhaseID
		LEFT JOIN TS_Event AS D
			ON C.F_EventID = D.F_EventID 
		LEFT JOIN TS_Event_Des AS E
			ON C.F_EventID = E.F_EventID AND E.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Discipline_Des AS F
			ON D.F_DisciplineID = F.F_DisciplineID AND F.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Match_Des AS G
			ON A.F_MatchID = G.F_MatchID AND G.F_LanguageCode = @LanguageCode 
		LEFT JOIN TS_Phase_Des AS H
			ON C.F_PhaseID = H.F_PhaseID AND H.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Round_Des AS I
			ON A.F_RoundID = I.F_RoundID AND I.F_LanguageCode = @LanguageCode
		WHERE A.F_MatchID = @MatchID		
	END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_TE_GetGeneralInfo] NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ENG'
EXEC [Proc_Report_KR_GetGeneralInfo] NULL, NULL, NULL, NULL, NULL,  NULL, N'','CHN'
EXEC [Proc_Report_KR_GetGeneralInfo] NULL, 109, NULL, NULL, NULL, NULL, N'C51C',  'CHN'
EXEC [Proc_Report_KR_GetGeneralInfo] NULL, NULL, NULL, 2538, NULL, NULL, N'C73',  'ENG'
EXEC [Proc_Report_KR_GetGeneralInfo] NULL, NULL, NULL, 2538, NULL, NULL, N'C73',  'CHN'

*/

