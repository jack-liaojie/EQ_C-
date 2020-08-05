if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[proc_DelPhase]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[proc_DelPhase]
GO

SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO


----存储过程名称：proc_DelPhase
----功		  能：删除一个Phase，将删除此Phase下所有的子Phase，并且删除所有的Match，主要是为编排服务
----作		  者：郑金勇 
----日		  期: 2009-04-08 

CREATE PROCEDURE proc_DelPhase 
	@PhaseID			INT,
	@Result 			AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	删除Phase失败，标示没有做任何操作！
					-- @Result=1; 	删除Phase成功！此值即为PhaseID
					-- @Result=-1; 	删除Phase失败，该PhaseID无效
					-- @Result=-2; 	删除Phase失败，该Phase的状态不允许删除
					-- @Result=-3; 	删除Phase失败，该Phase下的子Phase的状态不允许删除
					-- @Result=-4; 	删除Phase失败，该Phase下的Match的状态不允许删除
					-- @Result=-5; 	删除Phase失败，该Phase下父节点的状态不允许删除

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
	
	DECLARE @ParentStatusID AS INT
	DECLARE @ParentPhaseID AS INT

	
	SELECT @ParentPhaseID = F_FatherPhaseID FROM TS_Phase WHERE F_PhaseID = @PhaseID
	IF @ParentPhaseID = 0
	BEGIN
		SELECT @ParentStatusID = B.F_EventStatusID FROM TS_Phase AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_PhaseID = @PhaseID 
	END
	ELSE 
	BEGIN
		SELECT @ParentStatusID = F_PhaseStatusID FROM TS_Phase WHERE F_PhaseID = @PhaseID 
	END

	IF @ParentStatusID > 10 
	BEGIN
		SET @Result = -5
		RETURN
	END


	CREATE TABLE #table_Tree (
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_PhaseCode			NVARCHAR(10),
									F_PhaseOrder		INT,
									F_PhaseLongName		NVARCHAR(100),
									F_PhaseShortName	NVARCHAR(50),
									F_PhaseNodeType		INT,
									F_MatchID			INT,
									F_MatchOrder		INT,
									F_MatchName			NVARCHAR(100),
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
									F_NodeLevel			INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100),
									F_NodeName			NVARCHAR(100)
								 )
		


	INSERT INTO #table_Tree( F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseOrder, F_NodeType, F_NodeLevel, F_NodeKey, F_FatherNodeKey)
		SELECT F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_Order as F_PhaseOrder, 0 as F_NodeType,0 as F_NodeLevel, 'P'+CAST( F_PhaseID AS NVARCHAR(50)) as F_NodeKey, 'E'+CAST( F_EventID AS NVARCHAR(50)) as F_FatherNodeKey
			FROM TS_Phase WHERE F_PhaseID = @PhaseID


	DECLARE @NodeLevel INT
	SET @NodeLevel = 0

	--生成Phase树
	WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel=0 ) 
	BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

	
		INSERT INTO #table_Tree( F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseOrder, F_NodeType, F_NodeLevel, F_NodeKey, F_FatherNodeKey)
			SELECT A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_Order as F_PhaseOrder, 0 as F_NodeType,0 as F_NodeLevel, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
				FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	END

	--添加Match节点
	INSERT INTO #table_Tree( F_EventID, F_PhaseID, F_MatchID, F_MatchOrder, F_NodeType, F_NodeLevel, F_NodeKey, F_FatherNodeKey)
				SELECT B.F_EventID, B.F_PhaseID, A.F_MatchID, A.F_Order as F_MatchOrder, 1 as F_NodeType, (B.F_NodeLevel+1) as F_NodeLevel, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
					FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID=B.F_PhaseID 
						WHERE B.F_NodeType = 0
	
	IF EXISTS (SELECT A.F_PhaseID FROM #table_Tree AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_NodeType = 0 AND B.F_PhaseStatusID > 10)
	BEGIN
		SET @Result = -3
		RETURN
	END

	IF EXISTS (SELECT A.F_PhaseID FROM #table_Tree AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE A.F_NodeType = 1 AND B.F_MatchStatusID > 10)
	BEGIN
		SET @Result = -4
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务



		DELETE FROM TS_Phase_Model_Match_Result_Des WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Phase_Model_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Model_Match_Result_Des WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Match_Model_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Match_Model WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Statistic WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_ActionList WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Member WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Member WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Servant WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Result WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Des WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Split_Info WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result_Des WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Result_Record WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Result WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match_Des WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END
		
		UPDATE TS_Phase_Position SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Event_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Match_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Match_Result SET F_HistoryMatchID = NULL, F_HistoryMatchRank = NULL, F_HistoryLevel = NULL WHERE F_HistoryMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match_Model_Match_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match_Model_Match_Result SET F_HistoryMatchID = NULL, F_HistoryMatchRank = NULL, F_HistoryLevel = NULL WHERE F_HistoryMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END



		UPDATE TS_Phase_Model_Phase_Resut SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Phase_Position SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Result SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Position SET F_SourceMatchID = NULL, F_SourceMatchRank = NULL WHERE F_SourceMatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Match WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree WHERE F_NodeType = 1)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_MatchPoint WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Result WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Des WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		UPDATE TS_Match_Result SET F_StartPhaseID = NULL, F_StartPhasePosition = NULL WHERE F_StartPhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Match_Result SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Position SET F_StartPhaseID = NULL, F_StartPhasePosition = NULL WHERE F_StartPhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Position SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Result SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Phase_Position SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Phase_Resut SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Phase_Model_Match_Result SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		UPDATE TS_Match_Model_Match_Result SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		UPDATE TS_Event_Result SET F_SourcePhaseID = NULL, F_SourcePhaseRank = NULL WHERE F_SourcePhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Competitors WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Position WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END


		DELETE FROM TS_Phase_Position WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Match_Result WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Match_Result_Des WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Phase_Position WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model_Phase_Resut WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase_Model WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

		DELETE FROM TS_Phase WHERE F_PhaseID IN (SELECT F_PhaseID FROM #table_Tree WHERE F_NodeType = 0)
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --成功提交事务

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

