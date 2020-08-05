IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_JU_GetGeneralInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_JU_GetGeneralInfo]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    ��: [Proc_Report_JU_GetGeneralInfo]
--��    ��: �����Ŀ�����ȡ������Ϣ, �� Discipline, Event, EventUnit, Venue, Weekday, Date, StartTime, EndTime, AsOfDate, CreateTime �ȵ�.  
--�� �� ��: �����
--��    ��: 2010��9��16�� ������
--�޸ļ�¼��
/*			
	ʱ��					�޸���		�޸�����
	2010��9��25�� ������	�����		��������򱨱����򱨱�� Displine, Event, EventUnit ��ҳü�е�ˮƽλ��.
	2010��10��25�� ����һ	�����		����ֶ� MatchCount �� CompetitorCount.
	2010��10��28�� ������	�����		�� ReportType Ϊ C51B ʱ, �� EventID Ϊ׼; �������ı���� ReportType; ��� X98, X99.
*/



CREATE PROCEDURE [dbo].[Proc_Report_JU_GetGeneralInfo]
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
	
	DECLARE @Venue					NVARCHAR(100)
	DECLARE @Date					DATETIME
	DECLARE @StartTime				DATETIME
	DECLARE @EndTime				DATETIME

	DECLARE @Discipline				NVARCHAR(100)
	DECLARE @Event					NVARCHAR(200)
	DECLARE @Phase					NVARCHAR(200)
	DECLARE @Match					NVARCHAR(200)
	DECLARE @EventUnit				NVARCHAR(200)
	
	DECLARE @CourtCode				NVARCHAR(200)
	
	DECLARE @MatchCount				INT
	DECLARE @CompetitorCount		INT
	
	DECLARE @AllEventCount			INT
	DECLARE @FinishedEventCount		INT
	
	DECLARE @RegTypeID				INT
	
	------------------------------------------------------------------------------------------------------
	-- �� @DisciplineID, @EventID, @PhaseID, @MatchID ����Ԥ����
	------------------------------------------------------------------------------------------------------
	IF @ReportType <> N'C51B' AND @ReportType <> N'Z51B'
	BEGIN
		IF @MatchID > 0
			SELECT @PhaseID = M.F_PhaseID FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
		
		IF @PhaseID > 0
			SELECT @EventID = P.F_EventID FROM TS_Phase AS P WHERE P.F_PhaseID = @PhaseID
	END
	
	IF @EventID > 0
		SELECT @DisciplineID = E.F_DisciplineID FROM TS_Event AS E WHERE E.F_EventID = @EventID
	
	IF @DisciplineID = -1
		SELECT @DisciplineID = D.F_DisciplineID FROM TS_Discipline AS D WHERE D.F_Active = 1
		
	if @MatchID>0
	begin
		select @CourtCode=CD.F_CourtShortName 
		from TS_Match AS M 
		LEFT JOIN TC_Court AS C 
			ON C.F_CourtID=M.F_CourtID
		LEFT JOIN TC_Court_Des AS CD 
			ON CD.F_CourtID=C.F_CourtID AND CD.F_LanguageCode=@LanguageCode
		where M.F_MatchID=@MatchID
	END
	
	------------------------------------------------------------------------------------------------------
	-- ���� @ReportType ���� @DisciplineID, @EventID, @PhaseID, @MatchID
	------------------------------------------------------------------------------------------------------
	/* Judo - JU (���) ���豨��
		(1)	C08 - Competition Schedule
		(2)	C30 - Number of Entries by NOC
		(3) C32A - Entry List by NOC
		(4) C32C - Entry List by Weight Category
		(5) C38 - Entry Data Checklist
		(6) C39 - Entry Data Checklist - Competition Officials
		(7) C51A - Contest List(without contest number)
		(8) C51B - Contest List(with contest number)
		(9) C56 - Weigh-in List(media release)
		(10) C58 - Contest Order
		(11) C67 - Official Communication
		(12) C71 - Contest Results
		(13) C75 - Contest List
		(14) C92A - Medallists
		(15) C93 - Medallists by Event
		(16) C95 - Medal Standings
		(17) C96 - Top 8
		(18) X98 - Good Morning
		(19) X99 - Good Night
	*/
	
	-- ���� @DisciplineID ��Ч
	-- (1) C08 - Competition Schedule, (2) C30 - Number of Entries by NOC, (3) C32A - Entry List by NOC,
	-- (5) C38 - Entry Data Checklist, (6) C39 - Entry Data Checklist - Competition Officials
	-- (10) C58 - Contest Order, (11) C67 - Official Communication, 
	-- (15) C93 - Medallists by Event, (16) C95 - Medal Standings,
	-- (18) X98 - Good Morning, (19) X99 - Good Night
	IF @ReportType = N'C08' OR @ReportType = N'C30' OR @ReportType = N'C32A' 
		OR @ReportType = N'C38' OR @ReportType = N'C39' 
		OR @ReportType = N'C58' OR @ReportType = N'C67' 
		OR @ReportType = N'C93' OR @ReportType = N'C95'
		OR @ReportType = N'Z08' OR @ReportType = N'Z30' OR @ReportType = N'Z32A' 
		OR @ReportType = N'Z38' OR @ReportType = N'Z39' 
		OR @ReportType = N'Z58' OR @ReportType = N'Z67' 
		OR @ReportType = N'Z93' OR @ReportType = N'Z95'
		OR @ReportType = N'X98' OR @ReportType = N'X99'
	BEGIN
		SET @EventID = NULL
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END
	
	-- ���� @DisciplineID, @EventID ��Ч
	-- (4) C32C - Entry List by Event, (7) C51A - Contest List(without contest number), 
	-- (8) C51B - Contest List(with contest number), (9) C56 - Weigh-in List(media release), 
	-- (13) C75 - Contest List, (14) C92A - Medallsits (Individual), (17) C96 - Top 8
	ELSE IF @ReportType = N'C32C' OR @ReportType = N'C51A' 
		OR @ReportType = N'C51B' OR @ReportType = N'C56' 
		OR @ReportType = N'C75' OR @ReportType = N'C92A' OR @ReportType = N'C96'
		OR @ReportType = N'Z32C' OR @ReportType = N'Z51A' 
		OR @ReportType = N'Z51B' OR @ReportType = N'Z56' 
		OR @ReportType = N'Z75' OR @ReportType = N'Z92A' OR @ReportType = N'Z96'
	BEGIN
		SET @PhaseID = NULL
		SET @MatchID = NULL
	END
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ @Discipline, @Event, @Phase, @Match, @EventUnit
	------------------------------------------------------------------------------------------------------
	SELECT @Discipline = UPPER(DD.F_DisciplineLongName)
	FROM TS_Discipline_Des AS DD
	WHERE DD.F_DisciplineID = @DisciplineID AND DD.F_LanguageCode = @LanguageCode
	
	SELECT @Event = UPPER(ED.F_EventLongName)
	FROM TS_Event_Des AS ED
	WHERE ED.F_EventID = @EventID AND ED.F_LanguageCode = @LanguageCode
	
	SELECT @Phase = UPPER(PD.F_PhaseLongName)
	FROM TS_Phase_Des AS PD
	WHERE PD.F_PhaseID = @PhaseID AND PD.F_LanguageCode = @LanguageCode
	
	SELECT @Match = UPPER(MD.F_MatchLongName)
	FROM TS_Match_Des AS MD
	WHERE MD.F_MatchID = @MatchID AND MD.F_LanguageCode = @LanguageCode
	
	SET @EventUnit = @Phase
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ @Venue, @Date, @StartTime, @EndTime
	------------------------------------------------------------------------------------------------------	
	
	SELECT @Venue = UPPER(VD.F_VenueLongName)
	FROM TD_Discipline_Venue AS DV
	LEFT JOIN TC_Venue_Des AS VD
		ON DV.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode
	WHERE DV.F_DisciplineID = @DisciplineID	
	
	-- ���� @DisciplineID, @EventID ��Ч
	-- ȡ��Ŀ��ʼ���ں�ʱ��: (7) C51A - Contest List(without contest number), (8) C51B - Contest List(with contest number)
	IF @ReportType = N'C51A' OR @ReportType = N'C51B' OR @ReportType = N'Z51A' OR @ReportType = N'Z51B' OR @ReportType=N'C56'
	BEGIN		
		SELECT @Date = E.F_OpenDate , @StartTime = E.F_OpenDate FROM TS_Event AS E WHERE E.F_EventID = @EventID
	END
	
	-- ȡ��Ŀ��ʼ����: (13) C75 - Contest List
	ELSE IF @ReportType = N'C75' OR @ReportType = N'Z75'
	BEGIN
		SELECT @Date = E.F_OpenDate FROM TS_Event AS E WHERE E.F_EventID = @EventID
	END
	
	-- ȡ��Ŀ��������: (14) C92A - Medallsits (Individual), (17) C96 - Top 8
	ELSE IF @ReportType = N'C92A' OR @ReportType = N'Z92A'
		OR @ReportType = N'C96' OR @ReportType = N'Z96'
	BEGIN
		SELECT @Date = E.F_CloseDate FROM TS_Event AS E WHERE E.F_EventID = @EventID
	END
	
	-- ���� @DisciplineID, @SessionID ��Ч
	-- ȡ��Ԫ��ʼ����: C58 - Contest Order
	ELSE IF @ReportType = N'C58' OR @ReportType = N'Z58'
	BEGIN
		SELECT @Date = S.F_SessionDate FROM TS_Session AS S WHERE S.F_SessionID = @SessionID
	END
	
	-- ���� @DisciplineID, @EventID, @MatchID ��Ч
	ELSE IF @ReportType = N'C71' OR @ReportType = N'Z71'
	BEGIN
		SELECT @Date = M.F_MatchDate FROM TS_Match AS M WHERE M.F_MatchID = @MatchID
	END
	
	ELSE IF @ReportType = N'ALL' OR @ReportType = N'ALL_L'
	BEGIN
		SET @Date = GETDATE()
		SET @StartTime = GETDATE()
		SET @EndTime = GETDATE()
	END
	
	------------------------------------------------------------------------------------------------------
	-- ��ȡ������Ϣ
	------------------------------------------------------------------------------------------------------
	SELECT @MatchCount = COUNT(M.F_MatchID)
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	WHERE P.F_EventID = @EventID
	
	SELECT @CompetitorCount = COUNT(EC.F_RegisterID)
	FROM TS_Event_Competitors AS EC
	WHERE EC.F_EventID = @EventID
		AND EC.F_RegisterID IS NOT NULL AND EC.F_RegisterID <> -1
		
	SELECT @AllEventCount = COUNT(E.F_EventID)
	FROM TS_Event AS E
	WHERE E.F_DisciplineID = @DisciplineID
		
	SELECT @FinishedEventCount = COUNT(E.F_EventID)
	FROM TS_Event AS E
	WHERE E.F_DisciplineID = @DisciplineID
		AND E.F_EventStatusID = 110
		
	SELECT @RegTypeID = E.F_PlayerRegTypeID
	FROM TS_Event AS E
	WHERE E.F_EventID = @EventID
	
	------------------------------------------------------------------------------------
	--��ȡ��ǰ����Session
	------------------------------------------------------------------------------------
	declare @matchID2 int
	       
			
	if @EventID>0
	begin
			select  
				@matchID2=min(m.F_MatchID)
			from TS_Match as M
			LEFT JOIN TS_Phase as P
				ON M.F_PhaseID=P.F_PhaseID
			LEFT JOIN TS_Event as E
				ON E.F_EventID=P.F_EventID
			where E.F_EventID=@EventID 
			
			select  
				@SessionID=max(isnull(m.F_SessionID,0))
			from TS_Match as M
			LEFT JOIN TS_Phase as P
				ON M.F_PhaseID=P.F_PhaseID
			LEFT JOIN TS_Event as E
				ON E.F_EventID=P.F_EventID
			where E.F_EventID=@EventID	and (M.F_MatchStatusID>99 or m.F_MatchID =@matchID2)
	end
	
	--if @MatchID>0
	--begin
	--		select  
	--			@SessionID=max(isnull(m.F_SessionID,0))
	--		from TS_Match as M
			
	--end
	
	declare @reporttime2 datetime
	declare @reporttime3 datetime
	select @reporttime2=F_SessionDate,@reporttime3=F_SessionTime from TS_Session where F_SessionID=@SessionID
	
	
	------------------------------------------------------------------------------------------------------
	-- ���� @LanguageCode �����ͬ����
	------------------------------------------------------------------------------------------------------
	IF @LanguageCode = 'ENG'
	BEGIN
		SELECT @Discipline AS [Discipline]
			, @Event AS [Event]
			, @EventUnit AS [EventUnit]
			, @Venue AS [Venue]
			, dbo.[Func_Report_JU_GetDateTime](@Date, 2, @LanguageCode) AS [Weekday]
			, dbo.[Func_Report_JU_GetDateTime](@Date, 1, @LanguageCode) AS [Date]
			, dbo.[Func_Report_JU_GetDateTime](@StartTime, 4, @LanguageCode) AS [StartTime]
			, dbo.[Func_Report_JU_GetDateTime](@EndTime, 4, @LanguageCode) AS [EndTime]
			, dbo.[Func_Report_JU_GetDateTime](GETDATE(), 1, @LanguageCode) AS [AsOfDate]
			, dbo.[Func_Report_JU_GetDateTime](GETDATE(), 3, 'ENG') AS [CreatedTime]
			, CONVERT(DECIMAL(12, 2), 11) AS [X_Portrait]
			, CONVERT(DECIMAL(12, 2), 11) AS [X_Landscape]
			, @MatchCount AS [MatchCount]
			, @CompetitorCount AS [CompetitorCount]
			, @AllEventCount AS [AllEventCount]
			, @FinishedEventCount AS [FinishedEventCount]
			, @RegTypeID AS [RegTypeID]
			, @CourtCode AS [CourtCode] 
	END
	ELSE
	BEGIN
		SELECT @Discipline AS [Discipline]
			, @Event AS [Event]
			, @EventUnit AS [EventUnit]
			, @Venue AS [Venue]
			, case DATEPART(dw, @Date) 
					when 1 then N'������' 
					when 2 then N'����һ'
					when 3 then N'���ڶ�'
					when 4 then N'������'
					when 5 then N'������'
					when 6 then N'������'
					when 7 then N'������'
				end
			AS [Weekday]
			, @CourtCode AS [CourtCode]
			,CONVERT(char(11),GETDATE(),120)+N' '+CONVERT(char(5),GETDATE(),114) AS [PrintTime]
			,CONVERT(char(11),@reporttime2,120)+N' '+CONVERT(char(5),@reporttime3,114) AS [SessionTime]
	END

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_Report_JU_GetGeneralInfo] NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ENG'
EXEC [Proc_Report_JU_GetGeneralInfo] NULL, NULL, NULL, NULL, NULL,  NULL, N'','CHN'
EXEC [Proc_Report_JU_GetGeneralInfo] NULL, 109, NULL, NULL, NULL, NULL, N'C51C',  'CHN'
EXEC [Proc_Report_JU_GetGeneralInfo] NULL, NULL, NULL, 2538, NULL, NULL, N'C73',  'ENG'
EXEC [Proc_Report_JU_GetGeneralInfo] NULL, NULL, NULL, 2538, NULL, NULL, N'C73',  'CHN'

*/