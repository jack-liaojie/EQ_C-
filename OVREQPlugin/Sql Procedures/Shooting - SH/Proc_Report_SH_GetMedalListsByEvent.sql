IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetMedalListsByEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetMedalListsByEvent]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_Report_SH_GetMedalListsByEvent](
												@DisciplineID		    INT,
												@LanguageCode		    CHAR(3)
)
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #TT (F_EventID INT, 
						F_EventLongName NVARCHAR(50), 
						F_DateDesc NVARCHAR(50), 
						F_EventCloseDate DATETIME)
	
	INSERT #TT(F_EventID)
	SELECT ER.F_EventID
	FROM TS_Event_Result AS ER
		LEFT JOIN TS_Event AS E ON ER.F_EventID = E.F_EventID
	WHERE	E.F_DisciplineID = @DisciplineID	
			AND ER.F_MedalID IS NOT NULL
	GROUP BY ER.F_EventID
	
	UPDATE #TT SET F_EventLongName = ED.F_EventLongName,
					F_EventCloseDate = E.F_CloseDate,
					F_DateDesc = DBO.Func_Report_GetDateTime(E.F_CloseDate,4)
	FROM #TT
	LEFT JOIN TS_Event AS E ON #TT.F_EventID = E.F_EventID
	LEFT JOIN TS_Event_Des AS ED ON ED.F_EventID = E.F_EventID AND ED.F_LanguageCode = @LanguageCode
		
	SELECT * FROM #TT ORDER BY F_EventCloseDate
	
SET NOCOUNT OFF
END


GO


-- EXEC Proc_Report_SH_GetMedalListsByEvent 1,'ENG'