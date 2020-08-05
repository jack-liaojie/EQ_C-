IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SL_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SL_GetCompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




----名    称：[Proc_Report_SL_GetCompetitionSchedule]
----描    述：得到Discipline下得CompetitionSchedule列表
----参数说明： 
----说    明：
----创 建 人：吴定昉
----日    期：2010年01月21日
----修改记录： 
/*			
			时间				修改人		修改内容	
			2012年09月12日       吴定昉      为满足国内运动会的报表要求，加入一些输出列表字段。
*/
---- =============================================



CREATE PROCEDURE [dbo].[Proc_Report_SL_GetCompetitionSchedule](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

    IF @LanguageCode = 'ENG'
	    SET Language English
    
	CREATE TABLE #Tmp_Table(
    [Date]         NVARCHAR(50),
    [StartTime]    NVARCHAR(50),
    [FinishTime]   NVARCHAR(50),
    [Event]        NVARCHAR(100),
    [MatchID]      INT
							)

	INSERT INTO #Tmp_Table ([Date], [StartTime], [FinishTime], [Event], [MatchID]) 
	SELECT case when @LanguageCode = 'ENG' then (convert(varchar,D.F_Date,111)) 
	            when @LanguageCode = 'CHN' then [dbo].[Func_Report_SL_GetDateTime](D.F_Date, 10)
	            end AS [Date],
	Substring(convert(varchar,M.F_StartTime,108),1,5) AS [startime],
	Substring(convert(varchar,M.F_EndTime,108),1,5) AS [finishtime],
	(case when MD.F_MatchShortName is null or MD.F_MatchShortName = '' then (ED.F_EventComment + ' ' + PD.F_PhaseShortName)
          else (ED.F_EventComment + ' ' + PD.F_PhaseShortName + ' - ' + MD.F_MatchShortName) end) AS [event],
    M.F_MatchID AS [MatchID]
	FROM TS_DisciplineDate AS D
	left join TS_Match AS M on D.F_Date = M.F_Matchdate
	left join TS_Phase AS P on M.F_PhaseID = P.F_PhaseID
	left join TS_Event AS E on P.F_EventID = E.F_EventID
	left join TS_Event_Des AS ED on E.f_EventID = ED.F_EventID and ED.F_Languagecode=@LanguageCode 
	left join TS_Phase_Des AS PD on P.f_PhaseID = PD.F_PhaseID and PD.F_Languagecode=@LanguageCode 
	left join TS_Match_Des AS MD on M.f_MatchID = MD.F_MatchID and MD.F_Languagecode=@LanguageCode 
	WHERE D.F_DisciplineID = @DisciplineID and E.F_disciplineid = @DisciplineID
	AND E.F_EventCode IS NOT NULL AND E.F_EventCode <> '000'
	ORDER BY convert(varchar,D.F_Date,112),convert(varchar,M.F_StartTime,108)

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

    ALTER TABLE #Tmp_Table  DROP COLUMN MatchID

	SELECT * FROM #Tmp_Table

Set NOCOUNT OFF
End	
GO
	
SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
exec [Proc_Report_SL_GetCompetitionSchedule] 67,'eng'
*/
