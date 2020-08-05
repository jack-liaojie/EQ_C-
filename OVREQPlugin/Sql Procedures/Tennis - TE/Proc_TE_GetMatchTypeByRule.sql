IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_GetMatchTypeByRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_GetMatchTypeByRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



----存储过程名称：[Proc_TE_GetMatchTypeByRule]
----功		  能：根据比赛规则，判断是否为团体比赛
----作		  者：李燕
----日		  期: 2011-06-11
----修  改 记 录: 


CREATE PROCEDURE [dbo].[Proc_TE_GetMatchTypeByRule]
    @MatchID				INT,
    @SubMatchCount   		INT OUTPUT,
    @IsFullMatch			INT OUTPUT
AS
BEGIN
	
SET NOCOUNT ON

    SET @IsFullMatch = 0;
	SET @SubMatchCount = 0;
					
					
	DECLARE @CompetitionRuleID    INT
	
	SET Implicit_Transactions off
	BEGIN TRANSACTION
	
	BEGIN TRY
		
		SELECT @CompetitionRuleID = F_CompetitionRuleID  FROM TS_Match WHERE F_MatchID = @MatchID
		
		
		DECLARE @XmlDoc AS XML
		SELECT @XmlDoc = F_CompetitionRuleInfo FROM TD_CompetitionRule WHERE F_CompetitionRuleID = @CompetitionRuleID

		IF @XmlDoc IS NOT NULL
		BEGIN
		DECLARE @iDoc AS INT
			EXEC sp_xml_preparedocument @iDoc OUTPUT, @XmlDoc
			
			SET @SubMatchCount = @XmlDoc.value('(/MatchRule[1])/@Match', 'int')
			SET @IsFullMatch = @XmlDoc.value('(/MatchRule[1])/@FullPlay','int')
			
			EXEC sp_xml_removedocument @iDoc
		END
		
		
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION;
	
	END CATCH;

	IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;
		
	SET @IsFullMatch = ISNULL(@IsFullMatch, -1)
	SET @SubMatchCount = ISNULL(@SubMatchCount, 0)
	RETURN 

SET NOCOUNT OFF
END


GO


--declare @a1 int
--declare @a2 int
--exec Proc_TE_GetMatchTypeByRule 1, @a1 output, @a2 output
--select @a1, @a2