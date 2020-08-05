IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AutoDrawPhasePosition_KR]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_KR]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_AutoDrawPhasePosition_KR]
--描    述: 空手道比赛，随机生成比赛初始签位
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2009-09-08
/*	
		序号	日期		修改者		修改描述
		1.		2010-04-30	郑金勇		实现用户部分签位手动指定，部分签位自动抽签。
		2.		2010-04-30	郑金勇		实现同一代表团的队员半区或者1/4半区回避，最多处理以代表团内报四个人进行回避。
		3.		2010-04-30  郑金勇		实现部分预先指定的运动员回避规则
		4.		2010-08-18  郑金勇		空手道抽签功能仅仅保证Phase级别的抽签，如果是Event级别的抽签暂时无法进行。
*/


CREATE PROCEDURE [dbo].[Proc_AutoDrawPhasePosition_KR]
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
									F_GroupType				INT NOT NULL,--0表示预先指定签位的运动员的半区，1表示分为上下半区，2表示分为四个四分之一半区，3表示额外指定的运动员之间的回避规则半区
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



			----第一步：首先处理预先指定签位的运动员，比如种子选手！

			INSERT INTO #TempGroup (F_RegisterID, F_GroupID, F_GroupType, F_ModelSection_L1, F_ModelSection_L2, F_L1_Fixed, F_L2_Fixed)
			SELECT A.F_RegisterID, DENSE_RANK() OVER(ORDER BY B.F_DelegationID) AS F_GroupID, 0, C.F_ModelSection_L1, C.F_ModelSection_L2, 1, 1  
				FROM TS_Phase_Position AS A LEFT JOIN TR_Register AS B 
				ON A.F_RegisterID = B.F_RegisterID LEFT JOIN TM_ModelType_Position AS C ON A.F_PhasePosition = C.F_ModelPosition AND C.F_ModelType = @ModleType 
				WHERE A.F_PhaseID = @PhaseID AND B.F_DelegationID IN 
				(SELECT B.F_DelegationID FROM TS_Phase_Competitors AS A LEFT JOIN TR_Register AS B 
					ON A.F_RegisterID = B.F_RegisterID WHERE A.F_PhaseID = @PhaseID AND A.F_RegisterID IS NOT NULL AND A.F_RegisterID != -1
						GROUP BY B.F_DelegationID HAVING COUNT(A.F_RegisterID) >= 2 AND COUNT(A.F_RegisterID) <= 4)


			----附加一步：所有的处理之前应该保证轮空运动员的位置确定好！
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

			----第二步：处理同一代表队的的运动员，同一赛队的有两个参赛运动员需要半区回避，如果有超过三个参赛运动员则需要四个四分之一半区回避，同一个代表队超过四个人就不处理了！
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

				IF (@RegsterNum = 2)--两个半区
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
				ELSE	--四个半区
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
					----插入没有用到1/4半区
					INSERT INTO #TempGroup (F_GroupID, F_GroupType, F_RegisterID, F_ModelSection_L1, F_ModelSection_L2)
						SELECT @GroupID AS F_GroupID, 2 AS F_GroupType, -2 AS F_RegisterID, F_ModelSection_L1, F_ModelSection_L2 
							FROM #ModelSections WHERE F_ModelSection_L2 NOT IN (SELECT F_ModelSection_L2 FROM #TempGroup WHERE F_GroupID = @GroupID)

					UPDATE #TempGroup SET F_GroupType = 2 WHERE F_GroupID = @GroupID

				END
								
				FETCH NEXT FROM Item_Cursor INTO @RegsterNum, @DelegationID

			END
			CLOSE Item_Cursor
			DEALLOCATE Item_Cursor

			----第三步：根据额外指定的运动员之间的回避规则进行运动员的半区限制！
			DECLARE @HRegisterID		AS INT
			DECLARE @ARegisterID		AS INT
			DECLARE @GroupNum			AS INT----一组回避关系中人员的个数
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
					----首先插入@HRegisterID
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

					----接着插入@ARegisterID
					----尽量让@ARegisterID 与 @HRegisterID分到两个大半区！
					SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
						WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L1 NOT IN (SELECT F_ModelSection_L1 FROM #TempGroup WHERE F_GroupID = @GroupID)
							ORDER BY NEWID()
					
					----如果不行就让@ARegisterID 与 @HRegisterID分到不同的四分之一半区中去！
					IF ((@Section_L1 IS NULL) OR (@Section_L2 IS NULL))
					BEGIN
						SELECT TOP 1 @Section_L1 = F_ModelSection_L1, @Section_L2 = F_ModelSection_L2 FROM #ModelSections 
							WHERE F_L1_CurNum < F_L1_MaxNum AND F_L2_CurNum < F_L2_MaxNum AND F_ModelSection_L2 NOT IN (SELECT F_ModelSection_L2 FROM #TempGroup WHERE F_GroupID = @GroupID)
								ORDER BY NEWID()
					END

					----再不行就让@ARegisterID 与 @HRegisterID分到同一个四分之一半区中去吧！
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
					BEGIN--已经分到两个大半区中去了
						UPDATE #TempGroup SET F_L1_Fixed = 1 WHERE F_RegisterID IN (@HRegisterID, @ARegisterID)
					END
					ELSE IF (EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L1 = B.F_ModelSection_L1 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID AND (A.F_L1_Fixed = 0 OR B.F_L1_Fixed = 0)))
					BEGIN--可以尝试分到两个大半区中去

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
						--无法分到两个半区中去！应该尝试分到两个1/4半区中去
						BEGIN--已经分到两个四分之一半区中去
							UPDATE #TempGroup SET F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_RegisterID IN (@HRegisterID, @ARegisterID)
						END
						ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID AND (A.F_L2_Fixed = 0 OR B.F_L2_Fixed = 0)))
						BEGIN--可以尝试分到两个四分之一半区中去

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
								PRINT '无法分到两个1/4半区中去！放弃做任何操作了！'
							END

						END
					END
					ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID))
					BEGIN--已经分到两个四分之一半区中去
						UPDATE #TempGroup SET F_L1_Fixed = 1, F_L2_Fixed = 1 WHERE F_RegisterID IN (@HRegisterID, @ARegisterID)
					END
					ELSE IF(EXISTS(SELECT A.F_RegisterID FROM #TempGroup AS A INNER JOIN #TempGroup AS B ON A.F_ModelSection_L2 = B.F_ModelSection_L2 WHERE A.F_RegisterID = @HRegisterID AND B.F_RegisterID = @ARegisterID AND (A.F_L2_Fixed = 0 OR B.F_L2_Fixed = 0)))
					BEGIN--可以尝试分到两个四分之一半区中去

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
							PRINT '无法分到两个1/4半区中去！放弃做任何操作了！'
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

				----每处理完一个HA约束条件更新一下所剩的分组位置数目。
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


			----第四步：有半区限制的各个运动员随机的指定签位PhasePosition！
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

			----第五步：剩余的没有任何限制参赛人员的进行随机抽签，与没有任何限制的抽签的解决方式是完全一致的。
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
		ELSE--只为KR项目作抽签特殊处理，其余的项目做无限制的随机抽签！
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

    END

    COMMIT TRANSACTION --成功提交事务
		
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



