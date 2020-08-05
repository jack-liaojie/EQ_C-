IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_SH_GetDisciplineOtherInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_SH_GetDisciplineOtherInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_Report_SH_GetDisciplineOtherInfo]
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


