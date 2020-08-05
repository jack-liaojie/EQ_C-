IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchSession]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchSession]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_GetMatchSession]
								(
									@MatchID		INT,
									@LanguageCode	nvarchar(100)
								)
RETURNS nvarchar(100)
AS
BEGIN
	declare @return as nvarchar(100)
	declare @sessionID as int
	declare @sessionTypeID as int
	select @sessionID = F_SessionID from ts_match where F_MatchID = @MatchID
	select @sessionTypeID = F_SessionTypeID from ts_session
	select @return = F_SessionTypeShortName from tc_sessionType_des where F_SessionTypeID = @sessionTypeID and F_LanguageCode = @LanguageCode
	return @return
END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO