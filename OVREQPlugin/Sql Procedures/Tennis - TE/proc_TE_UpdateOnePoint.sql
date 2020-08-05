IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TE_UpdateOnePoint]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_TE_UpdateOnePoint]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_TE_UpdateOnePoint]
----功		  能：网球项目,存储一个比分变化
----作		  者：郑金勇 
----日		  期: 2010-09-20
----修 改 记  录： 
/*
                  李燕    2011-2-12     增加抢七小比分的存储
                  李燕    2011-2-25     增加发球权的存储
                  李燕    2011-7-2      增加SubMatchcode，用于团体赛，-1：个人赛
*/


CREATE PROCEDURE [dbo].[proc_TE_UpdateOnePoint] (	
	@MatchID						INT,
	@SubMatchCode                   INT,  ---- -1：个人赛
	@SetNum							INT,
	@GameNum						INT,
	@AWinSets						INT,
	@BWinSets						INT,
	@AMatchRank						INT,
	@BMatchRank						INT,
	@AWinGames						INT,
	@BWinGames						INT,
	@ASetRank						INT,
	@BSetRank						INT,
	@ATBPoint                       INT,      --抢七小比分，默认为-1
	@BTBPoint                       INT,
	@AScore							INT,
	@BScore							INT,
	@AService                       INT,
	@BService                       INT,
	@AGameRank						INT,
	@BGameRank						INT,
	@MatchStatus					INT,
	@SetStatus						INT,
	@GameStatus						INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
SET NOCOUNT ON


	SET @Result = 0 -- @Result=0; 	存储一个比分变化失败，标示没有做任何操作！
					-- @Result=1; 	存储一个比分变化成功！

	
	IF(@ATBPoint = -1)
	BEGIN
	    SET @ATBPoint = NULL
	END	
	
	IF(@BTBPoint = -1)
	BEGIN
	    SET @BTBPoint = NULL
	END					
	
	DECLARE @SubMatchID   INT
	DECLARE @SetID        INT
	DECLARE @FatherSplitID AS INT
	DECLARE @MaxSplitID AS INT

	
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
			--Match的状态时不允许进行随意的改变的！要通过专门的状态改变函数去实现！
			--UPDATE TS_Match SET F_MatchStatusID = @MatchStatus WHERE F_MatchID = @MatchID
			
			IF(@SubMatchCode = -1)
			BEGIN
				UPDATE TS_Match_Result SET F_Points = @AWinSets, F_Rank = @AMatchRank, F_ResultID = (CASE WHEN @AMatchRank = 0 THEN 3 ELSE @AMatchRank END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
				UPDATE TS_Match_Result SET F_Points = @BWinSets, F_Rank = @BMatchRank, F_ResultID = (CASE WHEN @BMatchRank = 0 THEN 3 ELSE @BMatchRank END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
				
				UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @SetStatus WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1
				UPDATE A SET A.F_Points = @AWinGames, A.F_Rank = @ASetRank, A.F_SplitPoints = @ATBPoint 
					FROM TS_Match_Split_Result AS A 
					LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 1
				
				UPDATE A SET A.F_Points = @BWinGames, A.F_Rank = @BSetRank, A.F_SplitPoints = @BTBPoint FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 2
				
				IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum)
				BEGIN
					
					SELECT @FatherSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1
					SELECT @MaxSplitID = (ISNULL(MAX(F_MatchSplitID), 0) + 1)  FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
					
					INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitCode, F_MatchSplitType) VALUES (@MatchID, @MaxSplitID, @FatherSplitID, @GameNum, 2)
					INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES (@MatchID, @MaxSplitID, 1)
					INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES (@MatchID, @MaxSplitID, 2)
				END
				
				UPDATE A SET A.F_MatchSplitStatusID = @GameStatus FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1
				
				UPDATE C SET C.F_Points = @AScore, C.F_Rank = @AGameRank, C.F_Service = @AService FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID 
					LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
						WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1 AND C.F_CompetitionPosition = 1
						
				UPDATE C SET C.F_Points = @BScore, C.F_Rank = @BGameRank, C.F_Service = @BService FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID 
					LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
						WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1 AND C.F_CompetitionPosition = 2
		  END
	  	  ELSE
		  BEGIN
		        SELECT @SubMatchID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3
		        
				UPDATE A SET A.F_Points = @AWinSets, A.F_Rank = @AMatchRank, A.F_ResultID = (CASE WHEN @AMatchRank = 0 THEN 3 ELSE @AMatchRank END)
				   FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
				   WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 1 AND B.F_MatchSplitCode = @SubMatchCode AND B.F_MatchSplitType = 3
				   
				UPDATE A SET A.F_Points = @BWinSets, A.F_Rank = @BMatchRank, A.F_ResultID = (CASE WHEN @BMatchRank = 0 THEN 3 ELSE @BMatchRank END) 
				   FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
			       WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPosition = 2 AND B.F_MatchSplitCode = @SubMatchCode AND B.F_MatchSplitType = 3
				
				UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @SetStatus WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = @SubMatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1
				UPDATE A SET A.F_Points = @AWinGames, A.F_Rank = @ASetRank, A.F_SplitPoints = @ATBPoint 
					FROM TS_Match_Split_Result AS A 
					LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_FatherMatchSplitID = @SubMatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 1
				
				UPDATE A SET A.F_Points = @BWinGames, A.F_Rank = @BSetRank, A.F_SplitPoints = @BTBPoint 
				    FROM TS_Match_Split_Result AS A 
				    LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_FatherMatchSplitID = @SubMatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 2
				
				
				SELECT @SetID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_FatherMatchSplitID = @SubMatchID AND F_MatchSplitType = 1
				
				IF NOT EXISTS (SELECT * FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitID = @SetID AND A.F_MatchSplitCode = @GameNum)
				BEGIN
					
					SET @FatherSplitID = @SetID
					--SELECT @FatherSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1
					SELECT @MaxSplitID = (ISNULL(MAX(F_MatchSplitID), 0) + 1)  FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
					
					INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitCode, F_MatchSplitType) VALUES (@MatchID, @MaxSplitID, @FatherSplitID, @GameNum, 2)
					INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES (@MatchID, @MaxSplitID, 1)
					INSERT INTO TS_Match_Split_Result (F_MatchID, F_MatchSplitID, F_CompetitionPosition) VALUES (@MatchID, @MaxSplitID, 2)
				END
				
				UPDATE A SET A.F_MatchSplitStatusID = @GameStatus 
				   FROM TS_Match_Split_Info AS A 
				    LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitID = @SetID AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1
				
				UPDATE C SET C.F_Points = @AScore, C.F_Rank = @AGameRank, C.F_Service = @AService 
				    FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID 
					LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
						WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitID = @SetID AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1 AND C.F_CompetitionPosition = 1
						
				UPDATE C SET C.F_Points = @BScore, C.F_Rank = @BGameRank, C.F_Service = @BService FROM TS_Match_Split_Info AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID 
					LEFT JOIN TS_Match_Split_Result AS C ON A.F_MatchID = C.F_MatchID AND A.F_MatchSplitID = C.F_MatchSplitID
						WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitID = @SetID AND A.F_MatchSplitCode = @GameNum AND A.F_MatchSplitType = 2 AND B.F_MatchSplitType = 1 AND C.F_CompetitionPosition = 2
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

 --EXEC [proc_TE_UpdateOnePoint] 2
