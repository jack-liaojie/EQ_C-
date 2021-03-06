
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_GetDisciplineInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_GetDisciplineInfo]
GO


/****** Object:  StoredProcedure [dbo].[Proc_Report_FB_GetDisciplineInfo]    Script Date: 12/31/2010 17:08:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO








----存储过程名称：[Proc_Report_FB_GetDisciplineInfo]
----功		  能：得到当前激活的Discipline信息
----作		  者：李燕
----日		  期: 2010-10-28 

CREATE PROCEDURE [dbo].[Proc_Report_FB_GetDisciplineInfo]
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

    UPDATE #table_Discipline SET F_Report_TitleDate = [dbo].[Func_Report_FB_GetDateTime](GETDATE(), 1,@LanguageCode)
    UPDATE #table_Discipline SET F_Report_CreateDate = [dbo].[Func_Report_FB_GetDateTime](GETDATE(), 6,@LanguageCode)

    SELECT * FROM #table_Discipline

Set NOCOUNT OFF
End


GO


