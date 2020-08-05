IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_LoadPhaseModel]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_LoadPhaseModel]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go




--名    称：[Proc_LoadPhaseModel]
--描    述：将该Phase的晋级方案模型应用到编排之中
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年12月09日



CREATE PROCEDURE [dbo].[Proc_LoadPhaseModel](
				@PhaseID			INT,
				@PhaseModelID		INT,
				@Result				AS INT OUTPUT
)
AS
Begin
SET NOCOUNT ON 

	SET @Result=0;  -- @Result = 0; 	将该Phase的晋级方案模型应用到编排之中失败，标示没有做任何操作！
					-- @Result = 1; 	将该Phase的晋级方案模型应用到编排之中成功！
					-- @Result = -1;	将该Phase的晋级方案模型应用到编排之中失败，Phase状态或者Match状态已经是Running, 不允许进行此操作！
					-- @Result = -2;	将该Phase的晋级方案模型应用到编排之中失败，@PhaseModelID是无效值。


	IF EXISTS (SELECT F_PhaseID FROM TS_Phase WHERE F_PhaseStatusID >=50 AND F_PhaseID = @PhaseID)
	BEGIN
		SET @Result = -1
		RETURN
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
	
	IF EXISTS (SELECT B.F_MatchID FROM #TempTable AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE B.F_MatchStatusID >= 50 AND A.F_Level = 0)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF NOT EXISTS(SELECT F_PhaseModelID FROM TS_Phase_Model WHERE F_PhaseID = @PhaseID AND F_PhaseModelID = @PhaseModelID)
	BEGIN
		SET @Result = -2
		RETURN
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --设定事务
	
		UPDATE TS_Phase SET F_UsingModelID = @PhaseModelID WHERE F_PhaseID = @PhaseID
	    IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		UPDATE TS_Phase_Result SET F_SourcePhaseID = B.F_SourcePhaseID, F_SourcePhaseRank = B.F_SourcePhaseRank, F_SourceMatchID = B.F_SourceMatchID, F_SourceMatchRank = B.F_SourceMatchRank,
			F_RegisterID = NULL FROM TS_Phase_Result AS A LEFT JOIN TS_Phase_Model_Phase_Resut AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_PhaseID = @PhaseID AND B.F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END


		UPDATE TS_Phase_Position SET  F_StartPhaseID = B.F_StartPhaseID, F_StartPhasePosition = B.F_StartPhasePosition, F_SourcePhaseID = B.F_SourcePhaseID, F_SourcePhaseRank = B.F_SourcePhaseRank,
			F_SourceMatchID = B.F_SourceMatchID, F_SourceMatchRank = B.F_SourceMatchRank, F_RegisterID = NULL
				FROM TS_Phase_Position AS A LEFT JOIN TS_Phase_Model_Phase_Position AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_PhasePosition = B.F_PhasePosition
					WHERE B.F_PhaseID = @PhaseID AND B.F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END

		UPDATE TS_Match_Result SET F_CompetitionPositionDes1 = B.F_CompetitionPositionDes1, F_CompetitionPositionDes2 = B.F_CompetitionPositionDes2,
			F_StartPhaseID = B.F_StartPhaseID, F_StartPhasePosition = B.F_StartPhasePosition, F_SourcePhaseID = B.F_SourcePhaseID, F_SourcePhaseRank = B.F_SourcePhaseRank,
			F_SourceMatchID = B.F_SourceMatchID, F_SourceMatchRank = B.F_SourceMatchRank, F_HistoryMatchID = B.F_HistoryMatchID, F_HistoryMatchRank = B.F_HistoryMatchRank, F_HistoryLevel = B.F_HistoryLevel,
			F_RegisterID = NULL FROM TS_Match_Result AS A LEFT JOIN TS_Phase_Model_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition WHERE B.F_PhaseID = @PhaseID AND B.F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
			RETURN
		END



		UPDATE TS_Match_Result_Des SET F_CompetitorSourceDes = B.F_CompetitorSourceDes, F_SouceProgressDes = B.F_SouceProgressDes, F_SouceProgressType = B.F_SouceProgressType, F_Comment = B.F_Comment
			FROM TS_Match_Result_Des AS A LEFT JOIN TS_Phase_Model_Match_Result_Des AS B
				ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition AND A.F_LanguageCode = B.F_LanguageCode
					WHERE B.F_PhaseID = @PhaseID AND B.F_PhaseModelID = @PhaseModelID

        IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = 0
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
		  FROM TS_Phase AS A LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID

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
	  SET @CurItemID = 2
	  
	  WHILE EXISTS(SELECT F_ItemID FROM #table_Tree WHERE F_ItemID = @CurItemID)
	  BEGIN
	  
			SELECT @NodeType = F_NodeType, @CurPhaseID = F_PhaseID, @CurMatchID = F_MatchID FROM #table_Tree WHERE F_ItemID = @CurItemID
			SET @CurItemID = @CurItemID + 1
			
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


Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF


go

--EXEC Proc_LoadPhaseModel 2117, 5, 0