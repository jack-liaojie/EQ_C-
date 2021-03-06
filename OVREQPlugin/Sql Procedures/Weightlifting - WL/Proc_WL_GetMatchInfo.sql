IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_GetMatchInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_GetMatchInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称: [Proc_WL_GetMatchInfo]
--描    述: 举重项目(获取比赛信息)
--参数说明: 
--说    明: 
--创 建 人: 吴定昉
--日    期: 2010年10月16日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_WL_GetMatchInfo]
	@MatchID				INT,
	@LanguageCode			CHAR(3)
AS
BEGIN
SET NOCOUNT ON

	DECLARE @SQL		NVARCHAR(max)
	declare @PhaseID  INT
	declare @MainMatchID  INT
	
	SET @PhaseID = (SELECT F_PhaseID FROM TS_Match WHERE F_MatchID=@MatchID)
	SET @MainMatchID = (SELECT TOP 1 F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID AND F_MatchCode='01')

	CREATE TABLE #MatchInfo
	(
		EventName				NVARCHAR(100),
		PhaseName				NVARCHAR(100),
		MatchName				NVARCHAR(100),
		EventCode				NVARCHAR(100),
		PhaseCode				NVARCHAR(100),
		MatchCode				NVARCHAR(100),
        MatchStatusID           INT,
		F_MatchID				INT,
        StartTime         NVARCHAR(5),
        WeighInTime       NVARCHAR(5)
	)

	INSERT #MatchInfo
		(EventName, PhaseName, MatchName, EventCode, PhaseCode, MatchCode, MatchStatusID, F_MatchID,StartTime,WeighInTime)	
		(
			SELECT 
				ED.F_EventLongName,
                PD.F_PhaseLongName,
				MD.F_MatchLongName,
				E.F_EventCode,
                P.F_PhaseCode,
                MA.F_MatchCode,
                MA.F_MatchStatusID,
				MA.F_MatchID
				, LEFT(CONVERT(NVARCHAR(100), MS.F_StartTime, 114), 5)
				, LEFT(CONVERT(NVARCHAR(100),DATEADD(HOUR,-2, MS.F_StartTime), 114), 5)
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
				LEFT JOIN TS_Match AS MS ON MS.F_MatchID=@MainMatchID
			WHERE MA.F_MatchID = @MatchID 
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
EXEC [Proc_WL_GetMatchInfo] 100,'eng'

*/