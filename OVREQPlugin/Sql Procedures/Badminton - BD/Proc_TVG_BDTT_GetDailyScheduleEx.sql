IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TVG_BDTT_GetDailyScheduleEx]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TVG_BDTT_GetDailyScheduleEx]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_TVG_BDTT_GetDailyScheduleEx]
----功		  能：获取BD SCB需要的当日比赛安排
----作		  者：王强
----日		  期: 2011-08-13

CREATE PROCEDURE [dbo].[Proc_TVG_BDTT_GetDailyScheduleEx]
		@SessionID     INT,
		@CourtID    INT
AS
BEGIN
	
SET NOCOUNT ON

	/*CREATE TABLE #TMP_TABLE
	(
		PhaseID INT,
		EventName_ENG NVARCHAR(30),
		EventName_CHN NVARCHAR(30),
		PhaseName_ENG NVARCHAR(30),
		PhaseName_CHN NVARCHAR(30),
		StartTime NVARCHAR(30)
	)
	
	INSERT INTO #TMP_TABLE (PhaseID, EventName_ENG, PhaseName_ENG )
	(
		SELECT Z.F_PhaseID, X.F_EventShortName, Y.F_PhaseShortName FROM TS_Event_Des AS X
		LEFT JOIN TS_Phase AS Z ON Z.F_EventID = X.F_EventID
		LEFT JOIN TS_Phase_Des AS Y ON Y.F_PhaseID = Z.F_PhaseID
		WHERE X.F_LanguageCode = 'ENG' AND Y.F_LanguageCode = 'ENG' AND Z.F_PhaseID IN
		(SELECT DISTINCT(F_PhaseID) FROM TS_Match WHERE F_SessionID IN
		(SELECT A.F_SessionID FROM TS_Session AS A
		LEFT JOIN TS_DisciplineDate AS B ON B.F_Date = A.F_SessionDate
		WHERE B.F_DisciplineDateID = @DateID
		) AND F_CourtID = @CourtID
		)
	)
	
	UPDATE #TMP_TABLE SET EventName_CHN = X.F_EventShortName, PhaseName_CHN = Y.F_PhaseShortName
	FROM TS_Event_Des AS X
	LEFT JOIN TS_Phase AS Z ON Z.F_EventID = X.F_EventID
	LEFT JOIN TS_Phase_Des AS Y ON Y.F_PhaseID = Z.F_PhaseID
	WHERE X.F_LanguageCode = 'CHN' AND Y.F_LanguageCode = 'CHN' AND Z.F_PhaseID IN
	(SELECT DISTINCT(F_PhaseID) FROM TS_Match WHERE F_SessionID IN
	(SELECT A.F_SessionID FROM TS_Session AS A
	LEFT JOIN TS_DisciplineDate AS B ON B.F_Date = A.F_SessionDate
	WHERE B.F_DisciplineDateID = @DateID
	)
	)
	DECLARE @PhaseID INT
	DECLARE mycursor CURSOR FOR SELECT PhaseID FROM #TMP_TABLE
	OPEN mycursor
	FETCH NEXT FROM mycursor INTO @PhaseID
	
	WHILE @@FETCH_STATUS = 0
		BEGIN
			UPDATE #TMP_TABLE SET StartTime =
			(
				SELECT LEFT( CONVERT( NVARCHAR(30), MIN(F_StartTime), 108 ), 5) FROM TS_Match AS A WHERE A.F_PhaseID = @PhaseID
						AND A.F_SessionID IN 
						(
							SELECT X.F_SessionID FROM TS_Session AS X
							LEFT JOIN TS_DisciplineDate AS Y ON Y.F_Date = X.F_SessionDate
							WHERE Y.F_DisciplineDateID = @DateID
						)
			) WHERE PhaseID = @PhaseID
			
			FETCH NEXT FROM mycursor INTO @PhaseID
		END
	
	CLOSE mycursor
	DEALLOCATE mycursor
	--UPDATE #TMP_TABLE SET StartTime = 
	--(
	--	SELECT LEFT( CONVERT( NVARCHAR(30), MIN(F_StartTime), 108 ), 5) from TS_Match AS A WHERE A.F_PhaseID = F_PhaseID
	--)
	
	SELECT StartTime, (EventName_ENG + ' ' + PhaseName_ENG) AS EventPhaseName_ENG, 
			(EventName_CHN + PhaseName_CHN) AS EventPhaseName_CHN
	FROM #TMP_TABLE ORDER BY StartTime,PhaseID*/
	
	SELECT  LEFT( CONVERT( NVARCHAR(30), A.F_StartTime, 108 ), 5) AS StartTime, E1.F_EventShortName + ' ' + D1.F_PhaseShortName + ' ' + C1.F_MatchShortName 
	AS EventPhaseName_ENG
	FROM TS_Match AS A
	LEFT JOIN TS_Match_Des AS C1 ON C1.F_MatchID = A.F_MatchID AND C1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase_Des AS D1 ON D1.F_PhaseID = A.F_PhaseID AND D1.F_LanguageCode = 'ENG'
	LEFT JOIN TS_Phase AS F ON F.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event_Des AS E1 ON E1.F_EventID = F.F_EventID AND E1.F_LanguageCode = 'ENG'
	--LEFT JOIN TS_DisciplineDate AS G ON G.F_Date = B.F_SessionDate
	WHERE A.F_SessionID = @SessionID AND A.F_CourtID = @CourtID ORDER BY A.F_StartTime, CONVERT(INT, A.F_RaceNum)
	
SET NOCOUNT OFF
END




GO


