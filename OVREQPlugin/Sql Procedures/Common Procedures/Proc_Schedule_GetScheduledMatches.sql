IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetScheduledMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetScheduledMatches]
GO

/****** ����:  StoredProcedure [dbo].[Proc_Schedule_GetScheduledMatches]    �ű�����: 11/09/2009 14:26:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--��    �ƣ�[Proc_Schedule_GetScheduledMatches]
--��    ��������������ɸѡ���������ı���, ���� Schedule ģ��, 
--�� �� �ˣ�֣����
--��    �ڣ�2009��05��11��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����
			2009��11��09��		�����		ȡ����ʱ���ʹ��, ��� Session, Venue, Court, Round �ȵ�������Ϣ
			2009��11��12��		�����		�޸� Session ����д SessionTime, Session ����ʾ�� BUG	
											�޸Ĵ洢��������, Proc_GetScheduledMatches->Proc_Schedule_GetScheduledMatches
			2009��11��13��		�����		��Ӷ� MatchStatusID ��ɸѡ		
			2009��11��16��		�����		����ֶ� F_RaceNum ����ʾ 
			2009��11��23��		�����		��ʾ Competitors, Result
			2009��12��11��		�����		��Ӳ��� @Type, ��Ϊ -3 ʱ, ����ʾ�κμ�¼
			2010��2��5��		�����		����ֶ� [EndTime].
			2010��6��21��		�����		��Ӳ��� @IsCheckedStatus, 0 - ��ʾ����ѡ״̬����ı���; 1 - ��ʾ��С����ѡ״̬�ı���.
			2010��6��22��		�����		�ı���� @IsCheckedStatus ����: 0 - ��ʾ��С����ѡ״̬�ı���, 1 - ��ʾ����ѡ״̬����ı���;
											ɾ������ @TypMD.
			2010��6��29��		�����		�� [Time] �ֶ� ��Ϊ StartTime.
			2011��3��18��		�����      Court��Nameȡ����
			2011��4��25��		�����		��� PhaseID ɸѡ; ȡ����� SQL, ʹ�������жϼ� SQL.
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_GetScheduledMatches](
				 @DisciplineID		INT,
				 @EventID			INT,
				 @PhaseID			INT = NULL,
                 @LanguageCode		CHAR(3),
				 @SessionID			INT,
				 @DateTime			NVARCHAR(50),
				 @VenueID			INT,
				 @CourtID			INT,
				 @RoundID			INT,
				 @StatusID			INT,
				 @IsCheckedStatus	INT = 1		--ע��: 0 - ��ʾ��С����ѡ״̬�ı���; 1 - ��ʾ����ѡ״̬����ı���.
)
As
Begin
SET NOCOUNT ON 

	SELECT ED.F_EventLongName AS [Event]
		, M.F_RaceNum AS [R.Num]
		, M.F_MatchNum AS [M.Num]
		, M.F_MatchCode AS [M.Code]
		, LTRIM(RTRIM(PD.F_PhaseLongName)) + ' ' + MD.F_MatchLongName AS [M.Name]
		, LEFT(CONVERT(NVARCHAR(30), M.F_MatchDate, 120), 10) AS [Date]
		, (
			'S.' + CONVERT(NVARCHAR(10), F_SessionNumber) + ' ' 
			+	CASE
					WHEN S.F_SessionTime IS NULL THEN ''
					ELSE LEFT(CONVERT(NVARCHAR(30), S.F_SessionTime, 108), 5)
				END
		) AS [Session]
		, LEFT(CONVERT(NVARCHAR(30), M.F_StartTime, 108), 5) AS [StartTime]
		, LEFT(CONVERT(NVARCHAR(30), M.F_EndTime, 108), 5) AS [EndTime]
		, RD.F_RoundLongName AS [Round]
		, VD.F_VenueLongName AS [Venue]
		, CD.F_CourtShortName AS [Court]
		, SD.F_StatusLongName AS [Status]
		, M.F_OrderInSession AS [O.I.S]
		, M.F_OrderInRound AS [O.I.R]
		, [dbo].Fun_GetMatchCompetitors(M.F_MatchID, @LanguageCode) AS Competitors
		, [dbo].Fun_GetMatchSummaryResult(M.F_MatchID, @LanguageCode) AS Result
		, P.F_EventID
		, M.F_RoundID
		, M.F_SessionID
		, M.F_MatchID
		, M.F_VenueID
		, M.F_CourtID
		, M.F_MatchStatusID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON M.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Event AS E
		ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED
		ON P.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Match_Des AS MD
		ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Round_Des AS RD
		ON M.F_RoundID = RD.F_RoundID AND RD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Session AS S
		ON M.F_SessionID = S.F_SessionID
	LEFT JOIN TC_Venue_Des AS VD
		ON M.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Court_Des AS CD
		ON M.F_CourtID = CD.F_CourtID AND CD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Status_Des AS SD
		ON M.F_MatchStatusID = SD.F_StatusID AND SD.F_LanguageCode = @LanguageCode
	WHERE E.F_DisciplineID = @DisciplineID
		AND (@SessionID IS NULL OR @SessionID <= 0 OR M.F_SessionID = @SessionID)
		AND (@DateTime IS NULL OR @DateTime = '' OR LEFT(CONVERT(NVARCHAR(100), M.F_MatchDate, 120), 10) = LTRIM(RTRIM(@DateTime)))
		AND (@VenueID IS NULL OR @VenueID <= 0 OR M.F_VenueID = @VenueID)
		AND (@CourtID IS NULL OR @CourtID <= 0 OR M.F_CourtID = @CourtID)
		-- RoundID ��Чʱ, ���� EventID
		AND (((@RoundID IS NULL OR @RoundID <=0) AND (@EventID IS NULL OR @EventID <=0 OR P.F_EventID = @EventID))
			OR (M.F_RoundID = @RoundID))
		AND (@PhaseID IS NULL OR @PhaseID <= 0 OR M.F_PhaseID = @PhaseID)
		AND (@StatusID IS NULL OR @StatusID <= 0 
			OR (@IsCheckedStatus = 1 AND M.F_MatchStatusID = @StatusID)
			OR (@IsCheckedStatus = 0 AND M.F_MatchStatusID >= @StatusID))
	ORDER BY E.F_ORDER, M.F_MatchNum

Set NOCOUNT OFF
End	
GO

/*

exec [Proc_Schedule_GetScheduledMatches] 46, NULL, NULL, 'ENG', NULL, NULL, NULL, NULL, NULL, NULL
exec [Proc_Schedule_GetScheduledMatches] 1, NULL, NULL, 'CHN', NULL, '2009-09-25', NULL, NULL, NULL, NULL

*/