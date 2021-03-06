IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_DeleteMatchAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_DeleteMatchAction]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BD_DeleteMatchAction]
--描    述：删除比赛历程
--创 建 人：王强
--日    期：2011年08月14日


CREATE PROCEDURE [dbo].[Proc_BD_DeleteMatchAction](
												@MatchID		    INT,
												@Order              INT
)
As
Begin
SET NOCOUNT ON 
	
	DECLARE @MatchType INT
	
	SELECT @MatchType = C.F_PlayerRegTypeID
	FROM TS_Match AS A
	LEFT JOIN TS_Phase AS B ON B.F_PhaseID = A.F_PhaseID
	LEFT JOIN TS_Event AS C ON C.F_EventID = B.F_EventID
	WHERE A.F_MatchID = @MatchID
	
	IF @MatchType = 3
	BEGIN
		IF @Order BETWEEN 1 AND 5
		BEGIN
			DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND
			F_MatchSplitID IN
			(
				SELECT B.F_MatchSplitID FROM TS_Match_Split_Info AS A
				LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = A.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND A.F_Order = @Order AND A.F_FatherMatchSplitID = 0
			)
			RETURN
		END
	END
	
	DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
	
Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


GO

