IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateMatchSplitResults]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdateMatchSplitResults]

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO











--名    称：[Proc_UpdateMatchSplitResults]
--描    述：展开一个Match下所有的Split的结果，同时更新Result
--参数说明： 
--说    明：
--创 建 人：郑金勇
--日    期：2009年04月22日

CREATE PROCEDURE [dbo].[Proc_UpdateMatchSplitResults](
				 @MatchID			INT
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #table_Tree (
									F_MatchID				INT,
									F_MatchSplitID			INT,
									F_FatherMatchSplitID	INT,
									F_Order					INT,
									F_MatchSplitStatusID	INT,
									F_NodeType				INT,--注释: 
									F_NodeLevel				INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100),
									F_NodeName			NVARCHAR(100)
								 )

	DECLARE @NodeLevel INT
	SET @NodeLevel = 0

	INSERT INTO #table_Tree(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitStatusID, F_NodeType, F_NodeLevel, F_NodeKey, F_FatherNodeKey, F_NodeName)
		SELECT F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitStatusID, 0 AS F_NodeType, 0 AS F_NodeLevel, 'S'+CAST( F_MatchSplitID AS NVARCHAR(50)) as F_NodeKey, 'M'+CAST( @MatchID AS NVARCHAR(50)) AS F_FatherNodeKey, 'Match Split'+CAST( F_MatchSplitID AS NVARCHAR(50)) AS  F_NodeName
			FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0

	WHILE EXISTS ( SELECT F_MatchID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
	BEGIN
		SET @NodeLevel = @NodeLevel + 1
		UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
		
		INSERT INTO #table_Tree(F_MatchID, F_MatchSplitID, F_FatherMatchSplitID, F_Order, F_MatchSplitStatusID, F_NodeType, F_NodeLevel, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT A.F_MatchID, A.F_MatchSplitID, A.F_FatherMatchSplitID, A.F_Order, A.F_MatchSplitStatusID, 0 AS F_NodeType, 0 AS F_NodeLevel, 'S'+CAST( A.F_MatchSplitID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey AS F_FatherNodeKey, 'Match Split'+CAST( A.F_MatchSplitID AS NVARCHAR(50)) AS  F_NodeName 
				FROM TS_Match_Split_Info AS A INNER JOIN #table_Tree AS B ON A.F_MatchID = B.F_MatchID AND A.F_FatherMatchSplitID = B.F_MatchSplitID AND B.F_NodeLevel = @NodeLevel
	END

	SELECT * FROM #table_Tree ORDER BY F_NodeLevel, F_Order
	

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO

--select * from TS_Match_Split_Result where F_MatchID = 412
--EXEC [Proc_UpdateMatchSplitResults] 412