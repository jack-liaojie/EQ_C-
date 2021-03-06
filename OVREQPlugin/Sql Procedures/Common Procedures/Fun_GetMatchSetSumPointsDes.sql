IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchSetSumPointsDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchSetSumPointsDes]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_GetMatchSetSumPointsDes]
								(
									@MatchID	INT
								)
RETURNS nvarchar(100)
AS
BEGIN

	DECLARE @Points	AS nvarchar(100)
	DECLARE @Points1	AS INT
	DECLARE @Points2	AS INT
	SELECT  @Points1 = Sum(case when A.F_Points is null then 0 else  A.F_Points end) FROM ts_match_split_result As A left join ts_match_split_info as B 
	on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
	where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
			AND B.F_FatherMatchSplitID=0

	SELECT  @Points2 = Sum(case when A.F_Points is null then 0 else  A.F_Points end) FROM ts_match_split_result As A left join ts_match_split_info as B 
	on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
	where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
			AND B.F_FatherMatchSplitID=0
	
	set @Points = cast(@Points1  as nvarchar(50)) + ':' + cast(@Points2  as nvarchar(50))

	RETURN @Points

END



GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO