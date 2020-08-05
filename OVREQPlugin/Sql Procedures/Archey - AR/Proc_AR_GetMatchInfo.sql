IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_AR_GetMatchInfo]
--描    述: 射箭项目(获取比赛信息)
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年03月30日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetMatchInfo]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL		NVARCHAR(max)

	CREATE TABLE #MatchInfo
	(
		EventName				NVARCHAR(100),
		PhaseName				NVARCHAR(100),
		MatchName				NVARCHAR(100),
		EventCode				NVARCHAR(100),
		PhaseCode				NVARCHAR(100),
		MatchCode				NVARCHAR(100),
		SexCode					INT,
		EndCount				INT,
		ArrowCount				INT,
		IsSetPoints				INT,
		WinPoints				INT,
		Distince				INT,
        CompetitionRuleID		INT,
        MatchStatusID			INT,
		F_MatchID				INT,
		F_DisciplineID			INT
	)

	INSERT #MatchInfo
		(EventName, PhaseName, MatchName, EventCode, PhaseCode, MatchCode,SexCode, 
		 EndCount, ArrowCount,IsSetPoints,WinPoints,Distince,CompetitionRuleID, MatchStatusID, F_MatchID,F_DisciplineID)	
		(
			SELECT 
				ED.F_EventLongName,
                PD.F_PhaseLongName,
				MD.F_MatchLongName,
				E.F_EventCode,
                P.F_PhaseCode,
                MA.F_MatchCode,
                E.F_SexCode,
                MA.F_MatchComment1,
                MA.F_MatchComment2,
                MA.F_MatchComment3,
                MA.F_MatchComment4,
                MA.F_MatchComment5,
                MA.F_CompetitionRuleID,
                MA.F_MatchStatusID,
				MA.F_MatchID,
				E.F_DisciplineID
				FROM TS_Match AS MA 
				LEFT JOIN TS_Match AS MB
					ON MA.F_MatchID = MB.F_MatchID
				LEFT JOIN TS_Match_Des AS MD
					ON MA.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Phase AS P
					ON MB.F_PhaseID = P.F_PhaseID
				LEFT JOIN TS_Phase_Des AS PD
					ON MA.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Event AS E
					ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Event_Des AS ED
					ON P.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
			WHERE MA.F_MatchID = @MatchID 
		)

		SELECT * FROM #MatchInfo order by F_MatchID

SET NOCOUNT OFF
END

GO


/*
EXEC Proc_AR_GetMatchInfo 1,'ENG'
*/