IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetPlayerShootOffArrows]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetPlayerShootOffArrows]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_GetPlayerShootOffArrows]
--描    述: 射箭项目,获取某人每箭信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月11日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetPlayerShootOffArrows]
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
	, case when MSR.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(MSR.F_Points AS VARCHAR) END AS F_Points
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
	AND MSI.F_MatchSplitType = 3
	and MSI.F_MatchSplitCode = @ArrowIndex
	ORDER BY MSI.F_MatchSplitCode
	end
	
	else 
	BEGIN
	SELECT DISTINCT
	  MSR.F_CompetitionPosition
	, case when MSR.F_SplitInfo2 = 1 THEN 'X' ELSE CAST(MSR.F_Points AS VARCHAR) END AS F_Points
	, MSI.F_MatchSplitCode AS F_Order
	, MSI.F_MatchSplitCode
	, MSI.F_MatchID
	, MSI.F_MatchSplitID
	, MSI.F_FatherMatchSplitID
	, MSIF.F_MatchSplitCode AS FaterCode
	FROM TS_Match_Split_Info AS MSI
	LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID  AND MSR.F_MatchID =@MatchID
	LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
	where MSI.F_MatchID= @MatchID 
	AND MSI.F_FatherMatchSplitID = @FatherSplitID 
	AND MSR.F_CompetitionPosition = @CompetationPosition
	AND MSI.F_MatchSplitType = 3
	ORDER BY MSI.F_MatchSplitCode
	END
	

SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_GetPlayerShootOffArrows  32,1,1,'1','eng'
*/
