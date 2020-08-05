IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetPlayerArrows]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetPlayerArrows]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--��    ��: [Proc_AR_GetPlayerArrows]
--��    ��: �����Ŀ,��ȡĳ��ÿ����Ϣ
--����˵��: 
--˵    ��: 
--�� �� ��: �޿�
--��    ��: 2010��10��11��
--�޸ļ�¼��



CREATE PROCEDURE [dbo].[Proc_AR_GetPlayerArrows]
	@MatchID				INT,
	@FatherSplitID			INT,
	@CompetationPosition	INT,
	@ArrowIndex				INT,
	@LanguageCode			CHAR(3) = Null
AS
BEGIN
SET NOCOUNT ON
	
	if @LanguageCode = null
	begin
	 set @LanguageCode = 'ENG'
	 END
	if(@ArrowIndex <>-1)
	begin
	SELECT DISTINCT
	  MSR.F_CompetitionPosition
	, CASE WHEN MSR.F_SplitInfo2 = 1 THEN 'X'
		   WHEN MSR.F_SplitInfo2 = 0 AND MSR.F_Points=0 THEN 'M'
		   ELSE CAST(MSR.F_Points AS VARCHAR) END AS F_Points
	, MSI.F_MatchSplitCode AS F_Order
	, MSI.F_MatchSplitCode
	, MSI.F_MatchID
	, MSI.F_MatchSplitID
	, MSI.F_FatherMatchSplitID
	, MSIF.F_MatchSplitCode AS FaterCode
	FROM TS_Match_Split_Info AS MSI
	LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID =@MatchID
	LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
	where MSI.F_MatchID= @MatchID 
	AND MSI.F_FatherMatchSplitID = @FatherSplitID 
	AND MSR.F_CompetitionPosition = @CompetationPosition
	AND MSI.F_MatchSplitType = 1
	and MSI.F_MatchSplitCode = @ArrowIndex
	ORDER BY MSI.F_MatchSplitCode
	end
	
	else 
	BEGIN
	SELECT DISTINCT
	  MSR.F_CompetitionPosition	
	, CASE WHEN MSR.F_SplitInfo2 = 1 THEN 'X'
		   WHEN MSR.F_SplitInfo2 = 0 AND MSR.F_Points=0 THEN 'M'
		   ELSE CAST(MSR.F_Points AS VARCHAR) END AS F_Points
	, MSI.F_MatchSplitCode AS F_Order
	, MSI.F_MatchSplitCode
	, MSI.F_MatchID
	, MSI.F_MatchSplitID
	, MSI.F_FatherMatchSplitID
	, MSIF.F_MatchSplitCode AS FaterCode
	, MSI.F_Order AS F_ArrowIndex
	FROM TS_Match_Split_Info AS MSI
	LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID  AND MSR.F_MatchID =@MatchID
	LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
	where MSI.F_MatchID= @MatchID 
	AND MSI.F_FatherMatchSplitID = @FatherSplitID 
	AND MSR.F_CompetitionPosition = @CompetationPosition
	AND MSI.F_MatchSplitType = 1
	ORDER BY MSI.F_Order
	END
	

SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_GetPlayerArrows  129,8,1,'-1','CHN'
*/
