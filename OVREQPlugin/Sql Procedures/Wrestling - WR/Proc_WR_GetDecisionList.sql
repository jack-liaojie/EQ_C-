IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_WR_GetDecisionList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_WR_GetDecisionList]
GO

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

--名    称: [Proc_WR_GetDecisionList]
--描    述: 摔跤项目获取 Decision 列表.
--创 建 人: 宁顺泽
--日    期: 2011年10月14日 星期5
--修改记录：
/*			
	日期					修改人		修改内容
*/



CREATE PROCEDURE [dbo].[Proc_WR_GetDecisionList]
	@LanguageCode					CHAR(3) = NULL
AS
BEGIN
SET NOCOUNT ON
	
	IF @LanguageCode IS NULL
	BEGIN
		SELECT @LanguageCode = L.F_LanguageCode
		FROM TC_Language AS L
		WHERE L.F_Active = 1
	END

	SELECT 0 AS F_Order
		, N'' AS [Decision]
		, N'' AS [DecisionCode]
	UNION
	SELECT DD.F_Order
		,DCD.F_DecisionLongName AS [Decision]
		,DD.F_DecisionCode AS [DecisionCode]
	FROM TC_Decision AS DD
	LEFT JOIN TC_Decision_Des AS DCD
		ON DD.F_DecisionID = DCD.F_DecisionID AND DCD.F_LanguageCode = @LanguageCode
	INNER JOIN TS_Discipline AS D
		ON DD.F_DisciplineID = D.F_DisciplineID AND D.F_Active = 1
	ORDER BY F_Order

SET NOCOUNT OFF
END

/*

-- Just for test
EXEC [Proc_JU_GetDecisionList] 

*/