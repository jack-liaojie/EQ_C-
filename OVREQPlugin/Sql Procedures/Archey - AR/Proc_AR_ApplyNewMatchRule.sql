IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_ApplyNewMatchRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_ApplyNewMatchRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_AR_ApplyNewMatchRule]
----��		  �ܣ��˱��������µľ�������Ҫ��������ɾ�����������гɼ�������Ǵ����µı���Splits
----��		  �ߣ��޿�
----��		  ��: 2011-10-16 
----��  �� �� ¼: 
/*
                 �޿�          2011-10-17     
				 @IsSetPoints			    --�Ƿ����ÿ�ֵ�����ʤ
				 @DistinceNum			    --�о�
				 @CreateSplits				�Ƿ�ֱ�Ӵ���SplitInfo �� 0��������1����	
*/

CREATE PROCEDURE [dbo].[Proc_AR_ApplyNewMatchRule]
    @MatchID				INT,
    @CompetitionRuleID		INT,
    @CreateSplits			INT,
    @Result					INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;-- @Result=0; 	Ӧ���µľ�������ʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	Ӧ���µľ�������ɹ���
					-- @Result=-1; 	Ӧ���µľ�������ʧ�ܣ���MatchID��CompetitionRuleID��Ч
					-- @Result=-2; 	Ӧ���µľ�������ʧ�ܣ��ñ�����״̬��������о���������޸ĺ͵���
	
	IF NOT EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN 
	END
	
	IF NOT EXISTS (SELECT F_CompetitionRuleID FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -1
		RETURN 
	END
	
	--IF EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID AND F_MatchStatusID > 40)
	--BEGIN
	--	SET @Result = -2
	--	RETURN 
	--END  
		
		SET Implicit_Transactions off
		BEGIN TRANSACTION
		
		BEGIN TRY
			DECLARE @EndCount				       INT--�غ���Ŀ
			DECLARE @ArrowCount			           INT--ÿһ�غϵļ���
			DECLARE @IsSetPoints			       INT--�Ƿ����ÿ�ֵ�����ʤ
			DECLARE @WinPoints			           INT--ʤ�ߵ���
			DECLARE @MatchType					   INT--ÿһ�غϵ�ʤ�ߵ���
			DECLARE @DistinceNum			       INT--�о�
			DECLARE @CreateType					   INT --1 ��ʾֱ��ɾ��ԭ�е�Split�������µ�Split, 2��ʾ����ԭ�е�Split��ֱ�ӷ��� @Result=-3 �����û�������Split.������һ���Ĳ���
			
			CREATE TABLE #Temp_V
			(
								RuleName NVARCHAR(50),
								EndCount INT,
								ArrowCount	 INT ,
								IsSetPoints INT ,
								WinPoints INT,
								MatchType INT,
								DistinceNum INT
			)
			
			DECLARE @XmlDoc AS XML
			SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID

			IF @XmlDoc IS NOT NULL
			BEGIN
			DECLARE @iDoc AS INT
				EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
						
					INSERT #Temp_V ( EndCount , ArrowCount,IsSetPoints, WinPoints,MatchType,DistinceNum)
					  SELECT  EndCount AS EndCount , ArrowCount AS ArrowCount, IsSetPoints AS IsSetPoints, 
							  WinPoints AS WinPoints , MatchType AS MatchType, DistinceNum AS DistinceNum
						 FROM OPENXML(@iDoc, '/MatchRule/SetRule', 1)
						 WITH(
							RuleName NVARCHAR(50) '//MatchRule/@RuleName',
							MatchType INT '//MatchRule/@MatchType',						
							EndCount INT '@EndCount',
							ArrowCount	 INT '@ArrowCount',
							IsSetPoints INT '@IsSetPoints',
							WinPoints INT '@WinPoints',
							DistinceNum INT '@DistinceNum'
						)
										
				EXEC sp_xml_removedocument @iDoc			
				
			END
			
			SELECT  @EndCount = EndCount , @ArrowCount = ArrowCount, @IsSetPoints = IsSetPoints, 
							  @WinPoints = WinPoints,@MatchType = MatchType, @DistinceNum=DistinceNum
							  FROM #Temp_V
			DROP TABLE #Temp_V
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
			
			UPDATE TS_Match SET F_MatchComment1 = @EndCount, F_MatchComment2 = @ArrowCount, F_MatchComment3 = @IsSetPoints, 
								F_MatchComment4 = @WinPoints, F_MatchComment5 = @DistinceNum, F_MatchComment6 = @MatchType
								WHERE F_MatchID = @MatchID
			
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
		IF(@CreateSplits =1)
		BEGIN
			--�����ǰ���������гɼ���Split
			
			DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END

			DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END

			DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END

			DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END

			DECLARE @SplitNum AS INT
			DECLARE @EndCode	AS INT
			DECLARE @ArrowCode	AS INT
			DECLARE @TempDistinceNum AS INT
			SET @TempDistinceNum = 1
			SET @SplitNum = 1 
			SET @EndCode = 1
			SET @ArrowCode = 1
		
		WHILE (@TempDistinceNum <= @DistinceNum)
		BEGIN

			DECLARE @TempCount AS INT 
			SET @TempCount = 1
			WHILE (@TempCount <= @EndCount)
			BEGIN

				INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitCode, F_MatchSplitType, F_MatchSplitStatusID,F_MatchSplitPrecision) 
					VALUES (@MatchID, @SplitNum, 0, @TempCount, @EndCode, 0, 0,@TempDistinceNum)

				IF @@error<>0  --����ʧ�ܷ���  
				BEGIN 
					ROLLBACK   --����ع�
					SET @Result=0
					RETURN
				END

				DECLARE @FatherSplit AS INT
				DECLARE @TempCount1 AS INT
				SET @FatherSplit = @SplitNum
				SET @SplitNum = @SplitNum + 1
				SET @TempCount1 = 1
				WHILE (@TempCount1 <= @ArrowCount)
				BEGIN
					INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitCode, F_MatchSplitType, F_MatchSplitStatusID)
						VALUES (@MatchID, @SplitNum, @FatherSplit, @TempCount1, @ArrowCode, 1, 0)

					IF @@error<>0  --����ʧ�ܷ���  
					BEGIN 
						ROLLBACK   --����ع�
						SET @Result=0
						RETURN
					END

					SET @SplitNum = @SplitNum + 1
					SET @TempCount1 = @TempCount1 + 1
					SET @ArrowCode = @ArrowCode + 1
				END

				SET @TempCount = @TempCount +1
				SET @EndCode = @EndCode + 1
			END
				SET @TempDistinceNum = @TempDistinceNum + 1
		END

			INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition)
				SELECT A.F_MatchID, A.F_MatchSplitID, B.F_CompetitionPosition FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Result AS B
					ON A.F_MatchID = B.F_MatchID WHERE A.F_MatchID = @MatchID AND B.F_CompetitionPosition IS NOT NULL

			IF @@error<>0  --����ʧ�ܷ���  
			BEGIN 
				ROLLBACK   --����ع�
				SET @Result=0
				RETURN
			END
			
		END	
		END TRY
		BEGIN CATCH

			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
				
			SET @Result = 0
			RETURN 
		
		END CATCH;
		IF @@TRANCOUNT > 0
			COMMIT TRANSACTION;
		
	SET @Result = 1
	RETURN 

SET NOCOUNT OFF
END



GO


/*
exec Proc_AR_ApplyNewMatchRule
*/