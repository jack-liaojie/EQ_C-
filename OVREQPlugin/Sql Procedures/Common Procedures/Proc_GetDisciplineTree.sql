IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetDisciplineTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetDisciplineTree]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--名    称：[Proc_GetDisciplineTree]
--描    述：展开一个所有Discipline下信息
--参数说明： 
--说    明：
--创 建 人：余远华
--日    期：2009年05月18日

CREATE PROCEDURE [dbo].[Proc_GetDisciplineTree](
				 @DisciplineID			INT
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
									F_PhaseType			INT,
									F_MatchID			INT,
									F_ParticipantID		INT,
									F_ParticipantType	INT,--注释：值为 F_RegTypeID * 3 + F_SexCode
									F_NodeType			INT,--注释: -3表示Sport，-2表示Discipline，-1表示Event，0表示Phase，1表示Match, 2表示Participant
									F_NodeLevel			INT,
									F_Order             INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100),
									F_NodeName			NVARCHAR(100)
								 )

	  DECLARE @LanguageCode AS CHAR(3)

	  SELECT TOP 1 @LanguageCode = F_LanguageCode FROM TC_Language WHERE F_Active = 1 

	  IF (@LanguageCode IS NULL)
	  BEGIN
		  SET @LanguageCode = 'CHN'
	  END

      DECLARE @NodeLevel INT
	  SET @NodeLevel = 0

	  --Get Discipline
	  SET @NodeLevel = @NodeLevel + 1
	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
		SELECT A.F_SportID, A.F_DisciplineID, -2 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'D'+CAST( A.F_DisciplineID AS NVARCHAR(50)) as F_NodeKey, B.F_DisciplineLongName
		  FROM TS_Discipline AS A LEFT JOIN TS_Discipline_Des AS B ON A.F_DisciplineID = B.F_DisciplineID 
			WHERE A.F_DisciplineID = @DisciplineID AND B.F_LanguageCode = @LanguageCode

	  --Get Events
	  SET @NodeLevel = @NodeLevel + 1
	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
		SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, -1 as F_NodeType, @NodeLevel as F_NodeLevel, A.F_Order, 'E'+CAST( A.F_EventID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_EventLongName
		  FROM TS_Event AS A RIGHT JOIN #table_Tree AS B ON A.F_DisciplineID = B.F_DisciplineID LEFT JOIN TS_Event_Des AS C ON C.F_EventID = A.F_EventID
			WHERE B.F_NodeLevel = @NodeLevel - 1 AND C.F_LanguageCode = @LanguageCode
 
	  --Get Root Phases
	  INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseType, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
		SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseType, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
		  FROM TS_Phase AS A RIGHT JOIN #table_Tree AS B ON A.F_EventID = B.F_EventID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID
			WHERE A.F_FatherPhaseID = 0 AND B.F_NodeLevel = @NodeLevel AND C.F_LanguageCode = @LanguageCode

	  --Get Branch Phases
      WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	  BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
	
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseType, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
		  SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseType, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
			FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN (SELECT * FROM TS_Phase_Des WHERE F_LanguageCode = @LanguageCode) AS C ON C.F_PhaseID = A.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
	  END


	--添加Match节点
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
		  SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
			FROM (SELECT * FROM #table_Tree WHERE F_NodeType = 0) AS B INNER JOIN TS_Match AS A ON A.F_PhaseID = B.F_PhaseID
		
		UPDATE #table_Tree SET F_NodeName =  (CASE WHEN B.F_MatchCode IS NULL THEN '' ELSE '[' + B.F_MatchCode + '] ' END )+ C.F_MatchLongName FROM #table_Tree AS A LEFT JOIN TS_Match AS B ON A.F_MatchID = B.F_MatchID
			 LEFT JOIN TS_Match_Des AS C ON A.F_MatchID = C.F_MatchID AND C.F_LanguageCode = @LanguageCode
				WHERE A.F_NodeType = 1

	--添加Participant节点
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_MatchID, F_ParticipantID, F_ParticipantType, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			  SELECT A.F_SportID, A.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_MatchID, B.F_RegisterID, (C.F_RegTypeID * 3 + C.F_SexCode) as F_ParticipantType, 2 as F_NodeType, (A.F_NodeLevel + 1) as F_NodeLevel, B.F_CompetitionPosition, 'M'+CAST( A.F_MatchID AS NVARCHAR(50))+'R'+CAST( B.F_RegisterID AS NVARCHAR(50)) as F_NodeKey, A.F_NodeKey as F_FatherNodeKey, D.F_LongName as F_NodeName
				FROM  #table_Tree AS A LEFT JOIN TS_Match_Result AS B ON A.F_MatchID = B.F_MatchID LEFT JOIN TR_Register AS C ON B.F_RegisterID = C.F_RegisterID 
					LEFT JOIN TR_Register_Des AS D ON B.F_RegisterID = D.F_RegisterID
						WHERE A.F_NodeType = 1 AND B.F_RegisterID IS NOT NULL AND D.F_LanguageCode = @LanguageCode

		DELETE FROM #table_Tree WHERE F_ParticipantID = -1 AND F_NodeType = 2

		SELECT * FROM #table_Tree ORDER BY F_NodeLevel, F_NodeType, F_Order
	

Set NOCOUNT OFF
End	

