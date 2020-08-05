IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoDrawPhasePosition_SL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_SL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_AutoDrawPhasePosition_SL]
--描    述: 激流回旋比赛，随机生成比赛初始签位
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--修 改 人：吴定昉
--修改描述：加入激流回旋比赛的抽签方式，有且世界排名越靠前的签位越排在后面，没有世界排名的随机生成签位。
--日    期: 2010-07-08


CREATE PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_SL]
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
    @Type                       INT,  --键盘大小写/按钮左右键，1为大写，使用预先存储好的签位；0为小写，随机抽签。
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON
    
	SET @Result = 0;  -- @Result = 0; 	表示生成初始比赛签位失败，什么动作也没有
					  -- @Result = 1; 	表示生成初始比赛签位


	--SL抽签需要将世界排名靠前的置后出发！
	CREATE TABLE #table_ExistRankCompetitions(
							F_Order INT,
							F_RegisterID  INT,
							)
	DECLARE @ExistRankCount AS INT
	
	IF @NodeType = -1
	BEGIN
		CREATE TABLE #table_EventPositon(
                                     F_EventID              INT,
                                     F_EventPosition        INT,   
                                     F_RegisterID           INT,
                                     F_RowCount             INT
                                     )

		CREATE TABLE #table_ExistEventPosition(
												F_EventID              INT,
												F_EventPosition        INT, 
												F_RowCount             INT
											  )
											  
		DECLARE @IsOldEventPositionValid AS INT
		SET @IsOldEventPositionValid = 1
    
		IF EXISTS (SELECT F_RegisterID FROM TS_OldEvent_Position WHERE F_EventID = @EventID AND F_RegisterID <> -1 AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Event_Competitors WHERE F_EventID = @EventID))
		BEGIN
			SET @IsOldEventPositionValid = 0 --此处表明的是预先存好的签位的参赛人员和现有的待抽签人员不一致！
		END

		IF EXISTS (	SELECT A.F_RegisterID, B.F_RegisterID, A.F_EventID, A.F_EventPosition, B.F_EventID, B.F_EventPosition 
						FROM TS_OldEvent_Position AS A INNER JOIN TS_Event_Position AS B ON A.F_EventID = B.F_EventID AND A.F_EventPosition = B.F_EventPosition 
							WHERE ((A.F_RegisterID IS NULL AND B.F_RegisterID IS NOT NULL) OR (A.F_RegisterID <> B.F_RegisterID)) AND A.F_EventID = @EventID )
		BEGIN
			SET @IsOldEventPositionValid = 0 --此处表明的是预先存好的签位和现有的预先指定的签位不一致！
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务

			--做所有的操作之前，先根据世界排名，将运动员指定到后面的签位上去

			INSERT #table_ExistRankCompetitions(F_Order,F_RegisterID) 
			(SELECT row_number() over (order by II.F_InscriptionRank desc),PC.F_RegisterID FROM TS_Event_Competitors AS PC
			 LEFT JOIN TR_Inscription AS II ON PC.F_RegisterID = II.F_RegisterID 
			 WHERE PC.F_EventID = @EventID AND II.F_InscriptionRank IS NOT NULL AND II.F_InscriptionRank > 0)
			 
			SELECT @ExistRankCount = COUNT(*) FROM #table_ExistRankCompetitions

			DECLARE @EventPosCount AS INT
			SELECT @EventPosCount = COUNT(*) FROM TS_Event_Position WHERE F_EventID = @EventID

			DECLARE @EventComCount AS INT
			SELECT @EventComCount = Count(*) FROM TS_Event_Competitors where F_EventID = @EventID


			IF @EventPosCount >= @EventComCount
			BEGIN
			
				UPDATE TS_Event_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_PhasePosition - (@EventComCount - @ExistRankCount))
				WHERE F_EventID = @EventID
				AND F_EventPosition <= @EventComCount AND F_EventPosition > (@EventComCount - @ExistRankCount)
			
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
			
			END
			ELSE IF @EventPosCount >= @ExistRankCount
			BEGIN
			
				UPDATE TS_Event_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_PhasePosition - (@EventPosCount-@ExistRankCount))
				WHERE F_EventID = @EventID
				AND F_EventPosition <= @EventComCount AND F_EventPosition > (@EventPosCount-@ExistRankCount)	

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			END
			ELSE --@EventPosCount < @ExistRankCount
			BEGIN
			
				UPDATE TS_Event_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_EventPosition+(@ExistRankCount-@EventPosCount))
			    WHERE F_EventID = @EventID
			    
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
				
			END

			IF (@Type = 1 AND @IsOldEventPositionValid = 1)
			BEGIN

				UPDATE TS_Event_Position SET F_RegisterID = B.F_RegisterID FROM TS_Event_Position AS A LEFT JOIN TS_OldEvent_Position AS B ON A.F_EventID = B.F_EventID
				AND A.F_EventPosition = B.F_EventPosition WHERE A.F_EventID = @EventID

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			END
			ELSE IF (@Type = 0 OR @IsOldEventPositionValid = 0) --如果不是Copy预先存好的签位，或者预先存好的签位是无效的
			BEGIN

				INSERT INTO #table_EventPositon (F_EventID, F_RowCount, F_RegisterID)
					SELECT F_EventID, ROW_NUMBER() OVER (ORDER BY NEWID()), F_RegisterID FROM TS_Event_Competitors 
						WHERE F_EventID = @EventID AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID IS NOT NULL)

				INSERT INTO #table_ExistEventPosition (F_EventID, F_RowCount, F_EventPosition)
					SELECT F_EventID, ROW_NUMBER() OVER (ORDER BY F_EventPosition), F_EventPosition FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID IS NULL
						ORDER BY F_EventPosition

				UPDATE #table_EventPositon SET F_EventPosition = B.F_EventPosition FROM #table_EventPositon AS A INNER JOIN #table_ExistEventPosition
					AS B ON A.F_EventID = B.F_EventID AND A.F_RowCount = B.F_RowCount

				UPDATE TS_Event_Position SET F_RegisterID = B.F_RegisterID FROM TS_Event_Position AS A INNER JOIN #table_EventPositon AS B 
					ON A.F_EventID = B.F_EventID AND A.F_EventPosition = B.F_EventPosition WHERE A.F_EventID = @EventID
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

				UPDATE TS_Event_Position SET F_RegisterID = -1 WHERE F_EventID = @EventID AND F_RegisterID IS NULL --没有指定的位置直接轮空
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			END

		COMMIT TRANSACTION --成功提交事务
		
	END
	ELSE IF @NodeType = 0
	BEGIN
	
	    CREATE TABLE #table_PhasePositon(
                                     F_PhaseID              INT,
                                     F_PhasePosition        INT,   
                                     F_RegisterID           INT,
                                     F_RowCount             INT
                                     )

		CREATE TABLE #table_ExistPhasePosition(
												F_PhaseID              INT,
												F_PhasePosition        INT, 
												F_RowCount             INT
											  )
											  
	    DECLARE @IsOldPhasePositionValid AS INT
		SET @IsOldPhasePositionValid = 1
    
		IF EXISTS (SELECT F_RegisterID FROM TS_OldPhase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID <> -1 AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID))
		BEGIN
			SET @IsOldPhasePositionValid = 0 --此处表明的是预先存好的签位的参赛人员和现有的待抽签人员不一致！
		END

		IF EXISTS (	SELECT A.F_RegisterID, B.F_RegisterID, A.F_PhaseID, A.F_PhasePosition, B.F_PhaseID, B.F_PhasePosition 
						FROM TS_OldPhase_Position AS A INNER JOIN TS_Phase_Position AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition 
							WHERE ((A.F_RegisterID IS NULL AND B.F_RegisterID IS NOT NULL) OR (A.F_RegisterID <> B.F_RegisterID)) AND A.F_PhaseID = @PhaseID )
		BEGIN
			SET @IsOldPhasePositionValid = 0 --此处表明的是预先存好的签位和现有的预先指定的签位不一致！
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务
		
			--做所有的操作之前，先根据世界排名，将运动员指定到后面的签位上去

			INSERT #table_ExistRankCompetitions(F_Order,F_RegisterID) 
			(SELECT row_number() over (order by II.F_InscriptionRank desc),PC.F_RegisterID FROM TS_Phase_Competitors AS PC
			 LEFT JOIN TR_Inscription AS II ON PC.F_RegisterID = II.F_RegisterID 
			 WHERE PC.F_PhaseID = @PhaseID AND II.F_InscriptionRank IS NOT NULL AND II.F_InscriptionRank > 0)
			 
			SELECT @ExistRankCount = COUNT(*) FROM #table_ExistRankCompetitions

			DECLARE @PhasePosCount AS INT
			SELECT @PhasePosCount = COUNT(*) FROM TS_Phase_Position WHERE F_PhaseID =  @PhaseID

			DECLARE @PhaseComCount AS INT
			SELECT @PhaseComCount = Count(*) FROM TS_Phase_Competitors where F_PhaseID = @PhaseID


			IF @PhasePosCount >= @PhaseComCount
			BEGIN
			
				UPDATE TS_Phase_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_PhasePosition - (@PhaseComCount - @ExistRankCount))
				WHERE F_PhaseID = @PhaseID 
				AND F_PhasePosition <= @PhaseComCount AND F_PhasePosition > (@PhaseComCount - @ExistRankCount)
			
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
			
			END
			ELSE IF @PhasePosCount >= @ExistRankCount
			BEGIN
			
				UPDATE TS_Phase_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_PhasePosition - (@PhasePosCount-@ExistRankCount))
				WHERE F_PhaseID = @PhaseID 
				AND F_PhasePosition <= @PhaseComCount AND F_PhasePosition > (@PhasePosCount-@ExistRankCount)	

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			END
			ELSE --@PhasePosCount < @ExistRankCount
			BEGIN
			
				UPDATE TS_Phase_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_PhasePosition+(@ExistRankCount-@PhasePosCount))
			    WHERE F_PhaseID = @PhaseID
			    
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
				
			END
		
			IF (@Type = 1 AND @IsOldPhasePositionValid = 1)
			BEGIN

				UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A LEFT JOIN TS_OldPhase_Position AS B ON A.F_PhaseID = B.F_PhaseID
				AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			END
			ELSE IF (@Type = 0 OR @IsOldPhasePositionValid = 0) --如果不是Copy预先存好的签位，或者预先存好的签位是无效的
			BEGIN

				INSERT INTO #table_PhasePositon (F_PhaseID, F_RowCount, F_RegisterID)
					SELECT F_PhaseID, ROW_NUMBER() OVER (ORDER BY NEWID()), F_RegisterID FROM TS_Phase_Competitors 
						WHERE F_PhaseID = @PhaseID AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NOT NULL)

				INSERT INTO #table_ExistPhasePosition (F_PhaseID, F_RowCount, F_PhasePosition)
					SELECT F_PhaseID, ROW_NUMBER() OVER (ORDER BY F_PhasePosition), F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NULL
						ORDER BY F_PhasePosition

				UPDATE #table_PhasePositon SET F_PhasePosition = B.F_PhasePosition FROM #table_PhasePositon AS A INNER JOIN #table_ExistPhasePosition
					AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_RowCount = B.F_RowCount

				UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A INNER JOIN #table_PhasePositon AS B 
					ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

				UPDATE TS_Phase_Position SET F_RegisterID = -1 WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NULL --没有指定的位置直接轮空
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			END

		COMMIT TRANSACTION --成功提交事务
	
	END
    

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


/*
EXEC Proc_AutoDrawPhasePosition_SL 1,0,0


*/



