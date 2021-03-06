IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchAllSetPointsDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchAllSetPointsDes]


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE FUNCTION [dbo].[Fun_GetMatchAllSetPointsDes]
								(
									@MatchID					INT
								)
RETURNS nvarchar(100)
AS
BEGIN

	DECLARE @Return		AS nvarchar(100)

	declare @loop as int
	set @loop = 1

	while (@loop<=3)
	begin
		DECLARE @Points		AS nvarchar(100)
		DECLARE @Points1	AS INT
		DECLARE @Points2	AS INT

		SELECT  @Points1 = (case when A.F_Points is null then 0 else  A.F_Points end) FROM ts_match_split_result As A left join ts_match_split_info as B 
		on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
		where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1
				AND B.F_FatherMatchSplitID=0 and B.F_MatchSplitID=@loop

		SELECT  @Points2 = (case when A.F_Points is null then 0 else  A.F_Points end) FROM ts_match_split_result As A left join ts_match_split_info as B 
		on A.F_MatchId = B.F_MatchID and A.F_MatchSplitId = B.F_MatchSplitId
		where A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2
				AND B.F_FatherMatchSplitID=0 and B.F_MatchSplitID=@loop
		
		if(@Points1+@Points2>0)	set @Points = cast(@Points1  as nvarchar(50)) + cast(@Points2  as nvarchar(50)) + ' '

		set @Return = @Return + @Points

		set @loop = @loop + 1
	end

	RETURN @Return

END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

-- select * from ts_match_split_info