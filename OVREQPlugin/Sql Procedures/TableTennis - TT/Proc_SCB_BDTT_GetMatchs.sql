IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SCB_BDTT_GetMatchs]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SCB_BDTT_GetMatchs]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_SCB_BDTT_GetMatchs]
--描    述: SCB 获取比赛参数列表.
--创 建 人: 王强
--日    期: 2011-02-16
--修改记录：2011-6-13单打增加对组选择的过滤



CREATE PROCEDURE [dbo].[Proc_SCB_BDTT_GetMatchs]
	@SessionID					INT,
	@EventID					INT,
	@CourtID                    INT,
	@TeamPhaseCode              NVARCHAR(10) = ''
AS
BEGIN
SET NOCOUNT ON

	DECLARE @ProcName			NVARCHAR(100)
	DECLARE @DisciplineCode		CHAR(2)
	
	SELECT @DisciplineCode = D.F_DisciplineCode
	FROM TS_Event AS E
	LEFT JOIN TS_Discipline AS D
		ON E.F_DisciplineID = D.F_DisciplineID
	WHERE E.F_EventID = @EventID
	
	DECLARE @EventType INT
	SELECT @EventType = F_PlayerRegTypeID FROM TS_Event WHERE F_EventID = @EventID
	
	IF @EventType IN (1,2,3) AND @TeamPhaseCode != ''
	BEGIN
		SELECT ISNULL(PD.F_PhaseLongName, N'') + N' ' + ISNULL(MD.F_MatchLongName, N'') AS Match
		, M.F_MatchID, PD.F_PhaseLongName,  M.F_PhaseID
		FROM TS_Match AS M
		LEFT JOIN TS_Match_Des AS MD
			ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = 'ENG'
		INNER JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Phase_Des AS PD
			ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = 'ENG'
		WHERE (P.F_EventID = @EventID OR @EventID = -1)
			AND (M.F_SessionID = @SessionID OR @SessionID = -1)
			AND (M.F_CourtID = @CourtID OR @CourtID = -1) AND P.F_PhaseCode = @TeamPhaseCode
		ORDER BY M.F_MatchNum
	END
	ELSE
	BEGIN
		SELECT ISNULL(PD.F_PhaseLongName, N'') + N' ' + ISNULL(MD.F_MatchLongName, N'') AS Match
		, M.F_MatchID, PD.F_PhaseLongName,  M.F_PhaseID, PD2.F_PhaseLongName
		FROM TS_Match AS M
		LEFT JOIN TS_Match_Des AS MD
			ON M.F_MatchID = MD.F_MatchID AND MD.F_LanguageCode = 'ENG'
		INNER JOIN TS_Phase AS P
			ON M.F_PhaseID = P.F_PhaseID
		LEFT JOIN TS_Phase_Des AS PD
			ON P.F_PhaseID = PD.F_PhaseID AND PD.F_LanguageCode = 'ENG'
		LEFT JOIN TS_Phase_Des AS PD2
			ON P.F_PhaseID = PD2.F_PhaseID AND PD2.F_LanguageCode = 'CHN'
		WHERE (P.F_EventID = @EventID OR @EventID = -1)
			AND (M.F_SessionID = @SessionID OR @SessionID = -1)
			AND (M.F_CourtID = @CourtID OR @CourtID = -1)
		ORDER BY M.F_MatchNum
	END
	
	

SET NOCOUNT OFF
END


GO


