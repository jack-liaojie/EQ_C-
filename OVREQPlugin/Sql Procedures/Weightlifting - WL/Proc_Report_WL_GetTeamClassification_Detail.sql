IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetTeamClassification_Detail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Detail]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_Report_WL_GetTeamClassification_Detail]
--描    述: 获取 C76 - Unofficial Team Classification 的 NOC 的每个 Event 积分情况, 分性别.
--创 建 人: 邓年彩
--日    期: 2011年3月26日 星期六
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_Report_WL_GetTeamClassification_Detail]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3) = 'ENG'
AS
BEGIN
SET NOCOUNT ON

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
	
	SELECT F_SexCode, F_EventID, F_DelegationID
		, Points, Participants
		, CASE WHEN Participants <> 0 THEN ISNULL(CONVERT(NVARCHAR(10),  Points), N'') + N'/' 
			+ CONVERT(NVARCHAR(10),  Participants) END AS [Des]
	FROM
	(
		SELECT E.F_SexCode, E.F_EventID, X.F_DelegationID
			, E.F_EventCode
			, (
				SELECT SUM(RP.Points)
				FROM TS_Event_Result AS ER
				INNER JOIN TR_Register AS R
					ON ER.F_RegisterID = R.F_RegisterID
				LEFT JOIN #RankPoints AS RP
					ON ER.F_EventRank = RP.[Rank]
				WHERE E.F_EventID = ER.F_EventID 
					AND R.F_DelegationID = X.F_DelegationID
			) AS Points
			, ( 
				SELECT COUNT(I.F_RegisterID)
				FROM TR_Inscription AS I
				INNER JOIN TR_Register AS R
					ON I.F_RegisterID = R.F_RegisterID
				WHERE E.F_EventID = I.F_EventID 
					AND R.F_DelegationID = X.F_DelegationID
			) AS Participants
		FROM TS_Event AS E
		INNER JOIN
		(
			SELECT E.F_SexCode
				, R.F_DelegationID
			FROM TR_Inscription AS I
			INNER JOIN TR_Register AS R
				ON I.F_RegisterID = R.F_RegisterID
			INNER JOIN TS_Event AS E
				ON I.F_EventID = E.F_EventID
			WHERE E.F_DisciplineID = @DisciplineID
			GROUP BY E.F_SexCode, R.F_DelegationID
		) AS X
			ON E.F_SexCode = X.F_SexCode
		WHERE E.F_DisciplineID = @DisciplineID
		GROUP BY E.F_SexCode, E.F_EventID, E.F_EventCode, X.F_DelegationID
	) AS X
	ORDER BY F_SexCode, F_EventCode

SET NOCOUNT OFF
END
GO

/*

-- Just for test
EXEC [Proc_Report_WL_GetTeamClassification_Detail] -1

*/