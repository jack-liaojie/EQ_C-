IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SL_UpdateForerunRegisterInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SL_UpdateForerunRegisterInfo]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_SL_UpdateForerunRegisterInfo]
----功		  能：
----作		  者：吴定昉 
----日		  期: 2010-07-07 

CREATE PROCEDURE [dbo].[Proc_SL_UpdateForerunRegisterInfo] 
	@MatchID				INT,
	@CompetitionPosition	INT,
    @RegisterID                 INT,
    @Event                  NVARCHAR(100),
	@Return  			    AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON
	
    DECLARE @EventID        INT
    DECLARE @OldRegisterID  INT


	SET @Return=0;  -- @Return=0; 	更新Match失败，标示没有做任何操作！
					-- @Return=1; 	更新Match成功，返回！
					-- @Return=-1; 	更新Match失败，@MatchID无效


	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Return = -1
		RETURN
	END

	SELECT @EventID = E.F_EventID FROM TS_Match AS M 
	LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID 
	LEFT JOIN TS_Event AS E ON P.F_EventID = E.F_EventID
    WHERE F_MatchID = @MatchID

	SELECT @OldRegisterID = MR.F_RegisterID FROM TS_Match_Result AS MR 
    WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
 
    IF @RegisterID <> -1
    BEGIN
		IF NOT EXISTS(SELECT F_EventID,F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID)
		BEGIN
			IF NOT EXISTS(SELECT F_EventID,F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID = @OldRegisterID)
			BEGIN
			   INSERT INTO TR_Inscription(F_EventID,F_RegisterID,F_InscriptionResult)
			   VALUES(@EventID,@RegisterID,@Event)
			END
			ELSE
			BEGIN
			   UPDATE TR_Inscription SET F_EventID = @EventID, F_RegisterID = @RegisterID, F_InscriptionResult = @Event
			   WHERE F_EventID = @EventID AND F_RegisterID = @OldRegisterID
			END
		END
		UPDATE TS_Match_Result SET F_RegisterID = @RegisterID WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
    END
    ELSE
    BEGIN
       DELETE FROM TR_Inscription WHERE F_EventID = @EventID AND F_RegisterID = @OldRegisterID
       UPDATE TS_Match_Result SET F_RegisterID = NULL WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
    END
    
    
    IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Return=0
		RETURN
	END

	COMMIT TRANSACTION --成功提交事务


	SET @Return = 1
	RETURN


SET NOCOUNT OFF
END
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

/*

-- Just for test
EXEC [Proc_SL_UpdateForerunRegisterInfo] 1,1,-1,'',null

*/

