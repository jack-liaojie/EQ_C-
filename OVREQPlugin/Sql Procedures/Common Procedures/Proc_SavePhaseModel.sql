IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SavePhaseModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SavePhaseModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_SavePhaseModel]
--描    述：存储该Phase的晋级方案模型
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年12月09日



CREATE PROCEDURE [dbo].[Proc_SavePhaseModel](
				@PhaseID			INT,
				@PhaseModelName		NVARCHAR(100),
				@PhaseModelComment	NVARCHAR(200),
				@Order				INT = 0,
				@Result			AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result=0; 	存储该Phase的晋级方案模型失败，标示没有做任何操作！
					-- @Result>0; 	存储该Phase的晋级方案模型成功！此即为@PhaseModelID

	DECLARE @PhaseModelID AS INT
	SELECT @PhaseModelID = CASE WHEN MAX(F_PhaseModelID) IS NULL THEN 1 ELSE MAX(F_PhaseModelID) + 1 END FROM TS_Phase_Model WHERE F_PhaseID = @PhaseID
	
	IF (@Order = 0)
	BEGIN
		SELECT @Order = ISNULL(MAX(F_Order), 0) + 1 FROM TS_Phase_Model WHERE F_PhaseID = @PhaseID
	END
	
	CREATE TABLE #TempTable(
						F_PhaseID				INT,
						F_FatherPhaseID			INT,
						F_Level					INT,
						F_MatchID				INT)

	INSERT INTO #TempTable (F_PhaseID, F_FatherPhaseID, F_Level)
		SELECT F_PhaseID, F_FatherPhaseID, 0 AS F_Level FROM TS_Phase WHERE F_PhaseID = @PhaseID
	DECLARE @Level AS INT
	SET @Level = 0

	WHILE EXISTS (SELECT B.F_PhaseID FROM #TempTable AS A INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_FatherPhaseID WHERE A.F_Level = 0)
	BEGIN
		SET @Level = @Level + 1 
		UPDATE #TempTable SET F_Level = @Level WHERE F_Level = 0
		INSERT INTO #TempTable (F_PhaseID, F_FatherPhaseID, F_Level)
			SELECT B.F_PhaseID, B.F_FatherPhaseID, 0 AS F_Level FROM #TempTable AS A INNER JOIN TS_Phase AS B ON A.F_PhaseID = B.F_FatherPhaseID WHERE A.F_Level = @Level
	END

	INSERT INTO #TempTable (F_MatchID, F_Level) SELECT F_MatchID, 0 AS F_Level FROM TS_Match WHERE F_PhaseID IN (SELECT F_PhaseID FROM #TempTable)

	
	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务

		INSERT INTO TS_Phase_Model (F_PhaseID, F_PhaseModelID, F_Order, F_PhaseModelName, F_PhaseModelComment) 
			VALUES (@PhaseID, @PhaseModelID, @Order, @PhaseModelName, @PhaseModelComment) 

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END


		UPDATE TS_Phase SET F_UsingModelID = @PhaseModelID WHERE F_PhaseID = @PhaseID
        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		INSERT INTO TS_Phase_Model_Phase_Resut (F_PhaseID, F_PhaseModelID, F_PhaseResultNumber, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @PhaseID AS F_PhaseID, @PhaseModelID AS F_PhaseModelID, F_PhaseResultNumber, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank FROM TS_Phase_Result
				WHERE F_PhaseID = @PhaseID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		INSERT INTO TS_Phase_Model_Phase_Position(F_PhaseID, F_PhaseModelID, F_PhasePosition,
				F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank)
			SELECT @PhaseID AS F_PhaseID, @PhaseModelID AS F_PhaseModelID, F_PhasePosition, 
				F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank
				FROM TS_Phase_Position WHERE F_PhaseID = @PhaseID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		INSERT INTO TS_Phase_Model_Match_Result(F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2,
				F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel)
			SELECT @PhaseID AS F_PhaseID, @PhaseModelID AS F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_CompetitionPositionDes1, F_CompetitionPositionDes2,
				F_StartPhaseID, F_StartPhasePosition, F_SourcePhaseID, F_SourcePhaseRank, F_SourceMatchID, F_SourceMatchRank, F_HistoryMatchID, F_HistoryMatchRank, F_HistoryLevel
				FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM #TempTable WHERE F_Level = 0)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		INSERT INTO TS_Phase_Model_Match_Result_Des(F_PhaseID, F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment)
			SELECT @PhaseID AS F_PhaseID, @PhaseModelID AS F_PhaseModelID, F_MatchID, F_CompetitionPosition, F_LanguageCode, F_CompetitorSourceDes, F_SouceProgressDes, F_SouceProgressType, F_Comment
				FROM TS_Match_Result_Des WHERE F_MatchID IN (SELECT F_MatchID FROM #TempTable WHERE F_Level = 0)

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = @PhaseModelID
	RETURN

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go


/*
EXEC Proc_SavePhaseModel 2113, 'asdfg', 'asdfad', 0
*/