IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetRealTimeResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetRealTimeResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_TE_GetRealTimeResult]
----功		  能：获取当天已结束比赛的实时成绩
----作		  者：崔凯 
----日		  期: 2010-09-15

CREATE PROCEDURE [dbo].[Proc_TE_GetRealTimeResult] (	
	@DisciplineCode					NVARCHAR(10) = NULL,
	@Date							NVARCHAR(50) = NULL,
	@SessionID						INT,
	@EventID						INT
)	
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #REALTIME_RESULT( RETULT NVARCHAR(100))
	
	DECLARE @Languagecode	char(3)=N'CHN'
	DECLARE @MatchID INT 
	DECLARE @GEventID INT 
	
	DECLARE _CURSOR CURSOR FOR SELECT F_MatchID FROM TS_Match AS M
			 LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
			 LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
			 LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = E.F_DisciplineID
			WHERE (@Date=N'-1' OR CONVERT(nvarchar,DATEPART(d,M.F_MatchDate))=right(@Date,2) )
			AND (@EventID=-1 OR E.F_EventID=@EventID)
			AND (@SessionID=-1 OR M.F_SessionID=@SessionID)
			AND (@DisciplineCode=N'-1' OR D.F_DisciplineCode=@DisciplineCode)
			AND M.F_MatchStatusID IN (100,110) 
			ORDER BY F_STARTTIME
	OPEN _CURSOR
	FETCH NEXT FROM _CURSOR INTO @MatchID
	WHILE @@FETCH_STATUS =0
		BEGIN			
			--如果Event不同，空一行	
			DECLARE @tEventID INT = (SELECT E.F_EventID FROM TS_Match AS M
			 LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
			 LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID WHERE F_MatchID = @MatchID)			
			IF(@GEventID != @tEventID)
				begin				
				INSERT INTO #REALTIME_RESULT( RETULT) SELECT NULL
				end
			SET @GEventID =@tEventID
			
			INSERT INTO #REALTIME_RESULT( RETULT)
			
			SELECT ISNULL(LEFT(CONVERT(VARCHAR(20), F_STARTTIME,8),5),'')
			   + ' ' + ED.F_EventLongName
			   + ' ' + PD.F_PhaseLongName
			 FROM TS_Match AS M
			 LEFT JOIN TS_Match_Des AS MD ON MD.F_MatchID = M.F_MatchID AND MD.F_LanguageCode = 'CHN'
			 LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
			 LEFT JOIN TS_Phase_Des AS PD ON PD.F_PhaseID = P.F_PhaseID AND PD.F_LanguageCode = 'CHN'
			 LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
			 LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = E.F_EventID AND ED.F_LanguageCode = 'CHN'
			 WHERE M.F_MatchID = @MatchID
					
			INSERT INTO #REALTIME_RESULT( RETULT)
			
			SELECT '   ' + ISNULL(RD1.F_LongName,'BYE') + ' vs ' + ISNULL(RD2.F_LongName,'BYE') + '   '
			   + (CASE WHEN MR1.F_Points=NULL AND  MR2.F_Points=NULL THEN ' '
			   ELSE CAST(ISNULL(MR1.F_Points,'-') AS VARCHAR(10))+ ' : ' + CAST(ISNULL(MR2.F_Points,'-') AS VARCHAR(10)) END)
			 FROM TS_Match AS M
			 LEFT JOIN TS_Match_Result AS MR1 ON MR1.F_MatchID = M.F_MatchID AND MR1.F_CompetitionPosition = 1 
			 LEFT JOIN TR_Register_Des AS RD1 ON RD1.F_RegisterID = MR1.F_RegisterID AND RD1.F_LanguageCode = 'CHN'
			 LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID = M.F_MatchID AND MR2.F_CompetitionPosition = 2
			 LEFT JOIN TR_Register_Des AS RD2 ON RD2.F_RegisterID = MR2.F_RegisterID AND RD2.F_LanguageCode = 'CHN'
			WHERE M.F_MatchID = @MatchID
		
			
		FETCH NEXT FROM _CURSOR INTO @MatchID
		END
	CLOSE _CURSOR
	DEALLOCATE _CURSOR
	
	SELECT * FROM #REALTIME_RESULT

	 		
SET NOCOUNT OFF
END

GO

/*
EXEC Proc_TE_GetRealTimeResult 'ts','2011-08-14',-1,-1
*/
