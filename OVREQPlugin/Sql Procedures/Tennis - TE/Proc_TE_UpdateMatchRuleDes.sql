IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_TE_UpdateMatchRuleDes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_TE_UpdateMatchRuleDes]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_TE_UpdateMatchRuleDes]
----��		  �ܣ��õ�һ����Ŀ�ľ������������
----��		  �ߣ�֣���� 
----��		  ��: 2010-09-20

CREATE PROCEDURE [dbo].[Proc_TE_UpdateMatchRuleDes] (	
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

 --EXEC [Proc_TE_GetCompetitionRules] 1,'ENG'
