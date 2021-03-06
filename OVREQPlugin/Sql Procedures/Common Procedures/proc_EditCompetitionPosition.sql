IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_EditCompetitionPosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_EditCompetitionPosition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_EditCompetitionPosition]
----功		  能：编辑某一个比赛者位置的详细信息
----作		  者：郑金勇 
----日		  期: 2009-11-11 

CREATE PROCEDURE [dbo].[proc_EditCompetitionPosition] 
	@MatchID						INT,
	@CompetitionPosition			INT,
	@CompetitionPositionDes1		INT,
	@CompetitionPositionDes2		INT,
	@RegisterID						INT,
	@PositionSourceDes				NVARCHAR(100),
	@StartPhaseID					INT,
	@StartPhasePosition				INT,
	@SourcePhaseID					INT,
	@PhaseRank						INT,
	@SourceMatchID					INT,
	@MatchRank						INT,
	@HistoryMatchID					INT,
	@HistoryMatchRank				INT,
	@HistoryLevel					INT,
	@languageCode					CHAR(3),
	@PositionSourceType				INT,
    @SouceProgressDes               NVARCHAR(100),
    @ProgressDes                    NVARCHAR(100),
	@Result 						AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	编辑某一个比赛者位置的详细信息失败，标示没有做任何操作！
					-- @Result=1; 	编辑某一个比赛者位置的详细信息成功！
					-- @Result=-1; 	编辑某一个比赛者位置的详细信息失败，@MatchID和@CompetitionPosition无效

	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF (@StartPhaseID = 0)
	BEGIN
		SET @StartPhaseID = NULL
	END

	IF (@SourcePhaseID = 0)
	BEGIN
		SET @SourcePhaseID = NULL
	END

	IF (@SourceMatchID = 0)
	BEGIN
		SET @SourceMatchID = NULL
	END

	IF (@HistoryMatchID = 0)
	BEGIN
		SET @HistoryMatchID = NULL
	END

	IF (@StartPhasePosition = 0)
	BEGIN
		SET @StartPhasePosition = NULL
	END

	IF (@PhaseRank = 0)
	BEGIN
		SET @PhaseRank = NULL
	END

	IF (@MatchRank = 0)
	BEGIN
		SET @MatchRank = NULL
	END

	IF (@HistoryMatchRank = 0)
	BEGIN
		SET @HistoryMatchRank = NULL
	END

	IF (@HistoryLevel = 0)
	BEGIN
		SET @HistoryLevel = NULL
	END

	IF (@PositionSourceType = 0)
	BEGIN
		SET @StartPhaseID = NULL
		SET @StartPhasePosition = NULL
		SET @SourcePhaseID = NULL
		SET @PhaseRank	 = NULL
		SET @SourceMatchID = NULL
		SET @MatchRank	 = NULL
		SET @HistoryMatchID = NULL
		SET @HistoryMatchRank =NULL
		SET @HistoryLevel = NULL
	END
	
	IF (@PositionSourceType = 1)
	BEGIN
--		SET @StartPhaseID = NULL
--		SET @StartPhasePosition = NULL
		SET @SourcePhaseID = NULL
		SET @PhaseRank	 = NULL
		SET @SourceMatchID = NULL
		SET @MatchRank	 = NULL
		SET @HistoryMatchID = NULL
		SET @HistoryMatchRank =NULL
		SET @HistoryLevel = NULL
	END

	IF (@PositionSourceType = 2)
	BEGIN
		SET @StartPhaseID = NULL
		SET @StartPhasePosition = NULL
--		SET @SourcePhaseID = NULL
--		SET @PhaseRank	 = NULL
		SET @SourceMatchID = NULL
		SET @MatchRank	 = NULL
		SET @HistoryMatchID = NULL
		SET @HistoryMatchRank =NULL
		SET @HistoryLevel = NULL
	END

	IF (@PositionSourceType = 3)
	BEGIN
		SET @StartPhaseID = NULL
		SET @StartPhasePosition = NULL
		SET @SourcePhaseID = NULL
		SET @PhaseRank	 = NULL
--		SET @SourceMatchID = NULL
--		SET @MatchRank	 = NULL
		SET @HistoryMatchID = NULL
		SET @HistoryMatchRank =NULL
		SET @HistoryLevel = NULL
	END

	IF (@PositionSourceType = 4)
	BEGIN
		SET @StartPhaseID = NULL
		SET @StartPhasePosition = NULL
		SET @SourcePhaseID = NULL
		SET @PhaseRank	 = NULL
		SET @SourceMatchID = NULL
		SET @MatchRank	 = NULL
--		SET @HistoryMatchID = NULL
--		SET @HistoryMatchRank =NULL
--		SET @HistoryLevel = NULL
	END

	IF (@RegisterID = 0 OR @RegisterID = -2)
	BEGIN
		SET @RegisterID = NULL
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		UPDATE TS_Match_Result SET F_CompetitionPositionDes1 = @CompetitionPositionDes1, F_CompetitionPositionDes2 = @CompetitionPositionDes2, F_RegisterID = @RegisterID
			, F_StartPhaseID = @StartPhaseID, F_StartPhasePosition = @StartPhasePosition
			, F_SourcePhaseID = @SourcePhaseID, F_SourcePhaseRank = @PhaseRank
			, F_SourceMatchID = @SourceMatchID, F_SourceMatchRank = @MatchRank
			, F_HistoryMatchID = @HistoryMatchID, F_HistoryMatchRank = @HistoryMatchRank, F_HistoryLevel = @HistoryLevel
				WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		IF EXISTS (SELECT F_MatchID FROM TS_Match_Result_Des WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_LanguageCode = @LanguageCode)
		BEGIN
			
			UPDATE TS_Match_Result_Des SET F_CompetitorSourceDes = @PositionSourceDes, F_SouceProgressDes = @SouceProgressDes,F_ProgressDes = @ProgressDes 
				WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition AND F_LanguageCode = @LanguageCode

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END
		ELSE
		BEGIN
			insert into TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode,F_CompetitorSourceDes, F_SouceProgressDes, F_ProgressDes)
				VALUES (@MatchID, @CompetitionPosition, @languageCode, @PositionSourceDes, @SouceProgressDes, @ProgressDes)

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




