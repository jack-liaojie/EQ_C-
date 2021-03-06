IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_Report_BD_GetContestResultWinnerFirst]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_Report_BD_GetContestResultWinnerFirst]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[Fun_Report_BD_GetContestResultWinnerFirst]
								(
									@MatchID					INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

    DECLARE @Pos1 INT
    DECLARE @Pos2 INT
	DECLARE @Contest AS NVARCHAR(50)
	DECLARE @ResultDes AS NVARCHAR(200)
	DECLARE @HomePoint AS INT
	DECLARE @AwayPoint AS INT
    DECLARE @AIRM AS NVARCHAR(50)
    DECLARE @BIRM AS NVARCHAR(50)
    DECLARE @AIRMID AS INT
    DECLARE @BIRMID AS INT
    
    SET @Contest = ''
	SET @ResultDes = ''

    SELECT @Pos1 = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_ResultID = 1
    SELECT @Pos2 = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_ResultID = 2

    SELECT @HomePoint = A.F_Points, @AIRM = '(' + B.F_IRMCODE + ')' FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Pos1
	SELECT @AwayPoint = A.F_Points, @BIRM = '(' + B.F_IRMCODE + ')' FROM TS_Match_Result AS A LEFT JOIN TC_IRM AS B ON A.F_IRMID = B.F_IRMID
    WHERE A.F_MatchID = @MatchID AND A.F_CompetitionPositionDes1 = @Pos2

    IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
	BEGIN
		SET @Contest = CAST(@HomePoint AS NVARCHAR(100)) + (CASE WHEN @AIRM IS NULL THEN '' ELSE @AIRM END) + ' - ' + CAST(@AwayPoint AS NVARCHAR(100)) + (CASE WHEN @BIRM IS NULL THEN '' ELSE @BIRM END)
	END

	DECLARE @MatchSplitID AS INT
	DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0

	OPEN One_Cursor
	FETCH NEXT FROM One_Cursor INTO @MatchSplitID

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @HomePoint = F_Points, @AIRMID = F_IRMID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @Pos1
		SELECT @AwayPoint = F_Points, @BIRMID = F_IRMID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @Pos2
        SET @AIRM = (CASE WHEN @AIRMID IS NOT NULL THEN (SELECT '(' + F_IRMCODE + ')' FROM TC_IRM WHERE F_IRMID = @AIRMID) ELSE '' END)
        SET @BIRM = (CASE WHEN @BIRMID IS NOT NULL THEN (SELECT '(' + F_IRMCODE + ')' FROM TC_IRM WHERE F_IRMID = @BIRMID) ELSE '' END)

		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL) AND (@HomePoint+@AwayPoint)<>0)
		BEGIN
			SET @ResultDes = @ResultDes + ', ' + CAST(@HomePoint AS NVARCHAR(100)) + @AIRM + ':' + CAST(@AwayPoint AS NVARCHAR(100)) + @BIRM
		END

	FETCH NEXT FROM One_Cursor INTO @MatchSplitID

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor
	 
	SET @ResultDes = LTRIM(RTRIM(@ResultDes))
	IF(@ResultDes IS NULL OR LEN(@ResultDes)<2)
	BEGIN
		SET @ResultDes = ''
	END	
	ELSE
	BEGIN
		SET @ResultDes = RIGHT(@ResultDes, LEN(@ResultDes)-2)
	END

	RETURN @Contest + '    ' + @ResultDes

END


GO

