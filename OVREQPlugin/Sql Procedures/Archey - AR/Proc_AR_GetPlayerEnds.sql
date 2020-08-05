IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetPlayerEnds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetPlayerEnds]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_GetPlayerEnds]
--描    述: 射箭项目,获取某人局信息
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月11日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetPlayerEnds]
	@MatchID				INT,
	@EndDistince			INT, --靶距：0：淘汰赛; 1：90m/70m; 2:70m/60m; 3:50m ; 4:30m；
	@CompetitionPosition	INT,
	@EndIndex				NVARCHAR(10), --第几局
	@LanguageCode			CHAR(3) = Null
AS
BEGIN
SET NOCOUNT ON
		
	if @LanguageCode = null
	begin
	 set @LanguageCode = 'ENG'
	 END
	 
	 
	if(@EndIndex <>-1 AND @EndDistince<>-1)
	begin
		SELECT
		  MSR.F_CompetitionPosition
		, MSR.F_Points AS Total
		, MSI.F_Order  AS EndIndex
		, MSI.F_MatchSplitCode AS EndCode
		, MSI.F_MatchID	
		, MSI.F_MatchSplitID 
		, MSR.F_SplitPoints	AS SetPoints
		, MSR.F_Comment1 AS Num10s
		, MSR.F_Comment2 AS NumXs
		
		FROM TS_Match_Split_Info AS MSI
		LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID= @MatchID 
		LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
		where MSI.F_MatchID= @MatchID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0
		and MSI.F_Order = @EndIndex
		AND ISNULL(MSI.F_MatchSplitPrecision,1) = @EndDistince
	end
	
	else if(@EndIndex <>-1 AND @EndDistince = -1)
	BEGIN
		SELECT
		  MSR.F_CompetitionPosition
		, MSR.F_Points AS Total
		, MSI.F_Order  AS EndIndex
		, MSI.F_MatchSplitCode AS EndCode
		, MSI.F_MatchID	
		, MSI.F_MatchSplitID 
		, MSR.F_SplitPoints	AS SetPoints
		, MSR.F_Comment1 AS Num10s
		, MSR.F_Comment2 AS NumXs
		FROM TS_Match_Split_Info AS MSI
		LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID= @MatchID 
		LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
		where MSI.F_MatchID= @MatchID
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0 
		AND MSI.F_Order = @EndIndex
	END
	
	else if(@EndIndex =-1 AND @EndDistince <> -1)
	BEGIN
		 SELECT
		  MSR.F_CompetitionPosition
		, MSR.F_Points AS Total
		, MSI.F_Order  AS EndIndex
		, MSI.F_MatchSplitCode AS EndCode
		, MSI.F_MatchID	
		, MSI.F_MatchSplitID 
		, MSR.F_SplitPoints	AS SetPoints
		, MSR.F_Comment1 AS Num10s
		, MSR.F_Comment2 AS NumXs
		FROM TS_Match_Split_Info AS MSI
		LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID= @MatchID 
		LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
		where MSI.F_MatchID= @MatchID
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0 
		AND ISNULL(MSI.F_MatchSplitPrecision,1) = @EndDistince
	END
	
	else if(@EndIndex =-1 AND @EndDistince = -1)
	BEGIN
		SELECT
		  MSR.F_CompetitionPosition
		, MSR.F_Points AS Total
		, MSI.F_Order  AS EndIndex
		, MSI.F_MatchSplitCode AS EndCode
		, MSI.F_MatchID	
		, MSI.F_MatchSplitID 
		, MSR.F_SplitPoints	AS SetPoints
		, MSR.F_Comment1 AS Num10s
		, MSR.F_Comment2 AS NumXs
		FROM TS_Match_Split_Info AS MSI
		LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID= @MatchID 
		LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
		where MSI.F_MatchID= @MatchID
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0 
	END

SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_GetPlayerEnds 1,1,1,1,'ENG'
*/
