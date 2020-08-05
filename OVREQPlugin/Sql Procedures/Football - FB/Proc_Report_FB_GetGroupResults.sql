IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_GetGroupResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_GetGroupResults]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_FB_GetGroupResults]
----功		  能：得到一个小项的小组的比赛成绩。
----作		  者：邓年彩
----日		  期: 2011-6-9

CREATE PROCEDURE [dbo].[Proc_Report_FB_GetGroupResults]
                     (
	                   @EventID       INT,
                       @LanguageCode  CHAR(3)
                      )
AS
BEGIN
	
SET NOCOUNT ON

	SET LANGUAGE 'ENGLISH'

	SELECT P.F_PhaseID
		, MR1.F_RegisterID AS F_RegisterID_L
		, MR2.F_RegisterID AS F_RegisterID_H
		, MR1.F_StartPhasePosition AS Position_L
		, MR2.F_StartPhasePosition AS Position_H
		, ISNULL(CASE M.F_MatchStatusID
			WHEN 110 THEN CONVERT(NVARCHAR(10), MR1.F_Points) 
				+ N'-' + CONVERT(NVARCHAR(10), MR2.F_Points)
			ELSE 
				dbo.[Func_Report_FB_GetDateTime](M.F_MatchDate,7,@LanguageCode)
				--CONVERT(NVARCHAR(20), DATEPART(DAY, M.F_MatchDate)) 
				--+ N' ' + UPPER(LEFT(CONVERT(NVARCHAR(20), M.F_MatchDate, 100), 3))
		END, N' ') AS Results
		
	FROM TS_Match AS M
	INNER JOIN TS_Phase AS P
		ON M.F_PhaseID = P.F_PhaseID
	LEFT JOIN TS_Phase_Des AS PD
		ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
	--INNER JOIN TS_Phase AS FP
	--	ON P.F_FatherPhaseID = FP.F_PhaseID
		
	INNER JOIN TS_Match_Result AS MR1
		ON M.F_MatchID = MR1.F_MatchID
	INNER JOIN TS_Match_Result AS MR2
		ON M.F_MatchID = MR2.F_MatchID 
			AND MR1.F_CompetitionPosition <> MR2.F_CompetitionPosition		
	
	WHERE P.F_EventID = @EventID
		AND P.F_PhaseIsPool = 1
		--AND FP.F_PhaseCode = N'9'
	ORDER BY P.F_PhaseCode

SET NOCOUNT OFF
END

GO

/*
exec [Proc_Report_FB_GetGroupResults] 135,'ENG'
exec [Proc_Report_FB_GetGroupResults] 136,'ENG'
exec [Proc_Report_FB_GetGroupResults] 139,'ENG'
*/