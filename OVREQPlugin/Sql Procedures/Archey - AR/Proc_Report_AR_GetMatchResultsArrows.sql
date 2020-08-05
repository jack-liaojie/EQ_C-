IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_AR_GetMatchResultsArrows]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_AR_GetMatchResultsArrows]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--��    ��: [Proc_Report_AR_GetMatchResultsArrows]
--��    ��: �����Ŀ,��ȡĳ�˾���Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2010��10��11��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_Report_AR_GetMatchResultsArrows]
	@MatchID				INT,
	@CompetitionPosition	INT,
	@LanguageCode			CHAR(3) = Null
AS
BEGIN
SET NOCOUNT ON
		
	if @LanguageCode = null
	begin
	 set @LanguageCode = 'ENG'
	 END
	 
	SELECT
	 case when MSR.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(MSR.F_Points AS VARCHAR) END AS F_Points
	FROM TS_Match_Split_Info AS MSI
	LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = MSR.F_MatchSplitID  AND MSR.F_MatchID =@MatchID
	where MSI.F_MatchID= @MatchID 
	AND MSR.F_CompetitionPosition = @CompetitionPosition
	AND MSI.F_MatchSplitType = 1
	ORDER BY RIGHT('0000' + MSI.F_MatchSplitCode,4)

SET NOCOUNT OFF
END

GO

/*
exec Proc_Report_AR_GetMatchResultsArrows 32,1,'ENG'
*/
