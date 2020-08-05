IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_ApplyLastActionResult]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_ApplyLastActionResult]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_ApplyLastActionResult]
----功		  能：将技术统计的最后一项的成绩应用到比赛成绩MatchSplit中去！
----作		  者：郑金勇 
----日		  期: 2010-10-07
----修 改 记  录： 
/*
                  李燕    2011-2-12     增加抢七小比分的存储
                  李燕    2011-2-16     修改当有Action删除时候，删除相应的Game
                  李燕    2011-7-4      增加@SubMatchCode，为了团体赛
*/

CREATE PROCEDURE [dbo].[Proc_TE_ApplyLastActionResult] (	
	@MatchID					INT,
	@SubMatchCode               INT,  --- -1,个人赛
	@ActionType					INT
)	
AS
BEGIN
SET NOCOUNT ON

	CREATE TABLE #Temp_Results(	F_Level				INT, --0表示Match，1表示Set，2表示Game
								F_Status			INT,
								F_SetNum			INT,
								F_GameNum			INT,
								F_Position			INT,
								F_Server			INT,
								F_Points			INT,
								F_Rank				INT,
								F_TBPoint           INT)
	DECLARE @SubMatchID INT
	SELECT @SubMatchID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3 
										
	DECLARE @XmlDoc AS XML
	SELECT TOP 1 @XmlDoc = F_ActionXMLComment FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_ActionTypeID = @ActionType AND (F_MatchSplitID = 0 OR F_MatchSplitID = @SubMatchID)  
		ORDER BY F_ActionOrder DESC
	
	IF @XmlDoc IS NULL
	BEGIN
	
		 DELETE FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID IN
		 (
			SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType = 2
		 )
		 
		 DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType = 2
		 
		 RETURN
	END
	
	DECLARE @iDoc AS INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
	
		--SELECT @iDoc
				
		--总比分
		INSERT INTO #Temp_Results (F_Level, F_Status, F_Position, F_Server, F_Points, F_Rank)
			SELECT 0 AS F_Level, MatchStatus AS F_Status, Position AS F_Position, 0 AS F_Server, [Sets] AS F_Points, [Rank] AS F_Rank FROM OPENXML (@iDoc, '/MatchResult/Competitor',1)
				WITH (
						MatchStatus		NVARCHAR(50) '../@MatchStatus',
						Position		INT,
						[Sets]			INT,
						[Rank]			INT
					)
		--某一盘比分
		
		INSERT INTO #Temp_Results (F_Level, F_Status, F_SetNum, F_Position, F_Server, F_Points, F_Rank, F_TBPoint)
			SELECT 1 AS F_Level, SetSatus AS F_Status, SetNum AS F_SetNum, Position AS F_Position, 0 AS F_Server, Games AS F_Points, [Rank] AS F_Rank, TBPoint AS F_TBPoint FROM OPENXML (@iDoc, '/MatchResult/Set/Competitor',1)
				WITH (
						SetNum			INT '../@SetNum',
						SetSatus		INT '../@SetSatus',
						Position		INT,
						Games			INT,
						[Rank]			INT,
						TBPoint         INT
					)
				
		--某一局比分
		INSERT INTO #Temp_Results (F_Level, F_Status, F_SetNum, F_GameNum, F_Position, F_Server, F_Points, F_Rank)
			SELECT 2 AS F_Level, GameStatus AS F_Status, SetNum AS F_SetNum, GameNum AS F_GameNum, Position AS F_Position, [Server] AS F_Server, Score AS F_Points, [Rank] AS F_Rank   FROM OPENXML (@iDoc, '/MatchResult/Set/Game/Competitor',1)
				WITH (
					SetNum		INT '../../@SetNum',
					GameNum		INT '../@GameNum',
					GameStatus	INT '../@GameStatus',
					Position	INT,
					Score		INT,
					[Rank]		INT,
					[Server]	INT
				)
		
		
	EXEC sp_xml_removedocument @iDoc
	
	----个人赛
	IF(@SubMatchCode = -1)
	BEGIN
			--SELECT * FROM #Temp_Results ORDER BY F_Level, F_SetNum, F_GameNum
			UPDATE A SET A.F_Points = B.F_Points, A.F_Rank = B.F_Rank FROM TS_Match_Result AS A LEFT JOIN #Temp_Results AS B ON A.F_CompetitionPosition = B.F_Position
				WHERE A.F_MatchID = @MatchID AND B.F_Level = 0
			
			UPDATE A SET A.F_Points = C.F_Points, A.F_Rank = C.F_Rank, A.F_SplitPoints = (CASE WHEN C.F_TBPoint = -1 THEN NULL ELSE C.F_TBPoint END) FROM TS_Match_Split_Result AS A LEFT JOIN TS_Match_Split_Info AS B
				ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_SetNum AND A.F_CompetitionPosition = C.F_Position
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitType = 1 AND C.F_Level = 1
					
			UPDATE A SET A.F_MatchSplitStatusID = B.F_Status FROM TS_Match_Split_Info AS A LEFT JOIN #Temp_Results AS B ON A.F_MatchSplitCode = B.F_SetNum
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND B.F_Level = 1
			
			
			--SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType = 2 AND F_MatchSplitCode NOT IN ()
			--删除之前存在的局比分
			DELETE FROM TS_Match_Split_Result 
			WHERE F_MatchID = @MatchID AND F_MatchSplitID IN 
			( SELECT TMSI.F_MatchSplitID FROM  TS_Match_Split_Info AS TMSI
				 WHERE TMSI.F_MatchID = @MatchID AND TMSI.F_MatchSplitType = 2 AND TMSI.F_MatchSplitID NOT IN
					(
						SELECT B.F_MatchSplitID FROM TS_Match_Split_Info AS B 
									  LEFT JOIN TS_Match_Split_Info AS D ON B.F_MatchID = D.F_MatchID AND B.F_FatherMatchSplitID = D.F_MatchSplitID 
									  LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_GameNum AND D.F_MatchSplitCode = C.F_SetNum
							WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_Level = 2
					)
			)
			
			DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID  AND F_MatchSplitType = 2 AND F_MatchSplitID NOT IN
			(
				SELECT B.F_MatchSplitID FROM TS_Match_Split_Info AS B 
									  LEFT JOIN TS_Match_Split_Info AS D ON B.F_MatchID = D.F_MatchID AND B.F_FatherMatchSplitID = D.F_MatchSplitID 
									  LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_GameNum AND D.F_MatchSplitCode = C.F_SetNum
					WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_Level = 2 
			)
			
			UPDATE A SET A.F_Points = C.F_Points, A.F_Rank = C.F_Rank, A.F_Service = C.F_Server 
				 FROM TS_Match_Split_Result AS A 
				  LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
				  LEFT JOIN TS_Match_Split_Info AS D ON B.F_MatchID = D.F_MatchID AND B.F_FatherMatchSplitID = D.F_MatchSplitID 
				  LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_GameNum AND D.F_MatchSplitCode = C.F_SetNum AND A.F_CompetitionPosition = C.F_Position
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_Level = 2
					
			UPDATE A SET A.F_MatchSplitStatusID = B.F_Status FROM TS_Match_Split_Info AS A 
						  LEFT JOIN TS_Match_Split_Info AS C ON A.F_MatchID = C.F_MatchID AND A.F_FatherMatchSplitID = C.F_MatchSplitID 
						  LEFT JOIN #Temp_Results AS B ON A.F_MatchSplitCode = B.F_GameNum AND C.F_MatchSplitCode = B.F_SetNum
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 2 AND B.F_Level = 2
     END
	----团体赛
	ELSE
	BEGIN
			--SELECT * FROM #Temp_Results ORDER BY F_Level, F_SetNum, F_GameNum
			
			UPDATE A SET A.F_Points = B.F_Points, A.F_Rank = B.F_Rank 
			    FROM TS_Match_Split_Result AS A LEFT JOIN #Temp_Results AS B ON A.F_CompetitionPosition = B.F_Position
				WHERE A.F_MatchID = @MatchID AND F_MatchSplitID = @SubMatchID AND B.F_Level = 0
			
			UPDATE A SET A.F_Points = C.F_Points, A.F_Rank = C.F_Rank, A.F_SplitPoints = (CASE WHEN C.F_TBPoint = -1 THEN NULL ELSE C.F_TBPoint END) 
			   FROM TS_Match_Split_Result AS A 
			        LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
			        LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_SetNum AND A.F_CompetitionPosition = C.F_Position
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitType = 1 AND B.F_FatherMatchSplitID = @SubMatchID AND C.F_Level = 1
					
			UPDATE A SET A.F_MatchSplitStatusID = B.F_Status 
			    FROM TS_Match_Split_Info AS A LEFT JOIN #Temp_Results AS B ON A.F_MatchSplitCode = B.F_SetNum
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 1 AND A.F_FatherMatchSplitID = @SubMatchID AND B.F_Level = 1
			
			
			--SELECT * FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType = 2 AND F_MatchSplitCode NOT IN ()
			--删除之前存在的局比分
			DELETE FROM TS_Match_Split_Result 
			WHERE F_MatchID = @MatchID AND F_MatchSplitID IN 
			( SELECT TMSI.F_MatchSplitID FROM  TS_Match_Split_Info AS TMSI
				 WHERE TMSI.F_MatchID = @MatchID AND TMSI.F_MatchSplitType = 2 AND TMSI.F_MatchSplitID NOT IN
					(
						SELECT B.F_MatchSplitID FROM TS_Match_Split_Info AS B 
									  LEFT JOIN TS_Match_Split_Info AS D ON B.F_MatchID = D.F_MatchID AND B.F_FatherMatchSplitID = D.F_MatchSplitID 
									  LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_GameNum AND D.F_MatchSplitCode = C.F_SetNum
							WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_Level = 2 AND D.F_FatherMatchSplitID = @SubMatchID
					)
			)
			
			DELETE FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID  AND F_MatchSplitType = 2 AND F_MatchSplitID NOT IN
			(
				SELECT B.F_MatchSplitID FROM TS_Match_Split_Info AS B 
									  LEFT JOIN TS_Match_Split_Info AS D ON B.F_MatchID = D.F_MatchID AND B.F_FatherMatchSplitID = D.F_MatchSplitID 
									  LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_GameNum AND D.F_MatchSplitCode = C.F_SetNum
					WHERE B.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_Level = 2 AND D.F_FatherMatchSplitID = @SubMatchID
			)
			
			UPDATE A SET A.F_Points = C.F_Points, A.F_Rank = C.F_Rank, A.F_Service = C.F_Server 
				 FROM TS_Match_Split_Result AS A 
				  LEFT JOIN TS_Match_Split_Info AS B ON A.F_MatchID = B.F_MatchID AND A.F_MatchSplitID = B.F_MatchSplitID 
				  LEFT JOIN TS_Match_Split_Info AS D ON B.F_MatchID = D.F_MatchID AND B.F_FatherMatchSplitID = D.F_MatchSplitID 
				  LEFT JOIN #Temp_Results AS C ON B.F_MatchSplitCode = C.F_GameNum AND D.F_MatchSplitCode = C.F_SetNum AND A.F_CompetitionPosition = C.F_Position
					WHERE A.F_MatchID = @MatchID AND B.F_MatchSplitType = 2 AND C.F_Level = 2 AND D.F_FatherMatchSplitID = @SubMatchID
					
			UPDATE A SET A.F_MatchSplitStatusID = B.F_Status FROM TS_Match_Split_Info AS A 
						  LEFT JOIN TS_Match_Split_Info AS C ON A.F_MatchID = C.F_MatchID AND A.F_FatherMatchSplitID = C.F_MatchSplitID 
						  LEFT JOIN #Temp_Results AS B ON A.F_MatchSplitCode = B.F_GameNum AND C.F_MatchSplitCode = B.F_SetNum
				WHERE A.F_MatchID = @MatchID AND A.F_MatchSplitType = 2 AND B.F_Level = 2 AND C.F_FatherMatchSplitID = @SubMatchID
     END
SET NOCOUNT OFF
END






GO

--EXEC Proc_TE_ApplyLastActionResult 2, -2

