IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TT_GetMatchSplitIDFromOrder]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TT_GetMatchSplitIDFromOrder]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--王强2011-05-27  从Order获取到局ID

CREATE FUNCTION [dbo].[Fun_TT_GetMatchSplitIDFromOrder]
								(
									@MatchID					INT,
									@SetOrder INT,
									@GameOrder INT
								)
RETURNS INT
AS
BEGIN

	
	DECLARE @Res INT
	SELECT @Res = B.F_MatchSplitID FROM TS_Match_Split_Info AS A
	LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = A.F_MatchSplitID AND 
				B.F_Order = @GameOrder
	WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = @SetOrder

	IF @Res IS NULL
		RETURN -1
	RETURN @Res
END


GO

