IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_CreateXML_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_CreateXML_Schedule]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[Proc_BD_CreateXML_Schedule]
----功		  能：获取计时计分需要的日程
----作		  者：王强
----日		  期: 2011-5-10



CREATE PROCEDURE [dbo].[Proc_BD_CreateXML_Schedule] 
                   @DisciplineID    INT,
                   @DateID			INT,
                   @OutputXML		NVARCHAR(MAX) OUTPUT
AS
BEGIN
	
SET NOCOUNT ON
	DECLARE @Content NVARCHAR(MAX) = ''
	DECLARE @TempContent NVARCHAR(MAX)
	
	CREATE TABLE #TMP_TABLE
	(
		Match_No INT,
		MatchType INT,
		Athlete_A1 NVARCHAR(200),
		Athlete_A2 NVARCHAR(200),
		Athlete_B1 NVARCHAR(200),
		Athlete_B2 NVARCHAR(200)
	)
	
	DECLARE @MatchID INT
	
	DECLARE tmp_cursor CURSOR FOR 
	(
		SELECT C.F_MatchID FROM TS_DisciplineDate AS A
		LEFT JOIN TS_Session AS B ON B.F_SessionDate = A.F_Date
		LEFT JOIN TS_Match AS C ON C.F_SessionID = B.F_SessionID
		WHERE A.F_DisciplineID = @DisciplineID AND A.F_DisciplineDateID = @DateID
		AND ( NOT EXISTS( SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = C.F_MatchID AND F_RegisterID = NULL ) ) 
	)
	DECLARE @MatchType INT

	OPEN tmp_cursor

	FETCH NEXT FROM tmp_cursor INTO @MatchID
	WHILE @@FETCH_STATUS=0
		BEGIN
			
			SELECT @MatchType = C.F_PlayerRegTypeID FROM TS_Match AS A
			LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
			WHERE A.F_MatchID = @MatchID
			
			--Match头部		
			SET @TempContent = 
			(
				SELECT dbo.Fun_BDTT_GetMatchRscCode(X.F_MatchID) AS MatchCode,
					 Z.F_CourtCode AS FieldCode,  dbo.Fun_Report_BD_GetDateTime(X.F_MatchDate,10 ) + dbo.Fun_Report_BD_GetDateTime(X.F_StartTime,11 ) AS [DateTime],
					 ISNULL(dbo.Fun_BDTT_GetPlayerNOC(Y1.F_RegisterID),'') AS Noc_A, ISNULL(dbo.Fun_BDTT_GetPlayerNOC(y2.F_RegisterID),'') AS Noc_B
				FROM TS_Match AS X
				LEFT JOIN TS_Match_Result AS Y1 ON Y1.F_MatchID = X.F_MatchID AND Y1.F_CompetitionPositionDes1 = 1
				LEFT JOIN TS_Match_Result AS Y2 ON Y2.F_MatchID = X.F_MatchID AND Y2.F_CompetitionPositionDes1 = 2
				LEFT JOIN TC_Court AS Z ON Z.F_CourtID = X.F_CourtID
				WHERE X.F_MatchID = @MatchID FOR XML RAW('Schedule')
			)
		
			SET @TempContent = REPLACE( @TempContent, '/' , '')
			
			--单打
			IF @MatchType = 1
			BEGIN
			SET @TempContent +=
				(
					SELECT '0' AS Match_No, '0' AS MatchType, ISNULL(C1.F_SBShortName,'') AS Athlete_A1, '' AS Athlete_A2,  
						   ISNULL(C2.F_SBShortName,'') AS Athlete_B1, '' AS Athlete_B2  
					FROM TS_Match AS A 
					LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
					LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
					LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
					LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
					WHERE A.F_MatchID = @MatchID FOR XML RAW('SubMatch')
				)
			END 
			ELSE IF @MatchType = 2
			BEGIN
				SET @TempContent +=
				(SELECT '0' AS Match_No, '0' AS MatchType, ISNULL(D1.F_SBShortName,'') AS Athlete_A1, 
							ISNULL(D2.F_SBShortName,'') AS Athlete_A2,  
						   ISNULL(D3.F_SBShortName,'') AS Athlete_B1, ISNULL(D4.F_SBShortName,'') AS Athlete_B2  
					FROM TS_Match AS A 
					LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = 1
				
					LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
					LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = 'ENG'
					LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
					LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = 'ENG'
					
					LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = 2
					
					LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
					LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = 'ENG'
					LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
					LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = 'ENG'
					WHERE A.F_MatchID = @MatchID FOR XML RAW('SubMatch')
				)
				
			END
			ELSE IF @MatchType = 3
			BEGIN
				
					DELETE FROM #TMP_TABLE
					INSERT INTO #TMP_TABLE (Match_No, MatchType, Athlete_A1, Athlete_A2, Athlete_B1, Athlete_B2)
					(
						SELECT A.F_Order, A.F_MatchSplitType, ISNULL(C1.F_SBShortName,'') AS Athlete_A1, '' AS Athlete_A2,  
							   ISNULL(C2.F_SBShortName,'') AS Athlete_B1, '' AS Athlete_B2  
						FROM TS_Match_Split_Info AS A 
						LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
						LEFT JOIN TR_Register_Des AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_LanguageCode = 'ENG'
						LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
						LEFT JOIN TR_Register_Des AS C2 ON C2.F_RegisterID = B2.F_RegisterID AND C2.F_LanguageCode = 'ENG'
						WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND F_MatchSplitType IN (1,2)
					)
					
					INSERT INTO #TMP_TABLE (Match_No, MatchType, Athlete_A1, Athlete_A2, Athlete_B1, Athlete_B2)
					(
						SELECT A.F_Order AS Match_No, A.F_MatchSplitType, ISNULL(D1.F_SBShortName,'') AS Athlete_A1, ISNULL(D2.F_SBShortName,'') AS Athlete_A2,  
						   ISNULL(D3.F_SBShortName,'') AS Athlete_B1, ISNULL(D4.F_SBShortName,'') AS Athlete_B2  
						FROM TS_Match_Split_Info AS A 
						LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID
									AND B1.F_CompetitionPosition = 1
					
						LEFT JOIN TR_Register_Member AS C1 ON C1.F_RegisterID = B1.F_RegisterID AND C1.F_Order = 1
						LEFT JOIN TR_Register_Des AS D1 ON D1.F_RegisterID = C1.F_MemberRegisterID AND D1.F_LanguageCode = 'ENG'
						LEFT JOIN TR_Register_Member AS C2 ON C2.F_RegisterID = B1.F_RegisterID AND C2.F_Order = 2
						LEFT JOIN TR_Register_Des AS D2 ON D2.F_RegisterID = C2.F_MemberRegisterID AND D2.F_LanguageCode = 'ENG'
						
						LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID
									AND B2.F_CompetitionPosition = 2
						
						LEFT JOIN TR_Register_Member AS C3 ON C3.F_RegisterID = B2.F_RegisterID AND C3.F_Order = 1
						LEFT JOIN TR_Register_Des AS D3 ON D3.F_RegisterID = C3.F_MemberRegisterID AND D3.F_LanguageCode = 'ENG'
						LEFT JOIN TR_Register_Member AS C4 ON C4.F_RegisterID = B2.F_RegisterID AND C4.F_Order = 2
						LEFT JOIN TR_Register_Des AS D4 ON D4.F_RegisterID = C4.F_MemberRegisterID AND D4.F_LanguageCode = 'ENG'
						WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND F_MatchSplitType IN (3,4,5)
					)
				
					SET @TempContent += ( SELECT * FROM #TMP_TABLE AS SubMatch ORDER BY Match_No FOR XML AUTO)
						
			END
			
			SET @TempContent += '</Schedule>'
			SET @Content += ISNULL(@TempContent, '')
	
			FETCH NEXT FROM tmp_cursor INTO @MatchID
		END
	CLOSE tmp_cursor
	DEALLOCATE tmp_cursor
	
	DROP TABLE #TMP_TABLE
	
	SET @Content = '<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>' + '<ScheduleInfo>' + @Content + '</ScheduleInfo>'
	
	SET @OutputXML = @Content
SET NOCOUNT OFF
END


GO