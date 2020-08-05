IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchCourt]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchCourt]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_GetMatchCourt]
								(
									@MatchID		INT,
									@LanguageCode	nvarchar(100)
								)
RETURNS nvarchar(100)
AS
BEGIN
	declare @return as nvarchar(100)
	declare @CourtID as int
	select @CourtID = F_CourtID from ts_match where F_MatchID = @MatchID
	select @return = F_CourtShortName from tc_court_des where F_CourtID = @CourtID and F_LanguageCode = @LanguageCode
	return @return
END


GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO