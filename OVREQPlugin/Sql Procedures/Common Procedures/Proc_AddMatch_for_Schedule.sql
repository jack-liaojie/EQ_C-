IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddMatch_for_Schedule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddMatch_for_Schedule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：Proc_AddMatch_for_Schedule
----功		  能：添加一个Match，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-08 

CREATE PROCEDURE [dbo].[Proc_AddMatch_for_Schedule] 
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
	@MatchNum			INT,
	@Code				NVARCHAR(20),
	@MatchType			INT,
	@HasMedal			INT,
	@CompetitorNum		INT,
	@MatchInfo			NVARCHAR(50),
	@languageCode		CHAR(3),
	@MatchLongName		NVARCHAR(100),
	@MatchShortName		NVARCHAR(50),
	@MatchComment		NVARCHAR(100),
    @MatchComment2      NVARCHAR(100),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	添加Match失败，标示没有做任何操作！
					-- @Result>=1; 	添加Match成功！此值即为MatchID
					-- @Result=-1; 	添加Match失败，@PhaseID无效
					-- @Result=-2; 	添加Match失败，该Phase的状态不允许进行Match的添加
	DECLARE @NewMatchID AS INT	

	IF NOT EXISTS(SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	DECLARE @PhaseStatusID AS INT

	SELECT @PhaseStatusID = F_PhaseStatusID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	IF @PhaseStatusID > 10 
	BEGIN
		SET @Result = -2
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

		INSERT INTO TS_Match (F_PhaseID, F_MatchStatusID, F_VenueID, F_CourtID, F_WeatherID, F_SessionID, F_MatchDate, F_StartTime, F_EndTime, F_SpendTime, F_Order, F_MatchNum, F_MatchCode, F_MatchTypeID, F_MatchInfo, F_MatchHasMedal)
			VALUES (@PhaseID, @MatchStatusID, @VenueID, @CourtID, @WeatherID, @SessionID, @MatchDate, @StartTime, @EndTime, @SpendTime, @Order, @MatchNum, @Code, @MatchType, @MatchInfo, @HasMedal)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewMatchID = @@IDENTITY

		insert into TS_Match_DES (F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2)
			VALUES (@NewMatchID, @languageCode, @MatchLongName, @MatchShortName, @MatchComment, @MatchComment2)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DECLARE @curPosition AS INT
		SET @curPosition = 1
		WHILE (@curPosition <= @CompetitorNum )
		BEGIN
			insert into TS_Match_Result (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1)
				VALUES (@NewMatchID, @curPosition, @curPosition)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
			SET @curPosition = @curPosition + 1
		END
		
		INSERT INTO TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode)
			SELECT F_MatchID, F_CompetitionPosition, @languageCode AS F_LanguageCode FROM TS_Match_Result WHERE F_MatchID = @NewMatchID

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




