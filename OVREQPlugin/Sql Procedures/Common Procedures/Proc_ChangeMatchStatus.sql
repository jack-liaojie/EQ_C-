if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Proc_ChangeMatchStatus]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[Proc_ChangeMatchStatus]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：[Proc_ChangeMatchStatus]
----功		  能：更改比赛的比赛状态
----作		  者：郑金勇 
----日		  期: 2009-12-08
/*
	修改记录
	序号	日期			修改者		修改内容
	1		2010-06-17		郑金勇		Match状态变化后，要自动的触发Phase状态的变化，甚至是Event状态的变化。
										同时要将所引起的Phase和Event的变化列表返回出来。
	2		2010-06-17		郑金勇		Match状态修改的成功与否的操作结果标示@Result一方面要用输出参数输出，
										同时要用记录集查询的方式输出。

*/
CREATE PROCEDURE [dbo].[Proc_ChangeMatchStatus] (	
	@MatchID					INT,
	@StatusID					INT,
	@Result 					AS INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result = 0; 	更改比赛的比赛状态失败，标示没有做任何操作！
					-- @Result = -1; 	更改比赛的比赛状态失败，标示@MatchID、@StatusID 无效！
					-- @Result = 1; 	更改比赛的比赛状态成功！

	--此临时表用于列出状态发生变化的全部对象
	CREATE TABLE #Temp_ChangeList(
									F_Type			INT, -- F_Type = -1表示是Event；F_Type = 0表示是Phase；F_Type = 1表示是Match
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
		BEGIN TRANSACTION --设定事务

------------第一步：首先插入Match的Status修改记录
			UPDATE TS_Match SET F_MatchStatusID = @StatusID 
				WHERE F_MatchID = @MatchID 
			
			INSERT INTO #Temp_ChangeList(F_Type, F_EventID, F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
				VALUES (1, @EventID, @PhaseID, @MatchID, @MatchOldEventStatusID, @StatusID)

------------第二步：接着插入Match的父Phase的Status修改记录

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

				IF(@MaxMatchStatusID = 50 AND @PhaseOldStatusID != 50)--Running仅仅一部分进入Running
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END


				IF (@MinMatchStatusID < 110 AND @MaxMatchStatusID >=110 AND @PhaseOldStatusID != 50)--Running部分结束、部分还未结束
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
					INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
						VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END

--			END

------------第三步：接着插入Phase的父Phase的Status修改记录，此处应该是一个循环操作，关键看Phase嵌套的层数。
-----------			需要说明：此处无论各个Phase阶段是否发生状态变化都进行一边核查。
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

				IF(@MaxPhaseStatusID = 50 AND @PhaseOldStatusID != 50)--Running仅仅一部分进入Running
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
							INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
								VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END


				IF (@MinPhaseStatusID < 110 AND @MaxPhaseStatusID =110 AND @PhaseOldStatusID != 50)--Running部分结束、部分还未结束
				BEGIN
					UPDATE TS_Phase SET F_PhaseStatusID = 50 WHERE F_PhaseID = @PhaseID
					INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
						VALUES (0, @EventID, @PhaseID, -1, @PhaseOldStatusID, 50)
				END

			END

------------第四步：接着插入Event的Status修改记录
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

			IF(@MaxPhaseStatusID = 50 AND @EventOldStatusID != 50)--Running仅仅一部分进入Running
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 50 WHERE F_EventID = @EventID
						INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
							VALUES (-1, @EventID, -1, -1, @EventOldStatusID, 50)
			END


			IF (@MinPhaseStatusID < 110 AND @MaxPhaseStatusID =110 AND @EventOldStatusID != 50)--Running部分结束、部分还未结束
			BEGIN
				UPDATE TS_Event SET F_EventStatusID = 50 WHERE F_EventID = @EventID
				INSERT INTO #Temp_ChangeList(F_Type, F_EventID,	F_PhaseID,	F_MatchID, F_OldStatus, F_NewStatus)
					VALUES (-1, @EventID, -1, -1, @EventOldStatusID, 50)
			END

		SET @Result = 1
		COMMIT TRANSACTION --成功提交事务

	END TRY
	BEGIN CATCH
		
		ROLLBACK TRANSACTION --出错回滚事务
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
----测试用例
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