if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelEventPhases]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelEventPhases]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[proc_DelEventPhases]
----��		  �ܣ�ɾ����Event�����е���Phase������ɾ�����е�Match����Ҫ��ΪEvent�����±��ŷ�����ŷ���
----��		  �ߣ�֣���� 
----��		  ��: 2009-04-09

CREATE PROCEDURE [DBO].[proc_DelEventPhases] 
	@EventID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	ɾ��Event�µ���Phaseʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	ɾ��Event�µ���Phase�ɹ���
					-- @Result=-1; 	ɾ��Event�µ���Phaseʧ�ܣ���EventID��Ч
					-- @Result=-2; 	ɾ��Event�µ���Phaseʧ�ܣ���Event�µ�״̬������ɾ��
					-- @Result=-3; 	ɾ��Event�µ���Phaseʧ�ܣ���Event�µ���Phase��״̬������ɾ��
					-- @Result=-4; 	ɾ��Event�µ���Phaseʧ�ܣ���Event�µ���Match��״̬������ɾ��

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

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
		
		DELETE FROM TS_Event_Result WHERE F_EventID = @EventID

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

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
				SET @Result = 0
				RETURN
			END

			FETCH NEXT FROM Phase_Cursor INTO @PhaseID

		END

		CLOSE Phase_Cursor
		DEALLOCATE Phase_Cursor

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

