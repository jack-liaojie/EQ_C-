IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_AddMatchWithCompetitors]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_AddMatchWithCompetitors]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：proc_AddMatchWithCompetitors
----功		  能：添加一个Match，同时要添加对阵双方的信息，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-10 

CREATE PROCEDURE [dbo].[proc_AddMatchWithCompetitors] 
	@PhaseID			INT,
	@MatchStatusID		INT,
	@VenueID			INT,
	@CourtID			INT,
	@WeatherID			INT,
	@SessionID			INT,
	@MatchDate			DATETIME,
	@StartTime			DATETIME,
	@EndTime			DATETIME,
	@SpendTime			INT,
	@Order				INT,
	@MatchType			INT,
	@MatchInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@MatchLongName		NVARCHAR(100),
	@MatchShortName		NVARCHAR(50),
	@MatchComment		NVARCHAR(100),
	@APosition				INT,
	@ARegisterID			INT,
	@AStartPhaseID			INT,
	@AStartPhasePosition	INT,
	@ASourcePhaseID			INT,
	@ASourcePhaseRank		INT,
	@ASourceMatchID			INT,
	@ASourceMatchRank		INT,
	@AResult				INT,
	@ARank					INT,
	@APoints				INT,
	@AService				INT,

	@BPosition				INT,
	@BRegisterID			INT,
	@BStartPhaseID			INT,
	@BStartPhasePosition	INT,
	@BSourcePhaseID			INT,
	@BSourcePhaseRank		INT,
	@BSourceMatchID			INT,
	@BSourceMatchRank		INT,
	@BResult				INT,
	@BRank					INT,
	@BPoints				INT,
	@BService				INT,
	@MatchNum				INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Match失败，标示没有做任何操作！
					-- @Result=1; 	添加Match成功！此值即为MatchID
					-- @Result=-1; 	添加Match失败，@PhaseID无效
	DECLARE @NewMatchID AS INT	

	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
	BEGIN
		SET @Result = -1
		RETURN
	END


	IF @Order = 0 OR @Order IS NULL
	BEGIN
		SELECT @Order = (CASE WHEN MAX(F_Order) IS NULL THEN 0 ELSE MAX(F_Order) END) + 1 FROM TS_Match WHERE F_PhaseID = @PhaseID
	END

	IF @MatchStatusID IS NULL
	BEGIN
		SET @MatchStatusID = 10
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Match (F_PhaseID, F_MatchStatusID, F_VenueID, F_CourtID, F_WeatherID, F_SessionID, F_MatchDate, F_StartTime, F_EndTime, F_SpendTime, F_Order, F_MatchTypeID, F_MatchInfo, F_MatchNum)
			VALUES (@PhaseID, @MatchStatusID, @VenueID, @CourtID, @WeatherID, @SessionID, @MatchDate, @StartTime, @EndTime, @SpendTime, @Order, @MatchType, @MatchInfo, @MatchNum)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewMatchID = @@IDENTITY

		insert into TS_Match_DES (F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment)
			VALUES (@NewMatchID, @languageCode, @MatchLongName, @MatchShortName, @MatchComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		insert into TS_Match_Result (F_MatchID, F_CompetitionPosition, F_RegisterID, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_ResultID, F_Rank, F_Points, F_Service, F_CompetitionPositionDes1)
			VALUES (@NewMatchID, @APosition, @ARegisterID, @AStartPhaseID, @AStartPhasePosition, @ASourcePhaseID, @ASourcePhaseRank, @ASourceMatchID, @ASourceMatchRank, @AResult, @ARank, @APoints, @AService, @APosition)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		insert into TS_Match_Result (F_MatchID, F_CompetitionPosition, F_RegisterID, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_ResultID, F_Rank, F_Points, F_Service, F_CompetitionPositionDes1)
			VALUES (@NewMatchID, @BPosition, @BRegisterID, @BStartPhaseID, @BStartPhasePosition, @BSourcePhaseID, @BSourcePhaseRank, @BSourceMatchID, @BSourceMatchRank, @BResult, @BRank, @BPoints, @BService, @BPosition)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewMatchID
	RETURN

SET NOCOUNT OFF
END





