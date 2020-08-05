IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_TE_UpdatSetPoint]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_TE_UpdatSetPoint]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[proc_TE_UpdatSetPoint]
----功		  能：网球项目,存储盘比分变化
----作		  者：李燕
----日		  期: 2011-01-19
----修 改 记  录： 
/*
                  李燕    2011-2-12     增加抢七小比分的存储
                  李燕    2011-7-5      增加SubMatchcode，为了团体赛
*/

CREATE PROCEDURE [dbo].[proc_TE_UpdatSetPoint] (	
	@MatchID						INT,
	@SubMatchCode                   INT,  -- -1,个人赛
	@SetNum							INT,
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
	@MatchStatus					INT,
	@SetStatus						INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
SET NOCOUNT ON


	SET @Result = 0 -- @Result=0; 	存储一个比分变化失败，标示没有做任何操作！
					-- @Result=1; 	存储一个比分变化成功！

	
	IF(@SetStatus  = -1)
	BEGIN
	  SET @SetStatus = NULL 
	END
	
	IF(@AWinGames  = -1)
	BEGIN
	  SET @AWinGames = NULL 
	END
	
	IF(@BWinGames  = -1)
	BEGIN
	  SET @BWinGames = NULL 
	END
	
	IF(@ASetRank  = -1)
	BEGIN
	  SET @ASetRank = NULL 
	END
	
	IF(@BSetRank  = -1)
	BEGIN
	  SET @BSetRank = NULL 
	END
	
	IF(@ATBPoint  = -1)
	BEGIN
	  SET @ATBPoint = NULL 
	END
	
	IF(@BTBPoint  = -1)
	BEGIN
	  SET @BTBPoint = NULL 
	END
					
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
			--Match的状态时不允许进行随意的改变的！要通过专门的状态改变函数去实现！
			IF(@SubMatchCode = -1)
			BEGIN
				--UPDATE TS_Match SET F_MatchStatusID = @MatchStatus WHERE F_MatchID = @MatchID
				UPDATE TS_Match_Result SET F_Points = @AWinSets, F_Rank = @AMatchRank, F_ResultID = (CASE WHEN @AMatchRank = 0 THEN 3 ELSE @AMatchRank END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
				UPDATE TS_Match_Result SET F_Points = @BWinSets, F_Rank = @BMatchRank, F_ResultID = (CASE WHEN @BMatchRank = 0 THEN 3 ELSE @BMatchRank END) WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
				
				
				UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @SetStatus WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1
				UPDATE A SET A.F_Points = @AWinGames, A.F_Rank = @ASetRank, A.F_SplitPoints = @ATBPoint FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 1
				
				UPDATE A SET A.F_Points = @BWinGames, A.F_Rank = @BSetRank, A.F_SplitPoints = @BTBPoint FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 2
	        END
	        ELSE
	        BEGIN
	            DECLARE @SubMatchID   INT
	            SELECT @SubMatchID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3
	            
	        	UPDATE TS_Match_Split_Result SET F_Points = @AWinSets, F_Rank = @AMatchRank, F_ResultID = (CASE WHEN @AMatchRank = 0 THEN 3 ELSE @AMatchRank END) WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SubMatchID AND F_CompetitionPosition = 1
				UPDATE TS_Match_Split_Result SET F_Points = @BWinSets, F_Rank = @BMatchRank, F_ResultID = (CASE WHEN @BMatchRank = 0 THEN 3 ELSE @BMatchRank END) WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SubMatchID AND F_CompetitionPosition = 2
				
				
				UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = @SetStatus WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SetNum AND F_MatchSplitType = 1 AND F_FatherMatchSplitID = @SubMatchID
				UPDATE A SET A.F_Points = @AWinGames, A.F_Rank = @ASetRank, A.F_SplitPoints = @ATBPoint 
				    FROM TS_Match_Split_Result AS A 
				       LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 1 AND B.F_FatherMatchSplitID = @SubMatchID
				
				UPDATE A SET A.F_Points = @BWinGames, A.F_Rank = @BSetRank, A.F_SplitPoints = @BTBPoint 
				     FROM TS_Match_Split_Result AS A 
				     LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitCode = @SetNum AND B.F_MatchSplitType = 1 AND F_CompetitionPosition = 2 AND B.F_FatherMatchSplitID = @SubMatchID

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

 --EXEC [Proc_AddCompetitionRule] 1
