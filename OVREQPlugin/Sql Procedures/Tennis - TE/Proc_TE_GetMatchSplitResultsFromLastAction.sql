IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchSplitResultsFromLastAction]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchSplitResultsFromLastAction]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_TE_GetMatchSplitResultsFromLastAction]
----��		  �ܣ��õ�һ�������ĸ��̸��ֵ���ϸ�ɼ���Ϣ,������Ŀ,ʵ������Ҫ��������ɼ�����,��Դ�Ǽ���ͳ�Ƶ����һ�
----��		  �ߣ�֣���� 
----��		  ��: 2010-10-07
----�� �� ��  ¼�� 
/*
                  ����    2011-2-12     ��������С�ȷֵĴ洢
                  ����    2011-6-28     ���Ӳ�����Ϊ��������
*/


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchSplitResultsFromLastAction] (	
	@MatchID					INT,
	@ActionType					INT,
	@EntryType                  INT,
	@SubMatchCode               INT   ---- -1:������
)	
AS
BEGIN
SET NOCOUNT ON

    DECLARE @MatchSplitID   INT
    SET @MatchSplitID = 0
    IF(@SubMatchCode <> -1)
    BEGIN
       SELECT @MatchSplitID = F_MatchSplitID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = @SubMatchCode AND F_MatchSplitType = 3
    END
    
	CREATE TABLE #Temp_Results(	F_Level				INT, --0��ʾMatch��1��ʾSet��2��ʾGame
								F_Status			INT,
								F_SetNum			INT,
								F_GameNum			INT,
								F_Position			INT,
								F_Server			INT,
								F_Points			INT,
								F_Rank				INT,
								F_TBPoint           INT)
								
	DECLARE @XmlDoc AS XML
	SELECT TOP 1 @XmlDoc = F_ActionXMLComment FROM TS_Match_ActionList WHERE F_MatchID = @MatchID AND F_ActionTypeID = @ActionType AND F_MatchSplitID = @MatchSplitID
		ORDER BY F_ActionOrder DESC
	
	IF @XmlDoc IS NULL
	BEGIN
	     IF(@EntryType <> 2)
	     BEGIN
			 SELECT  0 AS LastSetNum, 0 AS LastGameNum, 1 AS RunningSetNum, 1 AS RunningGameNum
			 EXEC [Proc_TE_GetMatchSplitResults] @MatchID, @SubMatchCode
			 RETURN
	    END
	    ELSE 
	    BEGIN
	         SELECT  0 AS LastSetNum, 0 AS LastGameNum, 1 AS RunningSetNum, 1 AS RunningGameNum
			 RETURN
	    END
	END
	
	DECLARE @iDoc AS INT
	EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
	
		--SELECT @iDoc
		--ָ����ǰ�̺͵�ǰ��
		SELECT * FROM OPENXML (@iDoc, '/MatchResult',1)
			WITH (
					LastSetNum				INT,
					LastGameNum				INT,
					RunningSetNum			INT,
					RunningGameNum			INT
				)
					
		--�ܱȷ�
		INSERT INTO #Temp_Results (F_Level, F_Status, F_Position, F_Server, F_Points, F_Rank)
			SELECT 0 AS F_Level, MatchStatus AS F_Status, Position AS F_Position, 0 AS F_Server, [Sets] AS F_Points, [Rank] AS F_Rank FROM OPENXML (@iDoc, '/MatchResult/Competitor',1)
				WITH (
						MatchStatus		NVARCHAR(50) '../@MatchStatus',
						Position		INT,
						[Sets]			INT,
						[Rank]			INT
					)
		--ĳһ�̱ȷ�
		
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
				
		--ĳһ�ֱȷ�
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
	
	SELECT * FROM #Temp_Results ORDER BY F_Level, F_SetNum, F_GameNum
	
SET NOCOUNT OFF
END






GO
 --EXEC Proc_TE_GetMatchSplitResultsFromLastAction 1, -1
 --EXEC Proc_TE_GetMatchSplitResultsFromLastAction 2, -2
 --EXEC [Proc_TE_GetMatchSplitResults] 1
