IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchOrderInSession]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchOrderInSession]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_GetMatchOrderInSession]
								(
									@MatchID		INT
								)
RETURNS INT
AS
BEGIN
	declare @return as INT
	select @return = F_OrderInsession from ts_match where F_MatchID = @MatchID

	return @return
END

GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO