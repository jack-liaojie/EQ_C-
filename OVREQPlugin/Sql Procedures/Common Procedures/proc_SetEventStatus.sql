IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_SetEventStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_SetEventStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[proc_SetEventStatus]
----��		  �ܣ�����Event��Status
----��		  �ߣ�֣���� 
----��		  ��: 2010-05-25 

CREATE PROCEDURE [dbo].[proc_SetEventStatus] 
	@EventID			INT,
	@StatusID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	����Event��Statusʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	����Event��Status�ɹ���
					-- @Result=-1; 	����Event��Statusʧ�ܣ�@EventID��Ч
					-- @Result=-2; 	����Event��Statusʧ�ܣ���Event����Phase����Event��״̬��������д˲�����
	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

--	IF (@StatusID = 0 OR @StatusID = 10)
--	BEGIN
--		IF (EXISTS (SELECT A.F_MatchID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchStatusID > 10 AND B.F_EventID = @EventID)
--			OR EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseStatusID > 10 AND F_EventID = @EventID))
--		BEGIN
--			SET @Result = -2
--			RETURN
--		END
--	END

	IF (@StatusID = 110)
	BEGIN
		IF (EXISTS (SELECT A.F_MatchID FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchStatusID < 110 AND B.F_EventID = @EventID)
			OR EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseStatusID < 110 AND F_EventID = @EventID))
		BEGIN
			SET @Result = -2
			RETURN
		END
	END
	ELSE
	BEGIN
		DECLARE @MaxPhase AS INT
		DECLARE @MaxMatch AS INT
		SELECT @MaxMatch = MAX(A.F_MatchStatusID) FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID
		SELECT @MaxPhase = MAX(F_PhaseStatusID) FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = 0
		SET @MaxMatch = ISNULL(@MaxMatch, 10)
		SET @MaxPhase = ISNULL(@MaxPhase, 10)
		IF ((@MaxMatch < @StatusID) AND (@MaxPhase < @StatusID))
		BEGIN
			SET @Result = -2
			RETURN
		END
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		UPDATE TS_Event SET  F_EventStatusID = @StatusID WHERE F_EventID = @EventID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




