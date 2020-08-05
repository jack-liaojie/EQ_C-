IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetGeneralInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetGeneralInfo]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

--��    ��: [Proc_Report_WL_GetGeneralInfo]
--��    ��: ��Ŀ�����ȡ������Ϣ, �� Venue, Discipline, Event, EventUnit, Weekday, Date, StartTime, EndTime, CreateTime, AsOfDate �ȵ�,  
--����˵��: 
--˵    ��: 
--�� �� ��: �ⶨ�P
--��    ��: 2010��10��19��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetGeneralInfo]
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

	SET LANGUAGE N'English'

	-- ReportType Ϊ ALL, ��Ϊ����ģ��, ���� @LanguageCode
	IF @ReportType IS NULL OR @ReportType = N'' OR @ReportType = N'ALL'
	BEGIN
		SELECT 
			CASE @LanguageCode
				WHEN 'CHN' THEN N'SPORT NAME(����)'
				ELSE N'SPORT NAME(EN)'
			END AS [Sport]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'DISCIPLINE NAME(����)'
				ELSE N'DISCIPLINE NAME(EN)'
			END AS [Discipline]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'GENDER, EVENT NAME (����)'
				ELSE N'GENDER, EVENT NAME (EN)'
			END AS [Event]
			, N'DisciplineCode' AS [DisciplineCode]
			, N'EventCode' AS [EventCode]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'EVENT PHASE, EVENT UNIT (����)'
				ELSE N'EVENT PHASE, EVENT UNIT (EN)'
			END AS [EventUnit]
			, CASE @LanguageCode
				WHEN 'CHN' THEN N'VENUE NAME (����)'
				ELSE N'VENUE NAME (EN)'
			END AS [Venue]
			, dbo.Fun_GetWeekdayName(GETDATE(), @LanguageCode) AS [Weekday]
			, dbo.Fun_WL_GetDateTime(GETDATE(), 1, @LanguageCode) AS [Date]
			, CASE WHEN @LanguageCode='CHN' THEN N'��ʼʱ��' ELSE N'Start Time'END AS [StartTime]
			, CASE WHEN @LanguageCode='CHN' THEN N'����ʱ��' ELSE N'End Time' END AS [EndTime]
			, dbo.Fun_WL_GetDateTime(GETDATE(),6, @LanguageCode) AS [CreatedTime]
			, dbo.Fun_WL_GetDateTime(GETDATE(), 6, @LanguageCode) AS [AsOfDate] 
	END

	-- ReportType ������
	    --C08 - Competition Schedule 
	    --C30 - Number of Entries by NOC
	    --C32A - Entry List by NOC
	    --C32C - Entry List by Event    
	    --C38 - Entry Data Checklist
	    --C76 - Competition Summary
		--C92 - MedalLists     
	    --C93 - Medallists by Event
	    --C95 - Medal Standings
	    --C96 - Final Placing by NOC
	-- ���� @DisciplineID, @LanguageCode
	ELSE IF @ReportType = N'C08' 
	    OR @ReportType = N'C30' OR @ReportType = N'C32A' OR @ReportType = N'C32C' OR @ReportType = N'C38'
		OR @ReportType = N'C76'
		OR @ReportType = N'C92' OR @ReportType = N'C93'	OR @ReportType = N'C95' OR @ReportType = N'C96'
	BEGIN
		SELECT UPPER(SD.F_SportLongName) AS [Sport]
		    , UPPER(B.F_DisciplineLongName) AS [Discipline]
		    , UPPER(ED.F_EventLongName) AS [Event]
		    , A.F_DisciplineCode AS [DisciplineCode]
		    , E.F_EventCode AS [EventCode]
			, UPPER(D.F_VenueLongName) AS [Venue]
			, dbo.Fun_WL_GetDateTime(GETDATE(), 2, @LanguageCode) AS [Weekday]
			, dbo.Fun_WL_GetDateTime(GETDATE(), 1, @LanguageCode) AS [Date]
			, dbo.Fun_WL_GetDateTime(GETDATE(), 6, @LanguageCode) AS [AsOfDate]
			, dbo.Fun_WL_GetDateTime(GETDATE(), 6, @LanguageCode) AS [CreatedTime]
			, (
				SELECT COUNT(X.F_EventID)
				FROM TS_Event AS X
				WHERE X.F_DisciplineID = @DisciplineID
				AND X.F_EventCode <> '000'
			) AS [AllEventCount]
			, (
				SELECT COUNT(X.F_EventID)
				FROM TS_Event AS X
				WHERE X.F_DisciplineID = @DisciplineID
				    AND X.F_EventCode <> '000'
					AND X.F_EventStatusID = 110
			) AS [FinishedEventCount]
		FROM TS_Discipline AS A
		LEFT JOIN TS_Discipline_Des AS B
			ON A.F_DisciplineID = B.F_DisciplineID AND B.F_LanguageCode = @LanguageCode
		LEFT JOIN TS_Sport_Des AS SD
			ON A.F_SportID = SD.F_SportID AND SD.F_LanguageCode = @LanguageCode			
		LEFT JOIN TS_Event AS E
		    ON A.F_DisciplineID = E.F_DisciplineID AND E.F_EventID = @EventID
		LEFT JOIN TS_Event_Des AS ED
		    ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode    	
		LEFT JOIN TD_Discipline_Venue AS C
			ON A.F_DisciplineID = C.F_DisciplineID
		LEFT JOIN TC_Venue_Des AS D
			ON C.F_VenueID = D.F_VenueID AND D.F_LanguageCode = @LanguageCode
		WHERE A.F_DisciplineID = @DisciplineID 
--		    AND E.F_EventCode <> '000'
	END

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetGeneralInfo] NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ENG'
EXEC [Proc_Report_WL_GetGeneralInfo] NULL, NULL, NULL, NULL, NULL,  NULL, N'','CHN'
EXEC [Proc_Report_WL_GetGeneralInfo] NULL, 109, NULL, NULL, NULL, NULL, N'C51C',  'CHN'
EXEC [Proc_Report_WL_GetGeneralInfo] NULL, NULL, NULL, 2538, NULL, NULL, N'C73',  'ENG'
EXEC [Proc_Report_WL_GetGeneralInfo] 1, NULL, NULL, 2538, NULL, NULL, N'C93',  'CHN'

*/