if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchRegister]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_UpdateMatchRegister]
----功		  能：更改比赛的参赛人员
----作		  者：郑金勇 
----日		  期: 2009-04-17

CREATE PROCEDURE [dbo].[Proc_UpdateMatchRegister] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@RegisterID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	编辑Sport失败，标示没有做任何操作！
					-- @Result = 1; 	编辑Sport成功！
	IF (@RegisterID = -2 OR @RegisterID = 0)
	BEGIN
		SET @RegisterID = NULL
	END
	
	DECLARE @OldRegisterID	AS INT
	DECLARE @EventID		AS INT
	DECLARE @StartPhaseID	AS INT
	DECLARE @StartPosition	AS INT
	
	SELECT @EventID = B.F_EventID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchID = @MatchID
	SELECT @OldRegisterID = F_RegisterID, @StartPhaseID = ISNULL(F_StartPhaseID, 0), @StartPosition = ISNULL(F_StartPhasePosition, 0) FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
	BEGIN TRY
		UPDATE TS_Match_Result SET F_RegisterID = @RegisterID 
			WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

		IF @StartPosition != 0
		BEGIN
			IF @StartPhaseID = 0
			BEGIN
			
				IF EXISTS (SELECT F_EventID FROM TS_Event_Position WHERE F_EventID = @EventID AND F_EventPosition = @StartPosition)
				BEGIN
					UPDATE TS_Event_Position SET F_RegisterID = @RegisterID WHERE F_EventID = @EventID AND F_EventPosition = @StartPosition
				END
				ELSE
				BEGIN
					INSERT INTO TS_Event_Position (F_EventID, F_EventPosition, F_RegisterID) VALUES (@EventID, @StartPosition, @RegisterID)
				END
				
				IF @RegisterID IS NOT NULL
				BEGIN
					IF NOT EXISTS(SELECT F_EventID FROM TS_Event_Competitors WHERE F_EventID = @EventID AND F_RegisterID = @RegisterID)
					BEGIN
						INSERT INTO TS_Event_Competitors (F_EventID, F_RegisterID) VALUES (@EventID, @RegisterID)
					END
				END
				ELSE
				BEGIN
					DELETE FROM TS_Event_Competitors WHERE F_EventID = @EventID AND F_RegisterID = @OldRegisterID
				END
			END
			ELSE
			BEGIN
				
				IF EXISTS (SELECT F_PhaseID FROM TS_Phase_Position WHERE F_PhaseID = @StartPhaseID AND F_PhasePosition = @StartPosition)
				BEGIN
					UPDATE TS_Phase_Position SET F_RegisterID = @RegisterID WHERE F_PhaseID = @StartPhaseID AND F_PhasePosition = @StartPosition
				END
				ELSE
				BEGIN
					INSERT INTO TS_Phase_Position (F_PhaseID, F_PhasePosition, F_RegisterID) VALUES (@StartPhaseID, @StartPosition, @RegisterID)
				END
				
				IF @RegisterID IS NOT NULL
				BEGIN
					IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase_Competitors WHERE F_PhaseID = @StartPhaseID AND F_RegisterID = @RegisterID)
					BEGIN
						INSERT INTO TS_Phase_Competitors (F_PhaseID, F_RegisterID) VALUES (@StartPhaseID, @RegisterID)
					END
				END
				ELSE
				BEGIN
					DELETE FROM TS_Phase_Competitors WHERE F_PhaseID = @StartPhaseID AND F_RegisterID = @OldRegisterID
				END
			END
		END
	END TRY
	BEGIN CATCH
		
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;--出错回滚事务
			
		SET @Result = 0
		RETURN
		
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;--成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

