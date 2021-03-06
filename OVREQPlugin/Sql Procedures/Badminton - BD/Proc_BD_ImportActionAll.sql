IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_ImportActionAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_ImportActionAll]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_BD_ImportActionAll]
----功		  能：从XML文件导入得分历程
----作		  者：王强
----日		  期: 2011-5-13

CREATE PROCEDURE [dbo].[Proc_BD_ImportActionAll]
	@MatchRsc     NVARCHAR(20),
    @MatchInfoXML	NVARCHAR(MAX),
	@Result 	AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	导入失败，标示没有做任何操作！
					  -- @Result>0; 	导入成功！设置为@MatchID
					  --  -1表示RSC未找到,-2表示MatchSplitID未找到,-4代表xml格式错误
					  --  <0失败
					  
	DECLARE @DisciplineCode NVARCHAR(4)
	DECLARE @EventCode NVARCHAR(4)
	DECLARE @PhaseCode NVARCHAR(4)
	DECLARE @MatchCode NVARCHAR(4)
	SET @DisciplineCode = SUBSTRING( @MatchRsc, 1, 2)
	SET @EventCode = SUBSTRING( @MatchRsc, 4, 3)
	SET @PhaseCode = SUBSTRING( @MatchRsc, 7, 1)
	SET @MatchCode = SUBSTRING( @MatchRsc, 8, 2)
	
	DECLARE @MatchID INT
	
	SELECT @MatchID = D.F_MatchID FROM TS_Discipline AS A
	LEFT JOIN TS_Event AS B ON B.F_DisciplineID = A.F_DisciplineID
	LEFT JOIN TS_Phase AS C ON C.F_EventID = B.F_EventID
	LEFT JOIN TS_Match AS D ON D.F_PhaseID = C.F_PhaseID
	WHERE A.F_DisciplineCode = @DisciplineCode AND B.F_EventCode = @EventCode 
			AND C.F_PhaseCode = @PhaseCode AND D.F_MatchCode = @MatchCode
	
	IF @MatchID IS NULL
	BEGIN
		SET @Result = -1
		RETURN
	END
	
	IF @MatchInfoXML = '' OR @MatchInfoXML IS NULL
	BEGIN
		SET @Result = -3
		RETURN 
	END
	
	CREATE TABLE #TMP_ACTION_LIST
	(
		GroupRank INT,
		SetSplitID INT,
		GameSplitID INT,
		ScoreRegID INT,
		Match_No INT, 
		Game_No INT,
		[Order] INT,
		[Time] NVARCHAR(20),
		Score INT,
		[Type] INT,  
		ScorePlayer NVARCHAR(10),
		GameScoreA INT, 
		GameScoreB INT, 
		MatchScoreA INT, 
		MatchScoreB INT, 
		DuelScoreA INT, 
		DuelScoreB INT,
		[Server] NVARCHAR(10)
	)
	
	CREATE TABLE #TMP_ACTION_LIST2
	(
		GroupRank INT,
		SetSplitID INT,
		GameSplitID INT,
		ScoreRegID INT,
		Match_No INT, 
		Game_No INT,
		[Order] INT,
		[Time] NVARCHAR(20),
		Score INT,
		[Type] INT,  
		ScorePlayer NVARCHAR(10),
		GameScoreA INT, 
		GameScoreB INT, 
		MatchScoreA INT, 
		MatchScoreB INT, 
		DuelScoreA INT, 
		DuelScoreB INT,
		[Server] NVARCHAR(10)
	)
	
	DECLARE @iDoc           AS INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @MatchInfoXML
	
	INSERT INTO #TMP_ACTION_LIST (Match_No, 
		Game_No,
		[Order],
		[Time],
		Score,
		[Type],  
		ScorePlayer,
		GameScoreA, 
		GameScoreB, 
		MatchScoreA, 
		MatchScoreB, 
		DuelScoreA, 
		DuelScoreB,
		[Server])
	SELECT *
	FROM OPENXML (@iDoc, '/MatchInfo/Score',1)
	WITH 
	(
		SubMatch_No INT, --这里和TT有所不同
		Game_No INT,
		[Order] INT,
		[Time] NVARCHAR(20),
		Score INT,
		[Type] INT,  
		ScorePlayer NVARCHAR(10),
		GameScoreA INT, 
		GameScoreB INT, 
		MatchScoreA INT, 
		MatchScoreB INT, 
		DuelScoreA INT, 
		DuelScoreB INT,
		[Server] NVARCHAR(10)
	)
	
	EXEC sp_xml_removedocument @iDoc
	
	IF NOT EXISTS (SELECT * FROM #TMP_ACTION_LIST)
	BEGIN
		SET @Result = -4
		RETURN
	END
	
	DECLARE @MatchType INT
	SELECT  @MatchType = A.F_PlayerRegTypeID
	FROM TS_Event AS A
	LEFT JOIN TS_Phase AS B ON B.F_EventID = A.F_EventID
	LEFT JOIN TS_Match AS C ON C.F_PhaseID = B.F_PhaseID
	WHERE C.F_MatchID = @MatchID
	
	IF @MatchType IN (1,2)
	BEGIN
		UPDATE #TMP_ACTION_LIST SET GameSplitID = F_MatchSplitID, SetSplitID = F_MatchSplitID
		FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = Game_No
	END
	ELSE IF @MatchType = 3
	BEGIN
		UPDATE #TMP_ACTION_LIST SET SetSplitID = A.F_MatchSplitID, GameSplitID = B.F_MatchSplitID  
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = A.F_MatchSplitID 
					AND B.F_FatherMatchSplitID != 0
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = Match_No AND B.F_Order = Game_No
	END

	--更新得分方的ID
	UPDATE #TMP_ACTION_LIST SET ScoreRegID = F_RegisterID
	FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = SetSplitID AND
	F_CompetitionPosition = (CASE WHEN [Type] IN (1,4,6) THEN 1 WHEN [Type] IN (2,3,5) THEN 2 ELSE 1 END)

	--导入分数
	DECLARE @CurMatchNo INT
	DECLARE @CurGameNo INT
	DECLARE @Order INT
	DECLARE @SetSplitID INT
	DECLARE @GameSplitID INT
	SELECT @CurMatchNo = MAX(Match_No) FROM #TMP_ACTION_LIST
	SELECT @CurGameNo = MAX(Game_No) FROM #TMP_ACTION_LIST
	SELECT @Order = MAX([Order]) FROM #TMP_ACTION_LIST WHERE Match_No = @CurMatchNo AND Game_No = @CurGameNo
	
	--大比分
	UPDATE TS_Match_Result SET F_Points =
	(SELECT DuelScoreA FROM #TMP_ACTION_LIST WHERE Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order),
	F_Service = 
	(SELECT CASE [Server] WHEN 'A1' THEN 1 WHEN 'A2' THEN 1 ELSE 0 END
	FROM #TMP_ACTION_LIST WHERE Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order)
	WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
	
	UPDATE TS_Match_Result SET F_Points =
	(SELECT DuelScoreB FROM #TMP_ACTION_LIST WHERE Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order),
	F_Service = 
	(SELECT CASE [Server] WHEN 'B1' THEN 1 WHEN 'B2' THEN 1 ELSE 0 END
	FROM #TMP_ACTION_LIST WHERE Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order)
	WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	
	--获取盘ID或局ID
	IF @MatchType IN (1,2)
	BEGIN
		SELECT @SetSplitID = F_MatchSplitID, @GameSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @CurGameNo
	END
	ELSE IF @MatchType = 3
	BEGIN
		SELECT @GameSplitID = B.F_MatchSplitID, @SetSplitID = A.F_MatchSplitID FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = A.F_MatchSplitID 
					AND B.F_Order = @CurGameNo AND B.F_FatherMatchSplitID != 0
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = @CurMatchNo
	END
	
	--团体赛则录入盘分
	IF @MatchType = 3
	BEGIN
		--A方盘分
		UPDATE TS_Match_Split_Result SET F_Points = MatchScoreA,
									F_Service = CASE [Server]
											WHEN 'A1' THEN 1
											WHEN 'A2' THEN 1
											ELSE 0	END		
		FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SetSplitID AND F_CompetitionPosition = 1 
			AND Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order
		IF @@ERROR != 0
		BEGIN
			ROLLBACK
			SET @Result = -21
			RETURN
		END	
		--B方盘分
		UPDATE TS_Match_Split_Result SET F_Points = MatchScoreB,
									F_Service = CASE [Server]
											WHEN 'B1' THEN 1
											WHEN 'B2' THEN 1
											ELSE 0	END	
		FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SetSplitID AND F_CompetitionPosition = 2
			AND Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order
		IF @@ERROR != 0
		BEGIN
			ROLLBACK
			SET @Result = -22
			RETURN
		END
	END
	
	--录入局分
	
	--A方局分
	UPDATE TS_Match_Split_Result SET F_Points = GameScoreA,
								F_Service = CASE [Server]
										WHEN 'A1' THEN 1
										WHEN 'A2' THEN 1
										ELSE 0	END,
								 F_Comment1 = CASE [Type]
										WHEN 3 THEN 1
										WHEN 5 THEN 2
										ELSE NULL END
	FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @GameSplitID AND F_CompetitionPosition = 1 
		AND Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order
	IF @@ERROR != 0
	BEGIN
		ROLLBACK
		SET @Result = -31
		RETURN
	END
	
	--B方局分
	UPDATE TS_Match_Split_Result SET F_Points = GameScoreB,
								F_Service = CASE [Server]
										WHEN 'B1' THEN 1
										WHEN 'B2' THEN 1
										ELSE 0	END,
								F_Comment1 = CASE [Type]
										WHEN 4 THEN 1
										WHEN 6 THEN 2
										ELSE NULL END
	
	FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @GameSplitID AND F_CompetitionPosition = 2 
		AND Match_No = @CurMatchNo AND Game_No = @CurGameNo AND [Order] = @Order
	IF @@ERROR != 0
	BEGIN
		ROLLBACK
		SET @Result = -32
		RETURN
	END
	
	/*BEGIN TRANSACTION
	
	--先删除所有得分历程
	DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID
	
	INSERT INTO TS_Match_ActionList (F_CompetitionPosition, F_MatchID, F_MatchSplitID, F_ActionTypeID, F_ActionOrder, F_RegisterID, F_ActionDetail1, F_ActionDetail2)
	(
		SELECT CASE WHEN [Type] IN (1,4,6) THEN 1 WHEN [Type] IN (2,3,5) THEN 2 ELSE 1 END,
			   @MatchID, GameSplitID, 0, A.[Order], dbo.Fun_BD_GetMatchPlayerIDFromTS(@MatchID, A.SetSplitID, A.ScorePlayer),
			   CASE WHEN [Type] IN (1,4,6) THEN A.GameScoreA WHEN [Type] IN (2,3,5) THEN A.GameScoreB ELSE A.GameScoreA END,
			   0
		FROM #TMP_ACTION_LIST AS A
		WHERE A.Score != 0 
	) ORDER BY A.[Order]
	IF @@ERROR != 0
	BEGIN
		ROLLBACK
		SET @Result = -40
		RETURN
	END
	COMMIT TRANSACTION*/
	
	
	
	--更新红牌，黄牌信息，分数信息由MatchInfo决定
	--1.先删除没有牌子的记录
	/*DELETE FROM #TMP_ACTION_LIST WHERE [Type] NOT IN (3,4,5,6)
	
	IF NOT EXISTS ( SELECT [Order] FROM #TMP_ACTION_LIST)
	BEGIN
		SET @Result = @MatchID 
		RETURN
	END
	
	--2.为每局内的记录编号
	INSERT INTO #TMP_ACTION_LIST2 (GroupRank,SetSplitID, GameSplitID,ScoreRegID,Match_No, Game_No,[Order],[Time],Score
			,[Type],ScorePlayer, GameScoreA, GameScoreB,MatchScoreA, MatchScoreB, DuelScoreA, DuelScoreB, [Server])
			(		
				SELECT ROW_NUMBER() OVER(PARTITION BY GameSplitID ORDER BY [Order] DESC),
				SetSplitID, GameSplitID,ScoreRegID,Match_No, Game_No,[Order],[Time],Score,[Type], ScorePlayer,GameScoreA, 
				GameScoreB, MatchScoreA, MatchScoreB, DuelScoreA, DuelScoreB,[Server] FROM #TMP_ACTION_LIST
			)

	--3.删除局内记录不为1的，防止一局内有两个以上的牌子
	DELETE FROM #TMP_ACTION_LIST2 WHERE GroupRank != 1
	
	UPDATE TS_Match_Split_Result SET 
				F_Comment1 = CASE [Type]
										WHEN 3 THEN 1
										WHEN 5 THEN 2
										ELSE NULL END
	FROM #TMP_ACTION_LIST2 AS A
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.GameSplitID AND F_CompetitionPosition = 1
	
	UPDATE TS_Match_Split_Result SET 
				F_Comment1 = CASE [Type]
										WHEN 4 THEN 1
										WHEN 6 THEN 2
										ELSE NULL END
	FROM #TMP_ACTION_LIST2 AS A
	WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.GameSplitID AND F_CompetitionPosition = 2
	
	SET @Result = @MatchID*/

SET NOCOUNT OFF
END


GO

