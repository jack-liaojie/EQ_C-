IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetScheduleTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetScheduleTree]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









--名    称：[Proc_GetScheduleTree]
--描    述：展开一个所有Sport下信息
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009年04月08日

CREATE PROCEDURE [dbo].[Proc_GetScheduleTree](
				 @ID			INT,--对应类型的ID，与Type相关
                 @Type          INT,--注释: -5表示是激活的Sport，激活的Discipline， -4表示所有Sport, -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase
				 @Option		INT = 0,--辅助参数默认为0，1表示显示Event、Phase、Match的应用模型名称
				 @Option1		INT = 0,--辅助参数1默认为0，1表示显示Event、Phase、Match节点要显示节点的当前状态
                 @LanguageCode  char(3)
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #table_Tree (
                                    F_SportID           INT,
                                    F_DisciplineID      INT,
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_PhaseCode			NVARCHAR(10),
									F_PhaseType			INT,
									F_PhaseSize			INT,
									F_NodeLongName		NVARCHAR(100),
									F_NodeShortName	    NVARCHAR(50),
									F_PhaseNodeType		INT,
									F_MatchID			INT,
									F_MatchNum			INT,
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match
									F_NodeLevel			INT,
                                    F_Order             INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100),
									F_NodeName			NVARCHAR(200),
									F_CompetitorNum		INT,
									F_UsingModelID		INT,
									F_UsingModelName	NVARCHAR(100),
									F_NodeStatusID		INT,
									F_NodeStatusDes		NVARCHAR(100)
								 )

      DECLARE @NodeLevel INT
	  SET @NodeLevel = 0


--	 IF @Type = -5
--	 BEGIN
--		DECLARE @SportID AS INT
--		SELECT TOP 1 @SportID =  (F_SportID) FROM TS_Sport WHERE F_Active = 1 
--		SELECT TOP 1 @ID = (F_DisciplineID) FROM TS_Discipline WHERE F_Active = 1 AND F_SportID = @SportID
--		SET @Type = -2
--	 END


      IF @Type = -4 OR @Type = -5
	  BEGIN

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT A.F_SportID, B.F_SportLongName, B.F_SportShortName, -3 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'S'+CAST( A.F_SportID AS NVARCHAR(50)) as F_NodeKey, B.F_SportLongName
			  FROM TS_Sport AS A LEFT JOIN TS_Sport_Des AS B ON A.F_SportID = B.F_SportID AND B.F_LanguageCode = @LanguageCode

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, A.F_DisciplineID, C.F_DisciplineLongName, C.F_DisciplineShortName, -2 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'D'+CAST( A.F_DisciplineID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_DisciplineLongName
			  FROM TS_Discipline AS A LEFT JOIN #table_Tree AS B ON A.F_SportID = B.F_SportID LEFT JOIN TS_Discipline_Des AS C ON C.F_DisciplineID = A.F_DisciplineID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel - 1

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, C.F_EventLongName, C.F_EventShortName, -1 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'E'+CAST( A.F_EventID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_EventLongName
			  FROM TS_Event AS A LEFT JOIN #table_Tree AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Event_Des AS C ON C.F_EventID = A.F_EventID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel - 1

		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseType, F_PhaseSize, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_PhaseType, A.F_PhaseSize, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order as F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel AND A.F_FatherPhaseID = 0
		  
      END
      
      IF @Type = -3
	  BEGIN

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT A.F_SportID, B.F_SportLongName, B.F_SportShortName, -3 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'S'+CAST( A.F_SportID AS NVARCHAR(50)) as F_NodeKey, B.F_SportLongName
			  FROM TS_Sport AS A LEFT JOIN TS_Sport_Des AS B ON A.F_SportID = B.F_SportID AND B.F_LanguageCode = @LanguageCode WHERE A.F_SportID = @ID

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, A.F_DisciplineID, C.F_DisciplineLongName, C.F_DisciplineShortName, -2 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'D'+CAST( A.F_DisciplineID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_DisciplineLongName
			  FROM TS_Discipline AS A LEFT JOIN #table_Tree AS B ON A.F_SportID = B.F_SportID LEFT JOIN TS_Discipline_Des AS C ON C.F_DisciplineID = A.F_DisciplineID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel - 1

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, C.F_EventLongName, C.F_EventShortName, -1 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'E'+CAST( A.F_EventID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_EventLongName
			  FROM TS_Event AS A LEFT JOIN #table_Tree AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Event_Des AS C ON C.F_EventID = A.F_EventID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel - 1

		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseType, F_PhaseSize, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_PhaseType, A.F_PhaseSize, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order as F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel AND A.F_FatherPhaseID = 0
		  
      END
 
      IF @Type = -2
	  BEGIN

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT A.F_SportID, A.F_DisciplineID, B.F_DisciplineLongName, B.F_DisciplineShortName, -2 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'D'+CAST( A.F_DisciplineID AS NVARCHAR(50)) as F_NodeKey, B.F_DisciplineLongName
			  FROM TS_Discipline AS A LEFT JOIN TS_Discipline_Des AS B ON A.F_DisciplineID = B.F_DisciplineID  AND B.F_LanguageCode = @LanguageCode WHERE A.F_DisciplineID = @ID

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, C.F_EventLongName, C.F_EventShortName, -1 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'E'+CAST( A.F_EventID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_EventLongName
			  FROM TS_Event AS A LEFT JOIN #table_Tree AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Event_Des AS C ON C.F_EventID = A.F_EventID  AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel - 1

	  
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseType, F_PhaseSize, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_PhaseType, A.F_PhaseSize,C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel AND A.F_FatherPhaseID = 0

	  END

      IF @Type = -1
	  BEGIN

		  SET @NodeLevel = @NodeLevel + 1
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT C.F_SportID, A.F_DisciplineID, A.F_EventID, B.F_EventLongName, B.F_EventShortName, -1 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'E'+CAST( A.F_EventID AS NVARCHAR(50)) as F_NodeKey, B.F_EventShortName
			  FROM TS_Event AS A LEFT JOIN TS_Event_Des AS B ON A.F_EventID = B.F_EventID AND B.F_LanguageCode = @LanguageCode LEFT JOIN TS_Discipline AS C ON A.F_DisciplineID = C.F_DisciplineID WHERE A.F_EventID = @ID
		  
		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseType, F_PhaseSize, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_PhaseType, A.F_PhaseSize, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel AND A.F_FatherPhaseID = 0

	  END

      IF @Type = 0

	  BEGIN

		  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseType, F_PhaseSize, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_PhaseType, A.F_PhaseSize, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @ID

	  END

      WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	  BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
	
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_PhaseType, F_PhaseSize, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
		  SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, A.F_PhaseType, A.F_PhaseSize, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
			FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeLevel = @NodeLevel
	  END
	

	--添加Match节点
	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_MatchNum, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, A.F_MatchNum, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_MatchLongName as F_NodeName
				FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID AND C.F_LanguageCode = @LanguageCode WHERE B.F_NodeType = 0
		

	--以下操作，主要是为了在PhaseTree上展现各个项目的报项人员数目。
	UPDATE #table_Tree SET F_CompetitorNum = B.F_CompetitorNum FROM #table_Tree AS A LEFT JOIN 
		(SELECT C.F_EventID, COUNT(D.F_RegisterID) AS F_CompetitorNum FROM TS_Event AS C LEFT JOIN TR_Inscription AS D ON C.F_EventID = D.F_EventID 
			LEFT JOIN TR_Register AS E ON D.F_RegisterID = E.F_RegisterID WHERE E.F_RegTypeID IN (1,2,3) GROUP BY C.F_EventID ) AS B 
			ON A.F_EventID = B.F_EventID 
				WHERE A.F_NodeType = -1


	

	IF @Option1 = 1
	BEGIN
		UPDATE #table_Tree SET F_NodeStatusID = B.F_EventStatusID FROM #table_Tree AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_NodeType = -1
		UPDATE #table_Tree SET F_NodeStatusID = B.F_PhaseStatusID FROM #table_Tree AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_NodeType = 0
		UPDATE #table_Tree SET F_NodeStatusID = B.F_MatchStatusID FROM #table_Tree AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE A.F_NodeType = 1

		UPDATE #table_Tree SET F_NodeStatusID = 0 WHERE F_NodeStatusID IS NULL

		UPDATE #table_Tree SET F_NodeStatusDes = B.F_StatusLongName FROM #table_Tree AS A LEFT JOIN TC_Status_Des AS B ON A.F_NodeStatusID = B.F_StatusID WHERE B.F_LanguageCode = @LanguageCode

		UPDATE #table_Tree SET F_NodeName = F_NodeName  + '  <' + F_NodeStatusDes + '>' WHERE F_NodeStatusDes IS NOT NULL AND F_NodeType IN (-1,0,1)
	END

	IF @Option = 1
	BEGIN
		UPDATE #table_Tree SET F_UsingModelID = B.F_UsingModelID FROM #table_Tree AS A LEFT JOIN TS_Event AS B ON A.F_EventID = B.F_EventID WHERE A.F_NodeType = -1
		UPDATE #table_Tree SET F_UsingModelID = B.F_UsingModelID FROM #table_Tree AS A LEFT JOIN TS_Phase AS B ON A.F_PhaseID = B.F_PhaseID WHERE A.F_NodeType = 0
		UPDATE #table_Tree SET F_UsingModelID = B.F_UsingModelID FROM #table_Tree AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID WHERE A.F_NodeType = 1

		UPDATE #table_Tree SET F_UsingModelName = B.F_ModelName FROM #table_Tree AS A LEFT JOIN TM_Model AS B ON A.F_UsingModelID = B.F_ModelID WHERE A.F_NodeType = -1
		UPDATE #table_Tree SET F_UsingModelName = B.F_PhaseModelName FROM #table_Tree AS A LEFT JOIN TS_Phase_Model AS B ON A.F_PhaseID = B.F_PhaseID AND A.F_UsingModelID = B.F_PhaseModelID WHERE A.F_NodeType = 0
		UPDATE #table_Tree SET F_UsingModelName = B.F_MatchModelName FROM #table_Tree AS A LEFT JOIN TS_Match_Model AS B ON A.F_MatchID = B.F_MatchID AND A.F_UsingModelID = B.F_MatchModelID WHERE A.F_NodeType = 1

		UPDATE #table_Tree SET F_NodeName = F_NodeName  + '  (' + F_UsingModelName + ')' WHERE F_UsingModelName IS NOT NULL
	END
	UPDATE #table_Tree SET F_CompetitorNum = 0 WHERE F_CompetitorNum IS NULL 
	UPDATE #table_Tree SET F_NodeName = F_NodeName  + '  [' + CAST(F_CompetitorNum AS NVARCHAR(10)) + ']' WHERE F_NodeType = -1 

	UPDATE #table_Tree SET F_DisciplineID = -1 WHERE F_DisciplineID IS NULL
	UPDATE #table_Tree SET F_EventID = -1 WHERE F_EventID IS NULL
	UPDATE #table_Tree SET F_PhaseID = -1 WHERE F_PhaseID IS NULL
	UPDATE #table_Tree SET F_MatchID = -1 WHERE F_MatchID IS NULL
	SELECT * FROM #table_Tree ORDER BY F_NodeLevel, F_NodeType, F_Order
	

Set NOCOUNT OFF
End	
GO
	
set QUOTED_IDENTIFIER OFF
GO
set ANSI_NULLS OFF

GO

--EXEC Proc_GetScheduleTree 0, -5, 1, 1, 'CHN'
--EXEC Proc_GetScheduleTree 0, -4, 1, 'CHN'