IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BatchUpdatePosition]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BatchUpdatePosition]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_BatchUpdatePosition]
--描    述：批量更改竞赛位置
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2010年04月08日

CREATE PROCEDURE [dbo].[Proc_BatchUpdatePosition](
				 @DisciplineID			INT,
                 @EventID				INT,
				 @PhaseID				INT,
				 @MatchID				INT,
				 @NodeType				INT,
                 @UpdateStr				NVARCHAR(500),
                 @Result				INT OUTPUT
)
As
Begin
SET NOCOUNT ON 

	SET @Result = 0
	CREATE TABLE #table_Tree (
                                    F_SportID           INT,
                                    F_DisciplineID      INT,
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_MatchID			INT,
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
									F_NodeLevel			INT
								 )

      DECLARE @NodeLevel INT
	  SET @NodeLevel = 0

	  IF @NodeType = -2--Discipline
	  BEGIN

			INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_NodeType, F_NodeLevel)
				SELECT F_SportID, F_DisciplineID, -2, 1 FROM TS_Discipline WHERE F_DisciplineID = @DisciplineID
				
			INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeType, F_NodeLevel)
				SELECT A.F_SportID, A.F_DisciplineID, B.F_EventID, -1, (A.F_NodeLevel + 1) FROM #table_Tree AS A INNER JOIN TS_Event AS B ON A.F_DisciplineID = B.F_DisciplineID AND A.F_NodeType = -2
				
			INSERT INTO #table_Tree (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel)
				SELECT A.F_SportID, A.F_DisciplineID, A.F_EventID, B.F_PhaseID, B.F_FatherPhaseID, 0, 0 FROM #table_Tree AS A INNER JOIN TS_Phase AS B ON A.F_EventID = B.F_EventID AND A.F_NodeType = -1 AND B.F_FatherPhaseID = 0
				
			SET @NodeLevel = 2

	  END
      ELSE IF @NodeType = -1--Event
	  BEGIN

			INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeType, F_NodeLevel)
				SELECT C.F_SportID, B.F_DisciplineID, A.F_EventID, -1, 1 FROM TS_Event AS A LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Sport AS C ON B.F_SportID = C.F_SportID
					WHERE A.F_EventID = @EventID
					
			INSERT INTO #table_Tree (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel)
				SELECT A.F_SportID, A.F_DisciplineID, A.F_EventID, B.F_PhaseID, B.F_FatherPhaseID, 0, 0 FROM #table_Tree AS A INNER JOIN TS_Phase AS B ON A.F_EventID = B.F_EventID AND A.F_NodeType = -1 AND B.F_FatherPhaseID = 0
			
			SET @NodeLevel = 1

	  END
      ELSE IF @NodeType = 0--Phase
	  BEGIN

		  INSERT INTO #table_Tree (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel)
				SELECT C.F_SportID, B.F_DisciplineID, A.F_EventID, D.F_PhaseID, D.F_FatherPhaseID, 0, 0 FROM TS_Phase AS D LEFT JOIN TS_Event AS A ON D.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Sport AS C ON B.F_SportID = C.F_SportID
					WHERE D.F_PhaseID = @PhaseID
					
		  SET @NodeLevel = 0

	  END
	  ELSE IF @NodeType = 1--Match
	  BEGIN
	  
		  INSERT INTO #table_Tree (F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_MatchID, F_NodeType, F_NodeLevel)
				SELECT C.F_SportID, B.F_DisciplineID, A.F_EventID, D.F_PhaseID, D.F_FatherPhaseID, E.F_MatchID, 1, 1 FROM TS_Match AS E LEFT JOIN TS_Phase AS D ON E.F_PhaseID = D.F_PhaseID LEFT JOIN TS_Event AS A ON D.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Sport AS C ON B.F_SportID = C.F_SportID
					WHERE E.F_MatchID = @MatchID
					
	  END
	  

      WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	  BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
	
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_NodeType, F_NodeLevel)
		  SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, 0 as F_NodeType, 0 as F_NodeLevel
			FROM TS_Phase AS A INNER JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	  END

	--添加Match节点
	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_NodeType, F_NodeLevel)
			SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel
				FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID WHERE B.F_NodeType = 0


	SELECT F_MatchID INTO #Temp_Matches FROM #table_Tree WHERE F_NodeType = 1

	DECLARE @iDoc       AS INT
	
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @UpdateStr

	SELECT F_OldPosition, F_NewPosition INTO #Temp_ChangeItems
		FROM OPENXML (@iDoc, '/Root/Item')
			WITH (
					F_OldPosition INT,
					F_NewPosition INT )
	
	CREATE TABLE #Temp_ChangePositions (
									F_MatchID				INT,
									F_CompetitionPosition	INT,
									F_OldPosition	INT,
									F_NewPosition	INT,
								)
		
	INSERT INTO #Temp_ChangePositions (F_MatchID, F_CompetitionPosition, F_OldPosition, F_NewPosition)
		SELECT C.F_MatchID, C.F_CompetitionPosition, B.F_OldPosition, B.F_NewPosition  FROM #Temp_Matches AS A CROSS JOIN #Temp_ChangeItems AS B INNER JOIN TS_Match_Result AS C
			ON A.F_MatchID = C.F_MatchID AND B.F_OldPosition = C.F_CompetitionPositionDes1

	UPDATE B SET B.F_CompetitionPositionDes1 = A.F_NewPosition FROM #Temp_ChangePositions AS A INNER JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID AND A.F_CompetitionPosition = B.F_CompetitionPosition
	
	SET @Result = 1
	RETURN
	
Set NOCOUNT OFF
End	

GO



--EXEC [Proc_BatchUpdatePosition] 58,84,1694,0,0,N'<Root>
--  <Item F_OldPosition="1" F_NewPosition="2" />
--  <Item F_OldPosition="2" F_NewPosition="1" />
--  <Item F_OldPosition="3" F_NewPosition="4" />
--  <Item F_OldPosition="5" F_NewPosition="4" />
--</Root>',0
