
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_SetTeamIRM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_SetTeamIRM]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Proc_SH_SetTeamIRM]
	@MatchID				INT
AS
BEGIN
SET NOCOUNT ON

	UPDATE TS_Match_Result SET F_IRMID = B.F_IRMID
	FROM TS_Match_Result A
	RIGHT JOIN (SELECT * FROM dbo.[Func_SH_GetTeamIRM](@MatchID)) AS B ON A.F_RegisterID = B.F_RegisterID
    
    
 	--IRM
	UPDATE TS_Match_Result 
	SET F_Rank = B.[Rank]
	FROM TS_Match_Result A
	LEFT JOIN dbo.[Func_SH_GetTeamResult] (@MatchID) B ON A.F_RegisterID = B.TeamID
	WHERE F_MatchID = @MatchID 
	
	UPDATE TS_Match_Result 
	SET F_Rank = 999, F_Points = NULL
	FROM TS_Match_Result A
	WHERE A.F_MatchID = @MatchID AND F_IRMID = 3

	UPDATE TS_Match_Result 
	SET F_Rank = 998
	FROM TS_Match_Result A
	WHERE A.F_MatchID = @MatchID AND F_IRMID = 2

	UPDATE TS_Match_Result 
	SET F_Rank = 997
	FROM TS_Match_Result A
	WHERE A.F_MatchID = @MatchID AND F_IRMID = 1
   
SET NOCOUNT OFF
END
GO

SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO

/*
EXEC [Proc_SH_SetTeamIRM] 62
*/
