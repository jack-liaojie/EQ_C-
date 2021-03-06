IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetTeamFinalPhaseResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetTeamFinalPhaseResults]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_BD_GetTeamFinalPhaseResults]
--描    述：获取团体赛决赛阶段的最终成绩
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2011年04月19日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetTeamFinalPhaseResults](
                       @EventID         INT,
                       @Order           INT --决赛的@Order为-1
)

As
Begin
SET NOCOUNT ON 

	SET LANGUAGE ENGLISH
	
	DECLARE @PhaseID INT
	DECLARE @EventCode NVARCHAR(10)
	

	SELECT @EventCode = F_EventComment FROM TS_Event_Des WHERE F_EventID = @EventID AND F_LanguageCode = 'ENG'
	
	IF @Order != -1
		BEGIN
			SELECT @PhaseID = F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID AND F_Order = @Order AND F_FatherPhaseID <> 0 AND F_PhaseIsPool = 0
		END
	ELSE
		BEGIN
			SELECT @PhaseID = F_PhaseID FROM TS_Match 
			WHERE F_PhaseID IN  (SELECT F_PhaseID FROM TS_Phase WHERE F_EventID = @EventID)
			GROUP BY F_PhaseID HAVING COUNT(F_MatchID) = 1
		END

	IF @PhaseID IS NULL
		RETURN
	
	CREATE TABLE #TMP_TABLE
	(
	   Value1 NVARCHAR(50),
	   Value2 NVARCHAR(50),
	   Value3 NVARCHAR(50),
	   Value4 NVARCHAR(50),
	   Value5 NVARCHAR(50)
	)

	INSERT INTO #TMP_TABLE (Value1, Value2,Value3,Value4, Value5) 
	(
		SELECT  C1.F_PrintShortName + ISNULL( ' - ' + CONVERT( NVARCHAR(10), B1.F_Points ), '' ),
				C2.F_PrintShortName + ISNULL( ' - ' + CONVERT( NVARCHAR(10), B2.F_Points ), '' ),
				@EventCode + A.F_RaceNum,
				CASE @Order
				WHEN 3
				THEN
					(
						E2.F_PrintShortName + ' - Bronze' --输者获铜牌
					)
				WHEN 4
				THEN
					(
						E1.F_PrintShortName + ' - Gold'
					)
				ELSE '' END
				,
				CASE @Order
				WHEN 4
				THEN
					(
						E2.F_PrintShortName + ' - Silver'
					)
				ELSE '' END
		FROM TS_Match AS A 
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
		LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
		
		LEFT JOIN TS_Match_Result AS D1 ON D1.F_MatchID = A.F_MatchID AND D1.F_ResultID = 1
		LEFT JOIN TR_Register_Des AS E1 ON E1.F_RegisterID = D1.F_RegisterID AND E1.F_LanguageCode = 'ENG'
		
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
		LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
		
		LEFT JOIN TS_Match_Result AS D2 ON D2.F_MatchID = A.F_MatchID AND D2.F_ResultID = 2
		LEFT JOIN TR_Register_Des AS E2 ON E2.F_RegisterID = D2.F_RegisterID AND E2.F_LanguageCode = 'ENG'
		WHERE A.F_PhaseID = @PhaseID 
	) ORDER BY A.F_Order
	
	SELECT * FROM #TMP_TABLE
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

--exec [dbo].[Proc_Report_BD_GetTeamFinalPhaseResults] 6,2