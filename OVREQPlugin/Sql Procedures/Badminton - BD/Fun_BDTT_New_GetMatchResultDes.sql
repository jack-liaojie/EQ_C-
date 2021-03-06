IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_New_GetMatchResultDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_New_GetMatchResultDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--获取比赛结果描述
CREATE FUNCTION [dbo].[Fun_BDTT_New_GetMatchResultDes]
								(
									@MatchID INT,
									@Type INT, --1表示获取大比分,不存在则为比赛时间，--2表示获取局比分或盘比分，不存在则为场地
									@RegisterID INT,--排在前面的RegID
									@ScheduleOnly INT
								)
RETURNS NVARCHAR(200)
AS
BEGIN
	DECLARE @Res NVARCHAR(200)
	DECLARE @MatchStatus INT
	DECLARE @EventCode NVARCHAR(20)
	DECLARE @Pos1 INT
	DECLARE @Pos2 INT
	SELECT @MatchStatus = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
	IF @MatchStatus NOT IN (100,110) OR @ScheduleOnly = 1
	BEGIN
		IF @Type = 1
		BEGIN
			
			SELECT @Res = [dbo].[Fun_Report_BD_GetDateTime](A.F_MatchDate, 8) + ' ' + [dbo].[Fun_Report_BD_GetDateTime](A.F_StartTime, 3)
			FROM TS_Match AS A WHERE F_MatchID = @MatchID
		END
		ELSE IF @Type = 2
		BEGIN
			SELECT @EventCode = C.F_EventComment
			FROM TS_Match AS A
			LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
			LEFT JOIN TS_Event_Des AS C ON C.F_EventID = B.F_EventID AND C.F_LanguageCode = 'ENG'
			WHERE A.F_MatchID = @MatchID
			
			SELECT @Res = ISNULL(B.F_CourtShortName,'') + ',' + ISNULL(@EventCode,'') + ISNULL(A.F_RaceNum,'')
			FROM TS_Match AS A
			LEFT JOIN TC_Court_Des AS B ON B.F_CourtID = A.F_CourtID AND B.F_LanguageCode = 'ENG'
			WHERE A.F_MatchID = @MatchID
			
		END	 
	END
	ELSE
	BEGIN
		IF @RegisterID > 0
		BEGIN
			SELECT @Pos1 = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_RegisterID = @RegisterID AND F_MatchID = @MatchID
			SELECT @Pos2 = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_CompetitionPositionDes1 != @Pos1 AND F_MatchID = @MatchID
		END
		ELSE
		BEGIN
			SELECT @Pos1 = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_Rank=1 AND F_MatchID = @MatchID
			SELECT @Pos2 = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_Rank=2 AND F_MatchID = @MatchID
		END
		
		IF @Type = 1
		BEGIN
			SELECT @Res = CASE WHEN B1.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B1.F_Points) END
						+ CASE WHEN C1.F_IRMCODE IS NULL THEN '' ELSE '(' + C1.F_IRMCODE + ')' END
						+ ':' 
						+ CASE WHEN B2.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B2.F_Points) END
						+ CASE WHEN C2.F_IRMCODE IS NULL THEN '' ELSE '(' + C2.F_IRMCODE + ')' END
			FROM TS_Match AS A
			LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPosition = @Pos1
			LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
			LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPosition = @Pos2
			LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
			WHERE A.F_MatchID = @MatchID
		END
		ELSE IF @Type = 2
		BEGIN
			DECLARE @SplitID INT
			SET @Res = ''
			DECLARE @Temp NVARCHAR(100)
			DECLARE mycursor CURSOR FOR SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
			OPEN mycursor
			FETCH NEXT FROM mycursor INTO @SplitID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				SELECT @Temp = CASE WHEN B1.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B1.F_Points) END
						+ CASE WHEN C1.F_IRMCODE IS NULL THEN '' ELSE '(' + C1.F_IRMCODE + ')' END
						+ ':' 
						+ CASE WHEN B2.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B2.F_Points) END
						+ CASE WHEN C2.F_IRMCODE IS NULL THEN '' ELSE '(' + C2.F_IRMCODE + ')' END
				FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPosition = @Pos1 
									AND B1.F_MatchSplitID = A.F_MatchSplitID
				LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
				LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPosition = @Pos2 
									AND B2.F_MatchSplitID = A.F_MatchSplitID
				LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @SplitID
				
				IF @Temp != ':'
				BEGIN
					SET @Res += @Temp
					SET @Res += ','
				END
				FETCH NEXT FROM mycursor INTO @SplitID
			END
			CLOSE mycursor
			DEALLOCATE mycursor
			IF RIGHT(@Res,1) = ','
			BEGIN
				SET @Res = LEFT(@Res, LEN(@Res)-1)
			END
			SET @Res = '(' + @Res + ')'
		END
	END
	
	RETURN @Res
END


GO

--PRINT [dbo].[Fun_BDTT_New_GetMatchResultDes](63,2,5)