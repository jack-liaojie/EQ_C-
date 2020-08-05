if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_UpdateMatchRegister]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_UpdateMatchRegister]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_UpdateMatchRegister]
----��		  �ܣ����ı����Ĳ�����Ա
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-17

CREATE PROCEDURE [dbo].[Proc_UpdateMatchRegister] (	
	@MatchID					INT,
	@CompetitionPosition		INT,
	@RegisterID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	�༭Sportʧ�ܣ���ʾû�����κβ�����
					-- @Result = 1; 	�༭Sport�ɹ���
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
	BEGIN TRANSACTION --�趨����
	
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
			ROLLBACK TRANSACTION;--����ع�����
			
		SET @Result = 0
		RETURN
		
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;--�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

