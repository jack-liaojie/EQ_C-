if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelEvent]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelEvent]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�proc_DelEvent
----��		  �ܣ�ɾ��һ��Event����ɾ����Event�����е���Phase������ɾ�����е�Match����Ҫ��Ϊ���ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-09

CREATE PROCEDURE proc_DelEvent 
	@EventID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ��Eventʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��Event�ɹ���
					-- @Result=-1; 	ɾ��Eventʧ�ܣ���EventID��Ч��
					-- @Result=-2; 	ɾ��Eventʧ�ܣ���Event��״̬������ɾ����
					-- @Result=-3; 	ɾ��Eventʧ�ܣ���Event�µ���Phase��״̬������ɾ����
					-- @Result=-4; 	ɾ��Eventʧ�ܣ���Event�µ���Match��״̬������ɾ����
					-- @Result=-5; 	ɾ��Eventʧ�ܣ���Event�µ����Ѿ�����Ĳ����߻���еȣ�

	IF NOT EXISTS(SELECT F_EventID FROM TS_Event WHERE F_EventID = @EventID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF EXISTS (SELECT F_EventID	FROM TS_Event WHERE F_EventID = @EventID AND F_EventStatusID > 10)
	BEGIN
		SET @Result = -2
		RETURN
	END

	IF EXISTS (SELECT F_PhaseID	FROM TS_Phase WHERE F_EventID = @EventID AND F_PhaseStatusID > 10)
	BEGIN
		SET @Result = -3
		RETURN
	END

	IF EXISTS (SELECT F_MatchID	FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID AND A.F_MatchStatusID > 10)
	BEGIN
		SET @Result = -4
		RETURN
	END

	IF EXISTS (SELECT F_EventID FROM TR_Inscription WHERE F_EventID = @EventID )
	BEGIN
		SET @Result = -5
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
		
		DECLARE @PhaseID		AS INT
		DECLARE @DelPhaseResult	AS INT

		DECLARE Phase_Cursor CURSOR FOR 
			SELECT F_PhaseID
				FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = 0

		OPEN Phase_Cursor
		FETCH NEXT FROM Phase_Cursor INTO @PhaseID
   
		WHILE @@FETCH_STATUS = 0
		BEGIN

			EXEC proc_DelPhase @PhaseID, @DelPhaseResult output

			IF @DelPhaseResult != 1
			BEGIN
				ROLLBACK
				CLOSE Phase_Cursor
				DEALLOCATE Phase_Cursor
				SET @Result = 0
				RETURN
			END

			FETCH NEXT FROM Phase_Cursor INTO @PhaseID

		END

		CLOSE Phase_Cursor
		DEALLOCATE Phase_Cursor
		

		DELETE FROM TS_Round_Des WHERE F_RoundID IN (SELECT F_RoundID FROM TS_Round WHERE F_EventID = @EventID)
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	
		DELETE FROM TS_Round WHERE F_EventID = @EventID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TR_Inscription WHERE F_EventID = @EventID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Event_Result WHERE F_EventID = @EventID 
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Event_Des WHERE F_EventID = @EventID
		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Event WHERE F_EventID = @EventID
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




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

