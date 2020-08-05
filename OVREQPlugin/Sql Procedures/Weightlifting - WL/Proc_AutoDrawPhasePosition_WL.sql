IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoDrawPhasePosition_WL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_WL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_AutoDrawPhasePosition_WL]
--描    述: 举重比赛随机签位
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--修 改 人：崔凯	
--修改描述：举重比赛随机签位
--日    期: 2011-01-10


CREATE PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_WL]
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
		------崔凯：临时表储存随机生成seed号，作为举重运动员签号
		--CREATE TABLE #table_ExistEventSeed(		
  --                                   F_RegisterID           INT,
  --                                   F_Seed	                INT)
											  
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
					--SELECT F_EventID, ROW_NUMBER() OVER (ORDER BY NEWID()), F_RegisterID FROM TS_Event_Competitors 
						--WHERE F_EventID = @EventID AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID IS NOT NULL)
					SELECT EC.F_EventID, ROW_NUMBER() OVER (ORDER BY I.F_InscriptionResult ASC,R.F_Weight DESC), EC.F_RegisterID FROM TS_Event_Competitors AS EC
						LEFT JOIN TR_Inscription AS I ON I.F_RegisterID = EC.F_RegisterID AND I.F_EventID=@EventID
						LEFT JOIN TR_Register AS R ON  R.F_RegisterID = EC.F_RegisterID
						WHERE EC.F_EventID = @EventID AND EC.F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID IS NOT NULL)
					ORDER BY I.F_InscriptionResult ASC,R.F_Weight DESC
				INSERT INTO #table_ExistEventPosition (F_EventID, F_RowCount, F_EventPosition)
					SELECT F_EventID, ROW_NUMBER() OVER (ORDER BY F_EventPosition), F_EventPosition FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID IS NULL
						ORDER BY F_EventPosition

				----崔凯：随机生成seed号，插入临时表作为举重运动员签号
				--INSERT INTO #table_ExistEventSeed (F_RegisterID,F_Seed)
				--	SELECT F_RegisterID,ROW_NUMBER() over(order by newid()) FROM TS_Event_Competitors
				--		WHERE F_EventID = @EventID 
				--		AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Event_Position WHERE F_EventID = @EventID AND F_RegisterID IS NOT NULL)
				
				UPDATE #table_EventPositon SET F_EventPosition = B.F_EventPosition FROM #table_EventPositon AS A INNER JOIN #table_ExistEventPosition
					AS B ON A.F_EventID = B.F_EventID AND A.F_RowCount = B.F_RowCount

				UPDATE TS_Event_Position SET F_RegisterID = B.F_RegisterID FROM TS_Event_Position AS A INNER JOIN #table_EventPositon AS B 
					ON A.F_EventID = B.F_EventID AND A.F_EventPosition = B.F_EventPosition WHERE A.F_EventID = @EventID
				----崔凯：将运动员签号插入报名报项表
				--Update TR_Inscription SET F_Seed=T.F_Seed FROM TR_Inscription AS I 
				--	INNER JOIN #table_ExistEventSeed AS T ON T.F_RegisterID = I.F_RegisterID
						
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
		------崔凯：临时表储存随机生成seed号，作为举重运动员签号
		--CREATE TABLE #table_ExistPhaseSeed(		
  --                                   F_RegisterID           INT,
  --                                   F_Seed	                INT)							  
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
				----崔凯：随机生成seed号，插入临时表作为举重运动员签号
				--INSERT INTO #table_ExistPhaseSeed (F_RegisterID,F_Seed)
				--	SELECT F_RegisterID,ROW_NUMBER() over(order by newid()) FROM TS_Phase_Competitors
				--		WHERE F_PhaseID = @PhaseID AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NOT NULL)

				UPDATE #table_PhasePositon SET F_PhasePosition = B.F_PhasePosition FROM #table_PhasePositon AS A INNER JOIN #table_ExistPhasePosition
					AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_RowCount = B.F_RowCount

				UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A INNER JOIN #table_PhasePositon AS B 
					ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID
				----崔凯：将运动员签号插入报名报项表
				--Update TR_Inscription SET F_Seed=T.F_Seed FROM TR_Inscription AS I 
				--	INNER JOIN #table_ExistPhaseSeed AS T ON T.F_RegisterID = I.F_RegisterID
				
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



