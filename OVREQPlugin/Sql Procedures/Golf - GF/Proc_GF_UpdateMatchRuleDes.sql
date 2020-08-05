IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateMatchRuleDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateMatchRuleDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





----存储过程名称：[Proc_GF_UpdateMatchRuleDes]
----功		  能：修改一个项目的竞赛规则的属性
----作		  者： 张翠霞
----日		  期: 2010-09-28

CREATE PROCEDURE [dbo].[Proc_GF_UpdateMatchRuleDes] (	
	@CompetitionRuleID				INT,
	@LanguageCode					CHAR(3),
	@PropertyName					NVARCHAR(50),
	@PropertyValue					NVARCHAR(100)
)	
AS
BEGIN
	
SET NOCOUNT ON

	IF NOT EXISTS(SELECT F_CompetitionRuleID FROM TD_CompetitionRule_Des WHERE F_CompetitionRuleID = @CompetitionRuleID AND F_LanguageCode = @LanguageCode)
	BEGIN
		INSERT INTO TD_CompetitionRule_Des (F_CompetitionRuleID, F_LanguageCode) VALUES (@CompetitionRuleID, @LanguageCode)
	END
	 
	DECLARE @Sql AS NVARCHAR(MAX)
	SET @Sql = N'UPDATE TD_CompetitionRule_Des SET ' + @PropertyName + ' = ''' + @PropertyValue + ''' WHERE F_CompetitionRuleID = ' + CAST(@CompetitionRuleID AS NVARCHAR(MAX)) + ' AND F_LanguageCode = ''' + CAST(@LanguageCode AS NVARCHAR(MAX)) + ''''
	
	EXEC (@Sql)
	
	RETURN
	
SET NOCOUNT OFF
END






GO


