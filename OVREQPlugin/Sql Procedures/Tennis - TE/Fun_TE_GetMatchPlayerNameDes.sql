
/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetMatchPlayerNameDes]    Script Date: 06/12/2011 09:08:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fun_TE_GetMatchPlayerNameDes]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[Fun_TE_GetMatchPlayerNameDes]
GO

/****** Object:  UserDefinedFunction [dbo].[Fun_TE_GetMatchPlayerNameDes]    Script Date: 06/12/2011 09:08:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[Fun_TE_GetMatchPlayerNameDes]
								(
									@MatchID					INT,
									@CompetitionPosition		INT,
									@LanguageCode				CHAR(3)
								)
RETURNS NVARCHAR (300)
AS
BEGIN
	DECLARE @RegisterLongName		AS NVARCHAR(300)
	DECLARE @RegisterLongName1		AS NVARCHAR(100)
	DECLARE @RegisterLongName2		AS NVARCHAR(100)
	DECLARE @RegisterLongName3		AS NVARCHAR(100)

	DECLARE @RegisterID1			AS INT
	DECLARE @RegisterID2			AS INT
	DECLARE @RegisterID3			AS INT

	DECLARE @MatchSplitID1			AS INT
	DECLARE @MatchSplitID2			AS INT
	DECLARE @MatchSplitID3			AS INT
	DECLARE @TempTable AS TABLE (
					OrderID			INT,
					MatchSplitID	INT
					)

	INSERT INTO @TempTable (OrderID, MatchSplitID)
		SELECT  row_number() over (order by F_MatchSplitID) AS OrderID, F_MatchSplitID AS MatchSplitID FROM TS_Match_Split_Info 
			WHERE F_MatchID = @MatchID AND F_FatherMatchSplitID = 0 ORDER BY F_MatchSplitID

	SELECT @MatchSplitID1 = MatchSplitID FROM @TempTable WHERE OrderID = 1
	SELECT @MatchSplitID2 = MatchSplitID FROM @TempTable WHERE OrderID = 2
	SELECT @MatchSplitID3 = MatchSplitID FROM @TempTable WHERE OrderID = 3

	SELECT @RegisterID1 = F_RegisterID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID1 AND F_CompetitionPosition = @CompetitionPosition
	SELECT @RegisterID2 = F_RegisterID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID2 AND F_CompetitionPosition = @CompetitionPosition
	SELECT @RegisterID3 = F_RegisterID FROM TS_Match_Split_Result WHERE F_MatchID = @MatchID AND F_MatchSplitID = @MatchSplitID3 AND F_CompetitionPosition = @CompetitionPosition

	SELECT @RegisterLongName1 = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID1 AND F_LanguageCode = @LanguageCode
	SELECT @RegisterLongName2 = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID2 AND F_LanguageCode = @LanguageCode
	SELECT @RegisterLongName3 = F_LongName FROM TR_Register_Des WHERE F_RegisterID = @RegisterID3 AND F_LanguageCode = @LanguageCode
	
	IF @RegisterLongName1 IS NULL
	BEGIN
		SET @RegisterLongName1 = ''
	END

	IF @RegisterLongName2 IS NULL
	BEGIN
		SET @RegisterLongName2 = ''
	END

	IF @RegisterLongName3 IS NULL
	BEGIN
		SET @RegisterLongName3 = ''
	END

	SET @RegisterLongName = '单打：' + @RegisterLongName1 + CHAR(10) + CHAR(13) +'单打：' + @RegisterLongName2 + CHAR(10) + CHAR(13) + '双打：' + @RegisterLongName3
	RETURN @RegisterLongName

END



GO


