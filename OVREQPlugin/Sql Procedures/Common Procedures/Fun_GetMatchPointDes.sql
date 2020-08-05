IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchPointsDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchPointsDes]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_GetMatchPointsDes]
								(
									@MatchID		INT,
									@Registerid1		INT,
									@Registerid2		INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN
	declare @Return		as	nvarchar(100)
	declare @Points1	as	int
	declare @Points2	as	int

	SELECT  @Points1 = F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_Registerid = @Registerid1
	SELECT  @Points2 = F_Points FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_Registerid = @Registerid2
	
	if(@Points1 is not null and @Points2 is not null)
	begin
		set @Return = cast(@Points1 as nvarchar(50)) + ':' + cast(@Points2 as nvarchar(50))
	end

	else
	begin
		set @Return	= ''
	end

	return @Return
END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO