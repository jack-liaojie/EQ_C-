IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BK_GetDisciplineInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BK_GetDisciplineInfo]

GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_Report_BK_GetDisciplineInfo]
----功		  能：得到当前激活的Discipline信息
----作		  者：杨佳鹏
----日		  期: 2011-06-09 

CREATE PROCEDURE [dbo].[Proc_Report_BK_GetDisciplineInfo]
             @DisciplineID  INT,
             @LanguageCode  CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH

    CREATE TABLE #table_Discipline(
		                F_DisciplineName	NVARCHAR(100),
                        F_VenueName         NVARCHAR(100),
                        F_Report_TitleDate  NVARCHAR(20),
                        F_Report_CreateDate NVARCHAR(30),
                                  )

    INSERT INTO #table_Discipline (F_DisciplineName)
    SELECT UPPER(F_DisciplineLongName) FROM TS_Discipline_Des AS B RIGHT JOIN TS_Discipline AS A ON B.F_DisciplineID = A.F_DisciplineID AND B.F_LanguageCode = @LanguageCode WHERE A.F_DisciplineID = @DisciplineID

    UPDATE #table_Discipline SET F_VenueName = UPPER(B.F_VenueShortName) FROM TC_Venue_Des AS B RIGHT JOIN TD_Discipline_Venue AS A ON B.F_VenueID = A.F_VenueID AND B.F_LanguageCode = @LanguageCode
    WHERE A.F_DisciplineID = @DisciplineID

    --UPDATE #table_Discipline SET F_Report_TitleDate = CONVERT (NVARCHAR(100),GETDATE(), 23)
    UPDATE #table_Discipline SET F_Report_TitleDate = [dbo].[Fun_Report_BK_GetDateTime](GETDATE(), 4)
    UPDATE #table_Discipline SET F_Report_CreateDate = [dbo].[Fun_Report_BK_GetDateTime](GETDATE(), 1)
    --UPDATE #table_Discipline SET F_Report_CreateDate = CONVERT (NVARCHAR(100),GETDATE(), 120)

    SELECT * FROM #table_Discipline

Set NOCOUNT OFF
End


GO


