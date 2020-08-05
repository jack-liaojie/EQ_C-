IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetMatchDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetMatchDes]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--名    称：[Proc_GetMatchDes]
--描    述：得到一个Phase或Match下所有信息的描述
--参数说明： 
--说    明：
--创 建 人：张翠霞
--日    期：2009年04月09日

CREATE PROCEDURE [dbo].[Proc_GetMatchDes](
				 @ID			INT,--对应类型的ID，与Type相关
                 @Type          INT --注释: 0表示Phase, 1表示Match
)
As
Begin
SET NOCOUNT ON 

	CREATE TABLE #table_Tree (
                                    F_PhaseID            INT,
                                    F_MatchID            INT,
                                    F_MatchName          NVARCHAR(100),
                                    F_HomeRegisterID     INT,
                                    F_AwayRegisterID     INT,
                                    F_MatchStatusID      INT,
                                    F_VenueID            INT,
                                    F_CourtID            INT,
                                    F_WeatherID          INT,
                                    F_SessionID          INT,
                                    F_MatchDate          datetime,
                                    F_StartTime          datetime,
                                    F_EndTime            datetime,
                                    F_NodeType			 INT,--注释: 0表示Phase，1表示Match
									F_NodeLevel			 INT,
                                    F_Order              INT,
                                    F_NodeKey			 NVARCHAR(100),
									F_FatherNodeKey		 NVARCHAR(100),
								 )

      DECLARE @NodeLevel INT
	  SET @NodeLevel = 0

      IF @Type = 0

	  BEGIN

		  INSERT INTO #table_Tree(F_PhaseID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey)
			SELECT F_PhaseID, 0 as F_NodeType, 0 as F_NodeLevel, F_Order, 'P'+CAST( F_PhaseID AS NVARCHAR(50)) as F_NodeKey
			  FROM TS_Phase WHERE F_PhaseID = @ID 

		  WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
		  BEGIN
			SET @NodeLevel = @NodeLevel + 1
			UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0
		
			INSERT INTO #table_Tree(F_PhaseID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey)
			  SELECT A.F_PhaseID, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
				FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
		  END
	
	--添加Match节点
		INSERT INTO #table_Tree(F_PhaseID, F_MatchID, F_MatchName, F_HomeRegisterID, F_AwayRegisterID, F_MatchStatusID, F_VenueID, F_CourtID, F_WeatherID, F_SessionID, F_MatchDate, F_StartTime, F_EndTime, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey)
		  SELECT A.F_PhaseID, A.F_MatchID, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_MatchName, (SELECT F_RegisterID FROM TS_Match_Result AS C WHERE C.F_CompetitionPosition = 1 AND C.F_MatchID = A.F_MatchID) as F_HomeRegisterID, (SELECT F_RegisterID FROM TS_Match_Result AS C WHERE C.F_CompetitionPosition = 2 AND C.F_MatchID = A.F_MatchID) as F_AwayRegisterID, A.F_MatchStatusID, A.F_VenueID, A.F_CourtID, A.F_WeatherID, A.F_SessionID, A.F_MatchDate, A.F_StartTime, A.F_EndTime, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey
			FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON B.F_PhaseID = A.F_PhaseID WHERE B.F_NodeType = 0
	
      END

      IF @Type = 1

	  BEGIN

      --添加Match节点
		INSERT INTO #table_Tree(F_PhaseID, F_MatchID, F_MatchName, F_HomeRegisterID, F_AwayRegisterID, F_MatchStatusID, F_VenueID, F_CourtID, F_WeatherID, F_SessionID, F_MatchDate, F_StartTime, F_EndTime, F_NodeType, F_NodeLevel, F_Order, F_NodeKey)
		  SELECT A.F_PhaseID, A.F_MatchID, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_MatchName, (SELECT F_RegisterID FROM TS_Match_Result AS C WHERE C.F_CompetitionPosition = 1 AND C.F_MatchID = A.F_MatchID) as F_HomeRegisterID, (SELECT F_RegisterID FROM TS_Match_Result AS C WHERE C.F_CompetitionPosition = 2 AND C.F_MatchID = A.F_MatchID) as F_AwayRegisterID, A.F_MatchStatusID, A.F_VenueID, A.F_CourtID, A.F_WeatherID, A.F_SessionID, A.F_MatchDate, A.F_StartTime, A.F_EndTime, 1 as F_NodeType, 1 as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey
			FROM TS_Match AS A WHERE A.F_MatchID = @ID
      END

	SELECT F_MatchName, F_HomeRegisterID, F_AwayRegisterID, F_MatchStatusID, F_VenueID, F_CourtID, F_WeatherID, F_SessionID, F_MatchDate, F_StartTime, F_EndTime FROM #table_Tree WHERE F_NodeType = 1 ORDER BY F_MatchID
	

Set NOCOUNT OFF
End	

	
set QUOTED_IDENTIFIER OFF
set ANSI_NULLS OFF

GO