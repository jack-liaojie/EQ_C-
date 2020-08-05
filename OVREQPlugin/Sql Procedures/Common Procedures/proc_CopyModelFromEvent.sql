IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_CopyModelFromEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_CopyModelFromEvent]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_CopyModelFromEvent]
----功		  能：将一个项目现有的编排存储为模型
----作		  者：郑金勇
----日		  期: 2009-08-19 

CREATE PROCEDURE [dbo].[proc_CopyModelFromEvent]
    @ModelName			NVARCHAR(100),
	@ModelComment		NVARCHAR(200),
	@Order				INT = 0,
	@EventID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	存储为模型失败，标示没有做任何操作！
					  -- @Result>=1; 	存储为模型成功！此值即为ModelID

	DECLARE @NewModelID AS INT
	DECLARE @PhaseStartID AS INT
	DECLARE @MatchStartID AS INT
	DECLARE @RoundStartID AS INT
	
	IF(@Order = 0)
	BEGIN
		SELECT @Order = ISNULL(MAX(F_Order),0) + 1 FROM TM_Model
	END


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TM_Model (F_ModelName, F_ModelComment, F_Order) VALUES (@ModelName, @ModelComment, @Order)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewModelID = @@IDENTITY

		UPDATE TS_Event SET F_UsingModelID = @NewModelID WHERE F_EventID = @EventID
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SELECT @PhaseStartID = (MIN(F_PhaseID) - 1) FROM TS_Phase WHERE F_EventID = @EventID

        INSERT INTO TM_Phase (F_ModelID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo, F_PhaseIsPool, F_PhaseHasPools)
			SELECT @NewModelID AS F_ModelID, (F_PhaseID - @PhaseStartID) AS F_PhaseID, (F_FatherPhaseID - @PhaseStartID) AS F_FatherPhaseID, F_PhaseCode, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo, F_PhaseIsPool, F_PhaseHasPools 
				FROM TS_Phase WHERE F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TM_Phase SET F_FatherPhaseID = 0 WHERE F_FatherPhaseID < 0 AND F_ModelID = @NewModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TM_Phase_Des (F_ModelID, F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_LanguageCode, A.F_PhaseLongName, A.F_PhaseShortName, A.F_PhaseComment
				FROM TS_Phase_Des AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		INSERT INTO TM_Phase_MatchPoint (F_ModelID, F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_WonMatchPoint, A.F_DrawMatchPoint, A.F_LostMatchPoint
				FROM TS_Phase_MatchPoint AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SELECT @RoundStartID = (MIN(F_RoundID) - 1) FROM TS_Round WHERE F_EventID = @EventID

        INSERT INTO TM_Round (F_ModelID, F_RoundID, F_Order, F_RoundCode, F_Comment)
			SELECT @NewModelID AS F_ModelID, (F_RoundID - @RoundStartID) AS F_RoundID, F_Order, F_RoundCode, F_Comment 
				FROM TS_Round WHERE F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TM_Round_Des (F_ModelID, F_RoundID, F_LanguageCode, F_RoundLongName, F_RoundShortName, F_RoundComment)
			SELECT @NewModelID AS F_ModelID, (A.F_RoundID - @RoundStartID) AS F_RoundID, A.F_LanguageCode, F_RoundLongName, F_RoundShortName, F_RoundComment
				FROM TS_Round_Des AS A LEFT JOIN TS_Round AS B ON A.F_RoundID = B.F_RoundID 
					WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		SELECT @MatchStartID = (MIN(A.F_MatchID) - 1) FROM TS_Match AS A LEFT JOIN TS_Phase AS B 
			ON A.F_PhaseID = B.F_PhaseID
				WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match (F_ModelID, F_MatchID, F_PhaseID, F_Order, F_MatchTypeID, F_MatchCode, F_MatchHasMedal, F_CompetitionRuleID, F_MatchInfo, F_MatchNum, F_RoundID, F_OrderInRound)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_Order, A.F_MatchTypeID,  A.F_MatchCode, A.F_MatchHasMedal, A.F_CompetitionRuleID, A.F_MatchInfo, A.F_MatchNum, (F_RoundID - @RoundStartID) AS F_RoundID, F_OrderInRound 
				FROM TS_Match AS A LEFT JOIN TS_Phase AS B 
					ON A.F_PhaseID = B.F_PhaseID
						WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match_Des (F_ModelID, F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2, F_MatchComment3)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_LanguageCode, A.F_MatchLongName, A.F_MatchShortName, A.F_MatchComment, A.F_MatchComment2, A.F_MatchComment3 
				FROM TS_Match_Des AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
					LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
						WHERE C.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match_Result (F_ModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel, F_Comment)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, (A.F_StartPhaseID - @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition,
				 (A.F_SourcePhaseID - @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank,
				 (A.F_HistoryMatchID - @MatchStartID) AS F_HistoryMatchID, A.F_HistoryMatchRank, A.F_HistoryLevel, A.F_Comment 
				FROM TS_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
					LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
						WHERE C.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match_Result_Des (F_ModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_CompetitionPosition, A.F_LanguageCode, A.F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, A.F_Comment 
				FROM TS_Match_Result_Des AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
					LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
						WHERE C.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Phase_Position (F_ModelID, F_PhaseID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhasePosition, (A.F_StartPhaseID- @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID - @PhaseStartID) AS F_PhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank
				FROM TS_Phase_Position AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					WHERE B.F_EventID = @EventID
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Phase_Result (F_ModelID, F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhaseResultNumber, A.F_PhaseRank, (A.F_SourcePhaseID - @PhaseStartID) AS F_PhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank
				FROM TS_Phase_Result AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID 
					WHERE B.F_EventID = @EventID
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Event_Result (F_ModelID, F_EventResultNumber, F_EventRank, F_EventDiplayPosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, F_EventResultNumber, F_EventRank, F_EventDisplayPosition, (F_SourcePhaseID - @PhaseStartID) AS F_PhaseID, F_SourcePhaseRank, (F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, F_SourceMatchRank
				FROM TS_Event_Result WHERE F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model(F_ModelID, F_PhaseID, F_PhaseModelID, F_Order, F_PhaseModelName, F_PhaseModelComment)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, A.F_Order, A.F_PhaseModelName, A.F_PhaseModelComment
				FROM TS_Phase_Model AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	
		INSERT INTO TM_Phase_Model_Phase_Position(F_ModelID, F_PhaseID, F_PhaseModelID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT  @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, A.F_PhasePosition, (A.F_StartPhaseID - @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID  - @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank
				FROM TS_Phase_Model_Phase_Position AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model_Phase_Resut (F_ModelID, F_PhaseID, F_PhaseModelID, F_PhaseResultNumber, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT  @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, A.F_PhaseResultNumber,(A.F_SourcePhaseID  - @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank
				FROM TS_Phase_Model_Phase_Resut AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model_Match_Result(F_ModelID, F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes2, (A.F_StartPhaseID - @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID  - @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank,
			 (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank, 
				 (A.F_HistoryMatchID - @MatchStartID) AS F_HistoryMatchID, A.F_HistoryMatchRank, A.F_HistoryLevel
				FROM TS_Phase_Model_Match_Result AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model_Match_Result_Des (F_ModelID, F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @NewModelID AS F_ModelID, (A.F_PhaseID - @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_CompetitionPosition, A.F_LanguageCode, A.F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, A.F_Comment
				FROM TS_Phase_Model_Match_Result_Des AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


        INSERT INTO TM_Match_Model (F_ModelID, F_MatchID, F_MatchModelID, F_Order, F_MatchModelName, F_MatchModelComment)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_MatchModelID, A.F_Order, A.F_MatchModelName, A.F_MatchModelComment 
				FROM TS_Match_Model AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
					LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
						WHERE C.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Match_Model_Match_Result(F_ModelID, F_MatchID, F_MatchModelID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_MatchModelID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes2, (A.F_StartPhaseID - @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID  - @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank,
			 (A.F_SourceMatchID - @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank, 
				 (A.F_HistoryMatchID - @MatchStartID) AS F_HistoryMatchID, A.F_HistoryMatchRank, A.F_HistoryLevel
				FROM TS_Match_Model_Match_Result AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
					LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
						WHERE C.F_EventID = @EventID
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Match_Model_Match_Result_Des (F_ModelID,F_MatchID, F_MatchModelID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @NewModelID AS F_ModelID, (A.F_MatchID - @MatchStartID) AS F_MatchID, A.F_MatchModelID, A.F_CompetitionPosition, A.F_LanguageCode, A.F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, A.F_Comment
				FROM TS_Match_Model_Match_Result_Des AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
					LEFT JOIN TS_Phase AS C ON B.F_PhaseID = C.F_PhaseID
						WHERE C.F_EventID = @EventID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @NewModelID
	RETURN

SET NOCOUNT OFF
END

GO


/*

DELETE FROM TM_MatchRank2PhaseRank
DELETE FROM TM_Match_Result
DELETE FROM TM_Match_Des
DELETE FROM TM_Match


DELETE FROM TM_PhaseRank2EventRank
DELETE FROM TM_Phase_MatchPoint
DELETE FROM TM_Phase_Des
DELETE FROM TM_Phase


DELETE FROM TM_Model
GO
DBCC CHECKIDENT ('TM_Model', RESEED, 0)
GO

DECLARE @Result AS INT
EXEC proc_CopyModelFromEvent 'Model1', 'ModelComment', 3, @Result OUTPUT
SELECT @Result

GO

*/