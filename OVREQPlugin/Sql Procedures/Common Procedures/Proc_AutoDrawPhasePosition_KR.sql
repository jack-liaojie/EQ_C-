IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoDrawPhasePosition_KR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_KR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--��    ��: [Proc_AutoDrawPhasePosition_KR]
--��    ��: ���ֵ�������������ɱ�����ʼǩλ
--����˵��: 
--˵    ��: 
--�� �� ��: �Ŵ�ϼ
--��    ��: 2009-09-08
/*	
		���	����		�޸���		�޸�����
		1.		2010-04-30	֣����		ʵ���û�����ǩλ�ֶ�ָ��������ǩλ�Զ���ǩ��
		2.		2010-04-30	֣����		ʵ��ͬһ�����ŵĶ�Ա��������1/4�����رܣ���ദ���Դ������ڱ��ĸ��˽��лرܡ�
		3.		2010-04-30  ֣����		ʵ�ֲ���Ԥ��ָ�����˶�Ա�رܹ���
		4.		2010-08-18  ֣����		���ֵ���ǩ���ܽ�����֤Phase����ĳ�ǩ�������Event����ĳ�ǩ��ʱ�޷����С�
*/


CREATE PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_KR]
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

		DECLARE @DisciplineCode AS NVARCHAR(20)
		DECLARE @EventCode		AS NVARCHAR(20)
		SELECT @EventCode = C.F_DisciplineCode + CAST(B.F_SexCode AS NVARCHAR(20)) + B.F_EventCode, @DisciplineCode = C.F_DisciplineCode FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID
			LEFT JOIN TS_Discipline AS C ON B.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID
		
		
		IF (((EXISTS(SELECT COUNT(A.F_RegisterID), B.F_DelegationID FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B 
													ON A.F_RegisterID = B.F_RegisterID WHERE A.F_PhaseID = @PhaseID  
														GROUP BY B.F_DelegationID HAVING COUNT(A.F_RegisterID) > 1))
				OR
			   (EXISTS (SELECT F_EventCode FROM TM_HA_Config WHERE F_EventCode =@EventCode)))
			AND @DisciplineCode = 'KR')
		BEGIN
			DECLARE @ModleType AS INT
			SELECT @ModleType = COUNT(F_ItemID) FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID
			
			CREATE TABLE #ModelSections(
										[F_ModelType]			INT NULL,
										[F_ModelSection_L1]		INT NULL,
										[F_ModelSection_L2]		INT NULL,
										[F_L1_MaxNum]			INT NULL,
										[F_L2_MaxNum]			INT NULL,
										[F_L1_CurNum]			INT NOT NULL DEFAULT(0),
										[F_L2_CurNum]			INT NOT NULL DEFAULT(0))

			INSERT INTO #ModelSections(F_ModelType, F_ModelSection_L1, F_ModelSection_L2, F_L1_MaxNum, F_L2_MaxNum)
				SELECT DISTINCT F_ModelType, F_ModelSection_L1, F_ModelSection_L2, F_ModelType/2, F_ModelType/4 FROM TM_ModelType_Position WHERE F_ModelType = @ModleType
		
			CREATE TABLE #TempGroup(F_ItemID				INT IDENTITY(1, 1),
									F_GroupID				INT NOT NULL, 
									F_GroupType				INT NOT NULL,--0��ʾԤ��ָ��ǩλ���˶�Ա�İ�����1��ʾ��Ϊ���°�����2��ʾ��Ϊ�ĸ��ķ�֮һ������3��ʾ����ָ�����˶�Ա֮��Ļرܹ������
									[F_ModelSection_L1]		INT NULL,
									[F_ModelSection_L2]		INT NULL,
									[F_L1_Fixed]			INT NOT NULL DEFAULT(0),
									[F_L2_Fixed]			INT NOT NULL DEFAULT(0),
									[F_RegisterID]			INT NULL)

			DECLARE @GroupID			AS INT
			DECLARE @RegsterNum			AS INT
			DECLARE @DelegationID		AS INT
			DECLARE @RegisterID			AS INT
			DECLARE @Section_L1			AS INT
			DECLARE @Section_L2			AS INT



			----��һ�������ȴ���Ԥ��ָ��ǩλ���˶�Ա����������ѡ�֣�

			INSERT INTO #TempGroup (F_RegisterID, F_GroupID, F_GroupType, F_ModelSection_L1, F_ModelSection_L2, F_L1_Fixed, F_L2_Fixed)
			SELECT A.F_RegisterID, DENSE_RANK() OVER(ORDER BY B.F_DelegationID) AS F_GroupID, 0, C.F_ModelSection_L1, C.F_ModelSection_L2, 1, 1  
				FROM TS_Phase_Position AS A LEFT JOIN TR_Register AS B 
				ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TM_ModelType_Position AS C ON A.F_PhasePosition = C.F_ModelPosition AND C.F_ModelType = @ModleType 
				WHERE A.F_PhaseID = @PhaseID AND B.F_DelegationID IN 
				(SELECT B.F_DelegationID FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B 
					ON A.F_RegisterID = B.F_RegisterID WHERE A.F_PhaseID = @PhaseID AND A.F_RegisterID IS NOT NULL AND A.F_RegisterID != -1
						GROUP BY B.F_DelegationID HAVING COUNT(A.F_RegisterID) >= 2 AND COUNT(A.F_RegisterID) <= 4)


			----����һ�������еĴ���֮ǰӦ�ñ�֤�ֿ��˶�Ա��λ��ȷ���ã�
			DECLARE @BYECount			AS INT
			DECLARE @AssignedCount		AS INT
			DECLARE @ValidCount			AS INT

			SELECT @AssignedCount = Count(F_RegisterID) FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NOT NULL
			SELECT @ValidCount = Count(F_RegisterID) FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID AND F_RegisterID NOT IN (SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NOT NULL)

			SET @BYECount = @ModleType - @AssignedCount - @ValidCount
--			SELECT @ModleType, @AssignedCount, @ValidCount
			UPDATE TS_Phase_Position SET F_RegisterID = -1 WHERE F_PhaseID = @PhaseID AND F_PhasePosition IN 
				(
				SELECT F_PhasePosition FROM 
					(SELECT F_PhasePosition, DENSE_RANK() OVER(ORDER BY F_PhasePosition DESC) AS RowNumber FROM TS_Phase_Position 
						WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NULL ) AS A WHERE A.RowNumber <= @BYECount
				)

			SELECT @GroupID = CASE WHEN MAX(F_GroupID) IS NULL THEN 1 ELSE MAX(F_GroupID) + 1 END  FROM #TempGroup 
			INSERT INTO #TempGroup (F_RegisterID, F_GroupID, F_GroupType, F_ModelSection_L1, F_ModelSection_L2, F_L1_Fixed, F_L2_Fixed)
				SELECT A.F_RegisterID, @GroupID AS F_GroupID, 0, C.F_ModelSection_L1, C.F_ModelSection_L2, 1, 1 FROM TS_Phase_Position AS A INNER JOIN TM_ModelType_Position AS C ON A.F_PhasePosition = C.F_ModelPosition AND C.F_ModelType = @ModleType 
					WHERE A.F_PhaseID = @PhaseID AND A.F_RegisterID = -1

			UPDATE #ModelSections SET F_L1_CurNum = B.F_L1_CurNum FROM #ModelSections AS A INNER JOIN 
				(SELECT COUNT(F_ModelSection_L1) AS F_L1_CurNum, F_ModelSection_L1 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L1) AS B
				ON A.F_ModelSection_L1 = B.F_ModelSection_L1

			UPDATE #ModelSections SET F_L2_CurNum = B.F_L2_CurNum FROM #ModelSections AS A INNER JOIN 
				(SELECT COUNT(F_ModelSection_L2) AS F_L2_CurNum, F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L2) AS B
				ON A.F_ModelSection_L2 = B.F_ModelSection_L2

			----�ڶ���������ͬһ����ӵĵ��˶�Ա��ͬһ���ӵ������������˶�Ա��Ҫ�����رܣ�����г������������˶�Ա����Ҫ�ĸ��ķ�֮һ�����رܣ�ͬһ������ӳ����ĸ��˾Ͳ������ˣ�
			DECLARE Item_Cursor CURSOR FOR 
				SELECT COUNT(A.F_RegisterID), B.F_DelegationID FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B 
					ON A.F_RegisterID = B.F_RegisterID WHERE A.F_PhaseID = @PhaseID AND A.F_RegisterID IS NOT NULL AND A.F_RegisterID != -1
						GROUP BY B.F_DelegationID HAVING COUNT(A.F_RegisterID) >= 2 AND COUNT(A.F_RegisterID) <= 4 
							ORDER BY COUNT(A.F_RegisterID) DESC, NEWID() 

			OPEN Item_Cursor
			FETCH NEXT FROM Item_Cursor INTO @RegsterNum, @DelegationID
			WHILE @@FETCH_STATUS = 0
			BEGIN

				IF EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_DelegationID = @DelegationID)
				BEGIN
					SELECT TOP 1 @GroupID = A.F_GroupID FROM #TempGroup AS A LEFT JOIN TR_Register AS B ON A.F_RegisterID = B.F_RegisterID WHERE B.F_DelegationID = @DelegationID
				END
				ELSE
				BEGIN
					SELECT @GroupID = CASE WHEN MAX(F_GroupID) IS NULL THEN 1 ELSE MAX(F_GroupID) + 1 END  FROM #TempGroup 
				END

				IF (@RegsterNum = 2)--��������
				BEGIN

					DECLARE Item_Cursor_1 CURSOR FOR 
						SELECT A.F_RegisterID FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B 
							ON A.F_RegisterID = B.F_RegisterID WHERE A.F_PhaseID = @PhaseID AND F_DelegationID = @DelegationID
								AND A.F_RegisterID NOT IN (SELECT F_RegisterID FROM #TempGroup)
								
					OPEN Item_Cursor_1
					FETCH NEXT FROM Item_Cursor_1 INTO @RegisterID
					WHILE @@FETCH_STATUS = 0
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L1 NOT IN (SELECT F_ModelSection_L1 FROM #TempGroup WHERE F_GroupID = @GroupID)
								ORDER BY (F_L1_MaxNum - F_L1_CurNum) DESC,(F_L2_MaxNum - F_L2_CurNum) DESC, NEWID()

						IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
						BEGIN
							SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
								WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum 
									ORDER BY (F_L1_MaxNum - F_L1_CurNum) DESC, (F_L2_MaxNum - F_L2_CurNum) DESC, NEWID()
						END

						INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2) VALUES (@GroupID, 1, @RegisterID, @Section_L1, @Section_L2)

						UPDATE #ModelSections SET F_L1_CurNum = B.F_L1_CurNum FROM #ModelSections AS A INNER JOIN 
							(SELECT COUNT(F_ModelSection_L1) AS F_L1_CurNum, F_ModelSection_L1 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L1) AS B
							ON A.F_ModelSection_L1 = B.F_ModelSection_L1

						UPDATE #ModelSections SET F_L2_CurNum = B.F_L2_CurNum FROM #ModelSections AS A INNER JOIN 
							(SELECT COUNT(F_ModelSection_L2) AS F_L2_CurNum, F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L2) AS B
							ON A.F_ModelSection_L2 = B.F_ModelSection_L2

						FETCH NEXT FROM Item_Cursor_1 INTO @RegisterID
					END
					CLOSE Item_Cursor_1
					DEALLOCATE Item_Cursor_1

					UPDATE #TempGroup SET F_GroupType = 1 WHERE F_GroupID = @GroupID 

				END
				ELSE	--�ĸ�����
				BEGIN

					DECLARE Item_Cursor_1 CURSOR FOR 
						SELECT A.F_RegisterID FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B 
							ON A.F_RegisterID = B.F_RegisterID WHERE A.F_PhaseID = @PhaseID AND F_DelegationID = @DelegationID
								AND A.F_RegisterID NOT IN (SELECT F_RegisterID FROM #TempGroup)
					OPEN Item_Cursor_1
					FETCH NEXT FROM Item_Cursor_1 INTO @RegisterID
					WHILE @@FETCH_STATUS = 0
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L2 NOT IN (SELECT F_ModelSection_L2 FROM #TempGroup WHERE F_GroupID = @GroupID)
								ORDER BY (F_L1_MaxNum - F_L1_CurNum) DESC,(F_L2_MaxNum - F_L2_CurNum) DESC, NEWID()

						IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
						BEGIN
							SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
								WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum 
									ORDER BY (F_L1_MaxNum - F_L1_CurNum) DESC,(F_L2_MaxNum - F_L2_CurNum) DESC, NEWID()
						END

						INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2) VALUES (@GroupID, 2, @RegisterID, @Section_L1, @Section_L2)

						UPDATE #ModelSections SET F_L1_CurNum = B.F_L1_CurNum FROM #ModelSections AS A INNER JOIN 
							(SELECT COUNT(F_ModelSection_L1) AS F_L1_CurNum, F_ModelSection_L1 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L1) AS B
							ON A.F_ModelSection_L1 = B.F_ModelSection_L1

						UPDATE #ModelSections SET F_L2_CurNum = B.F_L2_CurNum FROM #ModelSections AS A INNER JOIN 
							(SELECT COUNT(F_ModelSection_L2) AS F_L2_CurNum, F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L2) AS B
							ON A.F_ModelSection_L2 = B.F_ModelSection_L2

						FETCH NEXT FROM Item_Cursor_1 INTO @RegisterID
					END
					CLOSE Item_Cursor_1
					DEALLOCATE Item_Cursor_1
					----����û���õ�1/4����
					INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2)
						SELECT @GroupID AS F_GroupID, 2 AS F_GroupType, -2 AS F_RegisterID, F_ModelSection_L1, F_ModelSection_L2 
							FROM #ModelSections WHERE F_ModelSection_L2 NOT IN (SELECT F_ModelSection_L2 FROM #TempGroup WHERE F_GroupID = @GroupID)

					UPDATE #TempGroup SET F_GroupType = 2 WHERE F_GroupID = @GroupID

				END
								
				FETCH NEXT FROM Item_Cursor INTO @RegsterNum, @DelegationID

			END
			CLOSE Item_Cursor
			DEALLOCATE Item_Cursor

			----�����������ݶ���ָ�����˶�Ա֮��Ļرܹ�������˶�Ա�İ������ƣ�
			DECLARE @HRegisterID		AS INT
			DECLARE @ARegisterID		AS INT
			DECLARE @GroupNum			AS INT----һ��رܹ�ϵ����Ա�ĸ���
			DECLARE @ThisItemID			AS INT
			DECLARE @OtherItemID		AS INT
			DECLARE @OtherRegisterID	AS INT
			DECLARE @ThisModelSectionL1 AS INT
			DECLARE @ThisModelSectionL2 AS INT
			DECLARE @L1Fixed			AS INT
			DECLARE @L2Fixed			AS INT

			DECLARE Item_Cursor_HA CURSOR FOR 
				SELECT F_HRegisterID, F_ARegisterID FROM TM_HA_Config WHERE F_EventCode = @EventCode 
					AND F_HRegisterID IN (SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID)
					AND F_ARegisterID IN (SELECT F_RegisterID FROM TS_Phase_Competitors WHERE F_PhaseID = @PhaseID)
					ORDER BY F_Number

			OPEN Item_Cursor_HA
			FETCH NEXT FROM Item_Cursor_HA INTO @HRegisterID, @ARegisterID
			WHILE @@FETCH_STATUS = 0
			BEGIN
				
				IF ((NOT EXISTS(SELECT F_RegisterID FROM #TempGroup WHERE F_RegisterID = @HRegisterID))
					AND (NOT EXISTS(SELECT F_RegisterID FROM #TempGroup WHERE F_RegisterID = @ARegisterID)))
				BEGIN
					
					SELECT @GroupID = CASE WHEN MAX(F_GroupID) IS NULL THEN 1 ELSE MAX(F_GroupID) + 1 END  FROM #TempGroup
					----���Ȳ���@HRegisterID
					SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
						WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum ORDER BY NEWID()

					INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2) 
						VALUES (@GroupID, 3, @HRegisterID, @Section_L1, @Section_L2)

					UPDATE #ModelSections SET F_L1_CurNum = B.F_L1_CurNum FROM #ModelSections AS A INNER JOIN 
						(SELECT COUNT(F_ModelSection_L1) AS F_L1_CurNum, F_ModelSection_L1 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L1) AS B
						ON A.F_ModelSection_L1 = B.F_ModelSection_L1

					UPDATE #ModelSections SET F_L2_CurNum = B.F_L2_CurNum FROM #ModelSections AS A INNER JOIN 
						(SELECT COUNT(F_ModelSection_L2) AS F_L2_CurNum, F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L2) AS B
						ON A.F_ModelSection_L2 = B.F_ModelSection_L2

					----���Ų���@ARegisterID
					----������@ARegisterID �� @HRegisterID�ֵ������������
					SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
						WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L1 NOT IN (SELECT F_ModelSection_L1 FROM #TempGroup WHERE F_GroupID = @GroupID)
							ORDER BY NEWID()
					
					----������о���@ARegisterID �� @HRegisterID�ֵ���ͬ���ķ�֮һ������ȥ��
					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L2 NOT IN (SELECT F_ModelSection_L2 FROM #TempGroup WHERE F_GroupID = @GroupID)
								ORDER BY NEWID()
					END

					----�ٲ��о���@ARegisterID �� @HRegisterID�ֵ�ͬһ���ķ�֮һ������ȥ�ɣ�
					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum ORDER BY NEWID()
					END

					INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2) VALUES (@GroupID, 3, @ARegisterID, @Section_L1, @Section_L2)

				END
				ELSE IF((EXISTS(SELECT F_RegisterID FROM #TempGroup WHERE F_RegisterID = @HRegisterID))
						AND (EXISTS(SELECT F_RegisterID FROM #TempGroup WHERE F_RegisterID = @ARegisterID)))
				BEGIN

					IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L1 != B.F_ModelSection_L1 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID))
					BEGIN--�Ѿ��ֵ������������ȥ��
						UPDATE #TempGroup SET F_L1_Fixed = 1 WHERE F_RegisterID IN (@HRegisterID, @ARegisterID)
					END
					ELSE IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L1 = B.F_ModelSection_L1 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID AND (A.F_L1_Fixed = 0 OR B.F_L1_Fixed = 0)))
					BEGIN--���Գ��Էֵ������������ȥ

						IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L1 != B.F_ModelSection_L1 AND A.F_RegisterID != B.F_RegisterID WHERE A.F_RegisterID = @HRegisterID AND A.F_L1_Fixed = 0 AND B.F_L1_Fixed = 0))
						BEGIN
							SELECT TOP 1 @ThisItemID = A.F_ItemID, @OtherItemID = B.F_ItemID, @OtherRegisterID =B.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B 
								ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L1 != B.F_ModelSection_L1 AND A.F_RegisterID != B.F_RegisterID 
									WHERE A.F_RegisterID = @HRegisterID AND A.F_L1_Fixed = 0 AND B.F_L1_Fixed = 0 ORDER BY NEWID()
							
							UPDATE #TempGroup SET F_RegisterID = @OtherRegisterID, F_L1_Fixed = 1 WHERE F_ItemID = @ThisItemID
							UPDATE #TempGroup SET F_RegisterID = @HRegisterID, F_L1_Fixed = 1 WHERE F_ItemID = @OtherItemID
						END
						ELSE IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L1 != B.F_ModelSection_L1 AND A.F_RegisterID != B.F_RegisterID WHERE A.F_RegisterID = @ARegisterID AND A.F_L1_Fixed = 0 AND B.F_L1_Fixed = 0))
						BEGIN
							SELECT TOP 1 @ThisItemID = A.F_ItemID, @OtherItemID = B.F_ItemID, @OtherRegisterID =B.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B 
								ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L1 != B.F_ModelSection_L1 AND A.F_RegisterID != B.F_RegisterID 
									WHERE A.F_RegisterID = @ARegisterID AND A.F_L1_Fixed = 0 AND B.F_L1_Fixed = 0 ORDER BY NEWID()
							UPDATE #TempGroup SET F_RegisterID = @OtherRegisterID, F_L1_Fixed = 1 WHERE F_ItemID = @ThisItemID
							UPDATE #TempGroup SET F_RegisterID = @ARegisterID, F_L1_Fixed = 1 WHERE F_ItemID = @OtherItemID
						END 
						ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID))
						--�޷��ֵ�����������ȥ��Ӧ�ó��Էֵ�����1/4������ȥ
						BEGIN--�Ѿ��ֵ������ķ�֮һ������ȥ
							UPDATE #TempGroup SET F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_RegisterID IN (@HRegisterID, @ARegisterID)
						END
						ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID AND (A.F_L2_Fixed = 0 OR B.F_L2_Fixed = 0)))
						BEGIN--���Գ��Էֵ������ķ�֮һ������ȥ

							IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L1 != B.F_ModelSection_L1 AND A.F_RegisterID != B.F_RegisterID WHERE A.F_RegisterID = @HRegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0))
							BEGIN
								SELECT TOP 1 @ThisItemID = A.F_ItemID, @OtherItemID = B.F_ItemID, @OtherRegisterID =B.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B 
									ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L2 != B.F_ModelSection_L2 AND A.F_RegisterID != B.F_RegisterID 
										WHERE A.F_RegisterID = @HRegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0 ORDER BY NEWID()
								UPDATE #TempGroup SET F_RegisterID = @OtherRegisterID, F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_ItemID = @ThisItemID
								UPDATE #TempGroup SET F_RegisterID = @HRegisterID, F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_ItemID = @OtherItemID
							END
							ELSE IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L1 != B.F_ModelSection_L1 AND A.F_RegisterID != B.F_RegisterID WHERE A.F_RegisterID = @ARegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0))
							BEGIN
								SELECT TOP 1 @ThisItemID = A.F_ItemID, @OtherItemID = B.F_ItemID, @OtherRegisterID =B.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B 
									ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L2 != B.F_ModelSection_L2 AND A.F_RegisterID != B.F_RegisterID 
										WHERE A.F_RegisterID = @ARegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0 ORDER BY NEWID()
								UPDATE #TempGroup SET F_RegisterID = @OtherRegisterID, F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_ItemID = @ThisItemID
								UPDATE #TempGroup SET F_RegisterID = @ARegisterID, F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_ItemID = @OtherItemID
							END 
							ELSE
							BEGIN
								PRINT '�޷��ֵ�����1/4������ȥ���������κβ����ˣ�'
							END

						END
					END
					ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID))
					BEGIN--�Ѿ��ֵ������ķ�֮һ������ȥ
						UPDATE #TempGroup SET F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_RegisterID IN (@HRegisterID, @ARegisterID)
					END
					ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID AND (A.F_L2_Fixed = 0 OR B.F_L2_Fixed = 0)))
					BEGIN--���Գ��Էֵ������ķ�֮һ������ȥ

						IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L2 != B.F_ModelSection_L2 AND A.F_RegisterID != B.F_RegisterID WHERE A.F_RegisterID = @HRegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0))
						BEGIN
							SELECT TOP 1 @ThisItemID = A.F_ItemID, @OtherItemID = B.F_ItemID, @OtherRegisterID =B.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B 
								ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L2 != B.F_ModelSection_L2 AND A.F_RegisterID != B.F_RegisterID 
									WHERE A.F_RegisterID = @HRegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0 ORDER BY NEWID()
							UPDATE #TempGroup SET F_RegisterID = @OtherRegisterID, F_L1_Fixed = 0 WHERE F_ItemID = @ThisItemID
							UPDATE #TempGroup SET F_RegisterID = @HRegisterID, F_L1_Fixed = 0 WHERE F_ItemID = @OtherItemID
						END
						ELSE IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L2 != B.F_ModelSection_L2 AND A.F_RegisterID != B.F_RegisterID WHERE A.F_RegisterID = @ARegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0))
						BEGIN
							SELECT TOP 1 @ThisItemID = A.F_ItemID, @OtherItemID = B.F_ItemID, @OtherRegisterID =B.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B 
								ON A.F_GroupID =B.F_GroupID AND A.F_ModelSection_L2 != B.F_ModelSection_L2 AND A.F_RegisterID != B.F_RegisterID 
									WHERE A.F_RegisterID = @ARegisterID AND A.F_L2_Fixed = 0 AND B.F_L2_Fixed = 0 ORDER BY NEWID()
							UPDATE #TempGroup SET F_RegisterID = @OtherRegisterID, F_L1_Fixed = 0 WHERE F_ItemID = @ThisItemID
							UPDATE #TempGroup SET F_RegisterID = @ARegisterID, F_L1_Fixed = 0 WHERE F_ItemID = @OtherItemID
						END 
						ELSE
						BEGIN
							PRINT '�޷��ֵ�����1/4������ȥ���������κβ����ˣ�'
						END

					END

				END
				ELSE IF(EXISTS(SELECT F_RegisterID FROM #TempGroup WHERE F_RegisterID = @HRegisterID))
				BEGIN
					
					SELECT @GroupID = CASE WHEN MAX(F_GroupID) IS NULL THEN 1 ELSE MAX(F_GroupID) + 1 END  FROM #TempGroup
					SELECT @ThisModelSectionL1 = F_ModelSection_L1, @ThisModelSectionL2 = F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID = @HRegisterID

					SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
						WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L1 != @ThisModelSectionL1 ORDER BY NEWID()
					SET @L1Fixed = 1
					SET @L2Fixed = 0
					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L2 != @ThisModelSectionL2 ORDER BY NEWID() 
					END

					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum ORDER BY NEWID() 
						SET @L1Fixed = 1
						SET @L2Fixed = 1
					END

					INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2, F_L1_Fixed, F_L2_Fixed) 
						VALUES (@GroupID, 3, @ARegisterID, @Section_L1, @Section_L2, @L1Fixed, @L2Fixed)
					UPDATE #TempGroup SET F_L1_Fixed = @L1Fixed, F_L2_Fixed = @L2Fixed WHERE F_RegisterID = @HRegisterID

				END
				ELSE IF(EXISTS(SELECT F_RegisterID FROM #TempGroup WHERE F_RegisterID = @ARegisterID))
				BEGIN
					
					SELECT @GroupID = CASE WHEN MAX(F_GroupID) IS NULL THEN 1 ELSE MAX(F_GroupID) + 1 END  FROM #TempGroup
					SELECT @ThisModelSectionL1 = F_ModelSection_L1, @ThisModelSectionL2 = F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID = @ARegisterID

					SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
						WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L1 != @ThisModelSectionL1 ORDER BY NEWID()
					SET @L1Fixed = 1
					SET @L2Fixed = 0
					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L2 != @ThisModelSectionL2 ORDER BY NEWID() 
					END

					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum  ORDER BY NEWID() 
						SET @L1Fixed = 1
						SET @L2Fixed = 1
					END

					INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2, F_L1_Fixed, F_L2_Fixed) 
						VALUES (@GroupID, 3, @HRegisterID, @Section_L1, @Section_L2, @L1Fixed, @L2Fixed)
					UPDATE #TempGroup SET F_L1_Fixed = @L1Fixed, F_L2_Fixed = @L2Fixed WHERE F_RegisterID = @ARegisterID

				END

				----ÿ������һ��HAԼ����������һ����ʣ�ķ���λ����Ŀ��
				UPDATE #ModelSections SET F_L1_CurNum = B.F_L1_CurNum FROM #ModelSections AS A INNER JOIN 
					(SELECT COUNT(F_ModelSection_L1) AS F_L1_CurNum, F_ModelSection_L1 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L1) AS B
					ON A.F_ModelSection_L1 = B.F_ModelSection_L1

				UPDATE #ModelSections SET F_L2_CurNum = B.F_L2_CurNum FROM #ModelSections AS A INNER JOIN 
					(SELECT COUNT(F_ModelSection_L2) AS F_L2_CurNum, F_ModelSection_L2 FROM #TempGroup WHERE F_RegisterID > 0 GROUP BY F_ModelSection_L2) AS B
					ON A.F_ModelSection_L2 = B.F_ModelSection_L2

				FETCH NEXT FROM Item_Cursor_HA INTO @HRegisterID, @ARegisterID
				
			END
			CLOSE Item_Cursor_HA
			DEALLOCATE Item_Cursor_HA

--			SELECT @DisciplineCode, @EventCode
--			SELECT * FROM #ModelSections
--			SELECT * FROM #TempGroup


			----���Ĳ����а������Ƶĸ����˶�Ա�����ָ��ǩλPhasePosition��
			DELETE FROM #TempGroup WHERE F_RegisterID IN (SELECT F_RegisterID FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID) 
			DELETE FROM #TempGroup WHERE F_RegisterID = -2
			DECLARE @PhasePosition AS INT
			DECLARE Item_Cursor_Register CURSOR FOR 
				SELECT F_RegisterID FROM #TempGroup

			OPEN Item_Cursor_Register
			FETCH NEXT FROM Item_Cursor_Register INTO @RegisterID
			WHILE @@FETCH_STATUS = 0
			BEGIN

				SELECT TOP 1 @PhasePosition = B.F_ModelPosition FROM #TempGroup AS A LEFT JOIN TM_ModelType_Position AS B ON A.F_ModelSection_L1 = B.F_ModelSection_L1 
					AND A.F_ModelSection_L2 = B.F_ModelSection_L2 AND B.F_ModelType = @ModleType 
						WHERE A.F_RegisterID = @RegisterID AND B.F_ModelPosition NOT IN (SELECT F_PhasePosition FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID AND F_RegisterID IS NOT NULL)
							ORDER BY NEWID() 

				UPDATE TS_Phase_Position SET F_RegisterID = @RegisterID WHERE F_PhaseID = @PhaseID AND F_PhasePosition = @PhasePosition
				FETCH NEXT FROM Item_Cursor_Register INTO @RegisterID

			END
			CLOSE Item_Cursor_Register
			DEALLOCATE Item_Cursor_Register

			----���岽��ʣ���û���κ����Ʋ�����Ա�Ľ��������ǩ����û���κ����Ƶĳ�ǩ�Ľ����ʽ����ȫһ�µġ�
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
		ELSE--ֻΪKR��Ŀ����ǩ���⴦���������Ŀ�������Ƶ������ǩ��
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

    END

    COMMIT TRANSACTION --�ɹ��ύ����
		
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO
/*
EXEC Proc_AutoDrawPhasePosition 1,0,0
GO
exec Proc_CleanDrawPhasePosition 1,0
GO
*/



