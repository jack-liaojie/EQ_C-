IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetCompetitionRuleList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GetCompetitionRuleList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



----�洢�������ƣ�[Proc_GetCompetitionRuleList]
----��		  �ܣ��õ���Discipline�µ����еľ�������
----��		  �ߣ�֣���� 
----��		  ��: 2009-11-16

CREATE PROCEDURE [dbo].[Proc_GetCompetitionRuleList]
	@DisciplineID			INT,
    @LanguageCode			CHAR(3)
	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT A.F_CompetitionRuleID, B.F_CompetitionLongName 
				FROM TD_CompetitionRule AS A LEFT JOIN TD_CompetitionRule_Des AS B
					ON A.F_CompetitionRuleID = B.F_CompetitionRuleID AND B.F_LanguageCode = @LanguageCode
						WHERE A.F_DisciplineID = @DisciplineID
	UNION 
	SELECT '0' AS F_CompetitionRuleID, 'NONE' AS F_CompetitionLongName

SET NOCOUNT OFF
END

GO

