
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchSetPointsBySet]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchSetPointsBySet]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_GetMatchSetPointsBySet]
								(
									@MatchID					INT,
									@SplitSet					INT,
									@CompetitionPosition		INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @Points	AS INT
	declare @setcount as int
	select @setcount = count(*) from ts_match_split_info where f_matchid = @MatchID and f_matchSplitID = @SplitSet
	if(@setcount<=0)
		return Null

	SELECT  @Points = A.F_Points FROM ts_match_split_result As A left join ts_match_split_info as B 
	on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
	where B.F_FatherMatchSplitID=0 AND A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @CompetitionPosition
			AND B.F_MatchSplitID = @SplitSet AND B.F_FatherMatchSplitID=0
	

--	if @Points is null set @Points=0

	RETURN @Points

END


GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
