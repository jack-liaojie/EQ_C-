IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_SH_GetPhases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_SH_GetPhases]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_SCB_SH_GetPhases]
--描    述: SCB 获取比赛参数列表.
--创 建 人: 吴定昉
--日    期: 2011-02-24
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SCB_SH_GetPhases]
    @DayID					    INT,
	@EventID					INT
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #Temp_Table
	(
	    Phase  nvarchar(100), 
	    Phase_CHN  nvarchar(100), 
		F_PhaseID INT,
		F_MatchID INT
	)
	
	INSERT INTO #Temp_Table(Phase,Phase_CHN,F_PhaseID,F_MatchID)
	(
	SELECT distinct case when PD.F_PhaseLongName = '' then 'NULL' 
	                     else ISNULL(PD.F_PhaseLongName, N'NULL') end AS Phase
	    , case when PDCHN.F_PhaseLongName = '' then 'NULL'
	           else ISNULL(PDCHN.F_PhaseLongName, N'NULL') end AS Phase_CHN 
		, P.F_PhaseID AS F_PhaseID, M.F_MatchID
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = N'ENG'
	LEFT JOIN TS_Phase_Des AS PDCHN
		ON P.F_PhaseID = PDCHN.F_PhaseID AND PDCHN.F_LanguageCode = N'CHN'
	LEFT JOIN TS_DisciplineDate AS D
	    ON M.F_MatchDate = D.F_Date
	WHERE (P.F_EventID = @EventID OR @EventID = -1) AND D.F_DisciplineDateID = @DayID
		AND M.F_MatchCode <> '50'
	)
	
	
		DECLARE @GenderCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
		DECLARE @MatchLongname NVARCHAR(100)	
		DECLARE @TMP_MatchID INT
		
		DECLARE SCHEDULE_CURSOR CURSOR FOR
		SELECT F_MatchID FROM #Temp_table
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
			WHERE F_MatchID = @TMP_MatchID AND F_LanguageCode = 'ENG'	

			IF @MatchCode = '00' OR @PhaseCode = '1' OR @PhaseCode = '0' 
			BEGIN
				UPDATE #Temp_Table SET Phase = Phase WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE IF @PhaseCode = '9' AND @EventCode IN ('007','109','009','011','013','105','107')--25M STANDARD , 50M PRON WOMEN
			BEGIN
				UPDATE #Temp_Table SET Phase = Phase WHERE CURRENT OF SCHEDULE_CURSOR
			END
			ELSE 
			BEGIN
				UPDATE #Temp_Table SET Phase = Phase + ' ' + @MatchLongname WHERE CURRENT OF SCHEDULE_CURSOR
			END
			
			FETCH NEXT FROM SCHEDULE_CURSOR INTO @TMP_MatchID
		END
		CLOSE SCHEDULE_CURSOR
		DEALLOCATE SCHEDULE_CURSOR
	
	
	SELECT Phase, Phase_CHN, F_PhaseID FROM #Temp_Table ORDER BY F_PhaseID

SET NOCOUNT OFF
END

GO

/*
EXEC [Proc_SCB_SH_GetPhases] 1,2
*/