IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTeamClassification_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Team]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WL_GetTeamClassification_Team]
--描    述: 获取 C76 - Unofficial Team Classification 的 NOC 信息, 分性别.
--创 建 人: 邓年彩
--日    期: 2011年3月26日 星期六
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Team]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON	

	DECLARE @RankCount				INT
	DECLARE @Rank					INT
	DECLARE @SQL					NVARCHAR(MAX)
	DECLARE @RankField				NVARCHAR(20)

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline WHERE F_Active = 1
	END

	CREATE TABLE #RankPoints
	(
		[Rank]						INT,
		Points						INT
	)
	
	-- 在世界和洲际锦标赛及根据国际举联规则进行的比赛，各代表队的排名以下列标准将每名运动员的得分相加得出
	INSERT #RankPoints VALUES (1, 28)
	INSERT #RankPoints VALUES (2, 25)
	INSERT #RankPoints VALUES (3, 23)
	INSERT #RankPoints VALUES (4, 22)
	INSERT #RankPoints VALUES (5, 21)
	INSERT #RankPoints VALUES (6, 20)
	INSERT #RankPoints VALUES (7, 19)
	INSERT #RankPoints VALUES (8, 18)
	INSERT #RankPoints VALUES (9, 17)
	INSERT #RankPoints VALUES (10, 16)
	INSERT #RankPoints VALUES (11, 15)
	INSERT #RankPoints VALUES (12, 14)
	INSERT #RankPoints VALUES (13, 13)
	INSERT #RankPoints VALUES (14, 12)
	INSERT #RankPoints VALUES (15, 11)
	INSERT #RankPoints VALUES (16, 10)
	INSERT #RankPoints VALUES (17, 9)
	INSERT #RankPoints VALUES (18, 8)
	INSERT #RankPoints VALUES (19, 7)
	INSERT #RankPoints VALUES (20, 6)
	INSERT #RankPoints VALUES (21, 5)
	INSERT #RankPoints VALUES (22, 4)
	INSERT #RankPoints VALUES (23, 3)
	INSERT #RankPoints VALUES (24, 2)
	INSERT #RankPoints VALUES (25, 1)
	
	SELECT @RankCount = COUNT(*) FROM #RankPoints
	
	CREATE TABLE #Team
	(
		[Rank]						INT,
		F_SexCode						INT,
		F_DelegationID				INT,
		NOC							NVARCHAR(50),
		TotalPoints					INT,
		TotalParticipants			INT,
		Total_Des					NVARCHAR(50)
	)
	
	INSERT #Team (F_SexCode, F_DelegationID, NOC, TotalParticipants)
	SELECT E.F_SexCode
		, D.F_DelegationID
		, D.F_DelegationCode AS NOC
		, COUNT(I.F_RegisterID) AS TotalParticipants
	FROM TR_Inscription AS I
	INNER JOIN TR_Register AS R
		ON I.F_RegisterID = R.F_RegisterID
	INNER JOIN TC_Delegation AS D
		ON R.F_DelegationID = D.F_DelegationID
	INNER JOIN TS_Event AS E
		ON I.F_EventID = E.F_EventID
	WHERE E.F_DisciplineID = @DisciplineID
	GROUP BY E.F_SexCode, D.F_DelegationID, D.F_DelegationCode
	
	SET @Rank = 1
	WHILE @Rank <= @RankCount
	BEGIN
		-- 每一个名次添加一列
		SET @RankField = N'R_' + CONVERT(NVARCHAR(10), @Rank)
		SET @SQL = N'ALTER TABLE #Team ADD ' + @RankField + N' INT'
		EXEC (@SQL)
		
		-- 计算各个 NOC, 各个名次的积分, 并累计总分
		SET @SQL = N'
			UPDATE T SET ' + @RankField + N' = X.RankPoints
				, TotalPoints = ISNULL(TotalPoints, 0) + X.RankPoints
			FROM #Team AS T
			INNER JOIN
			(
				SELECT E.F_SexCode
					, D.F_DelegationID
					, SUM(RP.Points) AS RankPoints
				FROM TS_Event_Result AS ER
				INNER JOIN TR_Register AS R
					ON ER.F_RegisterID = R.F_RegisterID
				INNER JOIN TC_Delegation AS D
					ON R.F_DelegationID = D.F_DelegationID
				INNER JOIN TS_Event AS E
					ON ER.F_EventID = E.F_EventID
				INNER JOIN #RankPoints AS RP
					ON RP.[Rank] = ' + CONVERT(NVARCHAR(10), @Rank) + '
				WHERE E.F_DisciplineID = ' + CONVERT(NVARCHAR(10), @DisciplineID) + '
					AND ER.F_EventRank = ' + CONVERT(NVARCHAR(10), @Rank) + '
				GROUP BY E.F_SexCode, D.F_DelegationID, RP.Points
			) AS X
				ON T.F_SexCode = X.F_SexCode AND T.F_DelegationID = X.F_DelegationID
		'
		EXEC (@SQL)
		
		SET @Rank = @Rank + 1
	END
	
	SET @SQL = '
		UPDATE T SET [Rank] = X.Rank
		FROM #Team AS T
		INNER JOIN
		(
			SELECT F_SexCode, F_DelegationID
				, RANK() OVER (PARTITION BY F_SexCode ORDER BY ISNULL(TotalPoints, 0) DESC
	'
	
	-- 团体排名时若分数相同，名次在前数量多的队排名在前。		
	SET @Rank = 1
	WHILE @Rank <= @RankCount
	BEGIN
		SET @RankField = N'R_' + CONVERT(NVARCHAR(10), @Rank)
		SET @SQL = @SQL + ', ' + @RankField + ' DESC'
		
		SET @Rank = @Rank + 1
	END
			
	SET @SQL = @SQL + '
				) AS [Rank]
			FROM #Team
			WHERE ISNULL(TotalPoints, 0) <> 0
		) AS X
			ON T.F_SexCode = X.F_SexCode AND T.F_DelegationID = X.F_DelegationID
	'
	
	EXEC (@SQL)
	
	SELECT [Rank]
		, F_SexCode
		, F_DelegationID
		, NOC
		, TotalPoints
		, TotalParticipants
		, ISNULL(CONVERT(NVARCHAR(10),  TotalPoints), N'') + N'/' + CONVERT(NVARCHAR(10),  TotalParticipants) Total_Des
	FROM #Team
	ORDER BY F_SexCode, CASE WHEN [RANK] IS NULL THEN 1 ELSE 0 END, [Rank], NOC

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetTeamClassification_Team] -1

*/