IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TT_ImportMatchInfoXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TT_ImportMatchInfoXML]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






----存储过程名称：[Proc_TT_ImportMatchInfoXML]
----功		  能：从XML文件导入实时比分信息
----作		  者：王强
----日		  期: 2011-5-11

CREATE PROCEDURE [dbo].[Proc_TT_ImportMatchInfoXML]
	@MatchRsc     NVARCHAR(20),
    @MatchInfoXML			NVARCHAR(MAX),
    @BForce       INT,--是否接受状态约束
	@Result 			AS INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0;  -- @Result=0; 	导入失败，标示没有做任何操作！
					  -- @Result>0; 	导入成功！设置为@MatchID
					  --  -1表示RSC未找到
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
	IF @BForce != 1
	BEGIN
		DECLARE @MatchStatus INT
		SELECT @MatchStatus = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
		IF @MatchStatus IS NULL OR @MatchStatus = 110
		BEGIN
			SET @Result = -2
			RETURN
		END
	END
	
	DECLARE @MatchType INT
	SELECT  @MatchType = A.F_PlayerRegTypeID
	FROM TS_Event AS A
	LEFT JOIN TS_Phase AS B ON B.F_EventID = A.F_EventID
	LEFT JOIN TS_Match AS C ON C.F_PhaseID = B.F_PhaseID
	WHERE C.F_MatchID = @MatchID
	
	CREATE TABLE #TMP_DUEL_RESULT
	(
		DuelState NVARCHAR(10) collate database_default,
		DuelScoreA INT,
		DuelScoreB INT,
		DuelTime   NVARCHAR(20) collate database_default,
		DuelWLA   INT,
		DuelWLB   INT,
		DuelStatusA  NVARCHAR(10) collate database_default,
		DuelStatusB NVARCHAR(10) collate database_default
	)
	
	CREATE TABLE #TMP_SUB_MATCH_SCORE
	(
		SetSplitID INT,
		Match_No INT,
		MatchScoreA INT,
		MatchScoreB INT,
		MatchTime NVARCHAR(20) collate database_default,
		MatchWLA INT,
		MatchWLB INT,
		MatchStatusA NVARCHAR(10) collate database_default,
		MatchStatusB NVARCHAR(10) collate database_default,
		MatchState NVARCHAR(10) collate database_default
	)
	
	CREATE TABLE #TMP_GAME_SCORE
	(	
		GameSplitID INT,
		Match_No INT,
		Game_No INT, 
		GameScoreA INT,
		GameScoreB INT, 
		GameTime NVARCHAR(20) collate database_default,
		GameWLA INT,
		GameWLB INT, 
		GameStatusA NVARCHAR(10) collate database_default,
		GameStatusB NVARCHAR(10) collate database_default,
		GameState NVARCHAR(10) collate database_default
	)
	
	DECLARE @iDoc           AS INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @MatchInfoXML
	
	INSERT INTO #TMP_DUEL_RESULT
	SELECT *
	FROM OPENXML (@iDoc, '/Duel',1)
	WITH #TMP_DUEL_RESULT

	
	--获取Set比分
	INSERT INTO #TMP_SUB_MATCH_SCORE (
		Match_No,
		MatchScoreA, 
		MatchScoreB, 
		MatchTime,
		MatchWLA,
		MatchWLB,
		MatchStatusA,
		MatchStatusB,
		MatchState)
	SELECT *
	FROM OPENXML (@iDoc, '/Duel/Match',1)
	WITH
	(
		Match_No INT,
		MatchScoreA INT,
		MatchScoreB INT,
		MatchTime NVARCHAR(20) collate database_default,
		MatchWLA INT,
		MatchWLB INT,
		MatchStatusA NVARCHAR(10) collate database_default,
		MatchStatusB NVARCHAR(10) collate database_default,
		MatchState NVARCHAR(10) collate database_default
	)
	
	--获取Game比分
	INSERT INTO #TMP_GAME_SCORE
	(
		Match_No,
		Game_No, 
		GameScoreA,
		GameScoreB,
		GameTime,
		GameWLA,
		GameWLB, 
		GameStatusA,
		GameStatusB,
		GameState
	)
	SELECT *
	FROM OPENXML (@iDoc, '/Duel/Match/Game',1)
	WITH 
	(	
		Match_No INT '../@Match_No',
		Game_No INT, 
		GameScoreA INT,
		GameScoreB INT, 
		GameTime NVARCHAR(20) collate database_default,
		GameWLA INT,
		GameWLB INT, 
		GameStatusA NVARCHAR(10) collate database_default,
		GameStatusB NVARCHAR(10) collate database_default,
		GameState NVARCHAR(10) collate database_default
	)
	
	EXEC sp_xml_removedocument @iDoc
	
	
	
--	SELECT * FROM #TMP_DUEL_RESULT
	--SELECT * FROM #TMP_SUB_MATCH_SCORE
	----SELECT * FROM #TMP_GAME_SCORE
	--SET @Result = @MatchID
	--RETURN
	
	--状态5在common code中为closed，这里对应到ovr的unofficial
	UPDATE #TMP_DUEL_RESULT SET DuelState = '6' WHERE DuelState = '5'	
	UPDATE #TMP_SUB_MATCH_SCORE SET MatchState = '6' WHERE MatchState = '5'	
	UPDATE #TMP_GAME_SCORE SET GameState = '6' WHERE GameState = '5'	
	
	BEGIN TRANSACTION --设定事务
	
	--更新对阵A方比分
	UPDATE TS_Match_Result SET F_Points = A.DuelScoreA, F_IRMID = B.F_IRMID, 
			F_ResultID =  CASE A.DuelWLA
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END,
			F_Rank = CASE A.DuelWLA
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
	FROM #TMP_DUEL_RESULT AS A 
	LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.DuelStatusA
	WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 1
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = -11 
			RETURN
		END
		
	--更新对阵B方比分
	UPDATE TS_Match_Result SET F_Points = A.DuelScoreB, F_IRMID = B.F_IRMID, 
			F_ResultID =  CASE A.DuelWLB
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END,
			F_Rank = CASE A.DuelWLB
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
	FROM #TMP_DUEL_RESULT AS A 
	LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.DuelStatusB
	WHERE F_MatchID = @MatchID AND F_CompetitionPositionDes1 = 2
	IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = -12
			RETURN
		END
	--更新对阵状态
	
	DECLARE @NewStateID INT
	DECLARE @OldStateID INT
	SELECT @NewStateID = MIN(B.F_StatusID) FROM #TMP_DUEL_RESULT AS A
	LEFT JOIN TC_Status AS B ON B.F_StatusCode = A.DuelState
	
	SELECT @OldStateID = F_MatchStatusID FROM TS_Match WHERE F_MatchID = @MatchID
	
	
	UPDATE TS_Match SET F_SpendTime = [dbo].[Fun_BDTT_GetSecondsFromTime](A.DuelTime) + 180
	FROM #TMP_DUEL_RESULT AS A
	WHERE F_MatchID = @MatchID
	IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -13
				RETURN
			END
	
    IF @NewStateID IS NOT NULL
    BEGIN
		IF NOT ( @OldStateID = 40 AND @NewStateID = 30)
		BEGIN
			UPDATE TS_Match SET F_MatchStatusID = @NewStateID WHERE F_MatchID = @MatchID
		END
    END
		
	--**********************************************团体赛**********************************************
	IF @MatchType = 3
	BEGIN
		
		--获取到SetID
		UPDATE #TMP_SUB_MATCH_SCORE SET SetSplitID = A.F_MatchSplitID
		FROM TS_Match_Split_Info AS A
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = Match_No
		
		--获取到GameID
		UPDATE #TMP_GAME_SCORE SET GameSplitID = B.F_MatchSplitID
		FROM TS_Match_Split_Info AS A
		LEFT JOIN TS_Match_Split_Info AS B ON B.F_MatchID = A.F_MatchID AND B.F_FatherMatchSplitID = A.F_MatchSplitID
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = Match_No AND B.F_Order = Game_No
		
		--更新A方盘比分
		UPDATE TS_Match_Split_Result SET F_Points = A.MatchScoreA, F_IRMID = B.F_IRMID, 
				F_ResultID =  CASE A.MatchWLA
							  WHEN 1 THEN 1
							  WHEN 2 THEN 2
							  ELSE NULL END,
				F_Rank = CASE A.MatchWLA
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
		FROM #TMP_SUB_MATCH_SCORE AS A 
		LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.MatchStatusA
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
			AND F_MatchSplitID = A.SetSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -21
				RETURN
			END
			
		--更新B方盘比分
		UPDATE TS_Match_Split_Result SET F_Points = A.MatchScoreB, F_IRMID = B.F_IRMID, 
				F_ResultID =  CASE A.MatchWLB
							  WHEN 1 THEN 1
							  WHEN 2 THEN 2
							  ELSE NULL END,
				F_Rank = CASE A.MatchWLB
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
		FROM #TMP_SUB_MATCH_SCORE AS A 
		LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.MatchStatusB
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
			AND F_MatchSplitID = A.SetSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -22
				RETURN
			END
			
		--更新盘状态
		UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = B.F_StatusID, F_SpendTime = [dbo].[Fun_BDTT_GetSecondsFromTime](A.MatchTime) + 120
				--F_MatchSplitComment = CASE A.MatchState
				--						WHEN '4' THEN '2'
				--						ELSE NULL END
		FROM #TMP_SUB_MATCH_SCORE AS A
		LEFT JOIN TC_Status AS B ON B.F_StatusCode = A.MatchState
		WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.SetSplitID
		IF @@error<>0  --事务失败返回  
		BEGIN 
			ROLLBACK   --事务回滚
			SET @Result = -23
			RETURN
		END
		
		--其他盘比分归零
		UPDATE TS_Match_Split_Result SET F_Points = NULL, F_ResultID = NULL, F_IRMID = NULL
		WHERE F_MatchID = @MatchID AND F_MatchSplitID 
					IN (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0)
					AND F_MatchSplitID NOT IN (SELECT SetSplitID FROM #TMP_SUB_MATCH_SCORE)
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -24
				RETURN
			END
		
		--其他盘状态归零
		--UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 0, F_SpendTime = NULL, F_MatchSplitComment = NULL
		--WHERE F_MatchID = @MatchID AND F_MatchSplitID 
		--			IN (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0)
		--			AND F_MatchSplitID NOT IN (SELECT SetSplitID FROM #TMP_SUB_MATCH_SCORE)
		--IF @@error<>0  --事务失败返回  
		--	BEGIN 
		--		ROLLBACK   --事务回滚
		--		SET @Result = -25
		--		RETURN
		--	END
		
		--更新A方局比分
		UPDATE TS_Match_Split_Result SET F_Points = A.GameScoreA, F_IRMID = B.F_IRMID, 
				F_ResultID =  CASE A.GameWLA
							  WHEN 1 THEN 1
							  WHEN 2 THEN 2
							  ELSE NULL END,
				F_Rank = CASE A.GameWLA
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
		FROM #TMP_GAME_SCORE AS A 
		LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.GameStatusA
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
			AND F_MatchSplitID = A.GameSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -31
				RETURN
			END
			
		--更新B方局比分
		UPDATE TS_Match_Split_Result SET F_Points = A.GameScoreB, F_IRMID = B.F_IRMID, 
				F_ResultID =  CASE A.GameWLB
							  WHEN 1 THEN 1
							  WHEN 2 THEN 2
							  ELSE NULL END,
				F_Rank = CASE A.GameWLB
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
		FROM #TMP_GAME_SCORE AS A 
		LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.GameStatusB
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
			AND F_MatchSplitID = A.GameSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -32
				RETURN
			END
			
		--更新局状态
		UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = B.F_StatusID, F_SpendTime = [dbo].[Fun_BDTT_GetSecondsFromTime](A.GameTime)
				--F_MatchSplitComment = CASE A.GameState
				--						WHEN '4' THEN '2'
				--						ELSE NULL END
		FROM #TMP_GAME_SCORE AS A
		LEFT JOIN TC_Status AS B ON B.F_StatusCode = A.GameState
		WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.GameSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -33
				RETURN
			END
		
		--其他局比分归零
		UPDATE TS_Match_Split_Result SET F_Points = NULL, F_ResultID = NULL, F_IRMID = NULL
		WHERE F_MatchID = @MatchID AND 
			F_MatchSplitID IN (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID != 0)
		 AND F_MatchSplitID NOT IN 
			(SELECT GameSplitID FROM #TMP_GAME_SCORE)
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -34
				RETURN
			END
		
		--其他局状态归零
		--UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 0, F_SpendTime = NULL, F_MatchSplitComment = NULL
		--WHERE F_MatchID = @MatchID AND 
		--	F_MatchSplitID IN (SELECT F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID != 0)
		-- AND F_MatchSplitID NOT IN 
		--	(SELECT GameSplitID FROM #TMP_GAME_SCORE)
		--IF @@error<>0  --事务失败返回  
		--	BEGIN 
		--		ROLLBACK   --事务回滚
		--		SET @Result = -35
		--		RETURN
		--	END
		
		
	END
	
	IF @MatchType IN (1,2)--********************************************个人赛**********************************************
	BEGIN
		
		--获取到GameID
		UPDATE #TMP_GAME_SCORE SET GameSplitID = A.F_MatchSplitID
		FROM TS_Match_Split_Info AS A
		WHERE A.F_MatchID = @MatchID AND A.F_FatherMatchSplitID = 0 AND A.F_Order = Game_No
		
		--更新A方局比分
		UPDATE TS_Match_Split_Result SET F_Points = A.GameScoreA, F_IRMID = B.F_IRMID, 
				F_ResultID =  CASE A.GameWLA
							  WHEN 1 THEN 1
							  WHEN 2 THEN 2
							  ELSE NULL END,
					F_Rank = CASE A.GameWLA
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
		FROM #TMP_GAME_SCORE AS A 
		LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.GameStatusA
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 1
			AND F_MatchSplitID = A.GameSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -31
				RETURN
			END
			
		--更新B方局比分
		UPDATE TS_Match_Split_Result SET F_Points = A.GameScoreB, F_IRMID = B.F_IRMID, 
				F_ResultID =  CASE A.GameWLB
							  WHEN 1 THEN 1
							  WHEN 2 THEN 2
							  ELSE NULL END,
				F_Rank = CASE A.GameWLB
						  WHEN 1 THEN 1
						  WHEN 2 THEN 2
						  ELSE NULL END
		FROM #TMP_GAME_SCORE AS A 
		LEFT JOIN TC_IRM AS B ON B.F_IRMCODE = A.GameStatusB
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = 2
			AND F_MatchSplitID = A.GameSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -32
				RETURN
			END
			
		--更新局状态
		UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = B.F_StatusID, F_SpendTime = [dbo].[Fun_BDTT_GetSecondsFromTime](A.GameTime)
		FROM #TMP_GAME_SCORE AS A
		LEFT JOIN TC_Status AS B ON B.F_StatusCode = A.GameState
		WHERE F_MatchID = @MatchID AND F_MatchSplitID = A.GameSplitID
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -33
				RETURN
			END
			
		--其他局比分归零
		UPDATE TS_Match_Split_Result SET F_Points = NULL, F_ResultID = NULL, F_IRMID = NULL
		WHERE F_MatchID = @MatchID AND F_MatchSplitID NOT IN (SELECT GameSplitID FROM #TMP_GAME_SCORE)
		IF @@error<>0  --事务失败返回  
			BEGIN 
				ROLLBACK   --事务回滚
				SET @Result = -34
				RETURN
			END
		
		----其他局状态归零
		--UPDATE TS_Match_Split_Info SET F_MatchSplitStatusID = 0, F_SpendTime = NULL
		--WHERE F_MatchID = @MatchID AND F_MatchSplitID NOT IN (SELECT GameSplitID FROM #TMP_GAME_SCORE)
		--IF @@error<>0  --事务失败返回  
		--	BEGIN 
		--		ROLLBACK   --事务回滚
		--		SET @Result = -35
		--		RETURN
		--	END
		
	END
	
	COMMIT TRANSACTION --成功提交事务
  
	SET @Result = @MatchID

SET NOCOUNT OFF
END


GO

