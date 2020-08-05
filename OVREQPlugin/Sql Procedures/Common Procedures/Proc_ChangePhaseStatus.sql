if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_ChangePhaseStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_ChangePhaseStatus]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_ChangePhaseStatus]
----��		  �ܣ��������½׶ε�״̬
----��		  �ߣ�֣���� 
----��		  ��: 2010-06-17
/*
	����������
	1��Phase��״̬�����仯��Ҫ�Զ��Ĵ�����Phase״̬�ı仯��������Event״̬�ı仯��
	2��ͬʱҪ���������Phase��Event�ı仯�б��س�����
	3��Phase״̬�޸ĵĳɹ����Ĳ��������ʾ@Resultһ����Ҫ��������������ͬʱҪ�ü�¼����ѯ�ķ�ʽ�����
	�޸��б�
	���	����			�޸���		�޸�����

*/
CREATE PROCEDURE [dbo].[Proc_ChangePhaseStatus] (	
	@PhaseID					INT,
	@StatusID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	����Phase��״̬ʧ�ܣ���ʾû�����κβ�����
					-- @Result = -1; 	����Phase��״̬ʧ�ܣ���ʾ@MatchID��@StatusID ��Ч��
					-- @Result = -2; 	����Phase��״̬ʧ�ܣ���ʾ��Phase����Phase������Match��״̬�������Phase���д�״̬�޸ģ�
					-- @Result = 1; 	����Phase��״̬�ɹ���

	--����ʱ�������г�״̬�����仯��ȫ������
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = -1��ʾ��Event��F_Type = 0��ʾ��Phase��F_Type = 1��ʾ��Match
									F_EventID		INT,
									F_PhaseID		INT,
									F_MatchID		INT,
									F_OldStatus		INT,
									F_NewStatus		INT
								)

	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
	BEGIN
		SET @Result = -1
		GOTO Return_Loop
	END

	IF NOT EXISTS(SELECT F_StatusID FROM TC_Status WHERE F_StatusID = @StatusID)
	BEGIN
		SET @Result = -1
		GOTO Return_Loop
	END



	DECLARE @PhaseOldStatusID		AS INT
	DECLARE @EventOldStatusID		AS INT

	DECLARE @EventID				AS INT
	DECLARE @FatherPhaseID			AS INT

	SELECT @PhaseOldStatusID = F_PhaseStatusID, @FatherPhaseID = F_FatherPhaseID, @EventID = F_EventID 
		FROM TS_Phase WHERE F_PhaseID = @PhaseID

	IF (@StatusID = @PhaseOldStatusID)
	BEGIN
		SET @Result = 1
		GOTO Return_Loop
	END

--	IF (@StatusID = 0 OR @StatusID = 10)
--	BEGIN
--		IF (EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchStatusID > 10 AND F_PhaseID = @PhaseID)
--			OR EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseStatusID > 10 AND F_FatherPhaseID = @PhaseID))
--		BEGIN
--			SET @Result = -2
--			GOTO Return_Loop
--		END
--	END

	
	IF (@StatusID = 110)
	BEGIN
		IF (EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchStatusID < 110 AND F_PhaseID = @PhaseID)
			OR EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseStatusID < 110 AND F_FatherPhaseID = @PhaseID))
		BEGIN
			SET @Result = -2
			GOTO Return_Loop
		END
	END
	ELSE
	BEGIN
		DECLARE @MaxPhase AS INT
		DECLARE @MaxMatch AS INT
		SELECT @MaxMatch = MAX(F_MatchStatusID) FROM TS_Match WHERE F_PhaseID = @PhaseID
		SELECT @MaxPhase = MAX(F_PhaseStatusID) FROM TS_Phase WHERE F_FatherPhaseID = @PhaseID

		SET @MaxMatch = ISNULL(@MaxMatch, 10)
		SET @MaxPhase = ISNULL(@MaxPhase, 10)
		IF ((@MaxMatch < @StatusID) AND (@MaxPhase < @StatusID))
		BEGIN
			SET @Result = -2
			GOTO Return_Loop
		END
	END
	
	BEGIN TRY

		SET Implicit_Transactions off
		BEGIN TRANSACTION --�趨����

------------��һ�������Ȳ���Phase��Status�޸ļ�¼
			UPDATE TS_Phase SET F_PhaseStatusID = @StatusID 
				WHERE F_PhaseID = @PhaseID 
			
			INSERT INTO #Temp_ChangeList(F_Type, F_EventID, F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
				VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, @StatusID)


------------�����������Ų���Phase�ĸ�Phase��Status�޸ļ�¼���˴�Ӧ����һ��ѭ���������ؼ���PhaseǶ�׵Ĳ�����
-----------			��Ҫ˵�����˴����۸���Phase�׶��Ƿ���״̬�仯������һ�ߺ˲顣
			
			WHILE EXISTS (SELECT B.F_PhaseID FROM TS_Phase AS A LEFT JOIN TS_Phase AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE A.F_PhaseID = @PhaseID AND A.F_FatherPhaseID != 0)
			BEGIN

				SELECT @FatherPhaseID = A.F_FatherPhaseID, @PhaseOldStatusID = B.F_PhaseStatusID FROM TS_Phase AS A LEFT JOIN TS_Phase AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE A.F_PhaseID = @PhaseID

				SET @PhaseID = @FatherPhaseID

				DECLARE @MinPhaseStatusID AS INT
				DECLARE @MaxPhaseStatusID AS INT
				SELECT @MinPhaseStatusID = MIN(F_PhaseStatusID) FROM TS_Phase WHERE F_FatherPhaseID = @PhaseID
				SELECT @MaxPhaseStatusID = MAX(F_PhaseStatusID) FROM TS_Phase WHERE F_FatherPhaseID = @PhaseID

				IF (@MaxPhaseStatusID = 10 AND @PhaseOldStatusID != 10)--Available
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 10 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 10)
				END

				IF (@MinPhaseStatusID = 110 AND @PhaseOldStatusID != 110)--Finished
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 110 WHERE F_PhaseID = @PhaseID
					INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
						VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 110)
				END

				IF(@MaxPhaseStatusID = 30 AND @PhaseOldStatusID != 30)--Scheduled
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 30 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 30)
				END

				IF(@MaxPhaseStatusID = 50 AND @PhaseOldStatusID != 50)--Running����һ���ֽ���Running
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END


				IF (@MinPhaseStatusID < 110 AND @MaxPhaseStatusID =110 AND @PhaseOldStatusID != 50)--Running���ֽ��������ֻ�δ����
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
					INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
						VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END

			END

------------���Ĳ������Ų���Event��Status�޸ļ�¼
			SELECT @EventOldStatusID = F_EventStatusID FROM TS_Event WHERE F_EventID = @EventID

			SELECT @MinPhaseStatusID = MIN(F_PhaseStatusID) FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = 0
			SELECT @MaxPhaseStatusID = MAX(F_PhaseStatusID) FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = 0

			IF (@MaxPhaseStatusID = 10 AND @EventOldStatusID != 10)--Available
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 10 WHERE F_EventID = @EventID
						INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
							VALUES (0, @EventID, @PhaseID, -1, @EventOldStatusID, 10)
			END

			IF (@MinPhaseStatusID = 110 AND @EventOldStatusID != 110)--Finished
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 110 WHERE F_EventID = @EventID
				INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
					VALUES (-1, @EventID, -1, -1, @EventOldStatusID, 110)
			END

			IF(@MaxPhaseStatusID = 30 AND @EventOldStatusID != 30)--Scheduled
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 30 WHERE F_EventID = @EventID
						INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
							VALUES (-1, @EventID, -1, -1, @EventOldStatusID, 30)
			END

			IF(@MaxPhaseStatusID = 50 AND @EventOldStatusID != 50)--Running����һ���ֽ���Running
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 50 WHERE F_EventID = @EventID
						INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
							VALUES (-1, @EventID, -1, -1, @EventOldStatusID, 50)
			END


			IF (@MinPhaseStatusID < 110 AND @MaxPhaseStatusID =110 AND @EventOldStatusID != 50)--Running���ֽ��������ֻ�δ����
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 50 WHERE F_EventID = @EventID
				INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
					VALUES (-1, @EventID, -1, -1, @EventOldStatusID, 50)
			END

		SET @Result = 1
		COMMIT TRANSACTION --�ɹ��ύ����

	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION --����ع�����
		SET @Result = 0
		GOTO Return_Loop

	END CATCH

Return_Loop:
	SELECT @Result AS Result
	SELECT * FROM #Temp_ChangeList
	RETURN


SET NOCOUNT OFF
END

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

/*
----��������
DECLARE @Result AS INT
SET @Result = 0
EXEC [Proc_ChangePhaseStatus] 1654, 110, @Result OUTPUT
SELECT @Result AS ProcOUTPUT
*/
