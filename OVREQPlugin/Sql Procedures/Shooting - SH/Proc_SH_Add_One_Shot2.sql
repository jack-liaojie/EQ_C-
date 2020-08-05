
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_SH_Add_One_Shot2]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_SH_Add_One_Shot2]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_SH_Add_One_Shot2]
----��		  �ܣ�һǹ(��)�ɼ�
----��		  �ߣ���ѧ�� 
----��		  ��: 2010-09-25

CREATE PROCEDURE [dbo].[Proc_SH_Add_One_Shot2] (	
	@MatchID					INT,
	@RegID						INT,
	@ShotType					INT, --2 normal, 1 shoot-off 
	@ShotIndex					INT,
	@ShotValue					INT,
	@ShotValueIsNull			NVARCHAR(10)
	
)	
AS
BEGIN
	
SET NOCOUNT ON


	DECLARE @CompetitionPosition INT
	SELECT @CompetitionPosition = F_CompetitionPosition
	FROM TS_Match_Result
	WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID

	IF @RegID IS NULL 
	RETURN

	DECLARE @PhaseCode NVARCHAR(10)
	DECLARE @EventCode NVARCHAR(10)
	DECLARE @MatchCode NVARCHAR(10)
	SELECT @EventCode = Event_Code,
			 @PhaseCode = Phase_Code,
			 @MatchCode = Match_Code
	FROM dbo.Func_SH_GetEventCommonCodeInfo(@MatchID)


	DECLARE @PhaseID INT
	SELECT @PhaseID = F_PhaseID
	FROM TS_Match
	WHERE F_MatchID = @MatchID


	DECLARE @OldInterX INT
	SELECT @OldInterX = F_ActionDetail2 FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
			AND F_ActionTypeID = @ShotType AND F_MatchSplitID = @ShotIndex 

	DELETE FROM TS_Match_ActionList 
		WHERE F_MatchID = @MatchID AND F_CompetitionPosition = @CompetitionPosition
			AND F_ActionTypeID = @ShotType AND F_MatchSplitID = @ShotIndex 

	IF (@ShotValueIsNull = 'NOTNULL' )
	BEGIN
		INSERT INTO TS_Match_ActionList(F_MatchID, F_RegisterID, F_CompetitionPosition, F_ActionTypeID, F_MatchSplitID, F_ActionDetail1, F_ActionDetail2)
		VALUES(@MatchID, @RegID, @CompetitionPosition, @ShotType, @ShotIndex, @ShotValue, @OldInterX)
	END

	DECLARE @Score INT
	SELECT 	 @Score = SUM(F_ActionDetail1) FROM TS_Match_ActionList 
	WHERE F_MatchID = @MatchID 
		AND F_CompetitionPosition = @CompetitionPosition
		AND F_RegisterID = @RegID
		
	DECLARE @MAXDD INT
	SELECT @MAXDD = ISNULL( MAX(F_PhaseResultNumber), 0) + 1 FROM TS_Phase_Result
	-- Elimination
	IF @PhaseCode = 'A' AND @MatchCode IN('01', '02', '03', '04', '05')
	BEGIN
		UPDATE TS_Match_Result SET F_Points = @Score
			WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID
			
		IF (@ShotValueIsNull = 'NOTNULL' )
		BEGIN	
			DELETE FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegID
			INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_PhasePoints) VALUES(@PhaseID, @MAXDD, @RegID, @Score)
			UPDATE TS_Phase_Result SET F_PhaseRank = PR.RK
				FROM TS_Phase_Result R
				LEFT JOIN (SELECT *, RANK() OVER(ORDER BY F_PhasePoints DESC) AS RK FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID) PR
					ON PR.F_PhaseID = R.F_PhaseID AND PR.F_RegisterID = R.F_RegisterID
			WHERE R.F_PhaseID = @PhaseID	
		END
	END

	--Remember IRM
	DECLARE @IRMID INT
	
	SELECT @IRMID = F_IRMID
	FROM TS_Match_Result
	WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID

	-- Qualificaiton
	
	IF @PhaseCode = '9' AND @MatchCode IN('01', '02', '03', '04', '05')
	BEGIN
		UPDATE TS_Match_Result SET F_Points = @Score
			WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID

		IF (@ShotValueIsNull = 'NOTNULL' )
		BEGIN			
			DELETE FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegID
			INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_PhasePoints, F_IRMID) 
			VALUES(@PhaseID, @MAXDD, @RegID, @Score, @IRMID)
		END
		
		UPDATE TS_Phase_Result SET F_PhaseRank = PR.RK
			FROM TS_Phase_Result R
			LEFT JOIN (SELECT *, RANK() OVER(ORDER BY F_PhasePoints DESC) AS RK FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID) PR
				ON PR.F_PhaseID = R.F_PhaseID AND PR.F_RegisterID = R.F_RegisterID
		WHERE R.F_PhaseID = @PhaseID	
	END

	IF @EventCode = '105' AND @PhaseCode = '9' AND @MatchCode IN('00')
	BEGIN
		UPDATE TS_Match_Result SET F_Points = @Score
			WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID

		IF (@ShotValueIsNull = 'NOTNULL' )
		BEGIN			
			DELETE FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID AND F_RegisterID = @RegID
			INSERT INTO TS_Phase_Result(F_PhaseID, F_PhaseResultNumber, F_RegisterID, F_PhasePoints, F_IRMID) 
			VALUES(@PhaseID, @MAXDD, @RegID, @Score, @IRMID)
		END
		
		UPDATE TS_Phase_Result SET F_PhaseRank = PR.RK
			FROM TS_Phase_Result R
			LEFT JOIN (SELECT *, RANK() OVER(ORDER BY F_PhasePoints DESC) AS RK FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID) PR
				ON PR.F_PhaseID = R.F_PhaseID AND PR.F_RegisterID = R.F_RegisterID
		WHERE R.F_PhaseID = @PhaseID	
	END
	
	IF @PhaseCode = '9' AND @MatchCode IN('50')
	BEGIN
		UPDATE TS_Match_Result SET F_Points = @Score
			WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID
				
		UPDATE TS_Phase_Result SET F_PhasePointsIntDes1 = PR.F_Points
			FROM (SELECT A.*, B.F_PhaseID FROM TS_Match_Result A LEFT JOIN TS_Match B ON A.F_MatchID = B.F_MatchID WHERE A.F_MatchID = @MatchID) PR 
			LEFT JOIN TS_Phase_Result R
				ON PR.F_PhaseID = R.F_PhaseID AND PR.F_RegisterID = R.F_RegisterID
		WHERE R.F_PhaseID = @PhaseID	
			

		UPDATE TS_Phase_Result SET F_PhaseRank = PR.RK
			FROM TS_Phase_Result R
			LEFT JOIN (SELECT *, RANK() OVER(ORDER BY F_PhasePoints DESC, F_PhasePointsIntDes1 DESC) AS RK FROM TS_Phase_Result WHERE F_PhaseID = @PhaseID) PR
				ON PR.F_PhaseID = R.F_PhaseID AND PR.F_RegisterID = R.F_RegisterID
		WHERE R.F_PhaseID = @PhaseID		
		
		
	END

	-- IF FINAL
	IF @PhaseCode = '1' AND @MatchCode IN('01', '02', '03', '04', '05')
	BEGIN
	
		IF (@EventCode = '005' )
		BEGIN
			UPDATE TS_Match_Result SET F_Points = @Score
				FROM TS_Match_Result MR
				LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID
				LEFT JOIN TS_Phase_Result PR ON MR.F_RegisterID = PR.F_RegisterID
				WHERE MR.F_MatchID = @MatchID AND MR.F_RegisterID = @RegID
				AND PR.F_PhaseID IN 
				(
					SELECT M.F_PhaseID FROM TS_Match AS M
						LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
						LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
						WHERE E.F_EventCode = @EventCode AND P.F_PhaseCode = '9'
				)
		END
		
		ELSE
		BEGIN
			UPDATE TS_Match_Result SET F_Points = @Score + ISNULL(PR.F_PhasePoints,0)
				FROM TS_Match_Result MR
				LEFT JOIN TS_Match AS M ON M.F_MatchID = MR.F_MatchID
				LEFT JOIN TS_Phase_Result PR ON MR.F_RegisterID = PR.F_RegisterID
				WHERE MR.F_MatchID = @MatchID AND MR.F_RegisterID = @RegID
				AND PR.F_PhaseID IN 
				(
					SELECT M.F_PhaseID FROM TS_Match AS M
						LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
						LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
						WHERE E.F_EventCode = @EventCode AND P.F_PhaseCode = '9'
				)
		END


	END

	IF @PhaseCode = '1' AND @MatchCode IN('50')
	BEGIN
		UPDATE TS_Match_Result SET F_Points = @Score
			WHERE F_MatchID = @MatchID AND F_RegisterID = @RegID
			
		DECLARE @FinalMatchID INT
		SELECT @FinalMatchID = M.F_MatchID FROM TS_Match AS M
			LEFT JOIN TS_Phase AS P ON M.F_PhaseID = P.F_PhaseID
			LEFT JOIN TS_Event AS E ON E.F_EventID = P.F_EventID
			WHERE E.F_EventCode = @EventCode AND P.F_PhaseCode = '1' AND M.F_MatchCode = '01'
						
		UPDATE TS_Match_Result SET F_RANK = MR.RK
			FROM TS_Match_Result A
			LEFT JOIN (
						SELECT TR.*, RANK() OVER(ORDER BY TR.F_Points DESC, SR.F_Points DESC) RK FROM TS_Match_Result TR 
						LEFT JOIN (SELECT * FROM TS_Match_Result WHERE F_MatchID = @MatchID) SR ON SR.F_RegisterID =  TR.F_RegisterID
						WHERE TR.F_MatchID = @FinalMatchID
						) MR ON MR.F_MatchID = A.F_MatchID AND MR.F_RegisterID = A.F_RegisterID
			WHERE A.F_MatchID = @FinalMatchID
			
	END



SET NOCOUNT OFF
END


GO


