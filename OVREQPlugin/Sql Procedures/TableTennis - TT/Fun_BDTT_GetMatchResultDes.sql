IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_BDTT_GetMatchResultDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_BDTT_GetMatchResultDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--获取比赛结果描述
--2012-08-20  王强 
--用于全运会新增的全排名报表成绩展示
CREATE FUNCTION [dbo].[Fun_BDTT_GetMatchResultDes]
								(
									@MatchID INT,
									@WinnerFirst INT 
								)
RETURNS NVARCHAR(200)
AS
BEGIN
	DECLARE @Res NVARCHAR(200)
	DECLARE @MatchStatus INT
	DECLARE @EventCode NVARCHAR(20)
	DECLARE @Pos1 INT = 1
	DECLARE @Pos2 INT = 2
	SELECT @MatchStatus = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
	IF @MatchStatus IN (100,110)
	BEGIN
		IF @WinnerFirst = 1
		BEGIN
			SELECT @Pos1 = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_Rank = 1 AND F_MatchID = @MatchID
			SELECT @Pos2 = F_CompetitionPositionDes1 FROM TS_Match_Result WHERE F_Rank = 2 AND F_MatchID = @MatchID
		END
		
		SELECT @Res =
			   CASE WHEN B1.F_Points IS NOT NULL THEN CONVERT( NVARCHAR(10), B1.F_Points) ELSE '' END
			 + CASE WHEN C1.F_IRMID IS NOT NULL THEN '(' + C1.F_IRMCODE + ')' ELSE '' END
			 + ' : '
			 + CASE WHEN B2.F_Points IS NOT NULL THEN CONVERT( NVARCHAR(10), B2.F_Points) ELSE '' END
			 + CASE WHEN C2.F_IRMID IS NOT NULL THEN '(' + C2.F_IRMCODE + ')' ELSE '' END
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPositionDes1 = @Pos1
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPositionDes1 = @Pos2
		LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
		LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
		WHERE A.F_MatchID = @MatchID
	END
	RETURN @Res
END


GO

