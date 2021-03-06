IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_BD_ImportActionSingle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_BD_ImportActionSingle]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_BD_ImportActionSingle]
----功		  能：从XML文件导入得分历程
----作		  者：王强
----日		  期: 2011-5-13

CREATE PROCEDURE [dbo].[Proc_BD_ImportActionSingle]
	@MatchRsc     NVARCHAR(20),
	@MatchNo      INT,
	@GameNo       INT,
    @MatchInfoXML	NVARCHAR(MAX),
	@Result 	AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	导入失败，标示没有做任何操作！
					  -- @Result>0; 	导入成功！设置为@MatchID
					  --  -1表示RSC未找到,-2表示MatchSplitID未找到
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
		SubMatch_No INT, 
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
	
	INSERT INTO #TMP_ACTION_LIST
	SELECT *
	FROM OPENXML (@iDoc, '/MatchInfo/Score',1)
	WITH #TMP_ACTION_LIST
	
	EXEC sp_xml_removedocument @iDoc

		IF NOT EXISTS (SELECT * FROM #TMP_ACTION_LIST)
	BEGIN
		SET @Result = -4
		RETURN
	END
	DECLARE @SetSplitID INT
	DECLARE @GameSplitID INT
	DECLARE @MatchType INT
	SELECT  @MatchType = A.F_PlayerRegTypeID
	FROM TS_Event AS A
	LEFT JOIN TS_Phase AS B ON B.F_EventID = A.F_EventID
	LEFT JOIN TS_Match AS C ON C.F_PhaseID = B.F_PhaseID
	WHERE C.F_MatchID = @MatchID
	
	DELETE FROM #TMP_ACTION_LIST WHERE SubMatch_No != @MatchNo OR Game_No != @GameNo
	
	IF @MatchType IN (1,2)
	BEGIN
		SELECT @SetSplitID = F_MatchSplitID, @GameSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_Order = @GameNo
	END
	ELSE IF @MatchType = 3
	BEGIN
		SELECT @GameSplitID = B.F_MatchSplitID, @SetSplitID = A.F_MatchSplitID FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = A.F_MatchSplitID 
					AND B.F_Order = @GameNo AND B.F_FatherMatchSplitID != 0
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = @MatchNo
	END
	DECLARE @Res INT
	EXEC Proc_BD_SetCurrentSplitIndicator @MatchID, @GameSplitID, 2,@Res OUTPUT
	IF @SetSplitID IS NULL OR @GameSplitID IS NULL
	BEGIN
		SET @Result = -2
		RETURN
	END
	
	--先更新比分
	DECLARE @MaxOrder INT
	SELECT @MaxOrder = MAX([Order]) FROM #TMP_ACTION_LIST
	
	BEGIN TRANSACTION
	
	--A方赛分
	UPDATE TS_Match_Result SET F_Points = DuelScoreA, 
								F_Service = CASE [Server]
											WHEN 'A1' THEN 1
											WHEN 'A2' THEN 1
											ELSE 0	END				
	FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1 AND [Order] = @MaxOrder
	IF @@ERROR != 0
	BEGIN
		ROLLBACK
		SET @Result = -11
		RETURN
	END
	
	--B方赛分
	UPDATE TS_Match_Result SET F_Points = DuelScoreB,
								F_Service = CASE [Server]
											WHEN 'B1' THEN 1
											WHEN 'B2' THEN 1
											ELSE 0	END		 
	FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2 AND [Order] = @MaxOrder
	IF @@ERROR != 0
	BEGIN
		ROLLBACK
		SET @Result = -12
		RETURN
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
		FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SetSplitID AND F_CompetitionPosition = 1 AND [Order] = @MaxOrder
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
		FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @SetSplitID AND F_CompetitionPosition = 2 AND [Order] = @MaxOrder
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
	FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @GameSplitID AND F_CompetitionPosition = 1 AND [Order] = @MaxOrder
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
	
	FROM #TMP_ACTION_LIST WHERE F_MatchID = @MatchID AND F_MatchSplitID = @GameSplitID AND F_CompetitionPosition = 2 AND [Order] = @MaxOrder
	IF @@ERROR != 0
	BEGIN
		ROLLBACK
		SET @Result = -32
		RETURN
	END
	
	COMMIT TRANSACTION
	

	--********************************************以下为处理得分历程******************************************
	--先删除
	/*DELETE FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_MatchSplitID = @GameSplitID

	BEGIN TRANSACTION
	

	INSERT INTO TS_Match_ActionList (F_CompetitionPosition, F_MatchID, F_MatchSplitID, F_ActionTypeID, F_ActionOrder, F_RegisterID, F_ActionDetail1, F_ActionDetail2)
	(
		SELECT CASE WHEN [Type] IN (1,4,6) THEN 1 WHEN [Type] IN (2,3,5) THEN 2 ELSE 1 END,
			   @MatchID, @GameSplitID, 0, A.[Order], dbo.Fun_BD_GetMatchPlayerIDFromTS(@MatchID, @SetSplitID, A.ScorePlayer),
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
	
	SET @Result = @MatchID

SET NOCOUNT OFF
END


GO

