IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AddCompetitionRule]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AddCompetitionRule]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_AddCompetitionRule]
----��		  �ܣ����һ����Ŀ��һ����������
----��		  �ߣ�֣���� 
----��		  ��: 2010-09-20

CREATE PROCEDURE [dbo].[Proc_AddCompetitionRule] (	
	@DisciplineID					INT,
	@Result							INT OUTPUT
)	
AS
BEGIN
	
SET NOCOUNT ON
	SET @Result = 0 
	DECLARE @NewCompetitionRuleID AS INT
	SELECT  @NewCompetitionRuleID = (ISNULL(MAX(F_CompetitionRuleID), 0) + 1) FROM TD_CompetitionRule
	
	INSERT INTO TD_CompetitionRule (F_CompetitionRuleID, F_DisciplineID) VALUES (@NewCompetitionRuleID, @DisciplineID)

	SET @Result = @NewCompetitionRuleID
	RETURN
	
SET NOCOUNT OFF
END





GO

 --EXEC [Proc_AddCompetitionRule] 1
