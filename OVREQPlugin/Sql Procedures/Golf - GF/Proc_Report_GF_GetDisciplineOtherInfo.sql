IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_GF_GetDisciplineOtherInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_GF_GetDisciplineOtherInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--��    ��: [Proc_Report_GF_GetDisciplineOtherInfo]
--��    ��: SQ��Ŀ��ȡ Discipline ��������Ϣ, �� AllEventCount (����С����Ŀ), FinishedEventCount (����С����Ŀ)��.
--����˵��: 
--˵    ��: 
--�� �� ��: �Ŵ�ϼ
--��    ��: 2010��09��15��



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


