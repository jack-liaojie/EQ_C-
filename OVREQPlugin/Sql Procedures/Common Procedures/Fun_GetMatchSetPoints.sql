/****** Object:  UserDefinedFunction [dbo].[Fun_GetMatchSetPoints]    Script Date: 05/22/2009 15:48:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchSetPoints]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchSetPoints]

/****** Object:  UserDefinedFunction [dbo].[Fun_GetMatchSetPoints]    Script Date: 05/22/2009 15:48:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE FUNCTION [dbo].[Fun_GetMatchSetPoints]
								(
									@MatchID					INT,
									@SetIndex					INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @Points1	AS INT
	DECLARE @Points2	AS INT
	SELECT  @Points1 = A.F_Points FROM ts_match_split_result As A left join ts_match_split_info as B 
	on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
	where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
			AND B.F_FatherMatchSplitID=0 and A.F_MatchSplitID = @SetIndex

	SELECT  @Points2 = A.F_Points FROM ts_match_split_result As A left join ts_match_split_info as B 
	on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
	where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
			AND B.F_FatherMatchSplitID=0 and A.F_MatchSplitID = @SetIndex
	
	if(@Points1 is null and @Points2 is null) return Null
	else RETURN cast(@Points1 as nvarchar(20)) + ':' + cast(@Points2 as nvarchar(20))

	return null

END


GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO