IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoDrawPhasePosition_SL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_SL]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_AutoDrawPhasePosition_SL]
--��    ��: ��������������������ɱ�����ʼǩλ
--����˵��: 
--˵    ��: 
--�� �� ��: ֣����
--�� �� �ˣ��ⶨ�P
--�޸����������뼤�����������ĳ�ǩ��ʽ��������������Խ��ǰ��ǩλԽ���ں��棬û�������������������ǩλ��
--��    ��: 2010-07-08


CREATE PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_SL]
	@EventID					INT,
	@PhaseID					INT,
	@NodeType					INT,
    @Type                       INT,  --���̴�Сд/��ť���Ҽ���1Ϊ��д��ʹ��Ԥ�ȴ洢�õ�ǩλ��0ΪСд�������ǩ��
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON
    
	SET @Result = 0;  -- @Result = 0; 	��ʾ���ɳ�ʼ����ǩλʧ�ܣ�ʲô����Ҳû��
					  -- @Result = 1; 	��ʾ���ɳ�ʼ����ǩλ


	--SL��ǩ��Ҫ������������ǰ���ú������
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
			SET @IsOldEventPositionValid = 0 --�˴���������Ԥ�ȴ�õ�ǩλ�Ĳ�����Ա�����еĴ���ǩ��Ա��һ�£�
		END

		IF EXISTS (	SELECT A.F_RegisterID, B.F_RegisterID, A.F_EventID, A.F_EventPosition, B.F_EventID, B.F_EventPosition 
						FROM TS_OldEvent_Position AS A INNER JOIN TS_Event_Position AS B ON A.F_EventID = B.F_EventID AND A.F_EventPosition = B.F_EventPosition 
							WHERE ((A.F_RegisterID IS NULL AND B.F_RegisterID IS NOT NULL) OR (A.F_RegisterID <> B.F_RegisterID)) AND A.F_EventID = @EventID )
		BEGIN
			SET @IsOldEventPositionValid = 0 --�˴���������Ԥ�ȴ�õ�ǩλ�����е�Ԥ��ָ����ǩλ��һ�£�
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --�趨����

			--�����еĲ���֮ǰ���ȸ����������������˶�Աָ���������ǩλ��ȥ

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
			
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
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

				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

			END
			ELSE --@EventPosCount < @ExistRankCount
			BEGIN
			
				UPDATE TS_Event_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_EventPosition+(@ExistRankCount-@EventPosCount))
			    WHERE F_EventID = @EventID
			    
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
				
			END

			IF (@Type = 1 AND @IsOldEventPositionValid = 1)
			BEGIN

				UPDATE TS_Event_Position SET F_RegisterID = B.F_RegisterID FROM TS_Event_Position AS A LEFT JOIN TS_OldEvent_Position AS B ON A.F_EventID = B.F_EventID
				AND A.F_EventPosition = B.F_EventPosition WHERE A.F_EventID = @EventID

				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

			END
			ELSE IF (@Type = 0 OR @IsOldEventPositionValid = 0) --�������CopyԤ�ȴ�õ�ǩλ������Ԥ�ȴ�õ�ǩλ����Ч��
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
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

				UPDATE TS_Event_Position SET F_RegisterID = -1 WHERE F_EventID = @EventID AND F_RegisterID IS NULL --û��ָ����λ��ֱ���ֿ�
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

			END

		COMMIT TRANSACTION --�ɹ��ύ����
		
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
			SET @IsOldPhasePositionValid = 0 --�˴���������Ԥ�ȴ�õ�ǩλ�Ĳ�����Ա�����еĴ���ǩ��Ա��һ�£�
		END

		IF EXISTS (	SELECT A.F_RegisterID, B.F_RegisterID, A.F_PhaseID, A.F_PhasePosition, B.F_PhaseID, B.F_PhasePosition 
						FROM TS_OldPhase_Position AS A INNER JOIN TS_Phase_Position AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition 
							WHERE ((A.F_RegisterID IS NULL AND B.F_RegisterID IS NOT NULL) OR (A.F_RegisterID <> B.F_RegisterID)) AND A.F_PhaseID = @PhaseID )
		BEGIN
			SET @IsOldPhasePositionValid = 0 --�˴���������Ԥ�ȴ�õ�ǩλ�����е�Ԥ��ָ����ǩλ��һ�£�
		END

		SET Implicit_Transactions off
		BEGIN TRANSACTION --�趨����
		
			--�����еĲ���֮ǰ���ȸ����������������˶�Աָ���������ǩλ��ȥ

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
			
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
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

				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

			END
			ELSE --@PhasePosCount < @ExistRankCount
			BEGIN
			
				UPDATE TS_Phase_Position SET F_RegisterID = 
				(SELECT F_RegisterID FROM #table_ExistRankCompetitions WHERE F_Order = F_PhasePosition+(@ExistRankCount-@PhasePosCount))
			    WHERE F_PhaseID = @PhaseID
			    
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
				
			END
		
			IF (@Type = 1 AND @IsOldPhasePositionValid = 1)
			BEGIN

				UPDATE TS_Phase_Position SET F_RegisterID = B.F_RegisterID FROM TS_Phase_Position AS A LEFT JOIN TS_OldPhase_Position AS B ON A.F_PhaseID = B.F_PhaseID
				AND A.F_PhasePosition = B.F_PhasePosition WHERE A.F_PhaseID = @PhaseID

				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

			END
			ELSE IF (@Type = 0 OR @IsOldPhasePositionValid = 0) --�������CopyԤ�ȴ�õ�ǩλ������Ԥ�ȴ�õ�ǩλ����Ч��
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
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

				UPDATE TS_Phase_Position SET F_RegisterID = -1 WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NULL --û��ָ����λ��ֱ���ֿ�
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

			END

		COMMIT TRANSACTION --�ɹ��ύ����
	
	END
    

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


/*
EXEC Proc_AutoDrawPhasePosition_SL 1,0,0


*/



