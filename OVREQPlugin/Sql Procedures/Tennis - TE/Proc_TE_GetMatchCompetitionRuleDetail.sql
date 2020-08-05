IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchCompetitionRuleDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchCompetitionRuleDetail]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----存储过程名称：[Proc_TE_GetMatchCompetitionRuleDetail]
----功		  能：得到一竞赛规则的详细信息
----作		  者：郑金勇 
----日		  期: 2010-09-20

CREATE PROCEDURE [dbo].[Proc_TE_GetMatchCompetitionRuleDetail] (	
	@CompetitionRuleID					INT
)	
AS
BEGIN
	
SET NOCOUNT ON

	DECLARE @XmlDoc AS XML
	SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID

    DECLARE @SubMatchCount  INT
	IF @XmlDoc IS NOT NULL
	BEGIN
	DECLARE @iDoc AS INT
		EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
		
		SET @SubMatchCount = @XmlDoc.value('(/MatchRule/@Match)[1]', 'int')
		    IF(@SubMatchCount IS NULL OR @SubMatchCount = 0)
		    BEGIN ----个人赛
		
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
			 END
			 ELSE 
			 BEGIN    ----团体赛
			            
		          SELECT  * INTO #Temp_RuleDetail FROM OPENXML(@iDoc, '/MatchRule/SubMatch/SetRule', 2)
		             WITH(
		                   RuleName NVARCHAR(50) '//MatchRule/@RuleName',
		                   [MatchCount]  INT '//MatchRule/@Match',
		                   [FullPlay]    INT '//MatchRule/@FullPlay',
						   [MatchNum]    INT '../@MatchNum',
						   [MatchRegType]		INT '../@MatchRegType',
		                   [Sets]        INT '//MatchRule/@Sets',
						   SetNum        INT '@SetNum',
						   Games         INT '@Games',
						   Advantage     INT '@Advantage',
						   TieBreak      INT '@TieBreak',
						   DecidingTB    INT '@DecidingTB',
						   TBPoints      INT '@TBPoints'
		             )
				--ALTER TABLE #Temp_RuleDetail ALTER COLUMN [MatchRegType] NVARCHAR(100)
				
				--UPDATE A SET [MatchRegType] = B.F_RegTypeLongDescription FROM #Temp_RuleDetail AS A LEFT JOIN TC_RegType_Des AS B ON
				--	A.MatchRegType = B.F_RegTypeID AND B.F_LanguageCode = 'CHN'
				SELECT * FROM #Temp_RuleDetail
			 END
			
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

 --EXEC [Proc_TE_GetMatchCompetitionRuleDetail] 1
