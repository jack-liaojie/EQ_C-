IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoDrawPhasePositionToAvoid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoDrawPhasePositionToAvoid]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AutoDrawPhasePositionToAvoid]
--描    述: 空手道比赛，随机生成比赛初始签位
--参数说明: 
--说    明: 
--创 建 人: 郑金勇
--日    期: 2009-09-21



CREATE PROCEDURE [dbo].[Proc_AutoDrawPhasePositionToAvoid]
	@PhaseID					INT,
	@Type                       INT,  --键盘大小写，1为拷贝设定，0为不拷贝设定
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

		SET @Result = 0;  -- @Result = 0; 	表示生成初始比赛签位失败，什么动作也没有
						  -- @Result = 1; 	表示生成初始比赛签位

		CREATE TABLE #table_PhasePositon(
											 F_PhaseID              INT,
											 F_PhasePosition        INT,   
											 F_RegisterID           INT
										 )

		IF (@Type = 1)
		BEGIN
		--SELECT F_RegisterID FROM TS_OldPhase_Position WHERE F_PhaseID = @PhaseID 
			IF NOT EXISTS (SELECT F_RegisterID FROM TS_OldPhase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID <> -1 AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID))
			BEGIN

				IF NOT EXISTS (SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID AND F_RegisterID <> -1 AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_OldPhase_Position WHERE F_PhaseID = @PhaseID))
				BEGIN
				
					IF EXISTS( SELECT F_RegisterID FROM TS_OldPhase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID <> -1)
					BEGIN

						SET Implicit_Transactions off
						BEGIN TRANSACTION --设定事务
							UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A LEFT JOIN TS_OldPhase_Position AS B ON A.F_PhaseID = B.F_PhaseID
								AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID

							IF @@error<>0  --事务失败返回  
							BEGIN 
								ROLLBACK   --事务回滚
								SET @Result=0
								RETURN
							END
						
						COMMIT TRANSACTION --成功提交事务
						SET @Result = 1
						RETURN
					END
				END
			END

		END


		DECLARE @EventCode	AS NVARCHAR(20)
		SELECT @EventCode = F_EventCode FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID


		CREATE TABLE #Temp_HA_Config(
										F_HomeRegisterID	INT,
										F_HomeNOC			CHAR(3),
										F_AwayNOC			CHAR(3),
										F_AwayRegisterID	INT,
										F_Number			INT,
										F_Seted				INT
									)

		INSERT INTO #Temp_HA_Config (F_HomeNOC, F_AwayNOC, F_Number)
			SELECT F_HomeNOC, F_AwayNOC, F_Number FROM TM_HA_Config WHERE F_EventCode = @EventCode

		CREATE TABLE #Temp_Phase_Competitors(
												F_PhaseID			INT,
												F_RegisterID		INT,
												F_NOC				CHAR(3)
											)

		INSERT INTO #Temp_Phase_Competitors (F_PhaseID, F_RegisterID, F_NOC)
			SELECT A.F_PhaseID, A.F_RegisterID, C.F_FederationCode AS F_NOC 
				FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID
					LEFT JOIN TC_Federation AS C ON B.F_FederationID = C.F_FederationID WHERE F_PhaseID = @PhaseID

		UPDATE #Temp_HA_Config SET F_HomeRegisterID = B.F_RegisterID FROM #Temp_HA_Config AS A LEFT JOIN #Temp_Phase_Competitors AS B
			ON A.F_HomeNOC = B.F_NOC

		UPDATE #Temp_HA_Config SET F_AwayRegisterID = B.F_RegisterID FROM #Temp_HA_Config AS A LEFT JOIN #Temp_Phase_Competitors AS B
			ON A.F_AwayNOC = B.F_NOC
		
		DELETE FROM #Temp_HA_Config WHERE F_AwayRegisterID IS NULL

		DECLARE @HomeRegisterID		AS INT
		SET @HomeRegisterID = NULL
		SELECT TOP 1 @HomeRegisterID = F_HomeRegisterID FROM #Temp_HA_Config WHERE F_HomeNOC = 'CHN' 

--		SELECT @HomeRegisterID

		IF (@HomeRegisterID IS NULL)
		BEGIN

			SET Implicit_Transactions off
			BEGIN TRANSACTION --设定事务	

				INSERT INTO #table_PhasePositon (F_PhaseID, F_PhasePosition, F_RegisterID)
					SELECT F_PhaseID, ROW_NUMBER() OVER (ORDER BY NEWID()), F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID

				UPDATE TS_Phase_Position SET F_RegisterID = -1 WHERE F_PhaseID = @PhaseID
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

				UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A RIGHT JOIN #table_PhasePositon AS B 
					ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

			COMMIT TRANSACTION --成功提交事务
			SET @Result = 1

			RETURN--没有CHN不用回避
		END
		ELSE
		BEGIN

			DECLARE @ModelType			AS INT
			DECLARE @CompetitorCount	AS INT
			SELECT @ModelType = COUNT(F_ItemID) FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID
			SELECT @CompetitorCount = COUNT(F_RegisterID) FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID

			CREATE TABLE #Temp_ModelType_Position (
													   F_ModelType			INT,
													   F_ModelPosition		INT, 
													   F_ModelSection		INT,
													   F_Used				INT
												   )
			INSERT INTO #Temp_ModelType_Position (F_ModelType, F_ModelPosition, F_ModelSection)
				SELECT F_ModelType, F_ModelPosition, F_ModelSection FROM TM_ModelType_Position WHERE F_ModelType = @ModelType
			
			DELETE FROM #Temp_ModelType_Position WHERE F_ModelPosition > @CompetitorCount

			UPDATE #Temp_ModelType_Position SET F_Used = 0

			INSERT INTO #table_PhasePositon (F_PhaseID, F_PhasePosition, F_RegisterID)
				SELECT F_PhaseID, ROW_NUMBER() OVER (ORDER BY NEWID()), F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID



			DECLARE @HomePosition AS INT
			DECLARE @HomeSection  AS INT

			SELECT @HomePosition = F_PhasePosition FROM #table_PhasePositon WHERE F_RegisterID = @HomeRegisterID
			SELECT @HomeSection = F_ModelSection FROM #Temp_ModelType_Position WHERE F_ModelPosition = @HomePosition

			UPDATE #Temp_ModelType_Position SET F_Used = 1 WHERE F_ModelPosition = @HomePosition
--
--select	@HomePosition, @HomeRegisterID
--select * from #Temp_ModelType_Position

			UPDATE #table_PhasePositon SET F_PhasePosition = NULL WHERE F_RegisterID <> @HomeRegisterID
			
			UPDATE #Temp_HA_Config SET F_Seted = 0

--			select * from #Temp_ModelType_Position

			WHILE EXISTS(SELECT F_Number FROM #Temp_HA_Config WHERE F_Seted = 0)
			BEGIN
--				SELECT * FROM #Temp_HA_Config
				DECLARE @Number				AS INT
				DECLARE @CurRegisterID		AS INT
				SELECT TOP 1 @Number = F_Number FROM #Temp_HA_Config WHERE F_Seted = 0
				SELECT @CurRegisterID = F_AwayRegisterID FROM #Temp_HA_Config WHERE F_Number = @Number
				DECLARE @CurPosition		AS INT

				IF EXISTS( SELECT F_ModelPosition FROM #Temp_ModelType_Position WHERE F_Used = 0 AND F_ModelSection = (3 - @HomeSection) )
				BEGIN
					SELECT TOP 1 @CurPosition = F_ModelPosition FROM #Temp_ModelType_Position WHERE F_Used = 0 AND F_ModelSection = (3 - @HomeSection)
						ORDER BY ROW_NUMBER() OVER (ORDER BY NEWID())
--					SELECT @CurPosition AS ONE
				END
				ELSE
				BEGIN
					SELECT TOP 1 @CurPosition = F_ModelPosition FROM #Temp_ModelType_Position WHERE F_Used = 0
						ORDER BY ROW_NUMBER() OVER (ORDER BY NEWID())
--					SELECT @CurPosition AS TWO
				END
				
				UPDATE #Temp_ModelType_Position SET F_Used = 1 WHERE F_ModelPosition = @CurPosition
				UPDATE #Temp_HA_Config SET F_Seted = 1 WHERE F_AwayRegisterID = @CurRegisterID
				UPDATE #table_PhasePositon SET F_PhasePosition = @CurPosition WHERE F_RegisterID = @CurRegisterID

			END

			WHILE EXISTS( SELECT F_RegisterID FROM #table_PhasePositon WHERE F_PhasePosition IS NULL)
			BEGIN

				DECLARE @CurRegisterID1		AS INT
				SELECT TOP 1 @CurRegisterID1 = F_RegisterID FROM #table_PhasePositon WHERE F_PhasePosition IS NULL

				DECLARE @CurPosition1		AS INT
				SELECT TOP 1 @CurPosition1 = F_ModelPosition FROM #Temp_ModelType_Position WHERE F_Used = 0
					ORDER BY ROW_NUMBER() OVER (ORDER BY NEWID())

				UPDATE #table_PhasePositon SET F_PhasePosition = @CurPosition1 WHERE F_RegisterID = @CurRegisterID1 
				UPDATE #Temp_ModelType_Position SET F_Used = 1 WHERE F_ModelPosition = @CurPosition1
--select @CurRegisterID1, @CurPosition1
--select * from #table_PhasePositon
--select * from #Temp_ModelType_Position

			END

--SELECT * FROM #table_PhasePositon
			SET Implicit_Transactions off
			BEGIN TRANSACTION --设定事务	
				UPDATE TS_Phase_Position SET F_RegisterID = -1 WHERE F_PhaseID = @PhaseID
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

				UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A RIGHT JOIN #table_PhasePositon AS B 
					ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID

				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END
			COMMIT TRANSACTION --成功提交事务

			SET @Result = 1
			RETURN
		END

		
--	SET @Result = 1
--	RETURN

SET NOCOUNT OFF
END
GO


