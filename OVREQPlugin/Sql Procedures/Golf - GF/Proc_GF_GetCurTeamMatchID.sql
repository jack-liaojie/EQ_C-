IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetCurTeamMatchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetCurTeamMatchID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--名    称：[Proc_GF_GetCurTeamMatchID]
--描    述：得到团体比赛的MatchID
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2010年10月18日


CREATE PROCEDURE [dbo].[Proc_GF_GetCurTeamMatchID](
												@MatchID		    INT,
												@Result		        AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON

    SET @Result = -1

	SET LANGUAGE ENGLISH
							
	DECLARE @SexCode AS INT
	DECLARE @IndividualEventID AS INT
	DECLARE @PhaseOrder AS INT
    DECLARE @TeamEventID AS INT

    SELECT @SexCode = E.F_SexCode, @IndividualEventID = E.F_EventID, @PhaseOrder = P.F_Order FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID WHERE M.F_MatchID = @MatchID
    
    SELECT TOP 1 @TeamEventID = F_EventID FROM TS_Event WHERE F_SexCode = @SexCode AND F_PlayerRegTypeID = 3
    
    SELECT TOP 1 @Result = M.F_MatchID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
    WHERE P.F_EventID = @TeamEventID AND P.F_Order = @PhaseOrder

Set NOCOUNT OFF
End

GO


