IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchCompetitionRule_Team]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchCompetitionRule_Team]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchCompetitionRule_Team]
----功		  能：针对团体比赛，得到一场比赛的竞赛规则
----作		  者：李燕 
----日		  期: 2011-6-27

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchCompetitionRule_Team] (	
	@MatchID					INT,
	@SubMatchCode               INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

    CREATE TABLE  #tmp_table(RuleName   NVARCHAR(50),
                             MatchNum   INT,
                             [Sets]     INT,
                             SetNum     INT,
                             Games      INT,
                             Advantage  INT,
                             TieBreak   INT,
                             DecidingTB INT,
                             TBPoints   INT,
                             )
                             
                             
    
	DECLARE @XmlDoc AS XML
	SELECT @XmlDoc = B.F_CompetitionRuleInfo FROM TS_Match AS A LEFT JOIN TD_CompetitionRule AS B ON A.F_CompetitionRuleID = B.F_CompetitionRuleID
		WHERE A.F_MatchID = @MatchID
	IF @XmlDoc IS NOT NULL
	BEGIN
	DECLARE @iDoc AS INT
		EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
		
			--SELECT @iDoc
	    INSERT INTO #tmp_table(RuleName, MatchNum, [Sets], SetNum, Games, Advantage, TieBreak, DecidingTB, TBPoints)
		    SELECT * FROM OPENXML (@iDoc, '/MatchRule/SubMatch/SetRule',1)
				WITH (
					RuleName NVARCHAR(50) '//MatchRule/@RuleName',
					[MatchNum]  INT  '../@MatchNum',
					[Sets] INT '//MatchRule/@Sets',
					SetNum INT '@SetNum',
					Games INT '@Games',
					Advantage INT '@Advantage',
					TieBreak INT '@TieBreak',
					DecidingTB INT '@DecidingTB',
					TBPoints INT '@TBPoints'
				)
			
		EXEC sp_xml_removedocument @iDoc
	END
	ELSE 
	BEGIN
		INSERT INTO #tmp_table(RuleName, MatchNum, [Sets], SetNum, Games, Advantage, TieBreak, DecidingTB, TBPoints)
		   SELECT NULL AS RuleName, NULL AS MatchNum, NULL AS [Sets], NULL AS SetNum, NULL AS Games, NULL AS Advantage, NULL AS TieBreak, NULL AS DecidingTB, NULL AS TBPoints
	END
	
	    SELECT * FROM #tmp_table WHERE MatchNum = @SubMatchCode
	RETURN
	
SET NOCOUNT OFF
END





GO

 --EXEC [Proc_TE_GetMatchCompetitionRule] 1,'ENG'
