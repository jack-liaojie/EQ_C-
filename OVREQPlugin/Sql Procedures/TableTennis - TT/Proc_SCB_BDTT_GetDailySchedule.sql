IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetDailySchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetDailySchedule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_SCB_BDTT_GetDailySchedule]
----功		  能：获取TT SCB需要的当日比赛安排
----作		  者：王强
----日		  期: 2011-02-17

CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetDailySchedule]
		@DateID     INT
AS
BEGIN
	
SET NOCOUNT ON

	CREATE TABLE #TMP_TABLE
	(
		PhaseID INT,
		EventName_ENG NVARCHAR(30),
		EventName_CHN NVARCHAR(30),
		PhaseName_ENG NVARCHAR(30),
		PhaseName_CHN NVARCHAR(30),
		StartTime NVARCHAR(30)
	)
	
	DECLARE @SessionID INT
	DECLARE ssCursor CURSOR FOR SELECT A.F_SessionID FROM TS_Session AS A 
					LEFT JOIN TS_DisciplineDate AS B ON B.F_Date = A.F_SessionDate
					WHERE B.F_DisciplineDateID = @DateID ORDER BY A.F_SessionID
	OPEN ssCursor				
	FETCH NEXT FROM ssCursor INTO @SessionID
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		INSERT INTO #TMP_TABLE (PhaseID, EventName_ENG, EventName_CHN, PhaseName_ENG,PhaseName_CHN,StartTime )
		(
			SELECT Z.F_PhaseID, X1.F_EventShortName, X2.F_EventShortName, Y1.F_PhaseShortName,Y2.F_PhaseShortName,
			(SELECT LEFT( CONVERT( NVARCHAR(30), MIN(A.F_StartTime), 108 ), 5) FROM TS_Match AS A WHERE A.F_PhaseID = Z.F_PhaseID
						AND A.F_SessionID = @SessionID)
			FROM TS_Phase AS Z
			LEFT JOIN TS_Event_Des AS X1 ON X1.F_EventID = Z.F_EventID AND X1.F_LanguageCode = 'ENG'
			LEFT JOIN TS_Event_Des AS X2 ON X2.F_EventID = Z.F_EventID AND X2.F_LanguageCode = 'CHN'
			LEFT JOIN TS_Phase_Des AS Y1 ON Y1.F_PhaseID = Z.F_PhaseID AND Y1.F_LanguageCode = 'ENG'
			LEFT JOIN TS_Phase_Des AS Y2 ON Y2.F_PhaseID = Z.F_PhaseID AND Y2.F_LanguageCode = 'CHN'
			WHERE Z.F_PhaseID IN (SELECT DISTINCT(F_PhaseID) FROM TS_Match WHERE F_SessionID = @SessionID)
		)
		
		FETCH NEXT FROM ssCursor INTO @SessionID
	END
	
	CLOSE ssCursor
	DEALLOCATE ssCursor
	
	SELECT StartTime, EventName_ENG, EventName_CHN, PhaseName_ENG, PhaseName_CHN FROM #TMP_TABLE ORDER BY StartTime, EventName_ENG, PhaseID
	
SET NOCOUNT OFF
END


GO


