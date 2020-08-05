IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_ReportHeaderInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_ReportHeaderInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[Proc_Report_SH_ReportHeaderInfo]

CREATE PROCEDURE [dbo].[Proc_Report_SH_ReportHeaderInfo] (	
	@SportID					INT,
	@DisciplineID				INT,
	@EventID					INT,
	@PhaseID					INT,
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

CREATE TABLE #tmp(
			F_SportLongName NVARCHAR(100),
			F_DisciplineLongName NVARCHAR(100),
			F_VenueLongName NVARCHAR(100),
			F_EventLongName NVARCHAR(100),
			F_PhaseLongName NVARCHAR(100),
			F_MatchLongName NVARCHAR(100),
			F_Match_Week NVARCHAR(50),
			F_Match_Date NVARCHAR(50),
			F_Match_StartTime NVARCHAR(50),
			F_ReportCreatetime NVARCHAR(50)
			)
			
			
		DECLARE @DiciplineCode NVARCHAR(10)
		DECLARE @GenderCode NVARCHAR(10)
		DECLARE @EventCode NVARCHAR(10)
		DECLARE @PhaseCode NVARCHAR(10)
		DECLARE @MatchCode NVARCHAR(10)
	
	
	
	
		IF @MatchID > 0
		BEGIN

			INSERT INTO #tmp(F_SportLongName, F_DisciplineLongName,	F_VenueLongName, F_EventLongName, F_PhaseLongName, 
								F_MatchLongName, F_Match_Week, F_Match_Date, F_Match_StartTime, F_ReportCreatetime)
			SELECT SD.F_SportLongName,	UPPER(DD.F_DisciplineLongName),UPPER(VD.F_VenueLongName),	ED.F_EventLongName,	
			PD.F_PhaseLongName,
			MS.F_MatchLongName,
			(dbo.Func_SH_GetWeek(M.F_MatchDate,@LanguageCode) )AS Match_Week,	
			dbo.Func_Report_GetDateTime(M.F_MatchDate, 4) AS Match_Date,
			dbo.Func_Report_GetDateTime(M.F_StartTime, 3) AS Match_StartTime,
			dbo.Func_SH_GetChineseDate(GETDATE()) + dbo.Func_Report_GetDateTime(GETDATE(), 3)
			FROM TS_MATCH M
			LEFT JOIN TS_Match_Des MS ON M.F_MatchID = MS.F_MatchID AND MS.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase P ON M.F_PhaseID = P.F_PhaseID
			LEFT JOIN TS_Event E ON P.F_EventID = E.F_EventID
			LEFT JOIN TS_Discipline D ON D.F_DisciplineID = E.F_DisciplineID
			LEFT JOIN TS_Sport S ON S.F_SportID = D.F_SportID
			LEFT JOIN TC_Venue V ON V.F_VenueID = M.F_VenueID
			LEFT JOIN TC_Venue_Des VD ON VD.F_VenueID = V.F_VenueID AND VD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Phase_Des PD ON PD.F_PhaseID = P.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Event_Des ED ON ED.F_EventID = E.F_EventID AND ED.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Discipline_Des DD ON DD.F_DisciplineID = D.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
			LEFT JOIN TS_Sport_Des SD ON SD.F_SportID = S.F_SportID AND SD.F_LanguageCode = @LanguageCode
			WHERE M.F_MatchID = @MatchID
		END


		IF @MatchCode = '00' OR @PhaseCode = '1' OR @PhaseCode = '0' 
		BEGIN
			UPDATE #tmp SET F_PhaseLongName = F_PhaseLongName
		END
		ELSE IF @PhaseCode = '9' AND @EventCode IN ('005','007','109','009','011','013','105','107')--25M STANDARD , 50M PRON WOMEN
		BEGIN
			UPDATE #tmp SET F_PhaseLongName = F_PhaseLongName
		END
		ELSE 
		BEGIN
			UPDATE #tmp SET F_PhaseLongName = F_PhaseLongName + ' ' + F_MatchLongName
		END


SELECT * FROM #tmp


SET NOCOUNT OFF
END


-- Proc_Report_SH_ReportHeaderInfo -1,-1,-1,-1,1,'CHN'