IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Report_FB_AddtionalTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Proc_Report_FB_AddtionalTime]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----存储过程名称：[Proc_Report_FB_AddtionalTime]
----功		  能：得到当前Match各阶段的补时信息
----作		  者：翟广鹏
----日		  期: 2010-03-21

CREATE PROCEDURE [dbo].[Proc_Report_FB_AddtionalTime]
             @MatchID         INT,
             @LanguageCode    CHAR(3)='ENG'

AS
BEGIN
	
SET NOCOUNT ON
    DECLARE @Result		NVARCHAR(MAX)
    DECLARE @FirstHalf    NVARCHAR(50)
    DECLARE @SecondHalf    NVARCHAR(50)
    DECLARE @FirstExtraHalf    NVARCHAR(50)
    DECLARE @SecondExtraHalf    NVARCHAR(50)
   
    SELECT @FirstHalf =  CASE WHEN F_Memo IS NULL THEN '0' ELSE  F_Memo END FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = '1'AND F_MatchSplitStatusID IS NOT NULL
    SELECT @SecondHalf =  CASE WHEN F_Memo IS NULL THEN '0' ELSE  F_Memo END FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = '2'AND F_MatchSplitStatusID IS NOT NULL
    SELECT @FirstExtraHalf =  CASE WHEN F_Memo IS NULL THEN '0' ELSE  F_Memo END FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = '3'AND F_MatchSplitStatusID IS NOT NULL
    SELECT @SecondExtraHalf =  CASE WHEN F_Memo IS NULL THEN '0' ELSE  F_Memo END FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_MatchSplitCode = '4'AND F_MatchSplitStatusID IS NOT NULL
    
    SET @Result = ''
    IF @FirstHalf IS NOT NULL
    BEGIN
		SET @Result = CASE WHEN @LanguageCode = 'CHN' then '上半场: '+@FirstHalf+' 分钟' ELSE 'first half: '+@FirstHalf+' min'END
    END
    
     IF @SecondHalf IS NOT NULL
    BEGIN
		SET @Result = @Result+ CASE WHEN @LanguageCode = 'CHN' then ', 下半场: '+@SecondHalf+' 分钟' ELSE ', second half: '+@SecondHalf+' min'END 
    END
    
     IF @FirstExtraHalf IS NOT NULL
    BEGIN
    
		SET @Result = @Result+ CASE WHEN @LanguageCode = 'CHN' then ', 加时赛上半场: '+@FirstExtraHalf+' 分钟' ELSE ', first extra time: '+@FirstExtraHalf+' min'END
    END
    
     IF @SecondExtraHalf IS NOT NULL
    BEGIN
		SET @Result = @Result+ CASE WHEN @LanguageCode = 'CHN' then ', 加时赛下半场: '+@SecondExtraHalf+' 分钟' ELSE ', second extra time: '+@SecondExtraHalf+' min'END
    END

	select @Result As AddTime
Set NOCOUNT OFF
End

GO


--EXEC Proc_Report_FB_AddtionalTime 1,'ENG'