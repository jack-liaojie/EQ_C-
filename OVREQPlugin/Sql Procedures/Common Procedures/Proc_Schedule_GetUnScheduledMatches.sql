IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetUnScheduledMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetUnScheduledMatches]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--��    �ƣ�[Proc_Schedule_GetUnScheduledMatches]
--��    �����õ�һ��Phase����Match�ڵ�����б�����������״̬����Ҫ������Avalible��Scheduled�����ԣ��ؼ��ǲ����ϱ��������ı���
--����˵���� 
--˵    ����
--�� �� �ˣ�֣����
--��    �ڣ�2009��09��08��
--�޸ļ�¼��
/*			
			ʱ��				�޸���		�޸�����	
			2009��11��10��		�����		ȡ��������ʱ���ʹ�úͲ���;
											�ṩ��Proc_GetScheduledMatchesһ���������ʾ���;
			2009��11��11��		�����		�����߼�, �� SessionID, DateTime, VenueID, CourtID, RoundID
											ȫΪ NULL ��ʱ��, ���迼��; ����һ����Чʱ, ��������Щ��������
			2009��11��12��		�����		�޸� Session ����д SessionTime, Session ����ʾ�� BUG	
											�޸Ĵ洢��������, Proc_GetUnScheduledMatchesByCondition->Proc_Schedule_GetUnScheduledMatches
			2009��11��13��		�����		��Ӷ� MatchStatusID ��ɸѡ
			2009��11��16��		�����		����ֶ� F_RaceNum ����ʾ 
			2009��11��23��		�����		��ʾ Competitors, Result
			2010��2��5��		�����		����ֶ� [EndTime].
			2010��6��21��		�����		��Ӳ��� @IsCheckedStatus, 0 - ��ʾ����ѡ״̬�����ı���; 1 - ��ʾС����ѡ״̬�ı���.
			2010��6��22��		�����		�ı���� @IsCheckedStatus ����, 0 - ��ʾС����ѡ״̬�ı���; 1 - ��ʾ����ѡ״̬�����ı���.
			2010��6��29��		�����		�� [Time] �ֶ� ��Ϊ StartTime.
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_GetUnScheduledMatches](
				 @TypeID			INT,	--ɸѡ��Ӧ���͵�ID����Type���
				 @Type				INT,	--ע��: -3 ��ʾ Sport��-2��ʾ Discipline��-1��ʾEvent��0��ʾPhase, 1��ʾMatch
                 @LanguageCode		char(3),
				 @SessionID			INT,
				 @DateTime			NVARCHAR(50),
				 @VenueID			INT,
				 @CourtID			INT,
				 @RoundID			INT,
				 @StatusID			INT,
				 @IsCheckedStatus	INT = 1	-- 0 - ��ʾС����ѡ״̬�ı���; 1 - ��ʾ����ѡ״̬�����ı���.
)
As
Begin
SET NOCOUNT ON 

	DECLARE @SQL AS NVARCHAR(4000)
	DECLARE @ConditionSQL AS NVARCHAR(1000)

	-- ������Ϣ
	SET @SQL = 'SELECT D.F_EventLongName AS [Event]
			, A.F_RaceNum AS [R.Num]
			, A.F_MatchNum AS [M.Num]
			, A.F_MatchCode AS [M.Code]
			, LTRIM(RTRIM(C.F_PhaseLongName)) + '' '' + E.F_MatchLongName AS [M.Name]
			, LEFT(CONVERT(NVARCHAR(30), A.F_MatchDate, 120), 10) AS [Date]
			, (
				''S.'' + CONVERT(NVARCHAR(10), F_SessionNumber) + '' '' 
				+	CASE
						WHEN G.F_SessionTime IS NULL THEN ''''
						ELSE LEFT(CONVERT(NVARCHAR(30), G.F_SessionTime, 108), 5)
					END
			) AS [Session]
			, LEFT(CONVERT(NVARCHAR(30), A.F_StartTime, 108), 5) AS [StartTime]
			, LEFT(CONVERT(NVARCHAR(30), A.F_EndTime, 108), 5) AS [EndTime]
			, F.F_RoundLongName AS [Round]
			, H.F_VenueLongName AS [Venue]
			, I.F_CourtLongName AS [Court]
			, K.F_StatusLongName AS [Status]
			, A.F_OrderInSession AS [O.I.S]
			, A.F_OrderInRound AS [O.I.R]
			, [dbo].Fun_GetMatchCompetitors(A.F_MatchID, ''' + @LanguageCode + ''') AS Competitors
			, [dbo].Fun_GetMatchSummaryResult(A.F_MatchID, ''' + @LanguageCode + ''') AS Result
			, B.F_EventID 
			, A.F_RoundID
			, A.F_SessionID
			, A.F_MatchID
			, A.F_VenueID
			, A.F_CourtID
			, A.F_MatchStatusID
		FROM TS_Match AS A
		LEFT JOIN TS_Phase AS B
			ON A.F_PhaseID = B.F_PhaseID
		LEFT JOIN TS_Phase_Des AS C
			ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Event_Des AS D
			ON B.F_EventID = D.F_EventID AND D.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Match_Des AS E
			ON A.F_MatchID = E.F_MatchID AND E.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Round_Des AS F
			ON A.F_RoundID = F.F_RoundID AND F.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Session AS G
			ON A.F_SessionID = G.F_SessionID
		LEFT JOIN TC_Venue_Des AS H
			ON A.F_VenueID = H.F_VenueID AND H.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TC_Court_Des AS I
			ON A.F_CourtID = I.F_CourtID AND I.F_LanguageCode = ''' + @LanguageCode + '''
		LEFT JOIN TS_Event AS J
			ON B.F_EventID = J.F_EventID
		LEFT JOIN TC_Status_Des AS K
			ON A.F_MatchStatusID = K.F_StatusID AND K.F_LanguageCode = ''' + @LanguageCode + '''
		WHERE 1 = 1
	'

	-- TypeID Ϊ SportID, ��ʱ������
	IF @Type = -3
	BEGIN
		SET @SQL = @SQL + ' AND 1 <> 1 '
	END

	-- TypeID Ϊ DisciplineID
	ELSE IF @Type = -2
	BEGIN 
		SET @SQL = @SQL + ' AND J.F_DisciplineID = ' + CAST(@TypeID AS NVARCHAR(10)) 
	END

	-- TypeID Ϊ EventID
	ELSE IF @Type = -1
	BEGIN 
		SET @SQL = @SQL + ' AND B.F_EventID = ' + CAST(@TypeID AS NVARCHAR(10)) 
	END

	-- TypeID Ϊ PhaseID
	ELSE IF @Type = 0
	BEGIN 

		-- ������ʱ��, �洢���ڸ� Phase (PhaseID Ϊ @TypeID) �Լ����� Phase
		CREATE TABLE #PhaseTable (
			F_PhaseID           INT,
			F_NodeLevel			INT
		)
		
		-- �ڵ����, @TypeID �� �ڵ����Ϊ 0, �� Phase �Ľڵ����Ϊ 1, ��������
		DECLARE @NodeLevel INT
		SET @NodeLevel = 0			

		-- ����� Phase (PhaseID Ϊ @TypeID)
		INSERT #PhaseTable
			(F_PhaseID, F_NodeLevel) 
		VALUES
			(@TypeID, @NodeLevel)
		
		-- ʹ�õݹ��������� Phase �ڵ�
		WHILE EXISTS ( SELECT A.F_PhaseID 
			FROM TS_Phase AS A
			LEFT JOIN #PhaseTable AS B
				ON A.F_FatherPhaseID = B.F_PhaseID
			WHERE B.F_NodeLevel = @NodeLevel )
		BEGIN
			INSERT #PhaseTable
				(F_PhaseID, F_NodeLevel)
				(
					SELECT A.F_PhaseID, @NodeLevel + 1
					FROM TS_Phase AS A
					LEFT JOIN #PhaseTable AS B
						ON A.F_FatherPhaseID = B.F_PhaseID
					WHERE B.F_NodeLevel = @NodeLevel
				)
			-- �ڵ���� + 1
			SET @NodeLevel = @NodeLevel + 1
		END

		-- ɸѡ����е� PhaseID ������ #PhaseTable �в���
		SET @SQL = @SQL + ' AND A.F_PhaseID IN (SELECT F_PhaseID FROM #PhaseTable) '

	END

	-- TypeID Ϊ MatchID
	ELSE IF @Type = 1
	BEGIN 
		SET @SQL = @SQL + ' AND A.F_MatchID = ' + CAST(@TypeID AS NVARCHAR(10)) 
	END


	-- �� @IsCheckedStatus = 1 ʱ, ��ʾ����ѡ״̬�����������ı���
	IF @IsCheckedStatus = 1
	BEGIN
		-- ��Ӳ����ϱ�������������ɸѡ
		SET @ConditionSQL = ' 1 = 1 '
		IF ((@SessionID IS NOT NULL) AND (@SessionID <> 0))
		BEGIN
			SET @ConditionSQL = @ConditionSQL + ' AND A.F_SessionID IS NOT NULL
				AND A.F_SessionID = ' + CAST(@SessionID AS NVARCHAR(10))
		END

		IF ((@DateTime IS NOT NULL) AND (@DateTime <> ''))
		BEGIN
			SET @ConditionSQL = @ConditionSQL 
				+ ' AND A.F_MatchDate IS NOT NULL 
				AND LEFT(CONVERT (NVARCHAR(100), A.F_MatchDate, 120), 10) = LTRIM(RTRIM(''' + @DateTime + '''))'  
		END

		IF ((@VenueID IS NOT NULL) AND (@VenueID <> 0))
		BEGIN
			SET @ConditionSQL = @ConditionSQL + ' AND A.F_VenueID IS NOT NULL  
				AND A.F_VenueID = ' + CAST(@VenueID AS NVARCHAR(10))
		END

		IF ((@CourtID IS NOT NULL) AND (@CourtID <> 0))
		BEGIN
			SET @ConditionSQL = @ConditionSQL + ' AND A.F_CourtID IS NOT NULL 
				AND A.F_CourtID = ' + CAST(@CourtID AS NVARCHAR(10))
		END

		IF ((@RoundID IS NOT NULL) AND (@RoundID <> 0))
		BEGIN
			SET @ConditionSQL = @ConditionSQL + ' AND A.F_RoundID IS NOT NULL 
				AND A.F_RoundID = ' + CAST(@RoundID AS NVARCHAR(10))
		END

		IF ((@StatusID IS NOT NULL) AND (@StatusID <> 0))
		BEGIN
			SET @ConditionSQL = @ConditionSQL + ' AND A.F_MatchStatusID IS NOT NULL 
				AND A.F_MatchStatusID = ' + CAST(@StatusID AS NVARCHAR(10))
		END

		-- SessionID, DateTime, VenueID, CourtID, RoundID ��һ����Ч
		IF @ConditionSQL <> ' 1 = 1 '
		BEGIN
			SET @SQL = @SQL + ' AND NOT ( ' + @ConditionSQL + ' ) '
		END
	END
	
	-- �� @IsCheckedStatus = 1 ʱ,  ��ʾС����ѡ״̬�ı���.
	ELSE IF ((@StatusID IS NOT NULL) AND (@StatusID <> 0))
	BEGIN
		SET @SQL = @SQL + ' AND A.F_MatchStatusID < ' + CAST(@StatusID AS NVARCHAR(10))
	END

	-- �趨�����ֶ�
	SET @SQL = @SQL + ' ORDER BY J.F_ORDER, A.F_MatchNum '

	EXEC (@SQL)
	
Set NOCOUNT OFF
End	
GO

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF
GO

/*

DECLARE @TypeID				INT
DECLARE @Type				INT
DECLARE @LanguageCode		char(3)
DECLARE @SessionID			INT
DECLARE @DateTime			NVARCHAR(50)
DECLARE @VenueID			INT
DECLARE @CourtID			INT
DECLARE @RoundID			INT
DECLARE @StatusID			INT

SET @TypeID = 46
SET @Type = -2				--ע��: -3 ��ʾ Sport��-2��ʾ Discipline��-1��ʾEvent��0��ʾPhase, 1��ʾMatch
SET @LanguageCode = 'ENG'
SET @SessionID = NULL
SET @DateTime = NULL
SET @VenueID = NULL
SET @CourtID = NULL
SET @RoundID = NULL
SET @StatusID = NULL

EXEC [Proc_Schedule_GetUnScheduledMatches] @TypeID, @Type, @LanguageCode
	, @SessionID, @DateTime, @VenueID, @CourtID, @RoundID, @StatusID

*/

