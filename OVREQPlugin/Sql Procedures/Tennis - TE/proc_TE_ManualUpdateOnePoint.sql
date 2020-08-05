IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TE_ManualUpdateOnePoint]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_TE_ManualUpdateOnePoint]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_TE_ManualUpdateOnePoint]
----功		  能：网球项目,手动修改一个Game的比分
----作		  者：李燕
----日		  期: 2011-6-10
----修 改 记  录： 
/*
                
*/


CREATE PROCEDURE [dbo].[proc_TE_ManualUpdateOnePoint] (	
	@MatchID						INT,
	@SetNum							INT,
	@GameNum						INT,
	@AScore							INT,
	@BScore							INT,
	@AService                       INT,
	@BService                       INT,
	@AGameRank						INT,
	@BGameRank						INT,
	@APreGameScore                  INT,
	@BPreGameScore                  INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
SET NOCOUNT ON


	SET @Result = 0 -- @Result=0; 	存储一个比分变化失败，标示没有做任何操作！
					-- @Result>=1; 	存储一个比分变化成功！

	
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
			--Match的状态时不允许进行随意的改变的！要通过专门的状态改变函数去实现！			
			IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum)
			BEGIN
				DECLARE @FatherSplitID AS INT
				DECLARE @MaxSplitID AS INT
				
				SELECT @FatherSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1
				SELECT @MaxSplitID = (ISNULL(MAX(F_MatchSplitID), 0) + 1)  FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
				
				INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitCode, F_MatchSplitType) VALUES (@MatchID, @MaxSplitID, @FatherSplitID, @GameNum, 2)
				INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES (@MatchID, @MaxSplitID, 1)
				INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES (@MatchID, @MaxSplitID, 2)
				
			END
			ELSE
			BEGIN
			    SELECT @Result = A.F_MatchSplitID FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum
			END
			
			UPDATE A SET A.F_MatchSplitStatusID = 110 FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID
				WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1
			
			UPDATE C SET C.F_Points = (CASE WHEN @AScore = -1 THEN NULL ELSE @AScore END), C.F_Rank = (CASE WHEN @AGameRank = -1 THEN NULL ELSE @AGameRank END), 
			            C.F_Service = (CASE WHEN @AService = -1 THEN NULL ELSE @AService END), C.F_SplitPoints = (CASE WHEN @APreGameScore = -1 THEN NULL ELSE @APreGameScore END) FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID 
				LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1 AND C.F_CompetitionPosition = 1
					
			UPDATE C SET C.F_Points = (CASE WHEN @BScore  = -1 THEN NULL ELSE @BScore END), C.F_Rank = (CASE WHEN @BGameRank = -1 THEN NULL ELSE @BGameRank END), 
			             C.F_Service = (CASE WHEN @BService  = -1 THEN NULL ELSE @BService END), C.F_SplitPoints = (CASE WHEN @BPreGameScore  = -1 THEN NULL ELSE @BPreGameScore END) FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID 
				LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1 AND C.F_CompetitionPosition = 2
			
			---抢七小比分
			IF EXISTS(SELECT A.F_MatchSplitID FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID
			          WHERE @GameNum = '13' AND B.F_MatchSplitComment1 = 1 AND B.F_MatchSplitCode = @SetNum AND A.F_MatchID = @MatchID)
			BEGIN
			        UPDATE A SET F_SplitPoints = @AScore FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND A.F_CompetitionPosition = 1
			              WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitComment1 = 1 AND @GameNum = '13'
			              
			        UPDATE A SET F_SplitPoints = @BScore FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID AND A.F_CompetitionPosition = 2
			              WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitComment1 = 1 AND @GameNum = '13'

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

     SELECT @Result = A.F_MatchSplitID FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum
     IF(@Result IS NULL)
     BEGIN
        SET @Result = 0
     END

	RETURN 
	
SET NOCOUNT OFF
END





GO

 --EXEC [proc_TE_UpdateOnePoint] 2
