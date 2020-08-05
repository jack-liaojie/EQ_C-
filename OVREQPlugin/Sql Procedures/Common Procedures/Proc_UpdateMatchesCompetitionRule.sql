IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_UpdateMatchesCompetitionRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_UpdateMatchesCompetitionRule]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_UpdateMatchesCompetitionRule]
----��		  �ܣ���������һ���ڵ��µ�����Match�ľ�������
----��		  �ߣ�֣���� 
----��		  ��: 2009-11-16

CREATE PROCEDURE [dbo].[Proc_UpdateMatchesCompetitionRule]
	@NodeType				INT,
	@EventID				INT,
	@PhaseID				INT,
	@MatchID				INT,
	@CompetitionRuleID		INT,
    @Result					INT OUTPUT
	
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result = 0   -- @Result=0; 	�༭Match�ľ�������ʧ�ܣ���ʾû�����κβ�����
					  -- @Result=1; 	�༭Match�ľ�������ɹ���
					  -- @Result=-1;	�༭Match�ľ�������ʧ�ܣ�@CompetitionRuleID��Ч��
					  -- @Result=-2;	�༭Match�ľ�������ʧ�ܣ���ѡ�е�Match�е�״̬�����������������



	IF @CompetitionRuleID = 0
	BEGIN
		SET @CompetitionRuleID = NULL
	END
	ELSE IF NOT EXISTS( SELECT F_CompetitionRuleID FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID)
	BEGIN
		SET @Result = -1
		RETURN
	END

	IF @NodeType = -1 --Event
	BEGIN
		IF EXISTS(SELECT A.F_MatchID FROM TS_Match AS A LEFT JOIN TS_Phase AS B
			ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID AND A.F_MatchStatusID >= 50)
		BEGIN
			SET @Result = -2
			RETURN
		END
		ELSE
		BEGIN
			UPDATE TS_Match SET F_CompetitionRuleID = @CompetitionRuleID FROM TS_Match AS A LEFT JOIN TS_Phase AS B
				ON A.F_PhaseID = B.F_PhaseID WHERE B.F_EventID = @EventID

			SET @Result = 1
			RETURN
		END
	END

	
	IF @NodeType = 0 --Phase
	BEGIN
		DECLARE @NodeLevel AS INT
		SET @NodeLevel = 0

		CREATE TABLE #table_Tree(	F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_MatchID			INT,
									F_NodeLevel			INT,
									F_NodeType			INT)

		INSERT INTO #table_Tree(F_PhaseID, F_FatherPhaseID, F_NodeLevel, F_NodeType)
			SELECT F_PhaseID, F_FatherPhaseID, 0 AS F_NodeLevel, 0 AS F_NodeType
				FROM TS_Phase WHERE F_PhaseID = @PhaseID

		WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
		BEGIN
			SET @NodeLevel = @NodeLevel + 1
			UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

			INSERT INTO #table_Tree(F_PhaseID, F_FatherPhaseID, F_NodeLevel, F_NodeType)
			  SELECT A.F_PhaseID, A.F_FatherPhaseID, 0 AS F_NodeLevel, 0 AS F_NodeType
				FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID 
					WHERE B.F_NodeLevel = @NodeLevel
		END

		IF EXISTS(SELECT A.F_MatchID FROM TS_Match AS A INNER JOIN #table_Tree AS B
				ON A.F_PhaseID = B.F_PhaseID WHERE A.F_MatchStatusID >= 50)
		BEGIN
			SET @Result = -2
			RETURN
		END
		ELSE
		BEGIN
			UPDATE TS_Match SET F_CompetitionRuleID = @CompetitionRuleID FROM TS_Match AS A INNER JOIN #table_Tree AS B
				ON A.F_PhaseID = B.F_PhaseID

			SET @Result = 1
			RETURN
		END
	END

	IF @NodeType = 1 --Match
	BEGIN
		IF EXISTS(SELECT F_MatchID FROM TS_Match WHERE F_MatchID = @MatchID AND F_MatchStatusID >= 50)
		BEGIN
			SET @Result = -2
			RETURN
		END
		ELSE
		BEGIN
			UPDATE TS_Match SET F_CompetitionRuleID = @CompetitionRuleID WHERE F_MatchID = @MatchID
			SET @Result = 1
			RETURN
		END
	END

	RETURN

SET NOCOUNT OFF
END

GO

