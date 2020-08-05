
/****** Object:  UserDefinedFunction [dbo].[Fun_Report_TE_GetMatchResultDes_ForTeam]    Script Date: 06/12/2011 09:33:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_TE_GetMatchResultDes_ForTeam]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_TE_GetMatchResultDes_ForTeam]
GO

/****** Object:  UserDefinedFunction [dbo].[Fun_Report_TE_GetMatchResultDes_ForTeam]    Script Date: 06/12/2011 09:33:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[Fun_Report_TE_GetMatchResultDes_ForTeam]
								(
									@MatchID					INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	
	DECLARE @ResultDes AS NVARCHAR(100)
	DECLARE @SplitResultDes  AS NVARCHAR(100)
	DECLARE @SplitDes AS NVARCHAR(100)
	
	DECLARE @AIRMCode AS NVARCHAR(50)
	DECLARE @BIRMCode AS NVARCHAR(50)

	SET @ResultDes = ''

	DECLARE @MatchSplitID AS INT
	DECLARE @MatchSplitType AS INT
    DECLARE @Index    AS INT
    SET @Index = 1
	
	DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID, F_MatchSplitComment3 
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 AND F_MatchSplitStatusID IN (50,100,110, 120)

	OPEN One_Cursor
	FETCH NEXT FROM One_Cursor INTO @MatchSplitID, @MatchSplitType

	WHILE @@FETCH_STATUS = 0
	BEGIN
        SET @SplitDes = CASE WHEN @MatchSplitType = 1 THEN 'S' + CAST(@Index AS NVARCHAR(100)) WHEN @MatchSplitType = 2 THEN 'D' ELSE '' END

	    SELECT @SplitResultDes = dbo.Fun_TE_GetMatchSplitsPointsDes(@MatchID, 2, @MatchSplitID)
	    
	    SET @SplitResultDes = @SplitResultDes + CHAR(10) + CHAR(13)
	    
	    IF(@Index = 1)
	    BEGIN 
	       SET @ResultDes = @SplitDes + ':'+ @SplitResultDes 
	    END
	    ELSE
	    BEGIN
	       SET @ResultDes = @ResultDes + @SplitDes+ ':' + @SplitResultDes
	    END

        SET @Index = @Index + 1
	FETCH NEXT FROM One_Cursor INTO @MatchSplitID, @MatchSplitType

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	
	SELECT @AIRMCode = B.F_IRMCode FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID  WHERE A.F_MatchID = @MatchID AND F_CompetitionPosition = 1
	SELECT @BIRMCode = B.F_IRMCode FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID  WHERE A.F_MatchID = @MatchID AND F_CompetitionPosition = 2
		
	SET @ResultDes = LTRIM(RTRIM(@ResultDes)) + ISNULL(@AIRMCode, '') + ' ' +  ISNULL(@BIRMCode, '')
		 
	SET @ResultDes = LTRIM(RTRIM(@ResultDes))
	if(@ResultDes is null or len(@ResultDes)<2)
	begin
		set @ResultDes = NULL
	end	
	
	RETURN @ResultDes

END




GO


