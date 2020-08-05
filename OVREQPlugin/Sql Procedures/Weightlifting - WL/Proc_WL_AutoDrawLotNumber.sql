IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WL_AutoDrawLotNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WL_AutoDrawLotNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--名    称: [Proc_WL_AutoDrawLotNumber]
--描    述: 举重比赛随机签位
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--修 改 人：崔凯	
--修改描述：举重比赛随机签位
--日    期: 2011-04-10


CREATE PROCEDURE [dbo].[Proc_WL_AutoDrawLotNumber]
	@EventID					INT,
	@SexCode					INT,
    @Type                       INT,  --抽签类别：1所有报项人员抽签，0指定到比赛位位置人员抽签
	@Result						AS INT OUTPUT	
AS
BEGIN
SET NOCOUNT ON

	SET @Result = 0;  -- @Result = 0; 	表示生成初始比赛签位失败，什么动作也没有
					  -- @Result = 1; 	表示生成初始比赛签位

	
		CREATE TABLE #table_EventPositon(
                                     F_EventID              INT,
									 F_SexCode				INT,  
                                     F_RegisterID           INT
                                     )

		----崔凯：临时表储存随机生成seed号，作为举重运动员签号
		CREATE TABLE #table_ExistEventSeed(		
                                     F_RegisterID           INT,
                                     F_Seed	                INT,
									 F_SexCode			INT,
									 F_EventID			INT
                                     )
											  
		
		SET Implicit_Transactions off
		BEGIN TRANSACTION --设定事务
			
			IF(@Type = 1)			
			BEGIN	
				----崔凯：生成待抽人员，插入临时表
				INSERT INTO #table_EventPositon (F_RegisterID,F_SexCode,F_EventID)
						SELECT I.F_RegisterID,R.F_SexCode,I.F_EventID FROM TR_Inscription AS I
						LEFT JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID
							WHERE I.F_RegisterID IS NOT NULL AND R.F_RegTypeID=1
			
					IF @@error<>0  --事务失败返回  
					BEGIN 
						ROLLBACK   --事务回滚
						SET @Result=0
						RETURN
					END			
							
			END
			ELSE IF(@Type = 0)	
			BEGIN
					----崔凯：生成待抽人员，插入临时表
					INSERT INTO #table_EventPositon (F_RegisterID,F_SexCode,F_EventID)
						SELECT I.F_RegisterID,R.F_SexCode,I.F_EventID FROM TS_Event_Competitors AS I
						LEFT JOIN TR_Register AS R ON R.F_RegisterID = I.F_RegisterID
							WHERE I.F_RegisterID IS NOT NULL AND R.F_RegTypeID=1
							
					IF @@error<>0  --事务失败返回  
					BEGIN 
						ROLLBACK   --事务回滚
						SET @Result=0
						RETURN
					END					
					
			END
			
		IF (@SexCode != -1)
		BEGIN
			DELETE FROM #table_EventPositon WHERE (F_SexCode != @SexCode OR F_SexCode IS NULL)
		END	 

		IF (@EventID != -1)
		BEGIN		
			DELETE FROM #table_EventPositon WHERE F_EventID <> @EventID
			--F_RegisterID NOT IN (SELECT F_RegisterID FROM TR_Inscription WHERE F_EventID = @EventID)			
		END
						
			----崔凯：随机生成seed号，插入临时表作为举重运动员签号				
			INSERT INTO #table_ExistEventSeed (F_RegisterID,F_Seed,F_SexCode,F_EventID)
					SELECT F_RegisterID,ROW_NUMBER() over(order by newid()),F_SexCode,F_EventID FROM #table_EventPositon

					
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END	
				
			----崔凯：将运动员签号插入报名报项表
			Update TR_Inscription SET F_Seed=T.F_Seed FROM TR_Inscription AS I 
				 INNER JOIN #table_ExistEventSeed AS T ON T.F_RegisterID = I.F_RegisterID
						
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END	

		COMMIT TRANSACTION --成功提交事务	   
		
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END



GO


