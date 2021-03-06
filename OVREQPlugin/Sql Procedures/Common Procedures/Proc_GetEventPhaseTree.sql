IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetEventPhaseTree]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetEventPhaseTree]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--名    称：[Proc_GetEventPhaseTree]
--描    述：展开一个赛事项目下所有Phase
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月07日

CREATE PROCEDURE [dbo].[Proc_GetEventPhaseTree](
				 @EventID			INT
)
As
Begin
SET NOCOUNT ON 

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
		SELECT F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_Order as F_PhaseOrder, 0 as F_NodeType,0 as F_NodeLevel, 'P'+CAST( F_PhaseID AS NVARCHAR(50)) as F_NodeKey, 'E'+CAST( @EventID AS NVARCHAR(50)) as F_FatherNodeKey
			FROM TS_Phase WHERE F_EventID = @EventID AND F_FatherPhaseID = 0
	
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
	
	--select * from TS_Match
	SELECT * FROM #table_Tree ORDER BY F_NodeLevel
	

Set NOCOUNT OFF
End			

GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS OFF
GO



