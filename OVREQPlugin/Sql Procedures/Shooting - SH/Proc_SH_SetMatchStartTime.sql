
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_SetMatchStartTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_SetMatchStartTime]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_SH_SetMatchStartTime] (	
	@MatchID				INT,
	@CompetitionPosition	INT,
	@StartTime				TIME
)	
AS
BEGIN
	
SET NOCOUNT ON

	UPDATE TS_Match_Result SET F_StartTimeCharDes = CAST(@StartTime AS NVARCHAR(5))
	WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

	
SET NOCOUNT OFF
END

GO


-- EXEC Proc_SH_SetMatchStartTime 243,1,'9:30'

