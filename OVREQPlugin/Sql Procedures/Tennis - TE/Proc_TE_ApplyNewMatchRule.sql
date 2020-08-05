IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_ApplyNewMatchRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_ApplyNewMatchRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TE_ApplyNewMatchRule]
----功		  能：此比赛采用新的竞赛规则，要求首先是删除比赛的现有成绩，其次是创建新的比赛Splits
----作		  者：郑金勇
----日		  期: 2010-09-21 
----修  改 记 录: 
/*
                 李燕          2011-2-28     增加Advantage，TieBreak，DecidingTB的信息保存
*/

CREATE PROCEDURE [dbo].[Proc_TE_ApplyNewMatchRule]
    @MatchID				INT,
    @CompetitionRuleID		INT,
    @Result					INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;-- @Result=0; 	应用新的竞赛规则失败，标示没有做任何操作！
					-- @Result=1; 	应用新的竞赛规则成功！
					-- @Result=-1; 	应用新的竞赛规则失败，该MatchID或CompetitionRuleID无效
					-- @Result=-2; 	应用新的竞赛规则失败，该比赛的状态不允许进行竞赛规则的修改和调整
	
	IF NOT EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID)
	BEGIN
		SET @Result = -1
		RETURN 
	END
	
	IF NOT EXISTS (SELECT F_CompetitionRuleID FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -1
		RETURN 
	END
	
	IF EXISTS (SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID AND F_MatchStatusID > 40)
	BEGIN
		SET @Result = -2
		RETURN 
	END
	
	DECLARE @SubMatchCount INT
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
		--清除当前比赛的现有成绩和Split
		
		DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
		DELETE FROM TS_Match_Statistic WHERE F_MatchID = @MatchID
		
		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID
		DELETE FROM TS_Match_Split_Servant WHERE F_MatchID = @MatchID
		DELETE FROM TS_Match_Split_Member WHERE F_MatchID = @MatchID
		DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID
		DELETE FROM TS_Match_Split_Des WHERE F_MatchID = @MatchID
		DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID
		
		UPDATE TS_Match_Result SET F_Points = NULL, F_Rank = NULL, F_ResultID = NULL, F_IRMID = NULL WHERE F_MatchID = @MatchID
		
		UPDATE TS_Match SET F_CompetitionRuleID = @CompetitionRuleID WHERE F_MatchID = @MatchID
		
		
		DECLARE @XmlDoc AS XML
		SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID

		IF @XmlDoc IS NOT NULL
		BEGIN
		DECLARE @iDoc AS INT
			EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
			
			SET @SubMatchCount = @XmlDoc.value('(/MatchRule/@Match)[1]', 'int')
		    IF(@SubMatchCount IS NULL OR @SubMatchCount = 0)
		    BEGIN
				--单项赛
				INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitCode, F_MatchSplitType, F_Order, F_MatchSplitComment, F_MatchSplitComment1, F_MatchSplitComment2)
				SELECT @MatchID AS F_MatchID, SetNum AS F_MatchSplitID, 0 AS F_FatherMatchSplitID, SetNum AS F_MatchSplitCode, 1, SetNum AS F_Order,  Advantage AS F_MatchSplitComment, TieBreak AS F_MatchSplitComment1, DecidingTB AS F_MatchSplitComment2
				  FROM OPENXML (@iDoc, '/MatchRule/SetRule',1)
					WITH (
						RuleName NVARCHAR(50) '//MatchRule/@RuleName',
						[Sets] INT '//MatchRule/@Sets',
						SetNum INT '@SetNum',
						Games INT '@Games',
						Advantage INT '@Advantage',
						TieBreak INT '@TieBreak',
						DecidingTB INT '@DecidingTB',
						TBPoints INT '@TBPoints'
					)
		    END
		    ELSE  ---团体比赛
		    BEGIN
		        INSERT INTO TS_Match_Split_Info(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitCode, F_MatchSplitType, F_Order, F_MatchSplitComment2)
		          SELECT @MatchID AS F_MatchID, MatchNum AS F_MatchSplitID, 0 AS F_FatherMatchSplitID, MatchNum AS F_MatchSplitCode, 3, MatchNum AS F_Order, FullPlay AS F_MatchSplitComment2
		             FROM OPENXML(@iDoc, '/MatchRule/SubMatch', 2)
		              WITH(
		                      [MatchNum]  INT '@MatchNum',
		                      FullPlay    INT  '//MatchRule/@FullPlay'
		                  )
		                  
		        
		          
		          SELECT * INTO #Tmp_Set
		             FROM OPENXML(@iDoc, '/MatchRule/SubMatch/SetRule', 2)
		             WITH(
		                   [MatchCount]  INT '//MatchRule/@Match',
		                   [MatchNum]    INT '../@MatchNum',
		                   [Sets]        INT '//MatchRule/@Sets',
						   SetNum        INT '@SetNum',
						   Games         INT '@Games',
						   Advantage     INT '@Advantage',
						   TieBreak      INT '@TieBreak',
						   DecidingTB    INT '@DecidingTB',
						   TBPoints      INT '@TBPoints',
						   SetID         INT   
		             )
		        
		        UPDATE #Tmp_Set SET SetID = MatchNum * [Sets] + SetNum

                
                 INSERT INTO TS_Match_Split_Info(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitCode, F_MatchSplitType, F_Order, F_MatchSplitComment, F_MatchSplitComment1, F_MatchSplitComment2) 
                     SELECT @MatchID, SetID AS F_MatchSplitID, MatchNum AS F_FatherMatchSplitID, [SetNum] AS F_MatchSplitCode, 1 AS F_MatchSplitType, [SetNum] AS F_Order,  Advantage AS F_MatchSplitComment, TieBreak AS F_MatchSplitComment1, DecidingTB AS F_MatchSplitComment2
                      FROM #Tmp_Set 
                  
                ----城运会，1,2场为单打，3为双打
                UPDATE TS_Match_Split_Info SET F_MatchSplitComment3 = 1 WHERE F_MatchID = @MatchID AND F_MatchSplitType = 3 AND F_MatchSplitCode IN (1,2)
                UPDATE TS_Match_Split_Info SET F_MatchSplitComment3 = 2 WHERE F_MatchID = @MatchID AND F_MatchSplitType = 3 AND F_MatchSplitCode = 3
  
			END
			EXEC sp_xml_removedocument @iDoc
		END

		CREATE TABLE #Temp_Result (
								F_CompetitionPosition	INT
								)
		INSERT INTO #Temp_Result (F_CompetitionPosition) VALUES (1)
		INSERT INTO #Temp_Result (F_CompetitionPosition) VALUES (2)

		INSERT INTO TS_Match_Split_Result (F_MatchID,F_MatchSplitID,F_CompetitionPosition)
					SELECT A.F_MatchID, A.F_MatchSplitID, B.F_CompetitionPosition 
						FROM TS_Match_Split_Info AS A, #Temp_Result AS B 
							WHERE A.F_MatchID = @MatchID
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


--declare @tmp int 
--exec [Proc_TE_ApplyNewMatchRule] 1, 4, @tmp output
--select @tmp