IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TT_GetGamePoint]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TT_GetGamePoint]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
作者：王强
功能：判断局点
*/

CREATE FUNCTION [dbo].[Fun_TT_GetGamePoint]
								(
									@MatchID					INT,
									@MatchSplitID               INT
								)
RETURNS INT--不是局点，返回0，A方局点返回1，B方局点返回2
AS
BEGIN
	DECLARE @GamePtA INT
	DECLARE @GamePtB INT
	
	SELECT @GamePtA = ISNULL(B.F_Points,0), @GamePtB = ISNULL(C.F_Points,0)
	FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Result AS B ON B.F_MatchID = A.F_MatchID AND B.F_MatchSplitID = A.F_MatchSplitID 
			AND B.F_CompetitionPosition = 1
	LEFT JOIN TS_Match_Split_Result AS C ON C.F_MatchID = A.F_MatchID AND C.F_MatchSplitID = A.F_MatchSplitID 
			AND C.F_CompetitionPosition = 2
	WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitID = @MatchSplitID
	
	IF @GamePtA = @GamePtB
		RETURN 0
	
	IF @GamePtA = 10 AND @GamePtA > @GamePtB
		RETURN 1
		
	IF @GamePtA > 10 AND (@GamePtA - @GamePtB = 1)
		RETURN 1
		
	IF @GamePtB = 10 AND @GamePtB > @GamePtA
		RETURN 2
		
	IF @GamePtB > 10 AND (@GamePtB - @GamePtA = 1)
		RETURN 2
		
	RETURN 0

END


GO

