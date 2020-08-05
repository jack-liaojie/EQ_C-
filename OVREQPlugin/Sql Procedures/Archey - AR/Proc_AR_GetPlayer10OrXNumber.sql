IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_AR_GetPlayer10OrXNumber]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_AR_GetPlayer10OrXNumber]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






--名    称: [Proc_AR_GetPlayer10OrXNumber]
--描    述: 射箭项目,获取10环或内10环总数
--参数说明: 
--说    明: 
--创 建 人: 崔凯
--日    期: 2010年10月11日
--修改记录：



CREATE PROCEDURE [dbo].[Proc_AR_GetPlayer10OrXNumber]
	@MatchID				INT,
	@EndDistince			INT, --靶距：0：淘汰赛; 1：90m/70m; 2:70m/60m; 3:50m ; 4:30m；
	@CompetitionPosition	INT,
	@Type					int, --0是10环总数，1是X总数
	@LanguageCode			CHAR(3) = Null,
	@Result  			    AS INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
		
	if @LanguageCode = null
	begin
	 set @LanguageCode = 'ENG'
	 END
	 
	 
	if(@EndDistince=-1 AND @Type=0)
	begin
		SET @Result = (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
	end
	
	else 	if(@EndDistince=-1 AND @Type=1)
	begin
		SET @Result = (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitType = 0)
	end
		
	else 	if(@EndDistince<>-1 AND @Type=0)
	begin
		SET @Result = (SELECT SUM(F_Comment1)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitPrecision = @EndDistince
				AND MSI.F_MatchSplitType = 0)
	end	
	
	else 	if(@EndDistince<>-1 AND @Type=1)
	begin
		SET @Result = (SELECT SUM(F_Comment2)
				FROM TS_Match_Split_Result AS MSR		
				LEFT JOIN TS_Match_Split_Info AS MSI ON MSI.F_MatchSplitID = MSR.F_MatchSplitID and  MSI.F_MatchID= @MatchID 
				WHERE MSR.F_MatchID= @MatchID 
				AND MSR.F_CompetitionPosition = @CompetitionPosition
				AND MSI.F_MatchSplitPrecision = @EndDistince
				AND MSI.F_MatchSplitType = 0)
	end
	
SET NOCOUNT OFF
END

GO

/*
exec Proc_AR_GetPlayer10OrXNumber 1,1,1,1,'ENG'
*/
