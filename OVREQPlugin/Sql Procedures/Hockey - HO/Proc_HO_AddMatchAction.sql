 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_HO_AddMatchAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_HO_AddMatchAction]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--名    称：[Proc_HO_AddMatchAction]
--描    述：更新Match的Action信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2012年08月29日


CREATE PROCEDURE [dbo].[Proc_HO_AddMatchAction](
                                                @ActionID           INT = -1,
												@MatchID		    INT,
												@MatchSplitID       INT,
                                                @RegisterID         INT,
                                                @TeamPos            INT,
                                                @ActionCode         NVARCHAR(20),
                                                @ActionHappenTime   DateTime,
                                                @Result             AS INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

    SET @Result = 0   -- @Result=0; 	修改失败，标示没有做任何操作！
					  -- @Result>=1; 	修改成功！
    
    DECLARE @NewActionID   INT
    DECLARE @DisciplineID  INT
    DECLARE @ActionTypeID  INT
    DECLARE @ActionOrder   INT
    
    IF(@ActionID <> -1 AND EXISTS (SELECT F_ActionNumberID FROM TS_Match_ActionList WHERE F_ActionNumberID = @ActionID))
    BEGIN
       UPDATE TS_Match_ActionList  SET F_MatchID = @MatchID, F_MatchSplitID = @MatchSplitID, F_CompetitionPosition = @TeamPos,
                                      F_RegisterID = @RegisterID, F_ActionTypeID = @ActionTypeID, F_ActionHappenTime = @ActionHappenTime, 
                                      F_ActionOrder= @ActionOrder
                                 WHERE F_ActionNumberID = @ActionID
    END
    ELSE
    BEGIN
    
			SELECT @DisciplineID = E.F_DisciplineID FROM TS_Match AS M LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
					 LEFT JOIN TS_Event AS E On P.F_EventID = E.F_EventID 
				WHERE M.F_MatchID = @MatchID
		    
			IF NOT EXISTS(SELECT F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = @DisciplineID AND F_ActionCode = @ActionCode)
			BEGIN
			   SET @Result = -1
			   RETURN
			END
			ELSE
			BEGIN
			   SELECT @ActionTypeID = F_ActionTypeID FROM TD_ActionType WHERE F_DisciplineID = @DisciplineID AND F_ActionCode = @ActionCode
			END

			SELECT @ActionOrder = (CASE WHEN MAX(F_ActionOrder) IS NULL THEN 0 ELSE MAX(F_ActionOrder) END) + 1 FROM TS_Match_ActionList WHERE F_MatchID = @MatchID

			SET Implicit_Transactions off
			BEGIN TRANSACTION --设定事务
		       
			INSERT INTO TS_Match_ActionList (F_MatchID, F_MatchSplitID, F_CompetitionPosition, F_RegisterID, F_ActionTypeID, F_ActionHappenTime, F_ActionOrder)
					VALUES (@MatchID, @MatchSplitID, @TeamPos, @RegisterID, @ActionTypeID, @ActionHappenTime, @ActionOrder)
				
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
		   
			SET @NewActionID = @@IDENTITY
				

			COMMIT TRANSACTION --成功提交事务

			SET @Result = @NewActionID
			RETURN
	  END

    
          
Set NOCOUNT OFF
End

GO





