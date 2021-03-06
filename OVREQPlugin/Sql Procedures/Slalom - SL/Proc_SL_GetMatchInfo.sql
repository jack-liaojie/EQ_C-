IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_SL_GetMatchInfo]
--描    述: 激流回旋项目(获取比赛信息)
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年01月06日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_SL_GetMatchInfo]
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
		SplitCount				INT,
		GateCount				INT,
		SplitGate				NVARCHAR(10),
		WaterSpeed				NVARCHAR(10),
        MatchStatusID           INT,
		F_EventID				INT,
		F_PhaseID				INT,
		F_MatchID				INT
	)

	INSERT #MatchInfo
		(EventName, PhaseName, MatchName, EventCode, PhaseCode, MatchCode, SplitCount, GateCount, SplitGate, WaterSpeed, MatchStatusID, F_EventID, F_PhaseID, F_MatchID)	
		(
			SELECT 
				ED.F_EventLongName,
                PD.F_PhaseLongName,
				MD.F_MatchLongName,
				E.F_EventCode,
                P.F_PhaseCode,
                M.F_MatchCode,
                M.F_MatchComment1,
                M.F_MatchComment2,
				M.F_MatchComment3,
				M.F_MatchComment4,
                M.F_MatchStatusID,
                E.F_EventID,
                P.F_PhaseID,
				M.F_MatchID
				FROM TS_Match AS M 
				LEFT JOIN TS_Match_Des AS MD
					ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Phase AS P
					ON M.F_PhaseID = P.F_PhaseID
				LEFT JOIN TS_Phase_Des AS PD
					ON M.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = @LanguageCode
				LEFT JOIN TS_Event AS E
					ON P.F_EventID = E.F_EventID
				LEFT JOIN TS_Event_Des AS ED
					ON P.F_EventID = ED.F_EventID AND ED.F_LanguageCode = @LanguageCode
			WHERE M.F_MatchID = @MatchID 
		)

		SELECT * FROM #MatchInfo order by F_MatchID

SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_SL_GetMatchInfo] 2267,'eng'

*/