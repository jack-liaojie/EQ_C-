IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Schedule_GetUnScheduledMatches]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Schedule_GetUnScheduledMatches]
GO


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称：[Proc_Schedule_GetUnScheduledMatches]
--描    述：得到一个Phase或者Match节点的所有比赛，比赛的状态不重要，可能Avalible，Scheduled都可以，关键是不符合编排条件的比赛
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年09月08日
--修改记录：
/*			
			时间				修改人		修改内容	
			2009年11月10日		邓年彩		取消大量临时表的使用和操作;
											提供和Proc_GetScheduledMatches一样的输出显示结果;
			2009年11月11日		邓年彩		调整逻辑, 当 SessionID, DateTime, VenueID, CourtID, RoundID
											全为 NULL 的时候, 不予考虑; 当有一个有效时, 不满足这些条件的与
			2009年11月12日		邓年彩		修改 Session 不填写 SessionTime, Session 不显示的 BUG	
											修改存储过程名称, Proc_GetUnScheduledMatchesByCondition->Proc_Schedule_GetUnScheduledMatches
			2009年11月13日		邓年彩		添加对 MatchStatusID 的筛选
			2009年11月16日		邓年彩		添加字段 F_RaceNum 的显示 
			2009年11月23日		邓年彩		显示 Competitors, Result
			2010年2月5日		邓年彩		添加字段 [EndTime].
			2010年6月21日		邓年彩		添加参数 @IsCheckedStatus, 0 - 显示与所选状态不符的比赛; 1 - 显示小于所选状态的比赛.
			2010年6月22日		邓年彩		改变参数 @IsCheckedStatus 含义, 0 - 显示小于所选状态的比赛; 1 - 显示与所选状态不符的比赛.
			2010年6月29日		邓年彩		将 [Time] 字段 改为 StartTime.
*/

CREATE PROCEDURE [dbo].[Proc_Schedule_GetUnScheduledMatches](
				 @TypeID			INT,	--筛选对应类型的ID，与Type相关
				 @Type				INT,	--注释: -3 表示 Sport，-2表示 Discipline，-1表示Event，0表示Phase, 1表示Match
                 @LanguageCode		char(3),
				 @SessionID			INT,
				 @DateTime			NVARCHAR(50),
				 @VenueID			INT,
				 @CourtID			INT,
				 @RoundID			INT,
				 @StatusID			INT,
				 @IsCheckedStatus	INT = 1	-- 0 - 显示小于所选状态的比赛; 1 - 显示与所选状态不符的比赛.
)
As
Begin
SET NOCOUNT ON 

	DECLARE @SQL AS NVARCHAR(4000)
	DECLARE @ConditionSQL AS NVARCHAR(1000)

	-- 基本信息
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

	-- TypeID 为 SportID, 暂时不考虑
	IF @Type = -3
	BEGIN
		SET @SQL = @SQL + ' AND 1 <> 1 '
	END

	-- TypeID 为 DisciplineID
	ELSE IF @Type = -2
	BEGIN 
		SET @SQL = @SQL + ' AND J.F_DisciplineID = ' + CAST(@TypeID AS NVARCHAR(10)) 
	END

	-- TypeID 为 EventID
	ELSE IF @Type = -1
	BEGIN 
		SET @SQL = @SQL + ' AND B.F_EventID = ' + CAST(@TypeID AS NVARCHAR(10)) 
	END

	-- TypeID 为 PhaseID
	ELSE IF @Type = 0
	BEGIN 

		-- 创建临时表, 存储对于该 Phase (PhaseID 为 @TypeID) 以及子孙 Phase
		CREATE TABLE #PhaseTable (
			F_PhaseID           INT,
			F_NodeLevel			INT
		)
		
		-- 节点深度, @TypeID 的 节点深度为 0, 子 Phase 的节点深度为 1, 依次类推
		DECLARE @NodeLevel INT
		SET @NodeLevel = 0			

		-- 插入该 Phase (PhaseID 为 @TypeID)
		INSERT #PhaseTable
			(F_PhaseID, F_NodeLevel) 
		VALUES
			(@TypeID, @NodeLevel)
		
		-- 使用递归插入该子孙 Phase 节点
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
			-- 节点深度 + 1
			SET @NodeLevel = @NodeLevel + 1
		END

		-- 筛选结果中的 PhaseID 条件在 #PhaseTable 中查找
		SET @SQL = @SQL + ' AND A.F_PhaseID IN (SELECT F_PhaseID FROM #PhaseTable) '

	END

	-- TypeID 为 MatchID
	ELSE IF @Type = 1
	BEGIN 
		SET @SQL = @SQL + ' AND A.F_MatchID = ' + CAST(@TypeID AS NVARCHAR(10)) 
	END


	-- 当 @IsCheckedStatus = 1 时, 显示与所选状态及条件不符的比赛
	IF @IsCheckedStatus = 1
	BEGIN
		-- 添加不符合比赛安排条件的筛选
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

		-- SessionID, DateTime, VenueID, CourtID, RoundID 有一个有效
		IF @ConditionSQL <> ' 1 = 1 '
		BEGIN
			SET @SQL = @SQL + ' AND NOT ( ' + @ConditionSQL + ' ) '
		END
	END
	
	-- 当 @IsCheckedStatus = 1 时,  显示小于所选状态的比赛.
	ELSE IF ((@StatusID IS NOT NULL) AND (@StatusID <> 0))
	BEGIN
		SET @SQL = @SQL + ' AND A.F_MatchStatusID < ' + CAST(@StatusID AS NVARCHAR(10))
	END

	-- 设定排序字段
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
SET @Type = -2				--注释: -3 表示 Sport，-2表示 Discipline，-1表示Event，0表示Phase, 1表示Match
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

