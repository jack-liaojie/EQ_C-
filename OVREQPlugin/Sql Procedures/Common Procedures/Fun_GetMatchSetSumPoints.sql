IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchSetSumPoints]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchSetSumPoints]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[Fun_GetMatchSetSumPoints]
								(
									@MatchID					INT,
									@CompetitionPosition		INT
								)
RETURNS INT
AS
BEGIN

	DECLARE @Points	AS INT
	SELECT  @Points = Sum(case when A.F_Points is null then 0 else  A.F_Points end) FROM ts_match_split_result As A left join ts_match_split_info as B 
	on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
	where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = @CompetitionPosition
			AND B.F_FatherMatchSplitID=0
	
	if @Points is null set @Points=0

	RETURN @Points

END

GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- test 
--select * from ts_match_split_result


