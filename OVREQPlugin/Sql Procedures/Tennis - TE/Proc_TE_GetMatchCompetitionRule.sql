IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchCompetitionRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchCompetitionRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchCompetitionRule]
----功		  能：得到一场比赛的竞赛规则
----作		  者：郑金勇 
----日		  期: 2010-09-20

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchCompetitionRule] (	
	@MatchID					INT,
	@LanguageCode				CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @XmlDoc AS XML
	SELECT @XmlDoc = B.F_CompetitionRuleInfo FROM TS_Match AS A LEFT JOIN TD_CompetitionRule AS B ON A.F_CompetitionRuleID = B.F_CompetitionRuleID
		WHERE A.F_MatchID = @MatchID
	IF @XmlDoc IS NOT NULL
	BEGIN
	DECLARE @iDoc AS INT
		EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
		
			--SELECT @iDoc
					SELECT * FROM OPENXML (@iDoc, '/MatchRule/SetRule',1)
				WITH (
					RuleName NVARCHAR(50) '//MatchRule/@RuleName',
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
		SELECT NULL AS RuleName, NULL AS [Sets], NULL AS SetNum, NULL AS Games, NULL AS Advantage, NULL AS TieBreak, NULL AS DecidingTB, NULL AS TBPoints
	END
	
	RETURN
	
SET NOCOUNT OFF
END





GO

 --EXEC [Proc_TE_GetMatchCompetitionRule] 1,'ENG'
