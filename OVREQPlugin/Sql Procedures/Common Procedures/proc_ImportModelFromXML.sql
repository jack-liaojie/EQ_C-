IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_ImportModelFromXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_ImportModelFromXML]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----存储过程名称：[proc_ImportModelFromXML]
----功		  能：从XML文件导入编排模型
----作		  者：郑金勇
----日		  期: 2009-08-20 

CREATE PROCEDURE [dbo].[proc_ImportModelFromXML]
    @ModelName			NVARCHAR(100),
	@ModelComment		NVARCHAR(200),
    @ModelXML			NVARCHAR(MAX),
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	导入编排模型失败，标示没有做任何操作！
					  -- @Result>=1; 	导入编排模型成功！此值即为ModelID

	DECLARE @NewModelID AS INT
	DECLARE @iDoc       AS INT
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务


		INSERT INTO TM_Model (F_ModelName, F_ModelComment) VALUES (@ModelName, @ModelComment)

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		SET @NewModelID = @@IDENTITY
		

		EXEC sp_xml_preparedocument @iDoc OUTPUT, @ModelXML

		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		IF (@ModelName = '' OR @ModelName IS NULL)
		BEGIN
			SELECT TOP 1 @ModelName =  F_ModelName, @ModelComment = F_ModelComment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Models/TM_Model',1)
					WITH (
							F_ModelName NVARCHAR(100) './F_ModelName',
							F_ModelComment NVARCHAR(200) './F_ModelComment'
						)

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END

			UPDATE TM_Model SET F_ModelName = @ModelName, F_ModelComment = @ModelComment WHERE F_ModelID = @NewModelID

			IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result=0
				RETURN
			END
		END

        INSERT INTO TM_Phase (F_ModelID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo, F_PhaseIsPool, F_PhaseHasPools )
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseNodeType, F_Order, F_PhaseType, F_PhaseSize, F_PhaseRankSize, F_PhaseIsQual, F_PhaseInfo, F_PhaseIsPool, F_PhaseHasPools 
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phases/TM_Phase',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_FatherPhaseID INT './F_FatherPhaseID',
						F_PhaseCode NVARCHAR(10) './F_PhaseCode',
						F_PhaseNodeType INT './F_PhaseNodeType',
						F_Order INT './F_Order',
						F_PhaseType INT './F_PhaseType',
						F_PhaseSize INT './F_PhaseSize',
						F_PhaseRankSize INT './F_PhaseRankSize',
						F_PhaseIsQual INT './F_PhaseIsQual',
						F_PhaseInfo NVARCHAR(50) './F_PhaseInfo',
						F_PhaseIsPool INT './F_PhaseIsPool',
						F_PhaseHasPools INT './F_PhaseHasPools'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		INSERT INTO TM_Phase_Des (F_ModelID, F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_LanguageCode, F_PhaseLongName, F_PhaseShortName, F_PhaseComment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Dess/TM_Phase_Des',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_LanguageCode CHAR(3) './F_LanguageCode',
						F_PhaseLongName NVARCHAR(100) './F_PhaseLongName',
						F_PhaseShortName NVARCHAR(50) './F_PhaseShortName',
						F_PhaseComment NVARCHAR(100) './F_PhaseComment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		
		INSERT INTO TM_Phase_MatchPoint (F_ModelID, F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_WonMatchPoint, F_DrawMatchPoint, F_LostMatchPoint
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_MatchPoints/TM_Phase_MatchPoint',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_WonMatchPoint INT './F_WonMatchPoint',
						F_DrawMatchPoint INT './F_DrawMatchPoint',
						F_LostMatchPoint INT './F_LostMatchPoint'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


        INSERT INTO TM_Match (F_ModelID, F_MatchID, F_PhaseID, F_Order, F_MatchTypeID, F_MatchCode, F_MatchHasMedal, F_CompetitionRuleID, F_MatchInfo, F_MatchNum, F_RoundID, F_OrderInRound)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_PhaseID, F_Order, F_MatchTypeID, F_MatchCode, F_MatchHasMedal, F_CompetitionRuleID, F_MatchInfo, F_MatchNum, F_RoundID, F_OrderInRound
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Matchs/TM_Match',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_PhaseID INT './F_PhaseID',
						F_Order INT './F_Order',
						F_MatchTypeID INT './F_MatchTypeID',
						F_MatchCode NVARCHAR(20) './F_MatchCode',
						F_MatchHasMedal INT './F_MatchHasMedal',
						F_CompetitionRuleID INT './F_CompetitionRuleID',
						F_MatchInfo NVARCHAR(50) './F_MatchInfo',
						F_MatchNum INT './F_MatchNum',
						F_RoundID INT './F_RoundID',
						F_OrderInRound INT './F_OrderInRound'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match_Des (F_ModelID, F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2, F_MatchComment3)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_LanguageCode, F_MatchLongName, F_MatchShortName, F_MatchComment, F_MatchComment2, F_MatchComment3
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Match_Dess/TM_Match_Des',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_LanguageCode CHAR(3) './F_LanguageCode',
						F_MatchLongName NVARCHAR(100) './F_MatchLongName',
						F_MatchShortName NVARCHAR(50) './F_MatchShortName',
						F_MatchComment NVARCHAR(100) './F_MatchComment',
						F_MatchComment2 NVARCHAR(100) './F_MatchComment2',
						F_MatchComment3 NVARCHAR(100) './F_MatchComment3'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match_Result (F_ModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel, F_Comment)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel, F_Comment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Match_Results/TM_Match_Result',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_CompetitionPosition INT './F_CompetitionPosition',
						F_CompetitionPositionDes1 INT './F_CompetitionPositionDes1',
						F_CompetitionPositionDes2 INT './F_CompetitionPositionDes2',
						F_StartPhaseID INT './F_StartPhaseID',
						F_StartPhasePosition INT './F_StartPhasePosition',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank',
						F_HistoryMatchID INT './F_HistoryMatchID',
						F_HistoryMatchRank INT './F_HistoryMatchRank',
						F_HistoryLevel INT './F_HistoryLevel',
						F_Comment NVARCHAR(100) './F_Comment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Match_Result_Des (F_ModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Match_Result_Dess/TM_Match_Result_Des',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_CompetitionPosition INT './F_CompetitionPosition',
						F_LanguageCode CHAR(3) './F_LanguageCode',
						F_CompetitorSourceDes NVARCHAR(100) './F_CompetitorSourceDes',
						F_SouceProgressDes NVARCHAR(100) './F_SouceProgressDes', 
						F_SouceProgressType INT './F_SouceProgressType',
						F_Comment NVARCHAR(100) './F_Comment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Position (F_ModelID, F_PhaseID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Positions/TM_Phase_Position',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhasePosition INT './F_PhasePosition',
						F_StartPhaseID INT './F_StartPhaseID',
						F_StartPhasePosition INT './F_StartPhasePosition',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Result (F_ModelID, F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhaseResultNumber, F_PhaseRank, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Results/TM_Phase_Result',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhaseResultNumber INT './F_PhaseResultNumber',
						F_PhaseRank INT './F_PhaseRank',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Round (F_ModelID, F_RoundID, F_Order, F_RoundCode, F_Comment)
			SELECT @NewModelID AS F_ModelID, F_RoundID, F_Order, F_RoundCode, F_Comment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Rounds/TM_Round',1)
				WITH (
						F_RoundID INT './F_RoundID',
						F_Order INT './F_Order',
						F_RoundCode NVARCHAR(20) './F_RoundCode',
						F_Comment NVARCHAR(50) './F_Comment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Round_Des (F_ModelID, F_RoundID, F_LanguageCode, F_RoundLongName, F_RoundShortName, F_RoundComment)
			SELECT @NewModelID AS F_ModelID, F_RoundID, F_LanguageCode, F_RoundLongName, F_RoundShortName, F_RoundComment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Round_Dess/TM_Round_Des',1)
				WITH (
						F_RoundID INT './F_RoundID',
						F_LanguageCode CHAR(3) './F_LanguageCode',
						F_RoundLongName NVARCHAR(100) './F_RoundLongName',
						F_RoundShortName NVARCHAR(50) './F_RoundShortName',
						F_RoundComment NVARCHAR(100) './F_RoundComment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Event_Result (F_ModelID, F_EventResultNumber, F_EventRank, F_EventDiplayPosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, F_EventResultNumber, F_EventRank, F_EventDiplayPosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Event_Results/TM_Event_Result',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_EventResultNumber INT './F_EventResultNumber',
						F_EventRank INT './F_EventRank',
						F_EventDiplayPosition INT './F_EventDiplayPosition',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


        INSERT INTO TM_Match_Model (F_ModelID, F_MatchID, F_MatchModelID, F_Order, F_MatchModelName, F_MatchModelComment)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_MatchModelID, F_Order, F_MatchModelName, F_MatchModelComment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Match_Models/TM_Match_Model',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_MatchModelID INT './F_MatchModelID',
						F_Order INT './F_Order',
						F_MatchModelName NVARCHAR(100) './F_MatchModelName',
						F_MatchModelComment NVARCHAR(200) './F_MatchModelComment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Match_Model_Match_Result (F_ModelID, F_MatchID, F_MatchModelID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_MatchModelID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Match_Model_Match_Results/TM_Match_Model_Match_Result',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_MatchModelID INT './F_MatchModelID',
						F_CompetitionPosition INT './F_CompetitionPosition',
						F_CompetitionPositionDes1 INT './F_CompetitionPositionDes1',
						F_CompetitionPositionDes2 INT './F_CompetitionPositionDes2',
						F_StartPhaseID INT './F_StartPhaseID',
						F_StartPhasePosition INT './F_StartPhasePosition',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank',
						F_HistoryMatchID INT './F_HistoryMatchID',
						F_HistoryMatchRank INT './F_HistoryMatchRank',
						F_HistoryLevel INT './F_HistoryLevel'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Match_Model_Match_Result_Des (F_ModelID, F_MatchID, F_MatchModelID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @NewModelID AS F_ModelID, F_MatchID, F_MatchModelID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Match_Model_Match_Result_Dess/TM_Match_Model_Match_Result_Des',1)
				WITH (
						F_MatchID INT './F_MatchID',
						F_MatchModelID INT './F_MatchModelID',
						F_CompetitionPosition INT './F_CompetitionPosition',
						F_LanguageCode CHAR(3) './F_LanguageCode',
						F_CompetitorSourceDes NVARCHAR(100) './F_CompetitorSourceDes',
						F_SouceProgressDes NVARCHAR(100) './F_SouceProgressDes', 
						F_SouceProgressType INT './F_SouceProgressType',
						F_Comment NVARCHAR(100) './F_Comment'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

        INSERT INTO TM_Phase_Model (F_ModelID, F_PhaseID, F_PhaseModelID, F_Order, F_PhaseModelName, F_PhaseModelComment)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhaseModelID, F_Order, F_PhaseModelName, F_PhaseModelComment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Models/TM_Phase_Model',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhaseModelID INT './F_PhaseModelID',
						F_Order INT './F_Order',
						F_PhaseModelName NVARCHAR(100) './F_PhaseModelName',
						F_PhaseModelComment NVARCHAR(200) './F_PhaseModelComment'
					)
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model_Phase_Position (F_ModelID, F_PhaseID, F_PhaseModelID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhaseModelID, F_PhasePosition, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Model_Phase_Positions/TM_Phase_Model_Phase_Position',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhaseModelID INT './F_PhaseModelID',
						F_PhasePosition INT './F_PhasePosition',
						F_StartPhaseID INT './F_StartPhaseID',
						F_StartPhasePosition INT './F_StartPhasePosition',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model_Phase_Resut (F_ModelID, F_PhaseID, F_PhaseModelID, F_PhaseResultNumber, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhaseModelID, F_PhaseResultNumber, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Model_Phase_Resuts/TM_Phase_Model_Phase_Resut',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhaseModelID INT './F_PhaseModelID',
						F_PhaseResultNumber INT './F_PhaseResultNumber',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

 INSERT INTO TM_Phase_Model_Match_Result (F_ModelID, F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2, F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Model_Match_Results/TM_Phase_Model_Match_Result',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhaseModelID INT './F_PhaseModelID',
						F_MatchID INT './F_MatchID',
						F_CompetitionPosition INT './F_CompetitionPosition',
						F_CompetitionPositionDes1 INT './F_CompetitionPositionDes1',
						F_CompetitionPositionDes2 INT './F_CompetitionPositionDes2',
						F_StartPhaseID INT './F_StartPhaseID',
						F_StartPhasePosition INT './F_StartPhasePosition',
						F_SourcePhaseID INT './F_SourcePhaseID',
						F_SourcePhaseRank INT './F_SourcePhaseRank',
						F_SourceMatchID INT './F_SourceMatchID',
						F_SourceMatchRank INT './F_SourceMatchRank',
						F_HistoryMatchID INT './F_HistoryMatchID',
						F_HistoryMatchRank INT './F_HistoryMatchRank',
						F_HistoryLevel INT './F_HistoryLevel'
					)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		INSERT INTO TM_Phase_Model_Match_Result_Des (F_ModelID, F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @NewModelID AS F_ModelID, F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment
				FROM OPENXML (@iDoc, '/ModelRoot/TM_Phase_Model_Match_Result_Dess/TM_Phase_Model_Match_Result_Des',1)
				WITH (
						F_PhaseID INT './F_PhaseID',
						F_PhaseModelID INT './F_PhaseModelID',
						F_MatchID INT './F_MatchID',
						F_CompetitionPosition INT './F_CompetitionPosition',
						F_LanguageCode CHAR(3) './F_LanguageCode',
						F_CompetitorSourceDes NVARCHAR(100) './F_CompetitorSourceDes',
						F_SouceProgressDes NVARCHAR(100) './F_SouceProgressDes', 
						F_SouceProgressType INT './F_SouceProgressType', 
						F_Comment NVARCHAR(100) './F_Comment'
					)

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

DECLARE @Result AS INT
DECLARE @ModelXML AS NVARCHAR(MAX)
EXEC proc_CreateModel2XML 1, @ModelXML OUTPUT
SELECT @ModelXML
DECLARE @iDoc AS INT 
EXEC sp_xml_preparedocument @iDoc OUTPUT, @ModelXML
SELECT @iDoc


EXEC proc_ImportModelFromXML 'Model2', 'Model2Comment', @ModelXML, @Result OUTPUT
SELECT @Result
*/