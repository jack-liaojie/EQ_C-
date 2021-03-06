IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Info_BDTT_New_GetMatchResultDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Info_BDTT_New_GetMatchResultDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--王强 2012-09-13
--获取比赛结果描述
CREATE FUNCTION [dbo].[Fun_Info_BDTT_New_GetMatchResultDes]
								(
									@MatchID INT,
									@SplitOrder INT,--单项比赛时忽略
									@GameOrder INT --SplitOrder和GameOrder都<=0时，取大比分
								)
RETURNS NVARCHAR(200)
AS
BEGIN
	/*
	大比分获取的情况为：单项赛：GameOrder <= 0  团体赛：SplitOrder <= 0
	盘比分获取的情况为：团体赛：SplitOrder > 0 GameOrder <= 0
	局比分获取的情况为：单项赛：GameOrder > 0  团体赛：SplitOrder > 0, GameOrder > 0 
	*/
	DECLARE @Res NVARCHAR(200)
	DECLARE @EventType INT
	SELECT @EventType = C.F_PlayerRegTypeID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID  = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	--大比分
	IF ( @EventType != 3 AND @GameOrder <= 0 ) OR (@EventType = 3 AND @SplitOrder <=0 )
	BEGIN
		SELECT @Res = CASE WHEN B1.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B1.F_Points) END
					+ CASE WHEN C1.F_IRMCODE IS NULL THEN '' ELSE '(' + C1.F_IRMCODE + ')' END
					+ ':' 
					+ CASE WHEN B2.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B2.F_Points) END
					+ CASE WHEN C2.F_IRMCODE IS NULL THEN '' ELSE '(' + C2.F_IRMCODE + ')' END
		FROM TS_Match AS A
		LEFT JOIN TS_Match_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_CompetitionPosition = 1
		LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
		LEFT JOIN TS_Match_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
		WHERE A.F_MatchID = @MatchID
	END
	
	--团体盘比分
	IF ( @EventType = 3 AND @SplitOrder > 0 AND @GameOrder <= 0 )
	BEGIN
		SELECT @Res = CASE WHEN B1.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B1.F_Points) END
					+ CASE WHEN C1.F_IRMCODE IS NULL THEN '' ELSE '(' + C1.F_IRMCODE + ')' END
					+ ':' 
					+ CASE WHEN B2.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B2.F_Points) END
					+ CASE WHEN C2.F_IRMCODE IS NULL THEN '' ELSE '(' + C2.F_IRMCODE + ')' END
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
		LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
		WHERE A.F_MatchID = @MatchID AND A.F_Order = @SplitOrder AND A.F_FatherMatchSplitID = 0
	END
	
	--团体局比分
	IF ( @EventType = 3 AND @SplitOrder > 0 AND @GameOrder > 0 )
	BEGIN
		SELECT @Res = CASE WHEN B1.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B1.F_Points) END
					+ CASE WHEN C1.F_IRMCODE IS NULL THEN '' ELSE '(' + C1.F_IRMCODE + ')' END
					+ ':' 
					+ CASE WHEN B2.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B2.F_Points) END
					+ CASE WHEN C2.F_IRMCODE IS NULL THEN '' ELSE '(' + C2.F_IRMCODE + ')' END
		FROM TS_Match_Split_Info AS X
		LEFT JOIN TS_Match_Split_Info AS A ON A.F_MatchID = X.F_MatchID AND A.F_FatherMatchSplitID = X.F_MatchSplitID AND A.F_Order = @GameOrder
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
		LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
		WHERE X.F_MatchID = @MatchID AND X.F_Order = @SplitOrder AND X.F_FatherMatchSplitID = 0
	END
	
	--单打局比分
	IF( @EventType != 3 AND @GameOrder > 0 )
	BEGIN
		SELECT @Res = CASE WHEN B1.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B1.F_Points) END
					+ CASE WHEN C1.F_IRMCODE IS NULL THEN '' ELSE '(' + C1.F_IRMCODE + ')' END
					+ ':' 
					+ CASE WHEN B2.F_Points IS NULL THEN '' ELSE CONVERT(NVARCHAR(10), B2.F_Points) END
					+ CASE WHEN C2.F_IRMCODE IS NULL THEN '' ELSE '(' + C2.F_IRMCODE + ')' END
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Result AS B1 ON B1.F_MatchID = A.F_MatchID AND B1.F_MatchSplitID = A.F_MatchSplitID AND B1.F_CompetitionPosition = 1
		LEFT JOIN TC_IRM AS C1 ON C1.F_IRMID = B1.F_IRMID
		LEFT JOIN TS_Match_Split_Result AS B2 ON B2.F_MatchID = A.F_MatchID AND B2.F_MatchSplitID = A.F_MatchSplitID AND B2.F_CompetitionPosition = 2
		LEFT JOIN TC_IRM AS C2 ON C2.F_IRMID = B2.F_IRMID
		WHERE A.F_MatchID = @MatchID AND A.F_Order = @GameOrder AND A.F_FatherMatchSplitID = 0
	END
	
	IF @Res = ':' OR @Res IS NULL
		SET @Res = ''
	RETURN @Res
END


GO

--PRINT [dbo].[Fun_BDTT_New_GetMatchResultDes](63,2,5)