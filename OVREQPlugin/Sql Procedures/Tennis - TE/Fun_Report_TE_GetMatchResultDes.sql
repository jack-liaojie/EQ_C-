
/****** Object:  UserDefinedFunction [dbo].[Fun_Report_TE_GetMatchResultDes]    Script Date: 06/12/2011 09:33:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_TE_GetMatchResultDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_TE_GetMatchResultDes]
GO

/****** Object:  UserDefinedFunction [dbo].[Fun_Report_TE_GetMatchResultDes]    Script Date: 06/12/2011 09:33:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE FUNCTION [dbo].[Fun_Report_TE_GetMatchResultDes]
								(
									@MatchID					INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	
	DECLARE @ResultDes AS NVARCHAR(100)
	DECLARE @HomePoint AS INT
	DECLARE @AwayPoint AS INT

	SET @ResultDes = ''

	DECLARE @MatchSplitID AS INT
	DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0

	OPEN One_Cursor
	FETCH NEXT FROM One_Cursor INTO @MatchSplitID

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @HomePoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 1
		SELECT @AwayPoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 2
		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
		BEGIN
			SET @ResultDes = @ResultDes +', '+CAST(@HomePoint AS NVARCHAR(100)) +':'+ CAST(@AwayPoint AS NVARCHAR(100))
		END

	FETCH NEXT FROM One_Cursor INTO @MatchSplitID

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	 
	SET @ResultDes = LTRIM(RTRIM(@ResultDes))
	if(@ResultDes is null or len(@ResultDes)<2)
	begin
		set @ResultDes = NULL
	end	
	else
	begin
		SET @ResultDes = right(@ResultDes, len(@ResultDes)-2)
	end

	RETURN @ResultDes

END




GO


