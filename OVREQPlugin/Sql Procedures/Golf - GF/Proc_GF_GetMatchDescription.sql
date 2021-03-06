IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetMatchDescription]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetMatchDescription]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GF_GetMatchDescription]
--描    述：GF 得到当前比赛描述信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年09月27日

CREATE PROCEDURE [dbo].[Proc_GF_GetMatchDescription](
				 @MatchID		INT,--当前比赛的ID
                 @LanguageCode  NVARCHAR(3) --比赛语言代码
)
	
AS
BEGIN
	
SET NOCOUNT ON

    SET LANGUAGE ENGLISH
	CREATE TABLE #table_Match (
	                                    F_MatchDes         NVARCHAR(100),
                                        F_DisciplineDes    NVARCHAR(100),
                                        F_EventDes		   NVARCHAR(100),
                                        F_PhaseDes         NVARCHAR(100),
										F_DateDes	       NVARCHAR(100),
										F_VenueDes	       NVARCHAR(100),
										F_MatchStatusID    INT
									 )
							
	INSERT INTO #table_Match(F_DisciplineDes, F_EventDes, F_PhaseDes, F_DateDes, F_VenueDes, F_MatchStatusID)
	SELECT DD.F_DisciplineLongName, ED.F_EventLongName, PD.F_PhaseLongName
	, dbo.Fun_Report_GF_GetDateTime(M.F_MatchDate, 4) + ' ' + dbo.Fun_Report_GF_GetDateTime(M.F_StartTime, 3)
	, VD.F_VenueLongName, M.F_MatchStatusID
	FROM TS_Match AS M
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED ON E.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
	LEFT JOIN TS_Discipline AS D ON E.F_DisciplineID = D.F_DisciplineID
	LEFT JOIN TS_Discipline_Des AS DD ON D.F_DisciplineID = DD.F_DisciplineID AND DD.F_LanguageCode = @LanguageCode
	LEFT JOIN TC_Venue AS V ON M.F_VenueID = V.F_VenueID
	LEFT JOIN TC_Venue_Des AS VD ON V.F_VenueID = VD.F_VenueID AND VD.F_LanguageCode = @LanguageCode
	WHERE M.F_MatchID = @MatchID

    UPDATE #table_Match SET F_MatchDes = F_EventDes + ' ' + F_PhaseDes

    SELECT F_MatchDes, F_DateDes, F_MatchStatusID FROM #table_Match

Set NOCOUNT OFF
End	
	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO


