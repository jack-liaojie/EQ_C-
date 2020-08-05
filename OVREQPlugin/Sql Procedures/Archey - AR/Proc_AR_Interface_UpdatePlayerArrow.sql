IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_Interface_UpdatePlayerArrow]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_Interface_UpdatePlayerArrow]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--��    ��: [Proc_AR_Interface_UpdatePlayerArrow]
--��    ��: �����Ŀ,����ĳ��һ�μ�����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2012��7��21��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_AR_Interface_UpdatePlayerArrow]
	@MatchID				INT,
	@RegisterID				INT,
	@EndIndex				NVARCHAR(10),
	@ArrowIndex				NVARCHAR(10),
	@Ring					NVARCHAR(10),
	@Result  			    AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	
	SET @Result=0;  -- @Result=0; 	����Matchʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	����Match�ɹ������أ�
					-- @Result=-1; 	����Matchʧ�ܣ�@MatchID��Ч

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	SET Implicit_Transactions OFF
	BEGIN TRANSACTION --�趨����	
	
	--����洢�֡������ݽṹ�����ڣ����ݹ��򴴽�
	IF NOT EXISTS (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID =@MatchID )
	BEGIN
		DECLARE @CompetitionRuleID INT
		SELECT @CompetitionRuleID = F_CompetitionRuleID FROM TS_Match WHERE F_MatchID =@MatchID
		IF @CompetitionRuleID IS NOT NULL
		BEGIN
				DECLARE	@IsCreate int
				exec Proc_AR_ApplyNewMatchRule @MatchID,@CompetitionRuleID,1,@IsCreate OUTPUT
				if(@IsCreate !=1)
				BEGIN
					ROLLBACK   --����ع�
					SET @Result=@IsCreate
					RETURN
				END 
		END
	END
	
	--���ñ���״̬
	UPDATE TS_Match SET F_MatchStatusID =50 WHERE F_MatchID =@MatchID	
	
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
		WHERE F_MatchID=@MatchID AND F_MatchSplitType=0
			AND  F_FatherMatchSplitID=0 
			AND  F_MatchSplitCode = @EndIndex  
			
	UPDATE TS_Match_Split_Result 
	SET F_Points = @Ring, 
		F_SplitInfo1 = (CASE WHEN @Ring ='10' OR UPPER(@Ring) = 'X' THEN 1 ELSE 0 END),
		F_SplitInfo2 =@IsX
	FROM TS_Match_Split_Result AS MSR
	LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID AND  MSI.F_MatchID= @MatchID 
	WHERE MSI.F_MatchID= @MatchID 
	AND MSR.F_MatchID=@MatchID 
	AND MSI.F_FatherMatchSplitID = @MathcSplitID 
	AND MSR.F_CompetitionPosition = @CompetitionPosition
	AND MSI.F_MatchSplitType = 1
	AND MSI.F_Order = @ArrowIndex	
	IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END
	
	
			DECLARE @EndCount				       INT--�غ���Ŀ
			DECLARE @ArrowCount			           INT--ÿһ�غϵļ���
			DECLARE @IsSetPoints			       INT--�Ƿ����ÿ�ֵ�����ʤ
			DECLARE @WinPoints			           INT--ʤ�ߵ���
			DECLARE @MatchType					   INT--��̭��1,��λ��0
			DECLARE @DistinceNum			       INT--�о�
	
	SELECT @EndCount= F_MatchComment1,@ArrowCount= F_MatchComment2,@IsSetPoints= F_MatchComment3
		  ,@WinPoints= F_MatchComment4,@MatchType= F_MatchComment5,@DistinceNum= F_MatchComment6  		  
		  FROM TS_Match WHERE F_MatchID =@MatchID
	
	--����ÿ�ֻ���
	UPDATE TS_Match_Split_Result SET F_Points = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 1 )
		,F_Comment1 =  (SELECT SUM(F_SplitInfo1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 1 )
		,F_Comment2 =  (SELECT SUM(F_SplitInfo2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_FatherMatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 1 )
		FROM TS_Match_Split_Result AS MSR
		LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
		WHERE MSR.F_MatchID= @MatchID 
		AND MSI.F_MatchSplitID = @MathcSplitID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0
	IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END
		
	--���±����ܻ���
	UPDATE TS_Match_Result SET F_Points = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0)
			,F_WinPoints = (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0)
			,F_LosePoints = (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0)	
			,F_PointsNumDes1 = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0
					AND MSI.F_MatchSplitPrecision=1)	
			,F_PointsNumDes2 = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0
					AND MSI.F_MatchSplitPrecision=2)		
			,F_PointsNumDes3 = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0
					AND MSI.F_MatchSplitPrecision=3)			
			,F_PointsNumDes4 = (SELECT SUM(F_Points)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
					AND MSI.F_FatherMatchSplitID = 0 
					AND MSR.F_CompetitionPosition = @CompetitionPosition
					AND MSI.F_MatchSplitType = 0
					AND MSI.F_MatchSplitPrecision=4)							
			FROM TS_Match_Result AS MR
			WHERE MR.F_MatchID= @MatchID 
				AND MR.F_CompetitionPosition = @CompetitionPosition
	IF @@error<>0  --����ʧ�ܷ���  
	BEGIN 
		ROLLBACK   --����ع�
		SET @Result=0
		RETURN
	END
			
	IF(@MatchType=1)
	--��̭��
		BEGIN
			--����ÿ��˫������
			IF (@IsSetPoints =1  AND @ArrowIndex=@ArrowCount)
			BEGIN 
				UPDATE MSR 
					SET MSR.F_SplitPoints= CASE WHEN ISNULL(MSR.F_Points,0)-ISNULL(MSR2.F_Points,0) >0 THEN 2 
												WHEN ISNULL(MSR.F_Points,0)-ISNULL(MSR2.F_Points,0) =0 THEN 1 
												ELSE 0 END
				FROM TS_Match_Split_Result AS MSR
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				LEFT JOIN TS_Match_Split_Result AS MSR2 ON  MSR2.F_MatchID= @MatchID   
							AND MSR2.F_MatchSplitID =@MathcSplitID  AND MSR2.F_CompetitionPosition != @CompetitionPosition 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0 
				
				UPDATE MSR 
					SET MSR.F_SplitPoints= CASE WHEN ISNULL(MSR.F_Points,0)-ISNULL(MSR2.F_Points,0) >0 THEN 2 
												WHEN ISNULL(MSR.F_Points,0)-ISNULL(MSR2.F_Points,0) =0 THEN 1 
												ELSE 0 END
				FROM TS_Match_Split_Result AS MSR
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				LEFT JOIN TS_Match_Split_Result AS MSR2 ON  MSR2.F_MatchID= @MatchID   
							AND MSR2.F_MatchSplitID =@MathcSplitID  AND MSR2.F_CompetitionPosition = @CompetitionPosition 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSI.F_MatchSplitID = @MathcSplitID 
				AND MSR.F_CompetitionPosition != @CompetitionPosition
				AND MSI.F_MatchSplitType = 0 
				
				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END
				
				
				--���µ��������ܵ���	
				UPDATE TS_Match_Result SET F_RealScore = (SELECT SUM(F_SplitPoints)
						FROM TS_Match_Split_Result AS MSR		
						LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
						WHERE MSR.F_MatchID= @MatchID 
						AND MSI.F_FatherMatchSplitID = 0 
						AND MSR.F_CompetitionPosition = @CompetitionPosition
						AND MSI.F_MatchSplitType = 0)	
					FROM TS_Match_Result AS MR
					WHERE MR.F_MatchID= @MatchID 
						  AND MR.F_CompetitionPosition = @CompetitionPosition
			
				UPDATE TS_Match_Result SET F_RealScore = (SELECT SUM(F_SplitPoints)
						FROM TS_Match_Split_Result AS MSR		
						LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
						WHERE MSR.F_MatchID= @MatchID 
						AND MSI.F_FatherMatchSplitID = 0 
						AND MSR.F_CompetitionPosition != @CompetitionPosition
						AND MSI.F_MatchSplitType = 0)			
					FROM TS_Match_Result AS MR
					WHERE MR.F_MatchID= @MatchID 
						  AND MR.F_CompetitionPosition != @CompetitionPosition
					IF @@error<>0  --����ʧ�ܷ���  
					BEGIN 
						ROLLBACK   --����ع�
						SET @Result=0
						RETURN
					END
			END
			 
				
			--����ʤ��
			--����ȡʤ
			IF(@IsSetPoints =1)
				BEGIN
					UPDATE MR SET F_Rank = CASE WHEN MR.F_RealScore>=6 THEN 1 
												WHEN MR2.F_RealScore>=6 THEN 2
												WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes>0 THEN 1 
												WHEN MR.F_RealScore = MR2.F_RealScore AND  MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes<0 THEN 2 
												WHEN MR.F_RealScore = MR2.F_RealScore AND  MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))<0 THEN 1
												WHEN MR.F_RealScore = MR2.F_RealScore AND  MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))>0 THEN 2 
											    ELSE NULL END 
						FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID= @MatchID AND MR2.F_CompetitionPosition != @CompetitionPosition
						WHERE MR.F_MatchID= @MatchID AND MR.F_CompetitionPosition = @CompetitionPosition
					UPDATE  MR SET F_Rank = CASE WHEN MR.F_RealScore>=6 THEN 1 
												 WHEN MR2.F_RealScore>=6 THEN 2 
												 WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes>0 THEN 1 
												 WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes<0 THEN 2 
												 WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))<0 THEN 1
												 WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))>0 THEN 2 
												ELSE NULL END 
						FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID= @MatchID AND MR2.F_CompetitionPosition = @CompetitionPosition
						WHERE MR.F_MatchID= @MatchID AND MR.F_CompetitionPosition != @CompetitionPosition	UPDATE TS_Match SET F_MatchStatusID =50 WHERE F_MatchID =@MatchID						
				END
			--�ܻ���ȡʤ
			ELSE
				BEGIN		
					UPDATE MR SET F_Rank = CASE WHEN MR.F_Points-MR2.F_Points>0 THEN 1 
												WHEN MR.F_Points-MR2.F_Points<0 THEN 2 
												WHEN MR.F_Points = MR2.F_Points AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes>0 THEN 1 
												WHEN MR.F_Points = MR2.F_Points AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes<0 THEN 2 
												WHEN MR.F_Points = MR2.F_Points AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))<0 THEN 1
												WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))>0 THEN 2 
												ELSE NULL END
						FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID= @MatchID AND MR2.F_CompetitionPosition != @CompetitionPosition
						WHERE MR.F_MatchID= @MatchID AND MR.F_CompetitionPosition = @CompetitionPosition
					UPDATE MR SET F_Rank = CASE WHEN MR.F_Points-MR2.F_Points>0 THEN 1 
												WHEN MR.F_Points-MR2.F_Points<0 THEN 2 
												WHEN MR.F_Points = MR2.F_Points AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes>0 THEN 1 
												WHEN MR.F_Points = MR2.F_Points AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes<0 THEN 2 
												WHEN MR.F_Points = MR2.F_Points AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))<0 THEN 1
												WHEN MR.F_RealScore = MR2.F_RealScore AND MR.F_FinishTimeNumDes-MR2.F_FinishTimeNumDes=0 
													AND CAST(MR.F_FinishTimeCharDes AS DECIMAL(5,2))-CAST(MR2.F_FinishTimeCharDes AS DECIMAL(5,2))>0 THEN 2 
												ELSE NULL END
						FROM TS_Match_Result AS MR 
						LEFT JOIN TS_Match_Result AS MR2 ON MR2.F_MatchID= @MatchID AND MR2.F_CompetitionPosition = @CompetitionPosition
						WHERE MR.F_MatchID= @MatchID AND MR.F_CompetitionPosition != @CompetitionPosition 
				
				END
			
			--���±���״̬Officials
			IF EXISTS(SELECT F_RegisterID FROM TS_Match_Result WHERE F_MatchID= @MatchID AND F_Rank=1)
				BEGIN
					UPDATE TS_Match SET F_MatchStatusID =110 WHERE F_MatchID =@MatchID
				END		
		
		END
	--��λ��
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
						 ELSE  row_number() over(order by F_Points desc, F_WinPoints desc ,F_LosePoints desc) END
				   ,F_RegisterID,F_MatchID
				FROM TS_Match_Result  WHERE  F_MatchID= @MatchID)
			
			UPDATE MR SET F_Rank = TV.F_Rank
			FROM TS_Match_Result AS MR
			LEFT JOIN #Temp_V AS TV ON TV.F_MatchID=@MatchID AND TV.F_RegisterID=MR.F_RegisterID
					WHERE MR.F_MatchID= @MatchID
					
			DECLARE @DisResult INT
			EXEC Proc_AR_CalcEndDistinceRanking @MatchID,@DisResult output 
			
			IF @@error<>0  --����ʧ�ܷ���  
					BEGIN 
						ROLLBACK   --����ع�
						SET @Result=0
						RETURN
					END
		END	 
	
	COMMIT TRANSACTION --�ɹ��ύ����

	
	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_Interface_UpdatePlayerArrow 1,1,1,'1',9,0,OUTPUT
*/
