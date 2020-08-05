
/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetCurGameResult]    Script Date: 05/30/2011 11:58:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TE_GetCurGameResult]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TE_GetCurGameResult]
GO


/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetCurGameResult]    Script Date: 05/30/2011 11:58:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



--名    称: [Fun_TE_GetCurGameResult]
--描    述：得到当前Game的比赛成绩
--参数说明： 
--说    明：
--创 建 人：李燕
--日    期：2011年05月30日
--修改记录：




CREATE FUNCTION [dbo].[Fun_TE_GetCurGameResult]
(
	@MatchID				INT
)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @ResultVar		NVARCHAR(100)
	
	IF NOT EXISTS(SELECT F_MatchID FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitType = 2 AND F_MatchSplitStatusID = 50)
	BEGIN
	     SET @ResultVar = ''
	     RETURN @ResultVar
	END
	
	DECLARE @GameA   NVARCHAR(10)
	DECLARE @GameB   NVARCHAR(10)
	DECLARE @SerA    INT
	DECLARE @SerB    INT
	
	SELECT @GameA = CAST( MSR1.F_Points AS NVARCHAR(10)), @GameB = CAST( MSR2.F_Points AS NVARCHAR(10)), @SerA = MSR1.F_Service, @SerB = MSR2.F_Service
	       FROM TS_Match_Split_Info AS MSI 
	           LEFT JOIN TS_Match_Split_Result AS MSR1 ON MSI.F_MatchID = MSR1.F_MatchID AND MSI.F_MatchSplitID = MSR1.F_MatchSplitID AND MSR1.F_CompetitionPosition = 1
	           LEFT JOIN TS_Match_Split_Result AS MSR2 ON MSI.F_MatchID = MSR2.F_MatchID AND MSI.F_MatchSplitID = MSR2.F_MatchSplitID AND MSR2.F_CompetitionPosition = 2
	        WHERE MSI.F_MatchID = @MatchID AND MSI.F_FatherMatchSplitID <> 0 AND MSI.F_MatchSplitStatusID = 50  
	
	 IF(@GameA = '45' AND @GameB = '40')
	 BEGIN
	     SET @GameA = 'AD'
	     SET @GameB = ''
	 END 
	 ELSE IF(@GameA = '40' AND @GameB = '45')
	 BEGIN
	     SET @GameA = ''
	     SET @GameB = 'AD'
	 END
	 
	 SET @ResultVar = CASE WHEN @SerA = 1 THEN '*' ELSE '' END+ @GameA + ':' + CASE WHEN @SerB = 1 THEN '*' ELSE '' END + @GameB

	RETURN @ResultVar

END


GO


