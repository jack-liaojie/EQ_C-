IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_AddMatchSplits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_AddMatchSplits]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







----�洢�������ƣ�[Proc_AR_AddMatchSplits]
----��		  �ܣ�
----��		  �ߣ��޿�
----��		  ��: 2011-10-28 

CREATE PROCEDURE [dbo].[Proc_AR_AddMatchSplits] 
	@MatchID			           INT,
	@EndCount				       INT,--�غ���Ŀ
	@ArrowCount			           INT,--ÿһ�غϵļ���
	@Distince			           INT,--�о࣬
	@CreateType					   INT, --1 ��ʾ����Split ,2���Ӽ���split
	@Result 			           AS INT OUTPUT
	
AS
BEGIN
SET NOCOUNT ON

 	DECLARE @SQL		    NVARCHAR(max)
 	DECLARE @Order		    NVARCHAR(50)

	SET @Result=0;		-- @Result=0; 	����MatchSplitsʧ�ܣ���ʾû�����κβ�����
						-- @Result=1; 	����MatchSplits�ɹ������أ�
						-- @Result=-1; 	����MatchSplitsʧ�ܣ�@MatchID��Ч
						-- @Result=-3;	����MatchSplitsʧ��,����Split��ֻ��ɾ��ԭ�е�Split���ٴ����µ�Split

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����
	
		
		DECLARE @EndType AS INT
		DECLARE @ArrowType	AS INT
		SET @EndType = 1
		SET @ArrowType = 1
		
		IF(@CreateType =2 )
		BEGIN
			SET @EndType = 2
			SET @ArrowType = 3
		
		END
		
		DECLARE @SplitResultNum AS INT
		DECLARE @SplitNum AS INT
		DECLARE @EndCode	AS INT
		DECLARE @ArrowCode	AS INT
		DECLARE @TempDistinceNum AS INT
		SET @TempDistinceNum = 1
		SET @SplitNum = (SELECT ISNULL(MAX(F_MatchSplitID),0)+1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID)
		SET @EndCode = (SELECT ISNULL(MAX(F_MatchSplitCode),0)+1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType=2)
		SET @ArrowCode = (SELECT ISNULL(MAX(F_MatchSplitCode),0)+1 FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType=3)
	    
	    SET @SplitResultNum = @SplitNum
		DECLARE @TempCount AS INT 
		SET @TempCount = 1
		WHILE (@TempCount <= @EndCount)
		BEGIN
			INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitCode, F_MatchSplitType, F_MatchSplitStatusID,F_MatchSplitPrecision) 
				VALUES (@MatchID, @SplitNum, 0, @TempCount, @EndCode, @EndType, 0,1)

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
					VALUES (@MatchID, @SplitNum, @FatherSplit, @TempCount1, @ArrowCode, @ArrowType, 0)

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

		INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition)
			SELECT A.F_MatchID, A.F_MatchSplitID, B.F_CompetitionPosition FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Result AS B
				ON A.F_MatchID = B.F_MatchID WHERE A.F_MatchID = @MatchID AND B.F_CompetitionPosition IS NOT NULL AND F_MatchSplitID >=@SplitResultNum

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����


	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END	


GO

/*
DECLARE @Result int
EXEC Proc_AR_AddMatchSplits 36,5,3,1,2, @Result output
SELECT	@Result as N'@Result'
*/

