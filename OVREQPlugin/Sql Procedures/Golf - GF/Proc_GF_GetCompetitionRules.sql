IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GF_GetCompetitionRules]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_GF_GetCompetitionRules]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




----�洢�������ƣ�[Proc_GF_GetCompetitionRules]
----��		  �ܣ��õ�һ����Ŀ�ľ��������б�
----��		  �ߣ��Ŵ�ϼ 
----��		  ��: 2010-09-27

CREATE PROCEDURE [dbo].[Proc_GF_GetCompetitionRules] (	
	@DisciplineID					INT,
	@LanguageCode					CHAR(3)
)	
AS
BEGIN
	
SET NOCOUNT ON

	SELECT B.F_CompetitionLongName, B.F_CompetitionShortName, B.F_Comment
	,A.F_CompetitionRuleID
	FROM TD_CompetitionRule AS A
	LEFT JOIN TD_CompetitionRule_Des AS B ON A.F_CompetitionRuleID = B.F_CompetitionRuleID AND B.F_LanguageCode = @LanguageCode
	WHERE A.F_DisciplineID = @DisciplineID
	
SET NOCOUNT OFF
END

GO

