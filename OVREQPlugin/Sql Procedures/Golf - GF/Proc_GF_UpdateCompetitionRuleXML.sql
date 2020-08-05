IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_UpdateCompetitionRuleXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_UpdateCompetitionRuleXML]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_GF_UpdateCompetitionRuleXML]
----��		  �ܣ����¾���ģ�͵�XML��������
----��		  �ߣ��Ŵ�ϼ
----��		  ��: 2010-09-28 

CREATE PROCEDURE [dbo].[proc_GF_UpdateCompetitionRuleXML]
    @CompetitionRuleID			INT,
    @RuleXML					NVARCHAR(MAX)
AS
BEGIN
	
SET NOCOUNT ON

	UPDATE TD_CompetitionRule SET F_CompetitionRuleInfo = @RuleXML WHERE F_CompetitionRuleID = @CompetitionRuleID

	RETURN

SET NOCOUNT OFF
END



GO


