IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_SetEventModelFromModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_SetEventModelFromModel]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_SetEventModelFromModel]
----功		  能：依据存储的模型建立项目的竞赛模型
----作		  者：郑金勇
----日		  期: 2009-08-19 
/*
	修改记录
	序号	日期			修改者		修改内容
	1		2010-07-06		郑金勇		赛事模型指定之后，需要进一步的按顺序指定所有的Phase子模型或者Match子模型
*/
CREATE PROCEDURE [dbo].[proc_SetEventModelFromModel]
	@EventID			INT,
	@ModelID			INT,
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	建立项目的竞赛模型失败，标示没有做任何操作！
					  -- @Result=1; 	建立项目的竞赛模型成功！

	DECLARE @PhaseStartID		AS INT
	DECLARE @RoundStartID		AS INT
	DECLARE @MatchStartID		AS INT
	DECLARE @PhaseMaxID			AS INT
	DECLARE @RoundMaxID			AS INT
	DECLARE @MatchMaxID			AS INT
	DECLARE @PhaseRealMaxID		AS INT
	DECLARE @RoundRealMaxID		AS INT
	DECLARE @MatchRealMaxID		AS INT

	SELECT @PhaseMaxID = (CASE WHEN MAX(F_PhaseID) IS NULL THEN 0 ELSE MAX(F_PhaseID) END) FROM TM_Phase WHERE F_ModelID = @ModelID
	SELECT @RoundMaxID = (CASE WHEN MAX(F_RoundID) IS NULL THEN 0 ELSE MAX(F_RoundID) END) FROM TM_Round WHERE F_ModelID = @ModelID
	SELECT @MatchMaxID = (CASE WHEN MAX(F_MatchID) IS NULL THEN 0 ELSE MAX(F_MatchID) END) FROM TM_Match WHERE F_ModelID = @ModelID


	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		DECLARE @DelResult AS INT
		EXEC proc_DelEventPhases @EventID, @DelResult OUTPUT
		
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		IF @DelResult <> 1
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		UPDATE TS_Event SET F_UsingModelID = @ModelID WHERE F_EventID = @EventID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Round_Des WHERE F_RoundID IN (SELECT F_RoundID FROM TS_Round WHERE F_EventID = @EventID)
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Round WHERE F_EventID = @EventID
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SELECT @PhaseStartID = (CASE WHEN MAX(F_PhaseID) IS NULL THEN 0 ELSE MAX(F_PhaseID) END) FROM TS_Phase
		SET @PhaseRealMaxID = @PhaseStartID + @PhaseMaxID
		DBCC CHECKIDENT ('TS_Phase', RESEED, @PhaseRealMaxID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SELECT @RoundStartID = (CASE WHEN MAX(F_RoundID) IS NULL THEN 0 ELSE MAX(F_RoundID) END) FROM TS_Round
		SET @RoundRealMaxID = @RoundStartID + @RoundMaxID
		DBCC CHECKIDENT ('TS_Round', RESEED, @RoundRealMaxID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SELECT @MatchStartID = (CASE WHEN MAX(F_MatchID) IS NULL THEN 0 ELSE MAX(F_MatchID) END) FROM TS_Match
		SET @MatchRealMaxID = @MatchStartID + @MatchMaxID
		DBCC CHECKIDENT ('TS_Match', RESEED, @MatchRealMaxID)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SET IDENTITY_INSERT dbo.TS_Phase ON 

		UPDATE TM_Phase SET F_PhaseIsPool = 0 
			WHERE F_ModelID = @ModelID AND F_PhaseIsPool IS NULL 

		UPDATE TM_Phase SET F_PhaseHasPools = 0 
			WHERE F_ModelID = @ModelID AND F_PhaseHasPools IS NULL 

        INSERT INTO TS_Phase (F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo, F_PhaseIsPool, F_PhaseHasPools)
			SELECT @EventID AS F_EventID, (F_PhaseID + @PhaseStartID) AS F_PhaseID, (CASE F_FatherPhaseID WHEN 0 THEN 0 ELSE  F_FatherPhaseID + @PhaseStartID END) AS F_FatherPhaseID, F_PhaseCode, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo, F_PhaseIsPool, F_PhaseHasPools 
				FROM TM_Phase WHERE F_ModelID = @ModelID

		SET IDENTITY_INSERT dbo.TS_Phase OFF
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Phase_Des (F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment)
			SELECT (F_PhaseID + @PhaseStartID) AS F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment
				FROM TM_Phase_Des WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		INSERT INTO TS_Phase_MatchPoint (F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint)
			SELECT (F_PhaseID + @PhaseStartID) AS F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint
				FROM TM_Phase_MatchPoint WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SET IDENTITY_INSERT dbo.TS_Round ON 

        INSERT INTO TS_Round (F_EventID, F_RoundID, F_Order, F_RoundCode, F_Comment)
			SELECT @EventID AS F_EventID, (F_RoundID + @RoundStartID) AS F_RoundID, F_Order, F_RoundCode, F_Comment 
				FROM TM_Round WHERE F_ModelID = @ModelID

		SET IDENTITY_INSERT dbo.TS_Round OFF
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Round_Des (F_RoundID, F_LanguageCode, F_RoundLongName, F_RoundShortName, F_RoundComment)
			SELECT (F_RoundID + @RoundStartID) AS F_RoundID, F_LanguageCode, F_RoundLongName, F_RoundShortName, F_RoundComment
				FROM TM_Round_Des WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		UPDATE TM_Match SET F_MatchHasMedal = 0 
			WHERE F_ModelID = @ModelID AND F_MatchHasMedal IS NULL

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		SET IDENTITY_INSERT dbo.TS_Match ON 

        INSERT INTO TS_Match (F_MatchID, F_PhaseID, F_Order, F_MatchTypeID, F_MatchCode, F_MatchHasMedal, F_CompetitionRuleID, F_MatchInfo, F_MatchNum, F_RoundID, F_OrderInRound)
			SELECT (F_MatchID + @MatchStartID) AS F_MatchID, (F_PhaseID + @PhaseStartID) AS F_PhaseID, F_Order, F_MatchTypeID, F_MatchCode, F_MatchHasMedal, NULL AS F_CompetitionRuleID, F_MatchInfo, F_MatchNum, (CASE F_RoundID WHEN 0 THEN NULL ELSE F_RoundID + @RoundStartID END) AS F_RoundID, F_OrderInRound 
				FROM TM_Match WHERE F_ModelID = @ModelID

		SET IDENTITY_INSERT dbo.TS_Match OFF 
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TS_Match_Des (F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2, F_MatchComment3)
			SELECT (F_MatchID + @MatchStartID) AS F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2, F_MatchComment3 
				FROM TM_Match_Des WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		UPDATE TM_Match_Result SET F_StartPhaseID = CASE F_StartPhaseID WHEN 0 THEN NULL ELSE F_StartPhaseID END,
			 F_StartPhasePosition = CASE F_StartPhasePosition WHEN 0 THEN NULL ELSE F_StartPhasePosition END,
			 F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END,
			 F_HistoryMatchID = CASE F_HistoryMatchID WHEN 0 THEN NULL ELSE F_HistoryMatchID END,
			 F_HistoryMatchRank = CASE F_HistoryMatchRank WHEN 0 THEN NULL ELSE F_HistoryMatchRank END,
			 F_HistoryLevel = CASE F_HistoryLevel WHEN 0 THEN NULL ELSE F_HistoryLevel END
			WHERE F_ModelID = @ModelID 
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TS_Match_Result (F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel, F_Comment)
			SELECT (F_MatchID + @MatchStartID) AS F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, (F_StartPhaseID + @PhaseStartID) AS F_StartPhaseID, F_StartPhasePosition,
				 (F_SourcePhaseID + @PhaseStartID) AS F_SourcePhaseID, F_SourcePhaseRank, (F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, F_SourceMatchRank,
				 (F_HistoryMatchID + @MatchStartID) AS F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel, F_Comment 
				FROM TM_Match_Result WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TS_Match_Result_Des (F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT (F_MatchID + @MatchStartID) AS F_MatchID, F_CompetitionPosition,F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment 
				FROM TM_Match_Result_Des WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TM_Phase_Position SET F_StartPhaseID = CASE F_StartPhaseID WHEN 0 THEN NULL ELSE F_StartPhaseID END,
			 F_StartPhasePosition = CASE F_StartPhasePosition WHEN 0 THEN NULL ELSE F_StartPhasePosition END,
			 F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END

		INSERT INTO TS_Phase_Position (F_PhaseID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT (F_PhaseID + @PhaseStartID) AS F_PhaseID, F_PhasePosition, (F_StartPhaseID + @PhaseStartID) AS F_StartPhaseID, F_StartPhasePosition, (F_SourcePhaseID + @PhaseStartID) AS F_PhaseID, F_SourcePhaseRank, (F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, F_SourceMatchRank
				FROM TM_Phase_Position WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		UPDATE TM_Phase_Result SET F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END

		INSERT INTO TS_Phase_Result (F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
					SELECT (F_PhaseID + @PhaseStartID) AS F_PhaseID, F_PhaseResultNumber, F_PhaseRank, (F_SourcePhaseID + @PhaseStartID) AS F_PhaseID, F_SourcePhaseRank, (F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, F_SourceMatchRank
						FROM TM_Phase_Result WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TM_Event_Result SET F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END

		INSERT INTO TS_Event_Result (F_EventID, F_EventResultNumber, F_EventRank, F_EventDisplayPosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @EventID AS F_EventID, F_EventResultNumber, F_EventRank, F_EventDiplayPosition, (F_SourcePhaseID + @PhaseStartID) AS F_PhaseID, F_SourcePhaseRank, (F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, F_SourceMatchRank
				FROM TM_Event_Result WHERE F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Phase_Model(F_PhaseID, F_PhaseModelID, F_Order, F_PhaseModelName, F_PhaseModelComment)
			SELECT (A.F_PhaseID + @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, A.F_Order, A.F_PhaseModelName, A.F_PhaseModelComment
				FROM TM_Phase_Model AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	

		UPDATE TM_Phase_Model_Phase_Position SET F_StartPhaseID = CASE F_StartPhaseID WHEN 0 THEN NULL ELSE F_StartPhaseID END,
			 F_StartPhasePosition = CASE F_StartPhasePosition WHEN 0 THEN NULL ELSE F_StartPhasePosition END,
			 F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END

		INSERT INTO TS_Phase_Model_Phase_Position(F_PhaseID, F_PhaseModelID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT  (A.F_PhaseID + @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, A.F_PhasePosition, (A.F_StartPhaseID + @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID  + @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank
				FROM TM_Phase_Model_Phase_Position AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TM_Phase_Model_Phase_Resut SET F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END

		INSERT INTO TS_Phase_Model_Phase_Resut (F_PhaseID, F_PhaseModelID, F_PhaseResultNumber, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT  (A.F_PhaseID + @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, A.F_PhaseResultNumber,(A.F_SourcePhaseID  + @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank, (A.F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank
				FROM TM_Phase_Model_Phase_Resut AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		UPDATE TM_Phase_Model_Match_Result SET F_StartPhaseID = CASE F_StartPhaseID WHEN 0 THEN NULL ELSE F_StartPhaseID END,
			 F_StartPhasePosition = CASE F_StartPhasePosition WHEN 0 THEN NULL ELSE F_StartPhasePosition END,
			 F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END,
			 F_HistoryMatchID = CASE F_HistoryMatchID WHEN 0 THEN NULL ELSE F_HistoryMatchID END,
			 F_HistoryMatchRank = CASE F_HistoryMatchRank WHEN 0 THEN NULL ELSE F_HistoryMatchRank END,
			 F_HistoryLevel = CASE F_HistoryLevel WHEN 0 THEN NULL ELSE F_HistoryLevel END
			WHERE F_ModelID = @ModelID 

		INSERT INTO TS_Phase_Model_Match_Result(F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT (A.F_PhaseID + @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, (A.F_MatchID + @MatchStartID) AS F_MatchID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes2, (A.F_StartPhaseID + @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID  + @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank,
			 (A.F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank, 
				 (A.F_HistoryMatchID + @MatchStartID) AS F_HistoryMatchID, A.F_HistoryMatchRank, A.F_HistoryLevel
				FROM TM_Phase_Model_Match_Result AS A WHERE A.F_ModelID = @ModelID


        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Phase_Model_Match_Result_Des (F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT (A.F_PhaseID + @PhaseStartID) AS F_PhaseID, A.F_PhaseModelID, (A.F_MatchID + @MatchStartID) AS F_MatchID, A.F_CompetitionPosition, A.F_LanguageCode, A.F_CompetitorSourceDes, A.F_SouceProgressDes, A.F_SouceProgressType, A.F_Comment
				FROM TM_Phase_Model_Match_Result_Des AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TS_Match_Model ( F_MatchID, F_MatchModelID, F_Order, F_MatchModelName, F_MatchModelComment)
			SELECT (A.F_MatchID + @MatchStartID) AS F_MatchID, A.F_MatchModelID, A.F_Order, A.F_MatchModelName, A.F_MatchModelComment 
				FROM TM_Match_Model AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		UPDATE TM_Match_Model_Match_Result SET F_StartPhaseID = CASE F_StartPhaseID WHEN 0 THEN NULL ELSE F_StartPhaseID END,
			 F_StartPhasePosition = CASE F_StartPhasePosition WHEN 0 THEN NULL ELSE F_StartPhasePosition END,
			 F_SourcePhaseID = CASE F_SourcePhaseID WHEN 0 THEN NULL ELSE F_SourcePhaseID END,
			 F_SourcePhaseRank = CASE F_SourcePhaseRank WHEN 0 THEN NULL ELSE F_SourcePhaseRank END,
			 F_SourceMatchID = CASE F_SourceMatchID WHEN 0 THEN NULL ELSE F_SourceMatchID END,
			 F_SourceMatchRank = CASE F_SourceMatchRank WHEN 0 THEN NULL ELSE F_SourceMatchRank END,
			 F_HistoryMatchID = CASE F_HistoryMatchID WHEN 0 THEN NULL ELSE F_HistoryMatchID END,
			 F_HistoryMatchRank = CASE F_HistoryMatchRank WHEN 0 THEN NULL ELSE F_HistoryMatchRank END,
			 F_HistoryLevel = CASE F_HistoryLevel WHEN 0 THEN NULL ELSE F_HistoryLevel END
			WHERE F_ModelID = @ModelID 

		INSERT INTO TS_Match_Model_Match_Result(F_MatchID, F_MatchModelID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT (A.F_MatchID + @MatchStartID) AS F_MatchID, A.F_MatchModelID, A.F_CompetitionPosition, A.F_CompetitionPositionDes1, A.F_CompetitionPositionDes2, (A.F_StartPhaseID + @PhaseStartID) AS F_StartPhaseID, A.F_StartPhasePosition, (A.F_SourcePhaseID  + @PhaseStartID) AS F_SourcePhaseID, A.F_SourcePhaseRank,
			 (A.F_SourceMatchID + @MatchStartID) AS F_SourceMatchID, A.F_SourceMatchRank, 
				 (A.F_HistoryMatchID + @MatchStartID) AS F_HistoryMatchID, A.F_HistoryMatchRank, A.F_HistoryLevel
				FROM TM_Match_Model_Match_Result AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TS_Match_Model_Match_Result_Des (F_MatchID, F_MatchModelID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT (A.F_MatchID + @MatchStartID) AS F_MatchID, A.F_MatchModelID, A.F_CompetitionPosition, A.F_LanguageCode, A.F_CompetitorSourceDes, A.F_SouceProgressDes, A.F_SouceProgressType, A.F_Comment
				FROM TM_Match_Model_Match_Result_Des AS A WHERE A.F_ModelID = @ModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
	  
	  
	  
		CREATE TABLE #table_Tree (	F_ItemID			INT IDENTITY(1, 1),
                                    F_SportID           INT,
                                    F_DisciplineID      INT,
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_MatchID			INT,
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
									F_NodeLevel			INT,
                                    F_Order             INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100)
								 )

      DECLARE @NodeLevel INT
	  SET @NodeLevel = 0

	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey)
		SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey
		  FROM TS_Phase AS A LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_EventID = @EventID AND A.F_FatherPhaseID = 0

      WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	  BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
	
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey)
		  SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
			FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	  END
	

	--添加Match节点
	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey)
			SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
				FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_NodeType = 0
	  
	  DECLARE @NodeType			AS INT
	  DECLARE @CurPhaseID		AS INT
	  DECLARE @CurMatchID		AS INT
	  DECLARE @PartModelID		AS INT
	  DECLARE @CurResult		AS INT
	  DECLARE @CurItemID		AS INT
	  SET @CurItemID = 1
	  
	  WHILE EXISTS(SELECT F_ItemID FROM #table_Tree WHERE F_ItemID = @CurItemID)
	  BEGIN
	  
			SELECT @NodeType = F_NodeType, @CurPhaseID = F_PhaseID, @CurMatchID = F_MatchID FROM #table_Tree WHERE F_ItemID = @CurItemID
			SET @CurItemID = @CurItemID + 1
			--PRINT CAST(@NodeType AS NVARCHAR(100)) + ',' +CAST(@CurPhaseID AS NVARCHAR(100)) +','+CAST(CASE  WHEN @CurMatchID IS NULL THEN '' ELSE @CurMatchID END  AS NVARCHAR(100))

			IF @NodeType = 0
			BEGIN
				SET @PartModelID = NULL
				SELECT TOP 1 @PartModelID = F_PhaseModelID FROM TS_Phase_Model WHERE F_PhaseID = @CurPhaseID ORDER BY F_Order
				IF @PartModelID IS NOT NULL
				BEGIN
					EXEC Proc_LoadPhaseModel @CurPhaseID, @PartModelID, @CurResult OUTPUT
					IF @CurResult != 1
					BEGIN 
						SET @Result=0
						RETURN
					END
				END
			END
			ELSE IF @NodeType = 1
			BEGIN
				SET @PartModelID = NULL
				SELECT TOP 1 @PartModelID = F_MatchModelID FROM TS_Match_Model WHERE F_MatchID = @CurMatchID ORDER BY F_Order
				IF @PartModelID IS NOT NULL
				BEGIN
					EXEC Proc_LoadMatchModel @CurMatchID, @PartModelID, @CurResult OUTPUT
					IF @CurResult != 1
					BEGIN 
						SET @Result=0
						RETURN
					END
				END
			END

	  END
	  
	COMMIT TRANSACTION --成功提交事务



	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END

GO


/*

DECLARE @Result AS INT
EXEC proc_SetEventModelFromModel 30, 405, @Result OUTPUT
SELECT @Result

GO
*/