IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetDisciplineOtherInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetDisciplineOtherInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--名    称: [Proc_Report_GF_GetDisciplineOtherInfo]
--描    述: SQ项目获取 Discipline 的其他信息, 如 AllEventCount (所有小项数目), FinishedEventCount (结束小项数目)等.
--参数说明: 
--说    明: 
--创 建 人: 张翠霞
--日    期: 2010年09月15日



CREATE PROCEDURE [dbo].[Proc_Report_GF_GetDisciplineOtherInfo]
	@DisciplineID						INT
AS
BEGIN
SET NOCOUNT ON

	SELECT 
		(
			SELECT COUNT(X.F_EventID)
			FROM TS_Event AS X
			WHERE X.F_DisciplineID = @DisciplineID
		) AS [AllEventCount]
		, (
			SELECT COUNT(X.F_EventID)
			FROM TS_Event AS X
			WHERE X.F_DisciplineID = @DisciplineID
				AND X.F_EventStatusID = 110
		) AS [FinishedEventCount]

SET NOCOUNT OFF
END



GO


