IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[proc_SetPhaseMatchesComment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[proc_SetPhaseMatchesComment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


----�洢�������ƣ�[proc_SetPhaseMatchesComment]
----��		  �ܣ�ָ���ýڵ��µ����б����ı�ע��Ϣ
----��		  �ߣ�֣���� 
----��		  ��: 2009-08-30 

CREATE PROCEDURE [dbo].[proc_SetPhaseMatchesComment] 
	@PhaseID				INT,--��Ӧ���͵�ID����Type���
	@MatchID				INT,
	@Type					INT,--ע��: -4��ʾ����Sport, -3��ʾSport��-2��ʾDiscipline��-1��ʾEvent��0��ʾPhase, 1��ʾMatch
	@Comment1				NVARCHAR(50),
	@Comment2				NVARCHAR(50),
	@Comment3				NVARCHAR(50),
	@Comment4				NVARCHAR(50),
	@Comment5				NVARCHAR(50),
	@Result 				AS INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

	SET @Result=0;  -- @Result=0; 	���ı�ע��Ϣʧ�ܣ���ʾû�����κβ�����
					-- @Result=1; 	���ı�ע��Ϣ�ɹ���

	CREATE TABLE #table_Tree (
                                    F_SportID           INT,
                                    F_DisciplineID      INT,
									F_EventID			INT, 
									F_PhaseID			INT,
									F_FatherPhaseID		INT,
									F_PhaseCode			NVARCHAR(10),
									F_NodeLongName		NVARCHAR(100),
									F_NodeShortName	    NVARCHAR(50),
									F_PhaseNodeType		INT,
									F_MatchID			INT,
									F_NodeType			INT,--ע��: -3��ʾSport��-2��ʾDiscipline��-1��ʾEvent��0��ʾPhase��1��ʾMatch
									F_NodeLevel			INT,
                                    F_Order             INT,
									F_NodeKey			NVARCHAR(100),
									F_FatherNodeKey		NVARCHAR(100),
									F_NodeName			NVARCHAR(100)
								 )

	DECLARE @NodeLevel INT
	SET @NodeLevel = 0

	IF @Type = 0
	BEGIN

		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_NodeName)
			SELECT D.F_SportID, C.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, B.F_PhaseLongName, B.F_PhaseShortName, 0 as F_NodeType, 0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_PhaseLongName
			  FROM TS_Phase AS A LEFT JOIN TS_Phase_Des AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Event AS C ON C.F_EventID = A.F_EventID LEFT JOIN TS_Discipline AS D ON D.F_DisciplineID = C.F_DisciplineID WHERE A.F_PhaseID = @PhaseID

		WHILE EXISTS ( SELECT F_PhaseID FROM #table_Tree WHERE F_NodeLevel = 0 ) 
		BEGIN
			SET @NodeLevel = @NodeLevel + 1
			UPDATE #table_Tree SET F_NodeLevel = @NodeLevel WHERE F_NodeLevel = 0

			INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_FatherPhaseID, F_PhaseCode, F_NodeLongName, F_NodeShortName, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
				SELECT B.F_SportID, B.F_DisciplineID, A.F_EventID, A.F_PhaseID, A.F_FatherPhaseID, A.F_PhaseCode, C.F_PhaseLongName, C.F_PhaseShortName, 0 as F_NodeType,0 as F_NodeLevel, A.F_Order, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, C.F_PhaseLongName
					FROM TS_Phase AS A LEFT JOIN #table_Tree AS B ON A.F_FatherPhaseID = B.F_PhaseID LEFT JOIN TS_Phase_Des AS C ON C.F_PhaseID = A.F_PhaseID WHERE B.F_NodeLevel = @NodeLevel
		END


		--���Match�ڵ�
		INSERT INTO #table_Tree(F_SportID, F_DisciplineID, F_EventID, F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
			SELECT B.F_SportID, B.F_DisciplineID, B.F_EventID, B.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, 1 as F_NodeType, (B.F_NodeLevel + 1) as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, B.F_NodeKey as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
				FROM TS_Match AS A LEFT JOIN #table_Tree AS B ON A.F_PhaseID = B.F_PhaseID LEFT JOIN TS_Match_Des AS C ON C.F_MatchID = A.F_MatchID WHERE B.F_NodeType = 0

	END
	ELSE
	BEGIN
		IF  @Type = 1
		BEGIN
			--���Match�ڵ�
			INSERT INTO #table_Tree( F_PhaseID, F_NodeLongName, F_NodeShortName, F_MatchID, F_NodeType, F_NodeLevel, F_Order, F_NodeKey, F_FatherNodeKey, F_NodeName)
				SELECT  A.F_PhaseID, C.F_MatchLongName, C.F_MatchShortName, A.F_MatchID, 1 as F_NodeType, 1 as F_NodeLevel, A.F_Order, 'M'+CAST( A.F_MatchID AS NVARCHAR(50)) as F_NodeKey, 'P'+CAST( A.F_PhaseID AS NVARCHAR(50)) as F_FatherNodeKey, 'Match'+CAST( A.F_Order AS NVARCHAR(50)) as F_NodeName
					FROM TS_Match AS A LEFT JOIN TS_Match_Des AS C ON A.F_MatchID = C.F_MatchID WHERE A.F_MatchID = @MatchID
		END
	END

	SET Implicit_Transactions off
	BEGIN TRANSACTION --�趨����

		IF @Comment1 <> '-1'
		BEGIN
			UPDATE TS_Match SET F_MatchComment1 = @Comment1
				WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree)
		END

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		IF @Comment2 <> '-1'
		BEGIN
			UPDATE TS_Match SET F_MatchComment2 = @Comment2
				WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree)
		END

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		IF @Comment3 <> '-1'
		BEGIN
			UPDATE TS_Match SET F_MatchComment3 = @Comment3
				WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree)
		END

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		IF @Comment4 <> '-1'
		BEGIN
			UPDATE TS_Match SET F_MatchComment4 = @Comment4
				WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree)
		END

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

		IF @Comment5 <> '-1'
		BEGIN
			UPDATE TS_Match SET F_MatchComment5 = @Comment5
				WHERE F_MatchID IN (SELECT F_MatchID FROM #table_Tree)
		END

		IF @@error<>0  --����ʧ�ܷ���  
		BEGIN 
			ROLLBACK   --����ع�
			SET @Result=0
			RETURN
		END

	COMMIT TRANSACTION --�ɹ��ύ����

	SET @Result = 1
	RETURN

SET NOCOUNT OFF
END




