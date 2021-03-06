IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_UpdateMatchStatistic]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_UpdateMatchStatistic]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_HO_UpdateMatchStatistic]
--描    述：每场比赛结束时,更新Match种两个Team的技术统计
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年09月06日


CREATE PROCEDURE [dbo].[Proc_HO_UpdateMatchStatistic](
												@MatchID		    INT
)
As
Begin
SET NOCOUNT ON 

    DECLARE @Result AS INT
    SET @Result=0;  -- @Result = 0; 	失败，标示没有做任何操作！
					-- @Result = 1; 	成功！
					
    DECLARE @HFGGaol AS INT
    DECLARE @HFGMiss AS INT
    DECLARE @HPCGaol AS INT
    DECLARE @HPCMiss AS INT
    DECLARE @HPSGoal AS INT
    DECLARE @HPSMiss AS INT
    DECLARE @HGCard  AS INT
    DECLARE @HYCard  AS INT
    DECLARE @HRCard  AS INT
    
    DECLARE @VFGGaol AS INT
    DECLARE @VFGMiss AS INT
    DECLARE @VPCGaol AS INT
    DECLARE @VPCMiss AS INT
    DECLARE @VPSGoal AS INT
    DECLARE @VPSMiss AS INT
    DECLARE @VGCard  AS INT
    DECLARE @VYCard  AS INT
    DECLARE @VRCard  AS INT
    
    SELECT @HFGGaol = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'FGGoal' AND MA.F_CompetitionPosition = 1
    
    SELECT @HFGMiss = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'FGMiss' AND MA.F_CompetitionPosition = 1
    
    SELECT @HPCGaol = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PCGaol' AND MA.F_CompetitionPosition = 1
    
    SELECT @HPCMiss = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PCMiss' AND MA.F_CompetitionPosition = 1
    
    SELECT @HPSGoal = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PSGoal' AND MA.F_CompetitionPosition = 1
    
    SELECT @HPSMiss = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PSMiss' AND MA.F_CompetitionPosition = 1
    
    SELECT @HGCard = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'GCard' AND MA.F_CompetitionPosition = 1
    
    SELECT @HYCard = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'YCard' AND MA.F_CompetitionPosition = 1
    
    SELECT @HRCard = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'RCard' AND MA.F_CompetitionPosition = 1
    
    SELECT @VFGGaol = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'FGGoal' AND MA.F_CompetitionPosition = 2
    
    SELECT @VFGMiss = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'FGMiss' AND MA.F_CompetitionPosition = 2
    
    SELECT @VPCGaol = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PCGaol' AND MA.F_CompetitionPosition = 2
    
    SELECT @VPCMiss = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PCMiss' AND MA.F_CompetitionPosition = 2
    
    SELECT @VPSGoal = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PSGoal' AND MA.F_CompetitionPosition = 2
    
    SELECT @VPSMiss = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'PSMiss' AND MA.F_CompetitionPosition = 2
    
    SELECT @VGCard = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'GCard' AND MA.F_CompetitionPosition = 2
    
    SELECT @VYCard = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'YCard' AND MA.F_CompetitionPosition = 2
    
    SELECT @VRCard = COUNT(MA.F_ActionNumberID)
    FROM TS_Match_ActionList AS MA
    LEFT JOIN TD_ActionType AS A ON MA.F_ActionTypeID = A.F_ActionTypeID
    WHERE MA.F_MatchID = @MatchID AND A.F_ActionCode = 'RCard' AND MA.F_CompetitionPosition = 2
    
    SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
    UPDATE TS_Match_Result SET F_WinPoints = @HFGGaol, F_LosePoints = @HFGGaol + @HFGMiss, F_WinSets = @HPCGaol
    , F_DrawSets = @HPCGaol + @HPCMiss, F_LoseSets = @HPSGoal, F_WinSets_1 = @HPSGoal + @HPSMiss
    , F_LoseSets_1 = @HGCard, F_WinSets_2 = @HYCard, F_LoseSets_2 = @HRCard
    , F_PointsCharDes1 = @VFGGaol, F_PointsCharDes2 = @VFGGaol + @VFGMiss, F_PointsCharDes3 = @VPCGaol
    , F_PointsCharDes4 = @VPCGaol + @VPCMiss, F_PointsNumDes1 = @VPSGoal, F_PointsNumDes2 = @VPSGoal + @VPSMiss
    , F_PointsNumDes3 = @VGCard, F_PointsNumDes4 = @VYCard, F_StartTimeNumDes = @VRCard
    WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

     UPDATE TS_Match_Result SET F_WinPoints = @VFGGaol, F_LosePoints = @VFGGaol + @VFGMiss, F_WinSets = @VPCGaol
    , F_DrawSets = @VPCGaol + @VPCMiss, F_LoseSets = @VPSGoal, F_WinSets_1 = @VPSGoal + @VPSMiss
    , F_LoseSets_1 = @VGCard, F_WinSets_2 = @VYCard, F_LoseSets_2 = @VRCard
    , F_PointsCharDes1 = @HFGGaol, F_PointsCharDes2 = @HFGGaol + @HFGMiss, F_PointsCharDes3 = @HPCGaol
    , F_PointsCharDes4 = @HPCGaol + @HPCMiss, F_PointsNumDes1 = @HPSGoal, F_PointsNumDes2 = @HPSGoal + @HPSMiss
    , F_PointsNumDes3 = @HGCard, F_PointsNumDes4 = @HYCard, F_StartTimeNumDes = @HRCard
    WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2

    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

    COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

Set NOCOUNT OFF
End

GO

/*EXEC Proc_HO_UpdateMatchStatistic 19*/

