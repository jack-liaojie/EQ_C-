IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_BD_GetTeamFinalPhaseBracket]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_BD_GetTeamFinalPhaseBracket]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_Report_BD_GetTeamFinalPhaseBracket]
--描    述：获取团体赛决赛阶段的晋级信息
--参数说明： 
--说    明：
--创 建 人：王强
--日    期：2011年04月19日


CREATE PROCEDURE [dbo].[Proc_Report_BD_GetTeamFinalPhaseBracket](
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
	   Value1 NVARCHAR(50) ,
	   Value2 NVARCHAR(50) ,
	   Value3 NVARCHAR(50) ,
	   Value4 NVARCHAR(50) 
	)
	
	--第一列特殊处理
	IF @Order = 1
		BEGIN
			INSERT INTO #TMP_TABLE (Value2,Value3) 
			(
				SELECT  ISNULL( C1.F_PrintShortName, 
				(SELECT Y.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), X.F_SourcePhaseRank) 
					FROM TS_Match_Result AS X
					LEFT JOIN TS_Phase_Des AS Y ON Y.F_PhaseID = X.F_SourcePhaseID AND Y.F_LanguageCode = 'ENG'
					WHERE X.F_MatchID = B1.F_MatchID AND X.F_CompetitionPositionDes1 = 1)
				  ), 
				ISNULL( C2.F_PrintShortName,
						(SELECT Y.F_PhaseShortName + ' Rank ' + CONVERT( NVARCHAR(4), X.F_SourcePhaseRank) 
							FROM TS_Match_Result AS X
							LEFT JOIN TS_Phase_Des AS Y ON Y.F_PhaseID = X.F_SourcePhaseID AND Y.F_LanguageCode = 'ENG'
							WHERE X.F_MatchID = B2.F_MatchID AND X.F_CompetitionPositionDes1 = 2)
					  )
				FROM TS_Match AS A 
				LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
				LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
				WHERE A.F_PhaseID = @PhaseID 
			) ORDER BY A.F_Order
		END
	ELSE IF @Order = -1
		BEGIN
			DECLARE @MatchID INT
			SELECT @MatchID = F_MatchID FROM TS_Match WHERE F_PhaseID = @PhaseID
			
			IF @MatchID IS NULL
				RETURN
			
		
			IF EXISTS (SELECT * FROM TS_Match_Result WHERE F_ResultID = 1 AND F_MatchID = @MatchID)
			BEGIN
				INSERT INTO #TMP_TABLE (Value1,Value2)
				VALUES
				(
					(SELECT ISNULL(B.F_PrintShortName, 
						(SELECT [dbo].[Fun_Report_BD_GetDateTime](Y.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](Y.F_StartTime, 3) 
						FROM TS_Match AS Y WHERE Y.F_MatchID = @MatchID))
					FROM TS_Match_Result AS A 
					LEFT JOIN TR_Register_Des AS B ON B.F_RegisterID = A.F_RegisterID AND B.F_LanguageCode = 'ENG'
					LEFT JOIN TS_Match AS C ON C.F_MatchID = A.F_MatchID
					WHERE A.F_MatchID = @MatchID AND F_ResultID = 1)
					,
					CASE WHEN ([dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchID) = '')
							OR ([dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchID) IS NULL)
					THEN
					(
						SELECT Y.F_CourtShortName + ',' + @EventCode + X.F_RaceNum FROM TS_Match AS X
						LEFT JOIN TC_Court_Des AS Y ON Y.F_CourtID = X.F_CourtID AND Y.F_LanguageCode = 'ENG'
						WHERE X.F_MatchID = @MatchID 
					)
					ELSE [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchID)
					END
					
				)
			END
			ELSE
			BEGIN
				
				INSERT INTO #TMP_TABLE (Value1,Value2)
				VALUES
				(
					
						(SELECT [dbo].[Fun_Report_BD_GetDateTime](Y.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](Y.F_StartTime, 3) 
						FROM TS_Match AS Y WHERE Y.F_MatchID = @MatchID)
					,
					CASE WHEN ([dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchID) = '')
							OR ([dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchID) IS NULL)
					THEN
					(
						SELECT Y.F_CourtShortName + ',' + @EventCode + X.F_RaceNum FROM TS_Match AS X
						LEFT JOIN TC_Court_Des AS Y ON Y.F_CourtID = X.F_CourtID AND Y.F_LanguageCode = 'ENG'
						WHERE X.F_MatchID = @MatchID 
					)
					ELSE [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](@MatchID)
					END
					
				)
			END
			
		END
	ELSE
		BEGIN
				INSERT INTO #TMP_TABLE (Value1,Value2,Value3,Value4)
				(SELECT  ISNULL( C1.F_PrintShortName, 
					(SELECT [dbo].[Fun_Report_BD_GetDateTime](Y.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](Y.F_StartTime, 3) 
					FROM TS_Match_Result AS X 
					LEFT JOIN TS_Match AS Y ON Y.F_MatchID = X.F_SourceMatchID
					WHERE X.F_CompetitionPositionDes1 = 1 AND X.F_MatchID =  B1.F_MatchID )
				  )
				  , 
				  CASE 
				  WHEN [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](D1.F_MatchID) IN ('',NULL)
						THEN (E1.F_CourtShortName + ',' + @EventCode + D1.F_RaceNum )
				  ELSE [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](D1.F_MatchID)
						  END
					,
					ISNULL( C2.F_PrintShortName,
							(SELECT [dbo].[Fun_Report_BD_GetDateTime](Y.F_MatchDate, 7) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](Y.F_StartTime, 3)
							FROM TS_Match_Result AS X 
							LEFT JOIN TS_Match AS Y ON Y.F_MatchID = X.F_SourceMatchID
							WHERE X.F_CompetitionPositionDes1 = 2 AND X.F_MatchID =  B2.F_MatchID )
						  )
					,
				  CASE 
				  WHEN [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](D2.F_MatchID) IN ('',NULL)
						THEN (E2.F_CourtShortName + ',' + @EventCode + D2.F_RaceNum )
				  ELSE [dbo].[Fun_Report_BD_GetContestResultWinnerFirst](D2.F_MatchID)
				  END
				FROM TS_Match AS A 
				LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
				LEFT JOIN TS_Match AS D1 ON D1.F_MatchID = B1.F_SourceMatchID AND B1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TC_Court_Des AS E1 ON E1.F_CourtID = D1.F_CourtID AND E1.F_LanguageCode = 'ENG'
				LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
				LEFT JOIN TS_Match AS D2 ON D2.F_MatchID = B2.F_SourceMatchID AND B2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TC_Court_Des AS E2 ON E2.F_CourtID = D2.F_CourtID AND E2.F_LanguageCode = 'ENG'
				WHERE A.F_PhaseID = @PhaseID )ORDER BY A.F_Order
		END
	
	SELECT * FROM #TMP_TABLE
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

