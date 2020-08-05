IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_WL_GetCompetitionSchedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_WL_GetCompetitionSchedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_Report_WL_GetCompetitionSchedule]
--描    述：得到Discipline下得CompetitionSchedule列表
--参数说明： 
--说    明：
--创 建 人：吴定昉
--日    期：2010年10月12日


CREATE PROCEDURE [dbo].[Proc_Report_WL_GetCompetitionSchedule](
												@DisciplineID		INT,
												@LanguageCode		CHAR(3)
                                                
)
As
Begin
SET NOCOUNT ON 

    SET Language English
    
	CREATE TABLE #Tmp_Table(
    [Date]         NVARCHAR(50),
    [StartTime]    NVARCHAR(50),
    [FinishTime]   NVARCHAR(50),
    [Event]        NVARCHAR(100),
    [Phase]        NVARCHAR(100),
    [Location]     NVARCHAR(100),
    [MatchID]      INT
							)

	INSERT INTO #Tmp_Table ([Date], [StartTime], [FinishTime], [Event], [Phase], [Location], [MatchID]) 
	SELECT dbo.Fun_WL_GetDateTime(D.F_Date, 7, @LanguageCode) +  dbo.Fun_WL_GetDateTime(D.F_Date, 2, @LanguageCode) AS [Date], 
	dbo.Fun_WL_GetDateTime(M.F_StartTime, 4, @LanguageCode) AS [startime],
	dbo.Fun_WL_GetDateTime(MF.F_EndTime, 4, @LanguageCode)  AS [finishtime],
    ED.F_EventLongName AS [Event],
    PD.F_PhaseLongName  AS [Phase],
    CTD.F_CityLongName AS [Location],      
    M.F_MatchID AS [MatchID]
	FROM TS_DisciplineDate AS D
	left join TS_Match AS M on D.F_Date = M.F_Matchdate AND M.F_MatchCode = '01'
	left join TS_Phase AS P on M.F_PhaseID = P.F_PhaseID
	left join TS_Event AS E on P.F_EventID = E.F_EventID
	left join TS_Match AS MF on D.F_Date = MF.F_Matchdate AND MF.F_MatchCode = '02' AND MF.F_PhaseID = P.F_PhaseID
	left join TS_Event_Des AS ED on E.f_EventID = ED.F_EventID and ED.F_Languagecode=@LanguageCode 
	left join TS_Phase_Des AS PD on P.f_PhaseID = PD.F_PhaseID and PD.F_Languagecode=@LanguageCode 
	left join TS_Match_Des AS MD on M.f_MatchID = MD.F_MatchID and MD.F_Languagecode=@LanguageCode 
	left join TC_Venue_Des AS VD on M.F_VenueID = VD.F_VenueID and VD.F_Languagecode=@LanguageCode 	
	left join TC_Court_Des AS CD on M.F_CourtID = CD.F_CourtID and CD.F_Languagecode=@LanguageCode 
	left join TC_Venue AS V on V.F_VenueID = VD.F_VenueID
	left join TC_City_Des AS CTD on V.F_CityID = CTD.F_CityID and CTD.F_Languagecode=@LanguageCode
	WHERE D.F_DisciplineID = @DisciplineID and E.F_disciplineid = @DisciplineID
	AND E.F_EventCode IS NOT NULL AND E.F_EventCode <> '000'
	ORDER BY convert(varchar,D.F_Date,112),convert(varchar,M.F_StartTime,108)

    UPDATE #Tmp_Table SET [StartTime] = RIGHT([StartTime], 4) WHERE LEFT([StartTime], 1) = '0'
    
    UPDATE #Tmp_Table SET [FinishTime] = RIGHT([FinishTime], 4) WHERE LEFT([FinishTime], 1) = '0'
    
 --   Declare @LastDate NVARCHAR(50)
 --   Declare @Date NVARCHAR(50)
 --   Declare @MatchID INT
	--Declare RunCur Cursor For Select 
	--[Date],[MatchID]
	--From #Tmp_Table  

 --   SET @LastDate = '-1'
	--Open RunCur
	--Fetch next From RunCur Into @Date,@MatchID
	--While @@fetch_status=0     
	--Begin
	--    IF @Date IS NOT NULL
	--    BEGIN
	--        IF @Date = @LastDate
	--        BEGIN
	--            Update #Tmp_Table SET [Date] = NULL WHERE [MatchID] = @MatchID
	--        END
	--    END
	--    SET @LastDate = @Date
	--    Fetch next From RunCur Into @Date,@MatchID
	--end
	--Close RunCur   
	--Deallocate RunCur

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
exec [Proc_Report_WL_GetCompetitionSchedule] 1,'chn'
*/
