IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_Interface_UpdatePlayerShootOffArrow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_Interface_UpdatePlayerShootOffArrow]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_Interface_UpdatePlayerShootOffArrow]
--描    述: 射箭项目,更新某人一次箭靶信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2012年7月21日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_Interface_UpdatePlayerShootOffArrow]
	@MatchID				INT,
	@RegisterID				INT,
	@EndIndex				NVARCHAR(10),
	@ArrowIndex				NVARCHAR(10),
	@Ring					NVARCHAR(10),
	@Distance				NVARCHAR(10),
	@Result  			    AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SET @Result=0;  -- @Result=0; 	更新Match失败，标示没有做任何操作！
					-- @Result=1; 	更新Match成功，返回！
					-- @Result=-1; 	更新Match失败，@MatchID无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --设定事务
	
	--设置比赛状态
	UPDATE TS_Match SET F_MatchStatusID =50 WHERE F_MatchID =@MatchID
	
	
	DECLARE @ShootOffCount INT
	SELECT @ShootOffCount = E.F_PlayerRegTypeID FROM TS_Match AS M
		LEFT JOIN TS_Phase AS P ON P.F_PhaseID = M.F_PhaseID
		LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
		WHERE F_MatchID =@MatchID
	--如果存储局、箭数据结构不存在，根据规则创建
	IF NOT EXISTS (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID =@MatchID AND F_MatchSplitType=2)
	BEGIN
		IF @ShootOffCount IS NOT NULL
		BEGIN
				DECLARE	@IsCreate int
				exec Proc_AR_AddMatchSplits @MatchID,1,@ShootOffCount,1,2,@IsCreate OUTPUT
				if(@IsCreate !=1)
				BEGIN
					ROLLBACK   --事务回滚
					SET @Result=@IsCreate
					RETURN
				END
							
				IF @@error<>0  --事务失败返回  
				BEGIN 
					ROLLBACK   --事务回滚
					SET @Result=0
					RETURN
				END

		END
	END
	
	
	DECLARE @Arrow VARCHAR(10)
	DECLARE @IsX Int
	SET @IsX =0
	IF(UPPER(@Ring) = 'X')
	BEGIN
		SET @Ring = '10'
		SET @IsX = 1
	END
	ELSE IF(UPPER(@Ring) = 'M')
	BEGIN
		SET @Ring = '0'
	END	
	ELSE IF(UPPER(@Ring) = '')
	BEGIN
		SET @Ring = Null
	END
	
	DECLARE @CompetitionPosition INT
	SELECT @CompetitionPosition=F_CompetitionPosition
		 FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID=@RegisterID
		 
	DECLARE @MathcSplitID INT
	SELECT  @MathcSplitID = F_MatchSplitID FROM TS_Match_Split_Info  
		WHERE F_MatchID=@MatchID AND F_MatchSplitType=2
			AND  F_FatherMatchSplitID=0 
			AND  F_MatchSplitCode = 1  
			
	UPDATE TS_Match_Split_Result 
	SET F_Points = @Ring, 
		F_SplitInfo1 = (CASE WHEN @Ring ='10' OR UPPER(@Ring) = 'X' THEN 1 ELSE 0 END),
		F_SplitInfo2 =@IsX
	   ,F_Comment=CASE WHEN ISNUMERIC(@Distance)=1 AND @Distance LIKE '%[0-9][0-9].[0-9][0-9]%' then @Distance
			WHEN ISNUMERIC(@Distance)=1 AND @Distance LIKE '%[0-9][0-9].[0-9]%' then @Distance
			WHEN ISNUMERIC(@Distance)=1 AND @Distance LIKE '%[0-9].[0-9][0-9]%' then @Distance
			WHEN ISNUMERIC(@Distance)=1 AND @Distance LIKE '%[0-9].[0-9] %' then @Distance
			WHEN ISNUMERIC(@Distance)=1 AND @Distance LIKE '%[0-9]%' then @Distance
			else '0' end
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID AND  MSI.F_MatchID= @MatchID 
	WHERE MSI.F_MatchID= @MatchID 
	AND MSR.F_MatchID=@MatchID 
	AND MSI.F_FatherMatchSplitID = @MathcSplitID 
	AND MSR.F_CompetitionPosition = @CompetitionPosition
	AND MSI.F_MatchSplitType = 3
	AND MSI.F_Order = @ArrowIndex
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END
	
	--更新每局环数
	UPDATE TS_Match_Split_Result SET F_Points = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 3 )
		,F_Comment1 =  (SELECT SUM(F_SplitInfo1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 3 )
		,F_Comment2 =  (SELECT SUM(F_SplitInfo2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 3 )
		,F_Comment =  (SELECT CAST(SUM(CAST(F_Comment AS decimal(5,2))) AS NVARCHAR(20))
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 3 )
		FROM TS_Match_Split_Result AS MSR
		LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
		WHERE MSR.F_MatchID= @MatchID 
		AND MSI.F_MatchSplitID = @MathcSplitID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 2
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END
		
	--更新比赛附加赛环数，距离
	UPDATE TS_Match_Result SET F_FinishTimeNumDes = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 2)
			,F_FinishTimeCharDes = (SELECT CAST(SUM(CAST(F_Comment AS decimal(5,2))) AS NVARCHAR(20))
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 2)					
			FROM TS_Match_Result AS MR
			WHERE MR.F_MatchID= @MatchID 
				AND MR.F_CompetitionPosition = @CompetitionPosition
	IF @@error<>0  --事务失败返回  
	BEGIN 
		ROLLBACK   --事务回滚
		SET @Result=0
		RETURN
	END
	
	DECLARE @MatchType					   INT--淘汰赛1,排位赛0	
	SELECT @MatchType= F_MatchComment5 FROM TS_Match WHERE F_MatchID =@MatchID
		  	
	IF(@MatchType=1)
	--淘汰赛
		BEGIN
			--更新胜负
			UPDATE MR SET F_Rank = CASE WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes>0 THEN 1 
										WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes<0 THEN 2 
										WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
									     AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))<0 THEN 1
										WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
									     AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))>0 THEN 2 
									    ELSE NULL END
						FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID= @MatchID AND MR2.F_CompetitionPosition != @CompetitionPosition
						WHERE MR.F_MatchID= @MatchID AND MR.F_CompetitionPosition = @CompetitionPosition
			UPDATE MR SET F_Rank = CASE WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes>0 THEN 1 
										WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes<0 THEN 2 
										WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
									     AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))<0 THEN 1
										WHEN MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
									     AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))>0 THEN 2 
									    ELSE NULL END
						FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID= @MatchID AND MR2.F_CompetitionPosition = @CompetitionPosition
						WHERE MR.F_MatchID= @MatchID AND MR.F_CompetitionPosition != @CompetitionPosition 				
			
			--更新比赛状态Officials
			IF EXISTS(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID= @MatchID AND F_Rank=1)
				BEGIN
					UPDATE TS_Match SET F_MatchStatusID =110 WHERE F_MatchID =@MatchID
				END		
		END
	--排位赛
	ELSE
		BEGIN
			CREATE TABLE #Temp_V
			(
								F_Rank				INT, 
								F_RegisterID		INT,
								F_MatchID			INT  
			)
			INSERT INTO #Temp_V(F_Rank,F_RegisterID,F_MatchID)
			(SELECT CASE WHEN F_Points IS NULL THEN NULL 
						 ELSE  row_number() over(order by F_Points desc, F_WinPoints desc ,F_LosePoints desc,F_FinishTimeNumDes DESC,F_FinishTimeCharDes) END
				   ,F_RegisterID,F_MatchID
				FROM TS_Match_Result  WHERE  F_MatchID= @MatchID)
			
			UPDATE MR SET F_Rank = TV.F_Rank
			FROM TS_Match_Result AS MR
			LEFT JOIN #Temp_V AS TV ON TV.F_MatchID=@MatchID AND TV.F_RegisterID=MR.F_RegisterID
					WHERE MR.F_MatchID= @MatchID
			IF @@error<>0  --事务失败返回  
					BEGIN 
						ROLLBACK   --事务回滚
						SET @Result=0
						RETURN
					END
		END	 
	
	COMMIT TRANSACTION --成功提交事务

	
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_Interface_UpdatePlayerShootOffArrow 1,1,'1','1','9','5',OUTPUT
*/
