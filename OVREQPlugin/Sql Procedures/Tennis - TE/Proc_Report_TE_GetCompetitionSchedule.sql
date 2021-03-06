IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_TE_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_TE_GetCompetitionSchedule]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_Report_TE_GetCompetitionSchedule]
--描    述: 网球项目报表获取 C08 - Competition Schedule 的详细内容.
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2010年10月12日




CREATE PROCEDURE [dbo].[Proc_Report_TE_GetCompetitionSchedule]
	@DisciplineID					INT,
	@LanguageCode					CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	IF @DisciplineID = -1
	BEGIN
		SELECT @DisciplineID = D.F_DisciplineID
		FROM TS_Discipline AS D
		WHERE D.F_Active = 1
	END

	CREATE TABLE #Temp_Schedules(F_MatchDate				DATETIME,
								 F_EventID					INT,
								 F_PhaseID					INT,
								 F_DaySessionStartTime		DATETIME,
								 F_NightSessionStartTime	DATETIME,
								 F_MatchCount               INT,
								 F_OrderInSession           INT,
								 F_EventCode                NVARCHAR(10),
								 F_PhaseCode                NVARCHAR(10)
								 )
	INSERT INTO #Temp_Schedules (F_MatchDate, F_EventID, F_PhaseID, F_EventCode, F_PhaseCode)
	SELECT DISTINCT A.F_MatchDate, C.F_EventID, B.F_PhaseID, C.F_EventCode, B.F_PhaseCode
	    FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
		LEFT JOIN TS_Event AS C ON B.F_EventID = C.F_EventID 
		WHERE C.F_DisciplineID = @DisciplineID AND A.F_MatchDate IS NOT NULL AND C.F_PlayerRegTypeID <> 3
		ORDER BY A.F_MatchDate
	
	UPDATE #Temp_Schedules SET F_OrderInSession = CASE F_EventCode WHEN '001' THEN 1 WHEN '002' THEN 2 WHEN '101' THEN 4 WHEN '102' THEN 5 WHEN '201' THEN 7 ELSE 8 END
    UPDATE #Temp_Schedules SET F_OrderInSession = 3 WHERE F_EventCode = '001' AND F_PhaseCode IN ('A', 'B','C','D','E')
    UPDATE #Temp_Schedules SET F_OrderInSession = 6 WHERE F_EventCode = '101' AND F_PhaseCode IN ('A', 'B','C','D','E')

	
	UPDATE A SET  A.F_DaySessionStartTime = B.F_SessionTime FROM #Temp_Schedules AS A LEFT JOIN TS_Session AS B ON A.F_MatchDate =B.F_SessionDate WHERE B.F_DisciplineID = @DisciplineID AND B.F_SessionTypeID IN (1, 2, 3)
	UPDATE A SET A.F_NightSessionStartTime = B.F_SessionTime FROM #Temp_Schedules AS A LEFT JOIN TS_Session AS B ON A.F_MatchDate =B.F_SessionDate WHERE B.F_DisciplineID = @DisciplineID AND B.F_SessionTypeID = 4 
	
	--UPDATE A SET A.F_MatchCount = B.F_MatchCount
	--     FROM #Temp_Schedules AS A 
	--      LEFT JOIN ( SELECT Count(X.F_MatchID) AS F_MatchCount, X.F_MatchDate, Z.F_EventID, Y.F_PhaseID  
	--                    FROM TS_Match AS X 
	--                        LEFT JOIN TS_Phase AS Y ON X.F_PhaseID = Y.F_PhaseID 
	--                        LEFT JOIN TS_Event AS Z ON Y.F_EventID = Z.F_EventID
	--                           WHERE X.F_MatchID NOT IN (SELECT F_MatchID FROM TS_Match_Result WHERE F_RegisterID = -1)
	--                            GROUP BY X.F_MatchDate, Y.F_PhaseID, Z.F_EventID ) AS B ON A.F_MatchDate = B.F_MatchDate AND A.F_EventID = B.F_EventID AND A.F_PhaseID = B.F_PhaseID
	
	SELECT A.*
			, dbo.[Func_Report_TE_GetDateTime](A.F_MatchDate, 2, 'CHN') AS [Date_Show] 
			, B.F_EventLongName
			, C.F_PhaseLongName
			, LEFT(CAST(CAST(A.F_DaySessionStartTime AS TIME(0)) AS NVARCHAR(10)), 5) AS DaySessionStartTime
			, LEFT(CAST(CAST(A.F_NightSessionStartTime AS TIME(0)) AS NVARCHAR(10)), 5) AS NightSessionStartTime
		FROM #Temp_Schedules AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase_Des AS C ON A.F_PhaseID = C.F_PhaseID AND C.F_LanguageCode = @LanguageCode
	    ORDER BY A.F_MatchDate, A.F_OrderInSession
		
SET NOCOUNT OFF
END





