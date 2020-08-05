if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_ChangeMatchStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_ChangeMatchStatus]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----�洢�������ƣ�[Proc_ChangeMatchStatus]
----��		  �ܣ����ı����ı���״̬
----��		  �ߣ�֣���� 
----��		  ��: 2009-12-08
/*
	�޸ļ�¼
	���	����			�޸���		�޸�����
	1		2010-06-17		֣����		Match״̬�仯��Ҫ�Զ��Ĵ���Phase״̬�ı仯��������Event״̬�ı仯��
										ͬʱҪ���������Phase��Event�ı仯�б��س�����
	2		2010-06-17		֣����		Match״̬�޸ĵĳɹ����Ĳ��������ʾ@Resultһ����Ҫ��������������
										ͬʱҪ�ü�¼����ѯ�ķ�ʽ�����

*/
CREATE PROCEDURE [dbo].[Proc_ChangeMatchStatus] (	
	@MatchID					INT,
	@StatusID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	���ı����ı���״̬ʧ�ܣ���ʾû�����κβ�����
					-- @Result = -1; 	���ı����ı���״̬ʧ�ܣ���ʾ@MatchID��@StatusID ��Ч��
					-- @Result = 1; 	���ı����ı���״̬�ɹ���

	--����ʱ�������г�״̬�����仯��ȫ������
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = -1��ʾ��Event��F_Type = 0��ʾ��Phase��F_Type = 1��ʾ��Match
									F_EventID		INT,
									F_PhaseID		INT,
									F_MatchID		INT,
									F_OldStatus		INT,
									F_NewStatus		INT
								)

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		GOTO Return_Loop
	END

	IF NOT EXISTS(SELECT F_StatusID FROM TC_Status WHERE F_StatusID = @StatusID)
	BEGIN
		SET @Result = -1
		GOTO Return_Loop
	END

	DECLARE @MatchOldEventStatusID	AS INT
	DECLARE @PhaseOldStatusID		AS INT
	DECLARE @EventOldStatusID		AS INT

	DECLARE @EventID				AS INT
	DECLARE @PhaseID				AS INT
	DECLARE @FatherPhaseID			AS INT

	SELECT @MatchOldEventStatusID = F_MatchStatusID, @PhaseID = A.F_PhaseID, @EventID = B.F_EventID 
		FROM TS_Match AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID
			WHERE A.F_MatchID = @MatchID

	IF (@StatusID = @MatchOldEventStatusID)
	BEGIN
		SET @Result = 1
		GOTO Return_Loop
	END



	IF @MatchOldEventStatusID IS NULL
	BEGIN
		SET @MatchOldEventStatusID = 0
	END

	BEGIN TRY

		SET Implicit_Transactions off
		BEGIN TRANSACTION --�趨����

------------��һ�������Ȳ���Match��Status�޸ļ�¼
			UPDATE TS_Match SET F_MatchStatusID = @StatusID 
				WHERE F_MatchID = @MatchID 
			
			INSERT INTO #Temp_ChangeList(F_Type, F_EventID, F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
				VALUES (1, @EventID, @PhaseID, @MatchID, @MatchOldEventStatusID, @StatusID)

------------�ڶ��������Ų���Match�ĸ�Phase��Status�޸ļ�¼

--			IF @StatusID IN (10, 30, 50, 110, 120, 130) OR @MatchOldEventStatusID IN (10, 30, 50, 110, 120, 130)
--			BEGIN
				SELECT @PhaseOldStatusID = F_PhaseStatusID FROM TS_Phase WHERE F_PhaseID = @PhaseID
				
				DECLARE @MinMatchStatusID AS INT
				DECLARE @MaxMatchStatusID AS INT
				SELECT @MinMatchStatusID = MIN(F_MatchStatusID) FROM TS_Match WHERE F_PhaseID = @PhaseID
				SELECT @MaxMatchStatusID = MAX(F_MatchStatusID) FROM TS_Match WHERE F_PhaseID = @PhaseID

				IF (@MaxMatchStatusID = 10 AND @PhaseOldStatusID != 10)--Available
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 10 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 10)
				END

				IF (@MinMatchStatusID >= 110 AND @PhaseOldStatusID != 110)--Finished
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 110 WHERE F_PhaseID = @PhaseID
					INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
						VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 110)
				END

				IF(@MaxMatchStatusID = 30 AND @PhaseOldStatusID != 30)--Scheduled
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 30 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 30)
				END

				IF(@MaxMatchStatusID = 50 AND @PhaseOldStatusID != 50)--Running����һ���ֽ���Running
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END


				IF (@MinMatchStatusID < 110 AND @MaxMatchStatusID >=110 AND @PhaseOldStatusID != 50)--Running���ֽ��������ֻ�δ����
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
					INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
						VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END

--			END

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
EXEC Proc_ChangeMatchStatus 4984, 50, @Result OUTPUT
SELECT @Result AS ProcOUTPUT
GO
DECLARE @Result AS INT
SET @Result = 0
EXEC Proc_ChangeMatchStatus 4984, 10, @Result OUTPUT
SELECT @Result AS ProcOUTPUT

*/