IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetDisciplineInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetDisciplineInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_Report_GF_GetDisciplineInfo]
----功		  能：得到当前Discipline信息
----作		  者：张翠霞
----日		  期: 2010-09-15

CREATE PROCEDURE [dbo].[Proc_Report_GF_GetDisciplineInfo]
             @DisciplineID  INT,
             @LanguageCode  CHAR(3)

AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
                                  
    SELECT UPPER(DD.F_DisciplineLongName) AS F_DisciplineName, UPPER(VD.F_VenueShortName) AS F_VenueName
    , [dbo].[Fun_Report_GF_GetDateTime](GETDATE(), 1) AS F_Report_CreateDate, [dbo].[Fun_Report_GF_GetDateTime](GETDATE(), 4) AS F_Report_TitleDate
    FROM TS_Discipline AS D
    LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
    LEFT JOIN TD_Discipline_Venue AS DV ON D.F_DisciplineID = DV.F_DisciplineID
    LEFT JOIN TC_Venue AS V ON DV.F_VenueID = V.F_VenueID
    LEFT JOIN TC_Venue_Des AS VD ON V.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode

Set NOCOUNT OFF
End

GO

