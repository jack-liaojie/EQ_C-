IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_AR_GetSetPointDesString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_AR_GetSetPointDesString]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[Fun_AR_GetSetPointDesString]
								(
									@MatchID					INT,
									@CompetitionPosition		INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @SecString NVARCHAR(100)
	DECLARE @Points NVARCHAR(100)

	SET @SecString = ''

	DECLARE One_Cursor CURSOR FOR 
				SELECT MSR.F_Points FROM TS_Match_Split_Info AS MSI
		LEFT JOIN  TS_Match_Split_Result AS MSR ON MSI.F_MatchSplitID = msr.F_MatchSplitID AND MSR.F_MatchID= @MatchID 
		LEFT JOIN  TS_Match_Split_Info AS MSIF ON  MSIF.F_MatchSplitID = MSI.F_FatherMatchSplitID AND MSIF.F_MatchSplitType=0
		where MSI.F_MatchID= @MatchID 
		AND MSR.F_CompetitionPosition = @CompetitionPosition
		AND MSI.F_MatchSplitType = 0
		ORDER BY MSI.F_Order
	
	OPEN One_Cursor
	FETCH NEXT FROM One_Cursor INTO @Points

	WHILE @@FETCH_STATUS = 0
	BEGIN
	    IF @Points IS NOT NULL
	        IF @SecString = ''
	            SET @SecString = @Points
	        ELSE    
				SET @SecString = @Points + ',' + @SecString
		FETCH NEXT FROM One_Cursor INTO @Points

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	
	RETURN @SecString

END


GO


