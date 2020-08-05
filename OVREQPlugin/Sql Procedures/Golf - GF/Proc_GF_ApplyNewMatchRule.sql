IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_ApplyNewMatchRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_ApplyNewMatchRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_GF_ApplyNewMatchRule]
----功		  能：此比赛采用新的竞赛规则，要求首先是删除比赛的现有成绩，其次是创建新的比赛Splits
----作		  者：张翠霞
----日		  期: 2010-09-28 

CREATE PROCEDURE [dbo].[Proc_GF_ApplyNewMatchRule]
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
		
		UPDATE TS_Match_Result SET F_Points = NULL, F_Rank = NULL, F_DisplayPosition = NULL, F_ResultID = NULL, F_IRMID = NULL, F_CompetitionPositionDes2 = NULL
		, F_PointsCharDes1 = NULL, F_PointsCharDes2 = NULL, F_PointsCharDes3 = NULL, F_PointsCharDes4 = NULL, F_PointsNumDes1 = NULL, F_StartTimeCharDes = NULL
		, F_StartTimeNumDes = NULL, F_FinishTimeNumDes = NULL WHERE F_MatchID = @MatchID
		
		UPDATE TS_Match SET F_CompetitionRuleID = @CompetitionRuleID WHERE F_MatchID = @MatchID
		
		DECLARE @XmlDoc AS XML
		SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID

		IF @XmlDoc IS NOT NULL
		BEGIN
		DECLARE @iDoc AS INT
			EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
			
				INSERT INTO TS_Match_Split_Info (F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_MatchSplitComment, F_MatchSplitComment1, F_Order)
				SELECT @MatchID AS F_MatchID, Hole AS F_MatchSplitID, 0 AS F_FatherMatchSplitID, Par AS F_MatchSplitComment, Distance AS F_MatchSplitComment1, Hole AS F_Order FROM OPENXML (@iDoc, '/CourseInfo/HoleRule',1)
					WITH (
					Hole      INT '@HoleNum',
					Par       INT '@HolePar',
					Distance  INT '@HoleDistance'
				)
				
			EXEC sp_xml_removedocument @iDoc
		END

        CREATE TABLE #Temp_Result (
								F_CompetitionPosition	INT
								)
								
		INSERT INTO #Temp_Result (F_CompetitionPosition)
		SELECT F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID
		
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



