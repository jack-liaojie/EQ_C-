IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetDisciplineInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetDisciplineInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_Report_SH_GetDisciplineInfo]
             @DisciplineID  INT,
             @LanguageCode  CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE #table_Discipline(
		                F_DisciplineName	NVARCHAR(100),
                        F_VenueName         NVARCHAR(100),
                        F_Report_TitleDate  NVARCHAR(20),
                        F_ReportWeek		NVARCHAR(20),
                        F_Report_CreateDate NVARCHAR(30),
                                  )

    INSERT INTO #table_Discipline (F_DisciplineName)
    SELECT UPPER(F_DisciplineLongName) FROM TS_Discipline_Des AS B RIGHT JOIN TS_Discipline AS A ON B.F_DisciplineID = A.F_DisciplineID WHERE A.F_DisciplineID = @DisciplineID
        AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Discipline SET F_VenueName = UPPER(B.F_VenueLongName) FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID
    WHERE A.F_DisciplineID = @DisciplineID AND B.F_LanguageCode = @LanguageCode

    UPDATE #table_Discipline SET F_Report_TitleDate = dbo.Func_Report_GetDateTime(getdate(), 6)
    UPDATE #table_Discipline SET F_Report_CreateDate = dbo.Func_Report_GetDateTime(getdate(), 1)
	

    UPDATE #table_Discipline SET F_ReportWeek = DBO.Func_SH_GetWeek(getdate(), @LanguageCode)
	
	
	IF @LanguageCode = 'CHN'
	BEGIN
	    UPDATE #table_Discipline SET F_Report_TitleDate = dbo.Func_SH_GetChineseDate(getdate()) + ' ' + dbo.Func_Report_GetDateTime(getdate(), 3)
		UPDATE #table_Discipline SET F_Report_CreateDate = dbo.Func_SH_GetChineseDate(getdate()) + ' ' + dbo.Func_Report_GetDateTime(getdate(), 3)
	END
	
    SELECT * FROM #table_Discipline

Set NOCOUNT OFF
End

GO

-- Proc_Report_SH_GetDisciplineInfo 1,'CHN'