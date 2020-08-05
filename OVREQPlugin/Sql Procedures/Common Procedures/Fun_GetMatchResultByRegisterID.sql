IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_GetMatchResultByRegisterID]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_GetMatchResultByRegisterID]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [DBO].[Fun_GetMatchResultByRegisterID]
								(
									@MatchID					INT,
									@RegisterID					INT
								)
RETURNS NVARCHAR(100)
AS
BEGIN

	DECLARE @ResultDes			AS NVARCHAR(100)
	DECLARE @HomePoint			AS INT
	DECLARE @AwayPoint			AS INT
	SET @ResultDes = ''

	DECLARE @HCompetitonPosition AS INT
	DECLARE @ACompetitonPosition AS INT

	SELECT 	@HCompetitonPosition = F_CompetitionPosition FROM TS_Match_Result WHERE F_MatchID = @MatchID AND F_RegisterID = @RegisterID
	IF (@HCompetitonPosition IS NULL OR @HCompetitonPosition > 2 OR @HCompetitonPosition < 1)
	BEGIN
		SET @ResultDes = ''
		RETURN @ResultDes
	END
	SET @ACompetitonPosition = 3 - @HCompetitonPosition

--	DECLARE @MatchSplitID AS INT
--	DECLARE One_Cursor CURSOR FOR 
--			SELECT F_MatchSplitID
--				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0

--	OPEN One_Cursor
--	FETCH NEXT FROM One_Cursor INTO @MatchSplitID
--
--	WHILE @@FETCH_STATUS = 0
--	BEGIN
--
--		SELECT @HomePoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 1
--		SELECT @AwayPoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = 2
--		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL))
--		BEGIN
--			SET @ResultDes = @ResultDes +' '+CAST(@HomePoint AS NVARCHAR(100)) +'-'+ CAST(@AwayPoint AS NVARCHAR(100))
--		END
--
--	END
--
--	CLOSE One_Cursor
--	DEALLOCATE One_Cursor



--	DECLARE @TotalSplitNum AS INT
--	SELECT @TotalSplitNum = COUNT(F_MatchSplitID) FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0
--	DECLARE @MatchSplitID AS INT
--	SET @MatchSplitID = 1
--	WHILE(@MatchSplitID <= @TotalSplitNum )
--	BEGIN
--		SELECT @HomePoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @HCompetitonPosition
--		SELECT @AwayPoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @ACompetitonPosition
--		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL))
--		BEGIN
--			SET @ResultDes = @ResultDes +' '+CAST(@HomePoint AS NVARCHAR(100)) +'-'+ CAST(@AwayPoint AS NVARCHAR(100))
--		END
--		SET @MatchSplitID = @MatchSplitID + 1
--	END



	DECLARE @MatchSplitID AS INT
	DECLARE One_Cursor CURSOR FOR 
			SELECT F_MatchSplitID
				FROM TS_Match_Split_Info WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0

	OPEN One_Cursor
	FETCH NEXT FROM One_Cursor INTO @MatchSplitID

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT @HomePoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @HCompetitonPosition
		SELECT @AwayPoint = F_Points FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID AND F_CompetitionPosition = @ACompetitonPosition

		IF ((@HomePoint IS NOT NULL) AND (@AwayPoint IS NOT NULL))
		BEGIN
			SET @ResultDes = @ResultDes +' '+CAST(@HomePoint AS NVARCHAR(100)) +'-'+ CAST(@AwayPoint AS NVARCHAR(100))
		END

		FETCH NEXT FROM One_Cursor INTO @MatchSplitID

	END

	CLOSE One_Cursor
	DEALLOCATE One_Cursor



	SET @ResultDes = LTRIM(RTRIM(@ResultDes))
	RETURN @ResultDes

END
GO


SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO