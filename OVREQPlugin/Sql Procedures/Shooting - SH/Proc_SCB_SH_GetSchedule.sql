IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_SCB_SH_GetSchedule]
--描    述：得到Discipline下得Schedule列表
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2011年02月23日


CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetSchedule](
												@DisciplineCode		CHAR(2),
												@DisciplineDateID	INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

    SET Language English
    
    DECLARE @DisciplineID INT
    
    SELECT @DisciplineID = F_DisciplineID FROM TS_Discipline 
    WHERE F_DisciplineCode = @DisciplineCode
    
	CREATE TABLE #Tmp_Table(
    [Date]         NVARCHAR(50),
    [StartTime]    NVARCHAR(50),
    [FinishTime]   NVARCHAR(50),
    [Event]        NVARCHAR(100),
    [Phase]        NVARCHAR(100),
    [Match]		   NVARCHAR(100),
    [Location]     NVARCHAR(100),
    [MatchID]      INT
							)

	INSERT INTO #Tmp_Table ([Date], [StartTime], [FinishTime], [Event], [Phase], [Location], [MatchID], [Match]) 
	SELECT (UPPER(Substring(dbo.Fun_GetWeekdayName(D.F_Date,'ENG'),1,3)) + ' '
	+ DATENAME(DAY,D.F_Date) + ' ' + UPPER(Substring(DATENAME(MONTH,D.F_Date),1,3)) ) AS [Date],
	Substring(convert(varchar,M.F_StartTime,108),1,5) AS [startime],
	Substring(convert(varchar,M.F_EndTime,108),1,5) AS [finishtime],
    ED.F_EventLongName AS [Event],
	PD.F_PhaseShortName AS [Phase],
    VD.F_VenueLongName AS [Location],      
    M.F_MatchID AS [MatchID],
    MD.F_MatchLongName
	FROM TS_DisciplineDate AS D
	left join TS_Match AS M on D.F_Date = M.F_Matchdate
	left join TS_Phase AS P on M.F_PhaseID = P.F_PhaseID
	left join TS_Event AS E on P.F_EventID = E.F_EventID
	left join TS_Event_Des AS ED on E.f_EventID = ED.F_EventID and ED.F_Languagecode=@LanguageCode 
	left join TS_Phase_Des AS PD on P.f_PhaseID = PD.F_PhaseID and PD.F_Languagecode=@LanguageCode 
	left join TS_Match_Des AS MD on M.f_MatchID = MD.F_MatchID and MD.F_Languagecode=@LanguageCode 
	left join TC_Venue_Des AS VD on M.F_VenueID = VD.F_VenueID and VD.F_Languagecode=@LanguageCode 	
	left join TC_Court_Des AS CD on M.F_CourtID = CD.F_CourtID and CD.F_Languagecode=@LanguageCode 
	WHERE D.F_DisciplineID = @DisciplineID and E.F_disciplineid = @DisciplineID
	AND E.F_EventCode IS NOT NULL 
	AND E.F_EventCode NOT IN( '000', '002' , '004' , '006' , '008' , '010' , '012' , '014', '102' , '104' , '106' , '108' , '110'  )
	AND M.F_MatchCode NOT IN ('50')
	AND D.F_DisciplineDateID = @DisciplineDateID
	AND F_RaceNum IS NOT NULL
	ORDER BY CAST(F_RaceNum AS INT), convert(varchar,D.F_Date,112),convert(varchar,M.F_StartTime,108)

    Declare @LastDate NVARCHAR(50)
    Declare @Date NVARCHAR(50)
    Declare @MatchID INT
	Declare RunCur Cursor For Select 
	[Date],[MatchID]
	From #Tmp_Table  

    SET @LastDate = '-1'
	Open RunCur
	Fetch next From RunCur Into @Date,@MatchID
	While @@fetch_status=0     
	Begin
	    IF @Date IS NOT NULL
	    BEGIN
	        IF @Date = @LastDate
	        BEGIN
	            Update #Tmp_Table SET [Date] = NULL WHERE [MatchID] = @MatchID
	        END
	    END
	    SET @LastDate = @Date
	    Fetch next From RunCur Into @Date,@MatchID
	end
	Close RunCur   
	Deallocate RunCur


		DECLARE @GenderCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @MatchLongname NVARCHAR(100)	
		DECLARE @TMP_MatchID INT
		
		DECLARE SCHEDULE_CURSOR CURSOR FOR
		SELECT MatchID FROM #Tmp_table
		OPEN SCHEDULE_CURSOR
		FETCH NEXT FROM SCHEDULE_CURSOR INTO @TMP_MatchID
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT 
					@GenderCode = Gender_Code,
					@EventCode = Event_Code,
					@PhaseCode = Phase_Code,
					@MatchCode = Match_Code
			 FROM dbo.Func_SH_GetEventCommonCodeInfo(@TMP_MatchID)

			SELECT @MatchLongname = F_MatchLongName 
			FROM TS_Match_Des 
			WHERE F_MatchID = @TMP_MatchID AND F_LanguageCode = @LanguageCode	

			IF @MatchCode = '00' OR @PhaseCode = '1' OR @PhaseCode = '0' 
			BEGIN
				UPDATE #Tmp_Table SET [Phase] = [Phase] WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode IN ('007','109','009','011','013','105','107')--25M STANDARD , 50M PRON WOMEN
			BEGIN
				UPDATE #Tmp_Table SET [Phase] = [Phase] WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode IN ('001','003','101','103') AND @MatchCode = '00'
			BEGIN
				DELETE FROM #Tmp_Table WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode = '005' AND @MatchCode = '01'
			BEGIN
				UPDATE #Tmp_Table SET 
				[Phase] = [Phase] 
				WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode = '005' AND @MatchCode = '02'
			BEGIN
				DELETE FROM #Tmp_Table 
				WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE 
			BEGIN
				UPDATE #Tmp_Table SET [Phase] = [Phase] + ' ' + @MatchLongname WHERE CURRENT OF SCHEDULE_CURSOR
			END
			
			FETCH NEXT FROM SCHEDULE_CURSOR INTO @TMP_MatchID
		END
		CLOSE SCHEDULE_CURSOR
		DEALLOCATE SCHEDULE_CURSOR	
	
--    ALTER TABLE #Tmp_Table  DROP COLUMN MatchID

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	
GO
	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
exec [Proc_SCB_SH_GetSchedule] 'SH',1,'eng'
*/
